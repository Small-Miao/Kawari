//! Cross-references the game's `Action` / `ClassJobActionUI` / `ClassJobCategory` sheets against
//! Kawari's Lua action scripts and reports what is implemented, what is missing, what is orphaned,
//! and which action IDs are hazardous (superseded at level, or PvP name-twins).
//!
//! This tool is strictly read-only with respect to `resources/`: it never creates, renames or
//! deletes a `.lua` file, and it refuses to write its reports anywhere under `resources/scripts/`.
//!
//! Note that "implemented" only means "some script file claims this action ID". It does not mean
//! the script is correct or complete.
//!
//! # Running the tests
//!
//! Most of the golden sample can only be checked against a real FFXIV install, and CI has none, so
//! those tests are `#[ignore]`d. A plain `cargo test` runs only the data-independent ones and
//! honestly reports the rest as `ignored`. To run the **full** golden sample locally:
//!
//! ```text
//! cargo test -p kawari-actionaudit -- --include-ignored
//! ```
//!
//! The runtime safety net that always applies is the schema canary in [`check_schema_canary`]: it
//! runs on every real invocation and hard-errors if the game data does not decode as expected.

use std::collections::{BTreeMap, BTreeSet, HashMap};
use std::path::{Component, Path, PathBuf};

use icarus::Action::{ActionRow, ActionSheet};
use icarus::ActionCategory::ActionCategorySheet;
use icarus::ActionIndirection::ActionIndirectionSheet;
use icarus::ClassJob::ClassJobSheet;
use icarus::ClassJobActionUI::ClassJobActionUISheet;
use icarus::ClassJobCategory::{ClassJobCategoryRow, ClassJobCategorySheet};
use kawari::config::get_config;
use physis::{
    Language,
    resource::{ResourceResolver, SqPackResource},
};
use serde::Serialize;

/// The one directory tree the tool must never write into: a stray *file* at depth 1 of
/// `resources/scripts/actions/` makes the world server's loader `read_dir` fail and panic at
/// startup, and CI never boots the world server so it would not be caught.
const FORBIDDEN_OUT_ROOT: &str = "resources/scripts";

/// Jobs this tool cannot meaningfully audit, and exactly why.
///
/// Every entry here is **reported, never swallowed**: a `warn!` at load time plus an
/// "Unsupported jobs" section in the summary report. They are dropped from `jobs` entirely, which
/// also removes them from the orphan denominator.
const UNSUPPORTED_JOBS: [(&str, &str); 10] = [
    (
        "ADV",
        "ADV is not a job, it is the \"no job selected\" state. Its ClassJob id is 0, and \
         `Action.ClassJob == 0` *also* means \"belongs to no job\", so the `ClassJob in {J, base}` \
         rule degenerates and scoops up every job-less action",
    ),
    (
        "BST",
        "ClassJobCategory has no BST column (the per-job bools stop at PCT), so the job cannot be \
         scoped",
    ),
    // The eight Disciples of the Hand. Their ClassJobActionUI panels reference the CraftAction
    // sheet (ids 100001-100482), which shares no id space with Action -- so every panel cell
    // resolves to nothing. Crafting is out of scope (this tool audits combat logs), so they are
    // excluded rather than emitting entries with empty names.
    ("CRP", "panel references the CraftAction sheet, not Action"),
    ("BSM", "panel references the CraftAction sheet, not Action"),
    ("ARM", "panel references the CraftAction sheet, not Action"),
    ("GSM", "panel references the CraftAction sheet, not Action"),
    ("LTW", "panel references the CraftAction sheet, not Action"),
    ("WVR", "panel references the CraftAction sheet, not Action"),
    ("ALC", "panel references the CraftAction sheet, not Action"),
    ("CUL", "panel references the CraftAction sheet, not Action"),
];

/// The language shortnames physis actually understands. Anything else silently degrades to
/// `Language::None`, so `--lang` is validated against this list instead.
const LANGUAGES: [&str; 8] = ["ja", "en", "de", "fr", "chs", "cht", "tc", "ko"];

fn parse_language(shortname: &str) -> Option<Language> {
    LANGUAGES
        .contains(&shortname)
        .then(|| Language::from_shortname(shortname))
}

/// `ActionCategory` ids that denote a real player combat action.
const CATEGORY_SPELL: u8 = 2;
const CATEGORY_WEAPONSKILL: u8 = 3;
const CATEGORY_ABILITY: u8 = 4;

// -------------------------------------------------------------------------------------------------
// CLI
// -------------------------------------------------------------------------------------------------

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Format {
    Json,
    Md,
    Both,
}

#[derive(Debug)]
struct Args {
    /// Raw job selectors: either "all" or a list of ClassJob ids / abbreviations.
    jobs: Vec<String>,
    all_jobs: bool,
    game_path: Option<String>,
    names_en: Option<PathBuf>,
    lang: Option<String>,
    level: Option<u8>,
    out: PathBuf,
    format: Format,
    summary_only: bool,
    audit_panelless: bool,
    new_action_dir: Option<String>,
}

impl Default for Args {
    fn default() -> Self {
        Self {
            jobs: vec!["26".to_string(), "27".to_string()],
            all_jobs: false,
            game_path: None,
            names_en: None,
            lang: None,
            level: None,
            out: PathBuf::from("actionaudit-out"),
            format: Format::Both,
            summary_only: false,
            audit_panelless: false,
            new_action_dir: None,
        }
    }
}

const HELP: &str = "\
kawari-actionaudit -- audit Kawari's Lua action scripts against the game's Action sheets

USAGE:
    cargo run -p kawari-actionaudit -- [OPTIONS]

OPTIONS:
    --jobs <LIST>          Comma-separated ClassJob ids or abbreviations, or `all`.
                           e.g. --jobs 26,27 | --jobs ACN,SMN | --jobs all
                           Default: 26,27 (ACN,SMN)
    --game-path <PATH>     Game install (sqpack). Default: config.filesystem.game_path
    --names-en <PATH>      OPTIONAL ffxiv-datamining csv/en/Action.csv. Supplies English names for
                           `name_en` and the rename report ONLY. Omitted => name_en is null and the
                           rename report is skipped.
    --lang <SHORT>         Primary sheet language. Default: config.world.language()
    --level <N>            Populate superseded_at_level + effective_at_level. Default: unset.
    --out <DIR>            Output directory. Default: ./actionaudit-out/
    --format <F>           json | md | both. Default: both
    --summary-only         Print counts to stdout, write no files.
    --audit-panelless      Audit jobs whose ClassJobActionUI panel is empty. Default: off.
    --new-action-dir <D>   Directory used for suggested paths of not-yet-existing actions.
    -h, --help             Print this help.
";

fn parse_args(argv: &[String]) -> Result<Option<Args>, String> {
    let mut args = Args::default();
    let mut i = 0;

    fn value(argv: &[String], i: &mut usize, flag: &str) -> Result<String, String> {
        *i += 1;
        argv.get(*i)
            .cloned()
            .ok_or_else(|| format!("{flag} requires a value"))
    }

    while i < argv.len() {
        let arg = argv[i].as_str();
        match arg {
            "-h" | "--help" => return Ok(None),
            "--jobs" => {
                let v = value(argv, &mut i, "--jobs")?;
                if v.eq_ignore_ascii_case("all") {
                    args.all_jobs = true;
                    args.jobs.clear();
                } else {
                    args.jobs = v
                        .split(',')
                        .map(|x| x.trim().to_string())
                        .filter(|x| !x.is_empty())
                        .collect();
                    if args.jobs.is_empty() {
                        return Err("--jobs was given an empty list".to_string());
                    }
                }
            }
            "--game-path" => args.game_path = Some(value(argv, &mut i, "--game-path")?),
            "--names-en" => args.names_en = Some(PathBuf::from(value(argv, &mut i, "--names-en")?)),
            "--lang" => args.lang = Some(value(argv, &mut i, "--lang")?),
            "--level" => {
                let v = value(argv, &mut i, "--level")?;
                args.level = Some(
                    v.parse::<u8>()
                        .map_err(|_| format!("--level expects a number, got `{v}`"))?,
                );
            }
            "--out" => args.out = PathBuf::from(value(argv, &mut i, "--out")?),
            "--format" => {
                let v = value(argv, &mut i, "--format")?;
                args.format = match v.as_str() {
                    "json" => Format::Json,
                    "md" => Format::Md,
                    "both" => Format::Both,
                    _ => return Err(format!("--format expects json|md|both, got `{v}`")),
                };
            }
            "--summary-only" => args.summary_only = true,
            "--audit-panelless" => args.audit_panelless = true,
            "--new-action-dir" => {
                args.new_action_dir = Some(value(argv, &mut i, "--new-action-dir")?)
            }
            other => return Err(format!("unknown argument `{other}`")),
        }
        i += 1;
    }

    Ok(Some(args))
}

// -------------------------------------------------------------------------------------------------
// Output directory safety guard
// -------------------------------------------------------------------------------------------------

/// The repository root, resolved from the crate's compile-time location (`tools/actionaudit`) and
/// therefore **independent of the current working directory**.
fn repo_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("..")
        .join("..")
        .to_path_buf()
}

/// Makes a path absolute and lexically normalized (resolving `.` and `..`) *without* touching the
/// filesystem, so it also works for paths that do not exist yet.
fn lexical_absolute(path: &Path) -> Result<PathBuf, String> {
    let abs = if path.is_absolute() {
        path.to_path_buf()
    } else {
        std::env::current_dir()
            .map_err(|e| format!("cannot read the current directory: {e}"))?
            .join(path)
    };

    let mut out = PathBuf::new();
    for component in abs.components() {
        match component {
            Component::CurDir => {}
            Component::ParentDir => {
                out.pop();
            }
            other => out.push(other.as_os_str()),
        }
    }
    Ok(out)
}

/// Canonicalizes the deepest *existing* ancestor of `path` and re-appends the remainder.
///
/// `std::fs::canonicalize` returns `Err` for a path that does not exist — and the default output
/// directory does not exist on the very first run, which is exactly when the guard matters. Doing
/// it this way also means both sides of the comparison get the same platform prefix (on Windows,
/// canonicalize returns a `\\?\` verbatim prefix, which never `starts_with`-matches a plain path).
fn canonicalize_lenient(path: &Path) -> Result<PathBuf, String> {
    let abs = lexical_absolute(path)?;

    let mut existing: &Path = &abs;
    let mut rest: Vec<std::ffi::OsString> = Vec::new();
    loop {
        if existing.exists() {
            break;
        }
        let Some(name) = existing.file_name() else {
            return Err(format!("no existing ancestor for `{}`", abs.display()));
        };
        rest.push(name.to_owned());
        let Some(parent) = existing.parent() else {
            return Err(format!("no existing ancestor for `{}`", abs.display()));
        };
        existing = parent;
    }

    let mut canonical = std::fs::canonicalize(existing)
        .map_err(|e| format!("cannot canonicalize `{}`: {e}", existing.display()))?;
    for name in rest.iter().rev() {
        canonical.push(name);
    }
    Ok(canonical)
}

/// Resolves `out` and refuses anything inside `resources/scripts/`. Creates nothing.
///
/// > 🚨 The forbidden root must **NOT** be resolved relative to the current directory. A relative
/// > `Path::new("resources/scripts").exists()` is false whenever the tool is invoked from anywhere
/// > but the repository root, which silently switches the whole guard off -- and
/// > `cd tools/actionaudit && ... --out ../../resources/scripts/actions/EVIL` then happily writes a
/// > file that panics the world server at startup. It is anchored to the compile-time crate
/// > location instead, so it holds from any cwd.
fn resolve_safe_outdir(out: &Path) -> Result<PathBuf, String> {
    let out = canonicalize_lenient(out)?;

    let forbidden = repo_root().join(FORBIDDEN_OUT_ROOT);
    if !forbidden.exists() {
        return Err(format!(
            "cannot find `{}`. This tool must be run from a Kawari checkout -- without it the \
             output-directory safety guard cannot be enforced, and a report written under \
             `resources/scripts/actions/` panics the world server at startup.",
            forbidden.display()
        ));
    }

    let forbidden = canonicalize_lenient(&forbidden)?;
    if out.starts_with(&forbidden) {
        return Err(format!(
            "refusing to write reports into `{}`: it is inside `{}`. A stray file there makes the \
             world server's script loader panic at startup.",
            out.display(),
            forbidden.display()
        ));
    }

    Ok(out)
}

// -------------------------------------------------------------------------------------------------
// English-name CSV (hand-rolled, RFC4180-aware)
// -------------------------------------------------------------------------------------------------

/// Splits one CSV line into fields, honoring RFC4180 quoting.
///
/// `en/Action.csv` contains 49 quoted fields, and they are quoted precisely because the name has a
/// comma in it (`2678 = "10,000 Needles"`, `8303 = "Storm, Swell, Sword"`). A naive `split(',')`
/// yields wrong names.
fn parse_csv_line(line: &str) -> Vec<String> {
    let mut fields = Vec::new();
    let mut field = String::new();
    let mut chars = line.chars().peekable();
    let mut in_quotes = false;

    while let Some(c) = chars.next() {
        if in_quotes {
            if c == '"' {
                if chars.peek() == Some(&'"') {
                    chars.next();
                    field.push('"'); // an escaped quote
                } else {
                    in_quotes = false;
                }
            } else {
                field.push(c);
            }
        } else if c == '"' && field.is_empty() {
            in_quotes = true;
        } else if c == ',' {
            fields.push(std::mem::take(&mut field));
        } else {
            field.push(c);
        }
    }

    // A line always ends with one final field -- including the empty one after a trailing comma.
    fields.push(field);
    fields
}

/// Reads `csv/en/Action.csv` into an id -> English-name map.
fn load_english_names(path: &Path) -> Result<HashMap<u32, String>, String> {
    let data = std::fs::read_to_string(path)
        .map_err(|e| format!("cannot read --names-en `{}`: {e}", path.display()))?;

    let mut lines = data.lines();
    let header = lines
        .next()
        .ok_or_else(|| format!("--names-en `{}` is empty", path.display()))?;
    // A UTF-8 BOM would otherwise glue itself onto field 0.
    let header = header.strip_prefix('\u{feff}').unwrap_or(header);
    let header_fields = parse_csv_line(header);

    let field0 = header_fields.first().map(String::as_str).unwrap_or("");
    let field1 = header_fields.get(1).map(String::as_str).unwrap_or("");
    if field0 != "#" || field1 != "Name" {
        return Err(format!(
            "--names-en `{}` has an unexpected header: field 0 = `{field0}`, field 1 = `{field1}` \
             (expected `#` and `Name`). This does not look like ffxiv-datamining's csv/en/Action.csv \
             -- note csv/cn/Action.csv has a 3-line header, a BOM and a different column order.",
            path.display()
        ));
    }

    let mut names = HashMap::new();
    for line in lines {
        if line.is_empty() {
            continue;
        }
        let fields = parse_csv_line(line);
        let (Some(id), Some(name)) = (fields.first(), fields.get(1)) else {
            continue;
        };
        let Ok(id) = id.parse::<u32>() else {
            continue;
        };
        if name.is_empty() {
            continue;
        }
        names.insert(id, name.clone());
    }

    Ok(names)
}

// -------------------------------------------------------------------------------------------------
// Filename suggestions
// -------------------------------------------------------------------------------------------------

/// `<CamelCase>_<id zero-padded to 5>` -- e.g. `SummonIfrit_25805`.
///
/// The stem must contain **exactly one** underscore: the Lua loader does `stem.split_once('_')` and
/// then `.parse::<u32>().expect(..)` on the tail, so an extra underscore panics the world server at
/// startup. Splitting the English name on every non-`[A-Za-z0-9]` character makes that hold by
/// construction (see the unit tests).
fn suggested_stem(name_en: &str, id: u32) -> String {
    // An apostrophe is deleted rather than treated as a word boundary, so `Arm's Length` becomes
    // `ArmsLength` (matching the existing `ArmsLength_07548.lua`) and not `ArmSLength`.
    let name_en: String = name_en
        .chars()
        .filter(|c| *c != '\'' && *c != '\u{2019}')
        .collect();

    let mut stem = String::new();
    for fragment in name_en.split(|c: char| !c.is_ascii_alphanumeric()) {
        let mut chars = fragment.chars();
        let Some(first) = chars.next() else {
            continue;
        };
        stem.push(first.to_ascii_uppercase());
        stem.push_str(chars.as_str());
    }
    if stem.is_empty() {
        stem.push_str("Unnamed");
    }
    format!("{stem}_{id:05}")
}

// -------------------------------------------------------------------------------------------------
// Lua tree scanner (replicates the loader's rules -- servers/world/src/lua/state.rs)
// -------------------------------------------------------------------------------------------------

#[derive(Debug, Serialize)]
struct DuplicateId {
    id: u32,
    kept: String,
    ignored: String,
}

#[derive(Debug, Default, Serialize)]
struct TreeHealth {
    duplicate_ids: Vec<DuplicateId>,
    /// Stems with no `_` at all: the loader warns and skips these.
    unparseable: Vec<String>,
    /// Stems whose tail does not parse as `u32`: the loader `.expect()`s => startup panic.
    would_panic: Vec<String>,
}

#[derive(Debug, Default)]
struct LuaTree {
    /// action id -> path, first-wins, exactly like the loader's `entry().or_insert_with()`.
    by_id: BTreeMap<u32, String>,
    health: TreeHealth,
    file_count: usize,
    dir_count: usize,
}

fn scan_lua_actions(search_dirs: &[String]) -> LuaTree {
    let mut tree = LuaTree::default();

    for search_dir in search_dirs {
        let actions_dir = format!("{search_dir}/actions");
        let Ok(entries) = std::fs::read_dir(&actions_dir) else {
            tracing::warn!("Could not read action script directory `{actions_dir}`, skipping.");
            continue;
        };

        for entry in entries.flatten() {
            let dir = entry.path();
            let Ok(files) = std::fs::read_dir(&dir) else {
                // The loader `.expect()`s here -- a plain file at this level panics it.
                tracing::error!(
                    "`{}` is not a readable directory. The world server's loader would PANIC on it.",
                    dir.display()
                );
                continue;
            };
            tree.dir_count += 1;

            for file in files.flatten() {
                let path = file.path();
                if path.extension().and_then(|x| x.to_str()) != Some("lua") {
                    continue;
                }
                tree.file_count += 1;

                let stem = path
                    .file_stem()
                    .and_then(|x| x.to_str())
                    .unwrap_or_default()
                    .to_string();
                let path_str = path.to_string_lossy().replace('\\', "/");

                let Some((_, tail)) = stem.split_once('_') else {
                    tree.health.unparseable.push(path_str);
                    continue;
                };
                let Ok(id) = tail.parse::<u32>() else {
                    tree.health.would_panic.push(path_str);
                    continue;
                };

                if let Some(kept) = tree.by_id.get(&id) {
                    tree.health.duplicate_ids.push(DuplicateId {
                        id,
                        kept: kept.clone(),
                        ignored: path_str,
                    });
                } else {
                    tree.by_id.insert(id, path_str);
                }
            }
        }
    }

    tree
}

// -------------------------------------------------------------------------------------------------
// Game data
// -------------------------------------------------------------------------------------------------

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Cell {
    upgrade: u32,
    base: u32,
}

#[derive(Debug, Clone)]
struct JobInfo {
    id: u32,
    abbrev: String,
    name_en: String,
    parent: u32,
}

struct GameData {
    actions: HashMap<u32, ActionRow>,
    categories: HashMap<u32, String>,
    jobs: BTreeMap<u32, JobInfo>,
    cjc: HashMap<u32, ClassJobCategoryRow>,
    /// ClassJob row id -> its `ClassJobActionUI` subrows.
    ui: HashMap<u32, Vec<Cell>>,
    /// action -> the button it sits on (`ActionIndirection.PreviousComboAction`), zero buttons
    /// omitted. This answers "which button triggers it", NOT "is it a pet action".
    replaces: HashMap<u32, u32>,
    /// Every action that has *any* `ActionIndirection` entry, including the ones whose button is 0
    /// (most pet casts). Membership here -- not the button value -- is what makes a `ClassJob == 0`
    /// action a `replacement` (§4.4).
    indirection: BTreeSet<u32>,
    /// Every action id appearing on ANY `ClassJobActionUI` panel. Used to tell a panel-less
    /// replacement (which must be rescued into `expected`) from one that is already covered.
    all_panel_ids: BTreeSet<u32>,
}

fn load_game_data(game_path: &str, lang: Language) -> Result<GameData, String> {
    let mut resolver = ResourceResolver::new();
    resolver.add_source(SqPackResource::from_existing(game_path));

    let action_sheet = ActionSheet::read_from(&mut resolver, lang)
        .map_err(|e| format!("failed to read the Action sheet: {e:?}"))?;
    let category_sheet = ActionCategorySheet::read_from(&mut resolver, lang)
        .map_err(|e| format!("failed to read the ActionCategory sheet: {e:?}"))?;
    let job_sheet = ClassJobSheet::read_from(&mut resolver, lang)
        .map_err(|e| format!("failed to read the ClassJob sheet: {e:?}"))?;
    // ClassJobCategory carries a localized `Name`, so it must be read in the primary language.
    let cjc_sheet = ClassJobCategorySheet::read_from(&mut resolver, lang)
        .map_err(|e| format!("failed to read the ClassJobCategory sheet: {e:?}"))?;
    let ui_sheet = ClassJobActionUISheet::read_from(&mut resolver, Language::None)
        .map_err(|e| format!("failed to read the ClassJobActionUI sheet: {e:?}"))?;
    let indirection_sheet = ActionIndirectionSheet::read_from(&mut resolver, Language::None)
        .map_err(|e| format!("failed to read the ActionIndirection sheet: {e:?}"))?;

    let mut actions = HashMap::new();
    for (id, subrows) in &action_sheet {
        if let Some((_, row)) = subrows.into_iter().next() {
            actions.insert(id, row);
        }
    }

    let mut categories = HashMap::new();
    for (id, subrows) in &category_sheet {
        if let Some((_, row)) = subrows.into_iter().next() {
            categories.insert(id, row.Name);
        }
    }

    let mut jobs = BTreeMap::new();
    for (id, subrows) in &job_sheet {
        let Some((_, row)) = subrows.into_iter().next() else {
            continue;
        };
        if row.Name.is_empty() {
            continue;
        }
        if let Some((_, why)) = UNSUPPORTED_JOBS
            .iter()
            .find(|(abbrev, _)| *abbrev == row.Abbreviation)
        {
            tracing::warn!(
                "Skipping {} ({id}): unsupported -- {why}.",
                row.Abbreviation
            );
            continue;
        }
        jobs.insert(
            id,
            JobInfo {
                id,
                abbrev: row.Abbreviation.clone(),
                name_en: row.NameEnglish.clone(),
                parent: row.ClassJobParent as u32,
            },
        );
    }

    let mut cjc = HashMap::new();
    for (id, subrows) in &cjc_sheet {
        if let Some((_, row)) = subrows.into_iter().next() {
            cjc.insert(id, row);
        }
    }

    // `ClassJobActionUI` is a SUBROW sheet: `.row(id)` would return only the first subrow, silently
    // yielding 1 cell instead of 15. Iterate and keep every subrow.
    let mut ui: HashMap<u32, Vec<Cell>> = HashMap::new();
    for (row_id, subrows) in &ui_sheet {
        let cells = subrows
            .into_iter()
            .map(|(_, row)| Cell {
                upgrade: row.UpgradeAction,
                base: row.BaseAction,
            })
            .collect();
        ui.insert(row_id, cells);
    }

    let mut replaces = HashMap::new();
    let mut indirection = BTreeSet::new();
    for (_, subrows) in &indirection_sheet {
        for (_, row) in subrows {
            if row.Name > 0 {
                indirection.insert(row.Name as u32);
                if row.PreviousComboAction > 0 {
                    replaces.insert(row.Name as u32, row.PreviousComboAction as u32);
                }
            }
        }
    }

    let all_panel_ids = ui
        .values()
        .flatten()
        .flat_map(|cell| [cell.upgrade, cell.base])
        .filter(|id| *id != 0)
        .collect();

    let gd = GameData {
        actions,
        categories,
        jobs,
        cjc,
        ui,
        replaces,
        indirection,
        all_panel_ids,
    };
    check_schema_canary(&gd)?;
    Ok(gd)
}

/// Hard-fails if the game data does not decode the way the join rules assume.
///
/// The golden sample lives in `cargo test` and is pinned to *this* machine's install. But
/// `--game-path` can point at **any** install, and if that install's schema disagrees with the
/// icarus pin (`ver/2026.04.21.0000.0000`), columns shift and the tool emits a report that looks
/// entirely plausible and is entirely wrong. This canary travels with `--game-path`, so it catches
/// that on every real run.
///
/// The subrow check is the load-bearing one: it fires immediately if the physis subrow-offset patch
/// is not in effect, which is exactly the failure that produced garbage panels before.
fn check_schema_canary(gd: &GameData) -> Result<(), String> {
    let fail = |what: &str, expected: String, got: String| -> String {
        format!(
            "schema canary failed: {what} -- expected {expected}, got {got}.\n\
             The game data does not decode the way this tool expects. Either the install's schema \
             disagrees with the icarus pin (ver/2026.04.21.0000.0000), or the physis subrow-offset \
             patch is not in effect (see .cargo/config.toml). Refusing to emit a plausible-looking \
             but WRONG report."
        )
    };

    // bool + i8: Arm's Length is a role action whose ClassJob is ALSO -1.
    let arms_length = gd.actions.get(&7548).ok_or_else(|| {
        fail(
            "Action[7548] (Arm's Length)",
            "present".into(),
            "absent".into(),
        )
    })?;
    if !arms_length.IsRoleAction || arms_length.ClassJob != -1 {
        return Err(fail(
            "Action[7548] (Arm's Length)",
            "IsRoleAction = true, ClassJob = -1".into(),
            format!(
                "IsRoleAction = {}, ClassJob = {}",
                arms_length.IsRoleAction, arms_length.ClassJob
            ),
        ));
    }

    // u8: Summon Ifrit II unlocks at level 90.
    let ifrit_ii = gd.actions.get(&25838).ok_or_else(|| {
        fail(
            "Action[25838] (Summon Ifrit II)",
            "present".into(),
            "absent".into(),
        )
    })?;
    if ifrit_ii.ClassJobLevel != 90 {
        return Err(fail(
            "Action[25838] (Summon Ifrit II)",
            "ClassJobLevel = 90".into(),
            format!("ClassJobLevel = {}", ifrit_ii.ClassJobLevel),
        ));
    }

    // Link: SMN's base class is ACN.
    let smn_parent = gd.jobs.get(&27).map(|job| job.parent);
    if smn_parent != Some(26) {
        return Err(fail(
            "ClassJob[27] (SMN)",
            "ClassJobParent = 26 (ACN)".into(),
            format!("ClassJobParent = {smn_parent:?}"),
        ));
    }

    // SUBROW DECODING -- catches an unpatched physis outright.
    for (row_id, want) in [(26u32, 15usize), (27, 49)] {
        let got = gd.ui.get(&row_id).map(Vec::len).unwrap_or(0);
        if got != want {
            return Err(fail(
                &format!("ClassJobActionUI row {row_id}"),
                format!("{want} subrows"),
                format!("{got} subrows"),
            ));
        }
    }

    // ..and that the decoded subrow *contents* are sane, not just the count: row 26 subrow 1 is
    // `Ruin II (172)` upgrading from the ladder root `Ruin (163)`. A 6-byte offset slip keeps the
    // count right and turns these into garbage.
    let acn = gd.ui.get(&26).expect("checked above");
    let want = Cell {
        upgrade: 172,
        base: 163,
    };
    if !acn.contains(&want) {
        return Err(fail(
            "ClassJobActionUI row 26",
            "a cell with UpgradeAction = 172 (Ruin II), BaseAction = 163 (Ruin)".into(),
            format!("{:?}", &acn[..acn.len().min(3)]),
        ));
    }

    Ok(())
}

impl GameData {
    /// Base classes point at themselves or at 0.
    fn base_of(&self, job_id: u32) -> u32 {
        match self.jobs.get(&job_id) {
            Some(job) if job.parent != 0 && job.parent != job_id => job.parent,
            _ => job_id,
        }
    }

    /// The panel is the union of the base class's row and the job's row. Rows exist for BOTH, and a
    /// job may have no base class at all (DRK/AST/MCH/...), in which case they collapse to one.
    fn panel_cells(&self, job_id: u32) -> Vec<Cell> {
        let base_id = self.base_of(job_id);
        let mut cells = Vec::new();
        for row_id in [base_id, job_id] {
            if row_id == job_id && base_id == job_id && !cells.is_empty() {
                continue;
            }
            if let Some(row_cells) = self.ui.get(&row_id) {
                cells.extend(row_cells.iter().copied());
            }
        }
        cells
    }

    /// A panel cell may point at something that is not a real action:
    ///
    ///   * a **placeholder cell** -- `41248` (SGE) and `41249` (MNK) have an empty `Name`, `Lv0` and
    ///     `ActionCategory 0`. Emitting them would put "implement action 41248" in the `missing`
    ///     bucket, i.e. tell the user to implement an action that does not exist;
    ///   * an id that is **not in the `Action` sheet at all** -- the DoH panels point at the
    ///     `CraftAction` sheet (§4.8b). Those jobs are excluded outright, but the guard is kept here
    ///     so a future sheet cannot silently inject nameless rows.
    ///
    /// Both are dropped, and dropping them is *reported* (see `panel_dropped_cells`).
    fn panel_ids(&self, job_id: u32) -> BTreeSet<u32> {
        let mut ids = BTreeSet::new();
        for cell in self.panel_cells(job_id) {
            for id in [cell.upgrade, cell.base] {
                if id != 0 && self.is_real_action(id) {
                    ids.insert(id);
                }
            }
        }
        ids
    }

    /// Present in the `Action` sheet, and actually named.
    fn is_real_action(&self, id: u32) -> bool {
        self.actions
            .get(&id)
            .is_some_and(|action| !action.Name.is_empty())
    }

    /// Panel cells dropped by `panel_ids` because they are not real actions -- surfaced rather than
    /// silently swallowed.
    fn panel_dropped_cells(&self, job_id: u32) -> BTreeSet<u32> {
        let mut ids = BTreeSet::new();
        for cell in self.panel_cells(job_id) {
            for id in [cell.upgrade, cell.base] {
                if id != 0 && !self.is_real_action(id) {
                    ids.insert(id);
                }
            }
        }
        ids
    }

    fn level_of(&self, id: u32) -> u8 {
        self.actions.get(&id).map(|a| a.ClassJobLevel).unwrap_or(0)
    }

    /// Cells sharing a `BaseAction` are ONE hotbar button's upgrade ladder. `BaseAction` is the
    /// ladder ROOT, not the immediate predecessor: `Ruin II` and `Ruin III` both point at `Ruin`.
    fn ladders(&self, job_id: u32) -> Vec<Ladder> {
        let mut groups: BTreeMap<u32, BTreeSet<u32>> = BTreeMap::new();
        for cell in self.panel_cells(job_id) {
            if cell.base == 0 {
                continue;
            }
            let members = groups.entry(cell.base).or_default();
            members.insert(cell.base);
            if cell.upgrade != 0 {
                members.insert(cell.upgrade);
            }
        }

        groups
            .into_iter()
            .map(|(root, members)| {
                let mut members: Vec<u32> = members.into_iter().collect();
                members.sort_by_key(|id| (self.level_of(*id), *id));

                for pair in members.windows(2) {
                    if self.level_of(pair[0]) == self.level_of(pair[1]) {
                        tracing::warn!(
                            "Ladder {root}: actions {} and {} share ClassJobLevel {}; the upgrade \
                             order is ambiguous, falling back to id order.",
                            pair[0],
                            pair[1],
                            self.level_of(pair[0])
                        );
                    }
                }

                Ladder { root, members }
            })
            .collect()
    }

    /// Role actions, scoped to the job through `ClassJobCategory`.
    ///
    /// The `is_real_player_skill` + `IsPvP` guards are NOT optional: without them SMN picks up the
    /// three PvP caster role actions (43252 / 43254 / 43291), which would land in `missing` and
    /// actively instruct the user to implement PvP action IDs.
    fn role_actions(&self, job_id: u32) -> BTreeSet<u32> {
        let base_id = self.base_of(job_id);
        let abbrevs: Vec<&str> = [base_id, job_id]
            .iter()
            .filter_map(|id| self.jobs.get(id).map(|j| j.abbrev.as_str()))
            .collect();

        let mut ids = BTreeSet::new();
        for (id, action) in &self.actions {
            if !action.IsRoleAction || action.IsPvP || !is_real_player_skill(action) {
                continue;
            }
            let Some(cjc) = self.cjc.get(&(action.ClassJobCategory as u32)) else {
                continue;
            };
            if abbrevs.iter().any(|abbrev| cjc_has(cjc, abbrev)) {
                ids.insert(*id);
            }
        }
        ids
    }

    /// panel ∪ role ∪ **the replacements reachable from the job's buttons**.
    ///
    /// Nearly every replacement already sits on the panel (all 30 of SMN's `ActionIndirection` rows
    /// do), but not all: `37037 Emergency Tactics` (Lv100) sits on SCH's `3586` button and appears
    /// on **no** panel anywhere. The client can still send its id, so the server must implement it.
    /// Without this closure it landed in no job's expected set at all and the audit stayed silent.
    ///
    /// A replacement that sits on SOME panel is already accounted for by that panel, so only the
    /// panel-less ones are rescued here. Scoping it any wider double-counts: `25823 Ruby Rite`
    /// (Lv72) sits on the `25883 Gemshine` button, and Gemshine is on the *shared ACN row*, so an
    /// unscoped closure drags every Lv58-100 SMN replacement into `expected(ACN)` -- a Lv1-30
    /// Arcanist cannot cast any of them, and it moved the golden from 20 to 31.
    ///
    /// Indirection nests (`Crimson Strike` -> `Crimson Cyclone` -> `Astral Flow`), so this is a
    /// fixpoint, not one pass.
    fn expected(&self, job_id: u32) -> BTreeSet<u32> {
        let mut ids = self.panel_ids(job_id);
        ids.extend(self.role_actions(job_id));

        loop {
            let mut added = false;
            for (action, button) in &self.replaces {
                if ids.contains(action) || !ids.contains(button) {
                    continue;
                }
                if self.all_panel_ids.contains(action) {
                    continue; // already covered by the panel it lives on
                }
                // Only job-less replacements are pulled in this way. Pet casts (ClassJob == -1) and
                // real job actions already arrive via the panel, and PvP twins must never be added.
                let Some(row) = self.actions.get(action) else {
                    continue;
                };
                if row.ClassJob != 0 || row.IsPvP || row.Name.is_empty() {
                    continue;
                }
                ids.insert(*action);
                added = true;
            }
            if !added {
                break;
            }
        }

        ids
    }

    /// Actions still tagged with the job and still looking player-usable, yet absent from the panel.
    /// Expected to be empty for every job with a panel; a non-zero value is a genuine red flag.
    fn stale_tagged(&self, job_id: u32) -> BTreeSet<u32> {
        let base_id = self.base_of(job_id);
        let expected = self.expected(job_id);

        let mut ids = BTreeSet::new();
        for (id, action) in &self.actions {
            let job = action.ClassJob as i32;
            if job != job_id as i32 && job != base_id as i32 {
                continue;
            }
            if !is_real_player_skill(action) || action.IsPvP || action.Name.is_empty() {
                continue;
            }
            if !expected.contains(id) {
                ids.insert(*id);
            }
        }
        ids
    }

    /// PvP actions whose (localized) name is byte-identical to an action the job actually uses.
    /// A developer searching `Action` by name finds both and can trivially wire up the wrong id.
    fn name_collisions(&self, job_id: u32) -> Vec<Collision> {
        let expected = self.expected(job_id);

        let mut by_name: HashMap<&str, Vec<u32>> = HashMap::new();
        for id in &expected {
            if let Some(action) = self.actions.get(id)
                && !action.Name.is_empty()
            {
                by_name.entry(action.Name.as_str()).or_default().push(*id);
            }
        }

        let mut collisions = Vec::new();
        for (pvp_id, action) in &self.actions {
            if !action.IsPvP || action.Name.is_empty() {
                continue;
            }
            let Some(matches) = by_name.get(action.Name.as_str()) else {
                continue;
            };
            let matches: Vec<u32> = matches.iter().copied().filter(|id| id != pvp_id).collect();
            if matches.is_empty() {
                continue;
            }
            if matches.len() > 1 {
                tracing::warn!(
                    "PvP action {pvp_id} (`{}`) matches {} expected actions ({matches:?}); the \
                     correct PvE id is ambiguous.",
                    action.Name,
                    matches.len()
                );
            }
            collisions.push(Collision {
                pvp_id: *pvp_id,
                name: action.Name.clone(),
                correct_pve_id: matches[0],
            });
        }

        collisions.sort_by_key(|c| c.pvp_id);
        collisions
    }

    fn classify(&self, id: u32, job: Option<(u32, u32)>) -> Kind {
        let Some(action) = self.actions.get(&id) else {
            return Kind::Unknown;
        };

        // `Arm's Length` is a role action whose ClassJob is ALSO -1, so IsRoleAction must be tested
        // first or every role action is misfiled as a pet action.
        if action.IsRoleAction {
            return Kind::Role;
        }
        // `ClassJob` is i8 and holds -1. Never cast it to an unsigned type before comparing.
        if action.ClassJob == -1 {
            return Kind::Pet;
        }
        // A `replacement` is a job-less action the client swaps onto an existing button at runtime.
        // `!IsPlayerAction` is SUFFICIENT but NOT NECESSARY -- an `ActionIndirection` entry also
        // qualifies:
        //   * requiring `!IsPlayerAction` alone misfiles `36952 Drakesbane` (a DRG combo finisher)
        //     and `37037 Emergency Tactics` (Lv100, on SCH's 3586 button) as `unknown`;
        //   * requiring an indirection entry alone misfiles `37036 Eudaimonia` (SGE) and the blank
        //     placeholder cells `41248`/`41249` (MNK/SGE panels) as `unknown`.
        // Taking the union is what drives `unknown` to zero across every job.
        if action.ClassJob == 0 && (self.indirection.contains(&id) || !action.IsPlayerAction) {
            return Kind::Replacement;
        }
        match job {
            Some((job_id, base_id)) => {
                if action.ClassJob as i32 == job_id as i32
                    || action.ClassJob as i32 == base_id as i32
                {
                    Kind::Player
                } else {
                    tracing::warn!(
                        "Action {id} (`{}`) is on job {job_id}'s panel but is tagged ClassJob {}.",
                        action.Name,
                        action.ClassJob
                    );
                    Kind::Unknown
                }
            }
            None if action.ClassJob > 0 => Kind::Player,
            None => Kind::Unknown,
        }
    }
}

#[derive(Debug, Clone)]
struct Ladder {
    root: u32,
    /// Level-sorted.
    members: Vec<u32>,
}

impl Ladder {
    /// Exactly ONE member of a ladder is active at a given level: the highest-level member the
    /// character has reached. A Lv100 Summoner does not have both `Summon Ifrit` and
    /// `Summon Ifrit II` on the bar -- the second replaces the first.
    fn effective_at_level(&self, gd: &GameData, level: u8) -> Option<u32> {
        self.members
            .iter()
            .rfind(|id| gd.level_of(**id) <= level)
            .copied()
    }

    fn predecessor(&self, id: u32) -> Option<u32> {
        let idx = self.members.iter().position(|m| *m == id)?;
        idx.checked_sub(1).map(|i| self.members[i])
    }

    fn successor(&self, id: u32) -> Option<u32> {
        let idx = self.members.iter().position(|m| *m == id)?;
        self.members.get(idx + 1).copied()
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Kind {
    Player,
    Replacement,
    Pet,
    Role,
    Unknown,
}

impl Kind {
    fn as_str(self) -> &'static str {
        match self {
            Kind::Player => "player",
            Kind::Replacement => "replacement",
            Kind::Pet => "pet",
            Kind::Role => "role",
            Kind::Unknown => "unknown",
        }
    }
}

/// The semantic filter that separates real player combat skills from Sprint / Teleport / Return /
/// Dye / duty actions / limit breaks. It removes 100% of the "All Classes" broad-category noise on
/// its own, so no `ClassJobCategory`-broadness threshold is needed.
fn is_real_player_skill(action: &ActionRow) -> bool {
    action.IsPlayerAction
        && action.ClassJobLevel > 0
        && matches!(
            action.ActionCategory,
            CATEGORY_SPELL | CATEGORY_WEAPONSKILL | CATEGORY_ABILITY
        )
}

/// icarus generates `ClassJobCategoryRow` with static fields, so indexing by abbreviation at runtime
/// needs a match. The abbreviation itself is READ FROM THE SHEET, so the job list stays data-driven;
/// only the column mapping is spelled out here.
fn cjc_has(row: &ClassJobCategoryRow, abbrev: &str) -> bool {
    match abbrev {
        "ADV" => row.ADV,
        "GLA" => row.GLA,
        "PGL" => row.PGL,
        "MRD" => row.MRD,
        "LNC" => row.LNC,
        "ARC" => row.ARC,
        "CNJ" => row.CNJ,
        "THM" => row.THM,
        "CRP" => row.CRP,
        "BSM" => row.BSM,
        "ARM" => row.ARM,
        "GSM" => row.GSM,
        "LTW" => row.LTW,
        "WVR" => row.WVR,
        "ALC" => row.ALC,
        "CUL" => row.CUL,
        "MIN" => row.MIN,
        "BTN" => row.BTN,
        "FSH" => row.FSH,
        "PLD" => row.PLD,
        "MNK" => row.MNK,
        "WAR" => row.WAR,
        "DRG" => row.DRG,
        "BRD" => row.BRD,
        "WHM" => row.WHM,
        "BLM" => row.BLM,
        "ACN" => row.ACN,
        "SMN" => row.SMN,
        "SCH" => row.SCH,
        "ROG" => row.ROG,
        "NIN" => row.NIN,
        "MCH" => row.MCH,
        "DRK" => row.DRK,
        "AST" => row.AST,
        "SAM" => row.SAM,
        "RDM" => row.RDM,
        "BLU" => row.BLU,
        "GNB" => row.GNB,
        "DNC" => row.DNC,
        "RPR" => row.RPR,
        "SGE" => row.SGE,
        "VPR" => row.VPR,
        "PCT" => row.PCT,
        _ => {
            tracing::warn!("Unknown ClassJob abbreviation: {abbrev}");
            false
        }
    }
}

// -------------------------------------------------------------------------------------------------
// Report model
// -------------------------------------------------------------------------------------------------

#[derive(Debug, Clone, Serialize)]
struct Collision {
    pvp_id: u32,
    name: String,
    correct_pve_id: u32,
}

#[derive(Debug, Serialize)]
struct ActionEntry {
    id: u32,
    name_en: Option<String>,
    name_loc: String,
    level: u8,
    category_id: u8,
    category_loc: String,
    kind: &'static str,
    base_action: Option<u32>,
    upgrade_from: Option<u32>,
    upgrade_to: Option<u32>,
    effective_at_level: Option<bool>,
    replaces: Option<u32>,
    is_pvp: bool,
    classjob_category: u8,
    implemented: bool,
    lua_path: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    reason: Option<&'static str>,
    #[serde(skip_serializing_if = "Option::is_none")]
    superseded_by: Option<u32>,
}

#[derive(Debug, Serialize)]
struct Meta {
    job_id: u32,
    job_abbrev: String,
    job_name_en: String,
    base_job_id: u32,
    game_path: String,
    names_en_path: Option<String>,
    english_names_available: bool,
    level_filter: Option<u8>,
    generated_by: &'static str,
    note: &'static str,
}

#[derive(Debug, Serialize)]
struct Counts {
    expected: usize,
    panel: usize,
    role: usize,
    implemented: usize,
    missing: usize,
    orphan: usize,
    superseded_at_level: usize,
    name_collisions: usize,
    stale_tagged: usize,
    missing_english_names: usize,
}

#[derive(Debug, Serialize)]
struct LadderEntry {
    root: u32,
    members: Vec<u32>,
    effective_at_level: Option<u32>,
}

#[derive(Debug, Serialize)]
struct JobReport {
    meta: Meta,
    counts: Counts,
    implemented: Vec<ActionEntry>,
    missing: Vec<ActionEntry>,
    orphans: Vec<ActionEntry>,
    superseded_at_level: Vec<ActionEntry>,
    name_collisions: Vec<Collision>,
    stale_tagged: Vec<ActionEntry>,
    upgrade_ladders: Vec<LadderEntry>,
    missing_english_names: Vec<u32>,
    lua_tree_health: TreeHealth,
}

/// Everything a report needs that is not per-job.
struct Context<'a> {
    gd: &'a GameData,
    lua: &'a LuaTree,
    names_en: Option<&'a HashMap<u32, String>>,
    level: Option<u8>,
    game_path: String,
    names_en_path: Option<String>,
    /// `implemented_ids \ union(expected(job)) over all named jobs`.
    orphan_ids: BTreeSet<u32>,
}

impl Context<'_> {
    fn entry(
        &self,
        id: u32,
        job: Option<(u32, u32)>,
        ladders: &[Ladder],
        missing_en: &mut BTreeSet<u32>,
    ) -> ActionEntry {
        let action = self.gd.actions.get(&id);
        let name_loc = action.map(|a| a.Name.clone()).unwrap_or_default();
        let category_id = action.map(|a| a.ActionCategory).unwrap_or(0);

        let name_en = self.names_en.and_then(|map| map.get(&id).cloned());
        if self.names_en.is_some() && name_en.is_none() {
            missing_en.insert(id);
        }

        let ladder = ladders.iter().find(|l| l.members.contains(&id));
        let effective_at_level = self.level.map(|level| match ladder {
            Some(ladder) => ladder.effective_at_level(self.gd, level) == Some(id),
            None => self.gd.level_of(id) <= level,
        });

        ActionEntry {
            id,
            name_en,
            name_loc,
            level: self.gd.level_of(id),
            category_id,
            category_loc: self
                .gd
                .categories
                .get(&(category_id as u32))
                .cloned()
                .unwrap_or_default(),
            kind: self.gd.classify(id, job).as_str(),
            base_action: ladder.map(|l| l.root),
            upgrade_from: ladder.and_then(|l| l.predecessor(id)),
            upgrade_to: ladder.and_then(|l| l.successor(id)),
            effective_at_level,
            replaces: self.gd.replaces.get(&id).copied(),
            is_pvp: action.map(|a| a.IsPvP).unwrap_or(false),
            classjob_category: action.map(|a| a.ClassJobCategory).unwrap_or(0),
            implemented: self.lua.by_id.contains_key(&id),
            lua_path: self.lua.by_id.get(&id).cloned(),
            reason: None,
            superseded_by: None,
        }
    }
}

/// Evaluated in order: a PvP action typically also fails `is_real_player_skill`, so a `system`-first
/// order would mask it.
fn orphan_reason(gd: &GameData, id: u32) -> &'static str {
    match gd.actions.get(&id) {
        Some(action) if action.IsPvP => "pvp",
        Some(action) if !is_real_player_skill(action) => "system",
        Some(_) => "suspect",
        None => "suspect",
    }
}

fn build_report(ctx: &Context, job_id: u32) -> JobReport {
    let gd = ctx.gd;
    let base_id = gd.base_of(job_id);
    let job = gd.jobs.get(&job_id).expect("job must exist");

    let panel_ids = gd.panel_ids(job_id);
    let role_ids = gd.role_actions(job_id);
    let expected = gd.expected(job_id);
    let ladders = gd.ladders(job_id);

    let mut missing_en = BTreeSet::new();
    let mut implemented = Vec::new();
    let mut missing = Vec::new();
    for id in &expected {
        let entry = ctx.entry(*id, Some((job_id, base_id)), &ladders, &mut missing_en);
        if entry.implemented {
            implemented.push(entry);
        } else {
            missing.push(entry);
        }
    }

    let dropped = gd.panel_dropped_cells(job_id);
    if !dropped.is_empty() {
        tracing::warn!(
            "{}: {} panel cell(s) point at something that is not a named action and were dropped: \
             {dropped:?}",
            job.abbrev,
            dropped.len()
        );
    }

    // ActionIndirection cross-check: every heuristic `replacement` must sit on a non-zero button.
    for id in &panel_ids {
        if gd.classify(*id, Some((job_id, base_id))) == Kind::Replacement
            && !gd.replaces.contains_key(id)
        {
            tracing::warn!(
                "Action {id} classifies as a `replacement` but has no button in ActionIndirection. \
                 The schema may have shifted."
            );
        }
    }

    let mut superseded_at_level = Vec::new();
    if let Some(level) = ctx.level {
        for ladder in &ladders {
            let effective = ladder.effective_at_level(gd, level);
            for member in &ladder.members {
                if Some(*member) == effective {
                    continue;
                }
                let mut entry =
                    ctx.entry(*member, Some((job_id, base_id)), &ladders, &mut missing_en);
                entry.superseded_by = effective;
                superseded_at_level.push(entry);
            }
        }
        superseded_at_level.sort_by_key(|e| e.id);
    }

    let stale_tagged: Vec<ActionEntry> = gd
        .stale_tagged(job_id)
        .into_iter()
        .map(|id| ctx.entry(id, Some((job_id, base_id)), &ladders, &mut missing_en))
        .collect();

    let orphans: Vec<ActionEntry> = ctx
        .orphan_ids
        .iter()
        .map(|id| {
            let mut entry = ctx.entry(*id, None, &[], &mut BTreeSet::new());
            entry.reason = Some(orphan_reason(gd, *id));
            entry
        })
        .collect();

    let name_collisions = gd.name_collisions(job_id);

    let upgrade_ladders: Vec<LadderEntry> = ladders
        .iter()
        .map(|l| LadderEntry {
            root: l.root,
            members: l.members.clone(),
            effective_at_level: ctx.level.and_then(|level| l.effective_at_level(gd, level)),
        })
        .collect();

    let counts = Counts {
        expected: expected.len(),
        panel: panel_ids.len(),
        role: role_ids.len(),
        implemented: implemented.len(),
        missing: missing.len(),
        orphan: orphans.len(),
        superseded_at_level: superseded_at_level.len(),
        name_collisions: name_collisions.len(),
        stale_tagged: stale_tagged.len(),
        missing_english_names: missing_en.len(),
    };

    JobReport {
        meta: Meta {
            job_id,
            job_abbrev: job.abbrev.clone(),
            job_name_en: job.name_en.clone(),
            base_job_id: base_id,
            game_path: ctx.game_path.clone(),
            names_en_path: ctx.names_en_path.clone(),
            english_names_available: ctx.names_en.is_some(),
            level_filter: ctx.level,
            generated_by: "kawari-actionaudit",
            note: "`implemented` only means a Lua script file claims this action ID. It does not \
                   mean the script is correct or complete.",
        },
        counts,
        implemented,
        missing,
        orphans,
        superseded_at_level,
        name_collisions,
        stale_tagged,
        upgrade_ladders,
        missing_english_names: missing_en.into_iter().collect(),
        lua_tree_health: TreeHealth {
            duplicate_ids: ctx
                .lua
                .health
                .duplicate_ids
                .iter()
                .map(|d| DuplicateId {
                    id: d.id,
                    kept: d.kept.clone(),
                    ignored: d.ignored.clone(),
                })
                .collect(),
            unparseable: ctx.lua.health.unparseable.clone(),
            would_panic: ctx.lua.health.would_panic.clone(),
        },
    }
}

// -------------------------------------------------------------------------------------------------
// Markdown emitters
// -------------------------------------------------------------------------------------------------

fn describe(entry: &ActionEntry) -> String {
    let name = match &entry.name_en {
        Some(name_en) if !entry.name_loc.is_empty() => format!("{} / {name_en}", entry.name_loc),
        Some(name_en) => name_en.clone(),
        None => entry.name_loc.clone(),
    };
    format!(
        "{} {name} (Lv{}, {}, {})",
        entry.id, entry.level, entry.category_loc, entry.kind
    )
}

fn render_job_markdown(report: &JobReport, gd: &GameData) -> String {
    let mut md = String::new();
    let meta = &report.meta;

    md.push_str(&format!(
        "# Action audit -- {} ({})\n\n",
        meta.job_abbrev, meta.job_name_en
    ));
    md.push_str(
        "> **\"Implemented\" only means a Lua script file claims this action ID.** It does not mean \
         the script is correct or complete.\n\n",
    );
    md.push_str(&format!(
        "- job id: {} (base class: {})\n- game path: `{}`\n- english names: {}\n- level filter: {}\n\n",
        meta.job_id,
        meta.base_job_id,
        meta.game_path,
        meta.names_en_path.as_deref().unwrap_or("(none)"),
        meta.level_filter
            .map(|l| l.to_string())
            .unwrap_or_else(|| "(unset)".to_string()),
    ));

    let c = &report.counts;
    md.push_str("## Counts\n\n| bucket | n |\n|---|---|\n");
    md.push_str(&format!("| expected | {} |\n", c.expected));
    md.push_str(&format!("| panel | {} |\n", c.panel));
    md.push_str(&format!("| role | {} |\n", c.role));
    md.push_str(&format!("| implemented | {} |\n", c.implemented));
    md.push_str(&format!("| missing | {} |\n", c.missing));
    md.push_str(&format!("| orphan (global) | {} |\n", c.orphan));
    md.push_str(&format!(
        "| superseded at level | {} |\n",
        c.superseded_at_level
    ));
    md.push_str(&format!(
        "| pvp name collisions | {} |\n",
        c.name_collisions
    ));
    md.push_str(&format!("| stale tagged | {} |\n", c.stale_tagged));
    md.push_str(&format!(
        "| missing english names | {} |\n\n",
        c.missing_english_names
    ));

    md.push_str(&format!(
        "## Implemented ({})\n\n",
        report.implemented.len()
    ));
    for entry in &report.implemented {
        md.push_str(&format!(
            "- [x] {} -- `{}`\n",
            describe(entry),
            entry.lua_path.as_deref().unwrap_or("")
        ));
    }

    md.push_str(&format!("\n## Missing ({})\n\n", report.missing.len()));
    for entry in &report.missing {
        md.push_str(&format!("- [ ] {}\n", describe(entry)));
    }

    md.push_str(&format!(
        "\n## Superseded at level ({})\n\n",
        report.superseded_at_level.len()
    ));
    md.push_str(
        "These are real actions on the panel that a character at the given level cannot cast, \
         because an upgrade has taken their button. They are NOT \"do not implement\" -- a \
         levelling character still casts them.\n\n",
    );
    for entry in &report.superseded_at_level {
        let by = entry
            .superseded_by
            .map(|id| describe_id(gd, id))
            .unwrap_or_else(|| "(nothing -- level too low for any member)".to_string());
        md.push_str(&format!("- {} -- superseded by {by}\n", describe(entry)));
    }

    md.push_str(&format!(
        "\n## PvP name collisions ({})\n\n",
        report.name_collisions.len()
    ));
    md.push_str(
        "PvP variants with byte-identical names but different action IDs. Searching `Action` by \
         name finds both. **Use the PvE id.**\n\n| PvP id (WRONG) | name | PvE id (CORRECT) |\n|---|---|---|\n",
    );
    for collision in &report.name_collisions {
        md.push_str(&format!(
            "| {} | {} | **{}** |\n",
            collision.pvp_id, collision.name, collision.correct_pve_id
        ));
    }

    md.push_str(&format!(
        "\n## Stale-tagged ({})\n\n",
        report.stale_tagged.len()
    ));
    md.push_str("Expected to be empty. A non-zero value is a red flag.\n\n");
    for entry in &report.stale_tagged {
        md.push_str(&format!("- {}\n", describe(entry)));
    }

    md.push_str(&format!("\n## Orphans ({})\n\n", report.orphans.len()));
    md.push_str(
        "Lua scripts whose action ID is on no job's expected list (computed over ALL named jobs).\n\n",
    );
    for entry in &report.orphans {
        md.push_str(&format!(
            "- [{}] {} -- `{}`\n",
            entry.reason.unwrap_or("?"),
            describe(entry),
            entry.lua_path.as_deref().unwrap_or("")
        ));
    }

    md.push_str(&format!(
        "\n## Upgrade ladders ({})\n\n",
        report.upgrade_ladders.len()
    ));
    for ladder in &report.upgrade_ladders {
        let chain: Vec<String> = ladder
            .members
            .iter()
            .map(|id| describe_id(gd, *id))
            .collect();
        md.push_str(&format!("- {}", chain.join(" -> ")));
        if let Some(effective) = ladder.effective_at_level {
            md.push_str(&format!("  [effective: {effective}]"));
        }
        md.push('\n');
    }

    md.push_str("\n## Lua tree health\n\n");
    md.push_str(&format!(
        "- duplicate ids: {}\n- unparseable file names (loader skips): {}\n- file names that would \
         PANIC the loader: {}\n",
        report.lua_tree_health.duplicate_ids.len(),
        report.lua_tree_health.unparseable.len(),
        report.lua_tree_health.would_panic.len(),
    ));
    for dup in &report.lua_tree_health.duplicate_ids {
        md.push_str(&format!(
            "  - id {}: keeps `{}`, ignores `{}`\n",
            dup.id, dup.kept, dup.ignored
        ));
    }
    for path in &report.lua_tree_health.would_panic {
        md.push_str(&format!("  - PANIC: `{path}`\n"));
    }

    md
}

fn describe_id(gd: &GameData, id: u32) -> String {
    match gd.actions.get(&id) {
        Some(action) => format!("{id} {} (Lv{})", action.Name, action.ClassJobLevel),
        None => format!("{id} (unknown)"),
    }
}

fn render_summary_markdown(reports: &[JobReport]) -> String {
    let mut md = String::from("# Action audit summary\n\n");
    md.push_str(
        "| job | expected | implemented | missing | superseded | pvp twins | stale | orphans (global) | missing en names |\n\
         |---|---|---|---|---|---|---|---|---|\n",
    );
    for report in reports {
        let c = &report.counts;
        md.push_str(&format!(
            "| {} | {} | {} | {} | {} | {} | {} | {} | {} |\n",
            report.meta.job_abbrev,
            c.expected,
            c.implemented,
            c.missing,
            c.superseded_at_level,
            c.name_collisions,
            c.stale_tagged,
            c.orphan,
            c.missing_english_names,
        ));
    }

    md.push_str("\n## Unsupported jobs\n\nThese jobs are excluded from the audit entirely, including from the orphan denominator:\n\n");
    for (abbrev, why) in UNSUPPORTED_JOBS {
        md.push_str(&format!("- **{abbrev}** -- {why}.\n"));
    }
    md
}

fn render_rename_markdown(
    reports: &[JobReport],
    names_en: &HashMap<u32, String>,
    new_action_dir: Option<&str>,
) -> String {
    let mut rows: BTreeMap<u32, (String, String)> = BTreeMap::new();

    for report in reports {
        for entry in report.implemented.iter().chain(report.missing.iter()) {
            let Some(name_en) = names_en.get(&entry.id) else {
                continue;
            };
            let suggested_stem = suggested_stem(name_en, entry.id);

            match &entry.lua_path {
                Some(path) => {
                    let path = Path::new(path);
                    let current_stem = path
                        .file_stem()
                        .and_then(|x| x.to_str())
                        .unwrap_or_default()
                        .to_string();
                    if current_stem == suggested_stem {
                        continue;
                    }
                    // Keep the existing directory: the 25 directory names follow no derivable rule
                    // and the loader ignores them. A move buys nothing and only adds risk.
                    let dir = path
                        .parent()
                        .map(|p| p.to_string_lossy().replace('\\', "/"))
                        .unwrap_or_default();
                    rows.insert(
                        entry.id,
                        (
                            format!("{dir}/{current_stem}.lua"),
                            format!("{dir}/{suggested_stem}.lua"),
                        ),
                    );
                }
                None => {
                    let Some(dir) = new_action_dir else {
                        continue;
                    };
                    rows.insert(
                        entry.id,
                        (
                            "(does not exist)".to_string(),
                            format!("resources/scripts/actions/{dir}/{suggested_stem}.lua"),
                        ),
                    );
                }
            }
        }
    }

    let mut md = String::from("# Filename suggestions\n\n");
    md.push_str(
        "Suggestions only -- this tool never renames or creates a file. Existing files keep their \
         current directory.\n\n| id | current | suggested |\n|---|---|---|\n",
    );
    for (id, (current, suggested)) in &rows {
        md.push_str(&format!("| {id} | `{current}` | `{suggested}` |\n"));
    }
    md
}

// -------------------------------------------------------------------------------------------------
// main
// -------------------------------------------------------------------------------------------------

fn main() {
    tracing_subscriber::fmt::init();
    std::process::exit(run());
}

fn run() -> i32 {
    let argv: Vec<String> = std::env::args().skip(1).collect();
    let args = match parse_args(&argv) {
        Ok(Some(args)) => args,
        Ok(None) => {
            println!("{HELP}");
            return 0;
        }
        Err(error) => {
            eprintln!("error: {error}\n\n{HELP}");
            return 1;
        }
    };

    let out = if args.summary_only {
        None
    } else {
        match resolve_safe_outdir(&args.out) {
            Ok(out) => Some(out),
            Err(error) => {
                eprintln!("error: {error}");
                return 1;
            }
        }
    };

    let config = get_config();
    let game_path = args
        .game_path
        .clone()
        .unwrap_or(config.filesystem.game_path.clone());
    let lang = match &args.lang {
        // `Language::from_shortname` silently maps anything it does not know to `Language::None`,
        // which then fails deep inside the resolver as an opaque `ResolverFailed`.
        Some(short) => match parse_language(short) {
            Some(lang) => lang,
            None => {
                eprintln!(
                    "error: unknown --lang `{short}`. Valid values: {}",
                    LANGUAGES.join(", ")
                );
                return 1;
            }
        },
        None => config.world.language(),
    };

    let gd = match load_game_data(&game_path, lang) {
        Ok(gd) => gd,
        Err(error) => {
            eprintln!("error: {error}");
            return 2;
        }
    };

    let names_en = match &args.names_en {
        Some(path) => match load_english_names(path) {
            Ok(names) => Some(names),
            Err(error) => {
                eprintln!("error: {error}");
                return 1;
            }
        },
        None => {
            tracing::warn!(
                "--names-en was not given, so english names are unavailable and the rename report \
                 is skipped. Pass e.g. --names-en <ffxiv-datamining>/csv/en/Action.csv"
            );
            None
        }
    };

    // Resolve the job selectors.
    let mut job_ids: Vec<u32> = Vec::new();
    if args.all_jobs {
        job_ids.extend(gd.jobs.keys().copied());
    } else {
        for selector in &args.jobs {
            let resolved = match selector.parse::<u32>() {
                Ok(id) if gd.jobs.contains_key(&id) => Some(id),
                Ok(_) => None,
                Err(_) => gd
                    .jobs
                    .values()
                    .find(|job| job.abbrev.eq_ignore_ascii_case(selector))
                    .map(|job| job.id),
            };
            match resolved {
                Some(id) => job_ids.push(id),
                None => {
                    eprintln!("error: unknown job `{selector}`");
                    return 1;
                }
            }
        }
    }
    // `Vec::dedup` only collapses *consecutive* duplicates, so `--jobs SMN,ACN,SMN` would audit SMN
    // twice. Drop repeats wherever they sit, keeping the caller's order.
    let mut seen = BTreeSet::new();
    job_ids.retain(|id| seen.insert(*id));

    // Skipping is driven by an empty panel, not by a hardcoded job id.
    let audited: Vec<u32> = job_ids
        .into_iter()
        .filter(|id| {
            if args.audit_panelless || !gd.panel_ids(*id).is_empty() {
                return true;
            }
            let abbrev = gd.jobs.get(id).map(|j| j.abbrev.as_str()).unwrap_or("?");
            tracing::warn!(
                "{abbrev} ({id}) has no ClassJobActionUI panel; its results would be meaningless. \
                 Skipping (use --audit-panelless to override)."
            );
            false
        })
        .collect();

    // The orphan denominator ALWAYS spans every named job, regardless of --jobs: otherwise every
    // other job's scripts would be reported as orphans.
    let mut all_expected: BTreeSet<u32> = BTreeSet::new();
    for job_id in gd.jobs.keys() {
        all_expected.extend(gd.expected(*job_id));
    }

    let search_dirs: Vec<String> = config
        .filesystem
        .additional_resource_paths
        .iter()
        .map(|path| format!("{path}/scripts"))
        .chain(std::iter::once("resources/scripts".to_string()))
        .collect();
    let lua = scan_lua_actions(&search_dirs);
    if lua.file_count == 0 {
        // Without this the tool happily emits a complete, plausible-looking report claiming
        // `implemented: 0 / missing: 69` -- i.e. it tells you to reimplement 47 actions that are
        // already done. Far more dangerous than crashing.
        eprintln!(
            "error: found no Lua action scripts at all (searched: {}).\n\
             The scan is relative to the CURRENT DIRECTORY -- run this tool from the repository \
             root. Refusing to emit a report that would claim everything is unimplemented.",
            search_dirs.join(", ")
        );
        return 2;
    }
    tracing::info!(
        "Scanned {} lua action scripts across {} directories.",
        lua.file_count,
        lua.dir_count
    );

    let orphan_ids: BTreeSet<u32> = lua
        .by_id
        .keys()
        .copied()
        .filter(|id| !all_expected.contains(id))
        .collect();

    let ctx = Context {
        gd: &gd,
        lua: &lua,
        names_en: names_en.as_ref(),
        level: args.level,
        game_path: game_path.clone(),
        names_en_path: args
            .names_en
            .as_ref()
            .map(|p| p.to_string_lossy().to_string()),
        orphan_ids,
    };

    let reports: Vec<JobReport> = audited
        .iter()
        .map(|job_id| build_report(&ctx, *job_id))
        .collect();

    for report in &reports {
        let c = &report.counts;
        println!(
            "{}: expected {} (panel {} + role {}), implemented {}, missing {}, superseded {}, \
             pvp-twins {}, stale {}, orphans {}, missing-en {}",
            report.meta.job_abbrev,
            c.expected,
            c.panel,
            c.role,
            c.implemented,
            c.missing,
            c.superseded_at_level,
            c.name_collisions,
            c.stale_tagged,
            c.orphan,
            c.missing_english_names,
        );
    }

    let Some(out) = out else {
        return 0;
    };

    if let Err(error) = std::fs::create_dir_all(&out) {
        eprintln!("error: cannot create `{}`: {error}", out.display());
        return 1;
    }

    for report in &reports {
        let abbrev = &report.meta.job_abbrev;
        if args.format != Format::Md {
            let json =
                serde_json::to_string_pretty(report).expect("failed to serialize the report");
            let path = out.join(format!("actionaudit-{abbrev}.json"));
            if let Err(error) = std::fs::write(&path, json) {
                eprintln!("error: cannot write `{}`: {error}", path.display());
                return 1;
            }
        }
        if args.format != Format::Json {
            let path = out.join(format!("actionaudit-{abbrev}.md"));
            if let Err(error) = std::fs::write(&path, render_job_markdown(report, &gd)) {
                eprintln!("error: cannot write `{}`: {error}", path.display());
                return 1;
            }
        }
    }

    let path = out.join("actionaudit-summary.md");
    if let Err(error) = std::fs::write(&path, render_summary_markdown(&reports)) {
        eprintln!("error: cannot write `{}`: {error}", path.display());
        return 1;
    }

    if let Some(names_en) = &names_en {
        let path = out.join("rename-suggestions.md");
        let md = render_rename_markdown(&reports, names_en, args.new_action_dir.as_deref());
        if let Err(error) = std::fs::write(&path, md) {
            eprintln!("error: cannot write `{}`: {error}", path.display());
            return 1;
        }
    }

    tracing::info!("Wrote reports to {}", out.display());
    0
}

// -------------------------------------------------------------------------------------------------
// Tests
// -------------------------------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::OnceLock;

    const SMN: u32 = 27;
    const ACN: u32 = 26;
    const BLU: u32 = 36;
    const MIN: u32 = 16;
    const CRP: u32 = 8;

    /// `cargo test` runs with the crate directory as cwd, but the tool (and the world server's Lua
    /// loader) resolve `resources/scripts/` and `config.yaml` relative to the repository root.
    fn goto_repo_root() {
        static ONCE: std::sync::Once = std::sync::Once::new();
        ONCE.call_once(|| {
            let root = repo_root()
                .canonicalize()
                .expect("cannot resolve the repository root");
            std::env::set_current_dir(root).expect("cannot enter the repository root");
        });
    }

    /// The user's sqpack.
    ///
    /// > 🚨 Every test using this is `#[ignore]`d. It must NOT degrade to "skip and pass" when the
    /// > game data is missing: `config.yaml` is untracked, so CI gets a default config with an empty
    /// > `game_path`, and a silent skip would let CI print a green "36 passed" while 24 of those
    /// > tests never executed a single assertion. `#[ignore]` makes the same situation print an
    /// > honest "24 ignored" instead.
    fn game() -> &'static GameData {
        static GAME: OnceLock<GameData> = OnceLock::new();
        GAME.get_or_init(|| {
            goto_repo_root();
            let config = get_config();
            let game_path = config.filesystem.game_path.clone();
            assert!(
                !game_path.is_empty() && Path::new(&game_path).exists(),
                "no FFXIV install at `{game_path}` (set filesystem.game_path in config.yaml).                  These tests are #[ignore]d for exactly this reason -- run them with                  `cargo test -p kawari-actionaudit -- --include-ignored` on a machine with the game."
            );
            match load_game_data(&game_path, config.world.language()) {
                Ok(gd) => gd,
                Err(error) => panic!("failed to load game data: {error}"),
            }
        })
    }

    /// The English-name CSV, which lives outside the repo. Also `#[ignore]`d -- see [`game`].
    fn english_names() -> &'static HashMap<u32, String> {
        static NAMES: OnceLock<HashMap<u32, String>> = OnceLock::new();
        NAMES.get_or_init(|| {
            goto_repo_root();
            let path = match std::env::var("KAWARI_NAMES_EN") {
                Ok(path) => PathBuf::from(path),
                Err(_) => repo_root().join("../ffxiv-datamining/csv/en/Action.csv"),
            };
            assert!(
                path.exists(),
                "no en/Action.csv at `{}` (override with $KAWARI_NAMES_EN)",
                path.display()
            );
            match load_english_names(&path) {
                Ok(names) => names,
                Err(error) => panic!("failed to load the english names: {error}"),
            }
        })
    }

    fn lua_tree() -> &'static LuaTree {
        static TREE: OnceLock<LuaTree> = OnceLock::new();
        TREE.get_or_init(|| {
            goto_repo_root();
            scan_lua_actions(&["resources/scripts".to_string()])
        })
    }

    // --- CLI + output guard ----------------------------------------------------------------------

    #[test]
    fn parses_default_args() {
        let args = parse_args(&[]).unwrap().unwrap();
        assert_eq!(args.jobs, vec!["26".to_string(), "27".to_string()]);
        assert_eq!(args.level, None);
        assert_eq!(args.format, Format::Both);
        assert_eq!(args.out, PathBuf::from("actionaudit-out"));
    }

    #[test]
    fn parses_flags() {
        let argv: Vec<String> = ["--jobs", "SMN", "--level", "100", "--format", "json"]
            .iter()
            .map(|s| s.to_string())
            .collect();
        let args = parse_args(&argv).unwrap().unwrap();
        assert_eq!(args.jobs, vec!["SMN".to_string()]);
        assert_eq!(args.level, Some(100));
        assert_eq!(args.format, Format::Json);
    }

    #[test]
    fn rejects_unknown_flag() {
        assert!(parse_args(&["--nope".to_string()]).is_err());
    }

    #[test]
    fn language_shortnames_are_validated() {
        // physis silently maps an unknown shortname to `Language::None`, which then fails deep in
        // the resolver as an opaque `ResolverFailed`.
        assert_eq!(parse_language("chs"), Some(Language::ChineseSimplified));
        assert_eq!(parse_language("en"), Some(Language::English));
        assert_eq!(parse_language("zh"), None);
        assert_eq!(parse_language(""), None);
    }

    #[test]
    fn outdir_guard_rejects_paths_inside_resources_scripts() {
        goto_repo_root();
        // A stray file under resources/scripts/actions/ panics the world server at startup.
        assert!(resolve_safe_outdir(Path::new("resources/scripts/actions/out")).is_err());
        assert!(resolve_safe_outdir(Path::new("resources/scripts")).is_err());
        assert!(resolve_safe_outdir(Path::new("./resources/scripts/effects")).is_err());
        // ..and it must not be dodgeable by a `..` component.
        assert!(
            resolve_safe_outdir(Path::new("actionaudit-out/../resources/scripts/actions")).is_err()
        );
    }

    #[test]
    fn outdir_guard_accepts_a_fresh_nonexistent_dir() {
        goto_repo_root();
        // `std::fs::canonicalize` returns Err for a path that does not exist -- the default outdir
        // on the very first run. The guard must still accept it, and create nothing.
        let fresh = Path::new("actionaudit-out-does-not-exist-12345/nested");
        assert!(!fresh.exists());
        let resolved = resolve_safe_outdir(fresh).expect("a fresh outdir must be accepted");
        assert!(resolved.is_absolute());
        assert!(!fresh.exists(), "the guard must not create anything");
    }

    /// Regression: the guard used to resolve `resources/scripts` RELATIVE TO THE CWD, so running
    /// from anywhere but the repo root made `forbidden.exists()` false and turned the whole check
    /// off. This escape reached `resources/scripts/actions/` and would have panicked the world
    /// server at startup.
    #[test]
    fn outdir_guard_survives_a_cwd_relative_escape() {
        let crate_dir = Path::new(env!("CARGO_MANIFEST_DIR"));
        let escape = crate_dir.join("../../resources/scripts/actions/EVIL");
        let error = resolve_safe_outdir(&escape)
            .expect_err("an --out that escapes into resources/scripts must be refused");
        assert!(error.contains("refusing to write"), "{error}");

        // NOTE: the cwd-relative spelling of this escape
        // (`cd tools/actionaudit && cargo run -- --out ../../resources/scripts/actions/EVIL`) is
        // verified end-to-end against the real binary rather than here -- `set_current_dir` is
        // process-global and would race the other tests, which run in parallel and rely on the cwd
        // being the repository root.
    }

    // --- CSV reader -------------------------------------------------------------------------------

    #[test]
    fn csv_reader_handles_rfc4180_quoting() {
        assert_eq!(parse_csv_line("1,Foo,2"), vec!["1", "Foo", "2"]);
        // A naive split(',') yields `"10` here.
        assert_eq!(
            parse_csv_line(r#"2678,"10,000 Needles",0,405"#),
            vec!["2678", "10,000 Needles", "0", "405"]
        );
        assert_eq!(
            parse_csv_line(r#"8303,"Storm, Swell, Sword",0"#),
            vec!["8303", "Storm, Swell, Sword", "0"]
        );
        assert_eq!(
            parse_csv_line(r#"1,"He said ""hi""",2"#),
            vec!["1", r#"He said "hi""#, "2"]
        );
        assert_eq!(parse_csv_line("1,,2"), vec!["1", "", "2"]);
        // A trailing comma means a trailing EMPTY field -- it must not vanish, or every column
        // index after it would shift.
        assert_eq!(parse_csv_line("1,2,"), vec!["1", "2", ""]);
        assert_eq!(parse_csv_line(""), vec![""]);
        assert_eq!(parse_csv_line(r#"1,"",2"#), vec!["1", "", "2"]);
    }

    #[test]
    fn csv_reader_rejects_a_wrong_header() {
        // csv/cn/Action.csv has a BOM, a 3-line header and a different column order: pointing
        // --names-en at it must abort, not silently read the wrong column.
        let dir = std::env::temp_dir().join("kawari-actionaudit-tests");
        std::fs::create_dir_all(&dir).unwrap();
        let path = dir.join("wrong-header.csv");
        std::fs::write(&path, "\u{feff}key,0,1,2,3\n#,Name,UnlockLink\n0,,0\n").unwrap();
        let error = load_english_names(&path).unwrap_err();
        assert!(error.contains("unexpected header"), "{error}");
        assert!(error.contains("`key`"), "{error}");
        std::fs::remove_file(&path).ok();
    }

    #[test]
    fn csv_reader_accepts_a_bom() {
        let dir = std::env::temp_dir().join("kawari-actionaudit-tests");
        std::fs::create_dir_all(&dir).unwrap();
        let path = dir.join("bom.csv");
        std::fs::write(&path, "\u{feff}#,Name,UnlockLink\n163,Ruin,0\n").unwrap();
        let names = load_english_names(&path).unwrap();
        assert_eq!(names.get(&163).map(String::as_str), Some("Ruin"));
        std::fs::remove_file(&path).ok();
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn english_names_golden_sample() {
        let names = english_names();
        for (id, expected) in [
            (25802u32, "Summon Ruby"),
            (25805, "Summon Ifrit"),
            (25838, "Summon Ifrit II"),
            (7429, "Enkindle Bahamut"),
            (7449, "Akh Morn"),
            (25823, "Ruby Rite"),
            (36990, "Necrotize"),
            (36997, "Lux Solaris"),
            (36998, "Enkindle Solar Bahamut"),
            // The quoted fields -- these are what catch a naive split(',').
            (2678, "10,000 Needles"),
            (8303, "Storm, Swell, Sword"),
        ] {
            assert_eq!(
                names.get(&id).map(String::as_str),
                Some(expected),
                "action {id}"
            );
        }
    }

    // --- Filename suggestions ---------------------------------------------------------------------

    #[test]
    fn suggested_stems_match_the_existing_convention() {
        assert_eq!(
            suggested_stem("Summon Ifrit II", 25838),
            "SummonIfritII_25838"
        );
        assert_eq!(suggested_stem("Arm's Length", 7548), "ArmsLength_07548");
        assert_eq!(suggested_stem("Storm's Path", 42), "StormsPath_00042");
        assert_eq!(suggested_stem("Butcher's Block", 47), "ButchersBlock_00047");
        assert_eq!(suggested_stem("Ruin III", 3579), "RuinIII_03579");
        assert_eq!(suggested_stem("10,000 Needles", 2678), "10000Needles_02678");
        assert_eq!(
            suggested_stem("Storm, Swell, Sword", 8303),
            "StormSwellSword_08303"
        );
        assert_eq!(suggested_stem("", 1), "Unnamed_00001");
        assert_eq!(suggested_stem("召唤伊弗利特", 25805), "Unnamed_25805");
    }

    /// The loader does `stem.split_once('_')` then `.parse::<u32>().expect(..)`. A stem with two
    /// underscores PANICS the world server at startup, and CI never boots it -- so this is checked
    /// over the ENTIRE generated suggestion set, not a sample.
    fn assert_stem_is_loader_safe(stem: &str) {
        assert_eq!(
            stem.matches('_').count(),
            1,
            "stem `{stem}` must have exactly one underscore"
        );
        assert!(stem.is_ascii(), "stem `{stem}` must be pure ASCII");
        let (name, id) = stem.split_once('_').unwrap();
        assert!(!name.is_empty(), "stem `{stem}` has an empty name part");
        assert!(
            id.parse::<u32>().is_ok(),
            "the tail of stem `{stem}` must parse as u32"
        );
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn every_generated_stem_is_loader_safe() {
        let names = english_names();
        for (id, name) in names {
            assert_stem_is_loader_safe(&suggested_stem(name, *id));
        }
    }

    #[test]
    fn stems_are_loader_safe_for_adversarial_names() {
        for name in [
            "Barrage_BRD",
            "10,000 Needles",
            "Arm's Length",
            "召唤伊弗利特",
            "___",
            "A  B",
            "-- weird --",
        ] {
            assert_stem_is_loader_safe(&suggested_stem(name, 42));
        }
    }

    // --- Lua tree ---------------------------------------------------------------------------------

    #[test]
    fn lua_tree_is_healthy() {
        let tree = lua_tree();

        // These are INVARIANTS -- they must hold no matter how the tree grows, and this test runs
        // in CI. The exact counts are deliberately NOT pinned here: this tool exists to drive
        // people to ADD action scripts, so `== 125` would turn the very first new script into a red
        // CI build. The tree was 125 files / 25 dirs when the tool was written; it may only grow.
        assert!(
            tree.file_count >= 125,
            "expected at least 125 lua action scripts, found {}",
            tree.file_count
        );
        assert!(
            tree.dir_count >= 25,
            "expected at least 25 action script directories, found {}",
            tree.dir_count
        );
        assert_eq!(
            tree.by_id.len(),
            tree.file_count,
            "every script must claim a distinct action id"
        );
        assert!(
            tree.health.duplicate_ids.is_empty(),
            "duplicate ids: {:?}",
            tree.health.duplicate_ids
        );
        assert!(
            tree.health.unparseable.is_empty(),
            "unparseable: {:?}",
            tree.health.unparseable
        );
        assert!(
            tree.health.would_panic.is_empty(),
            "would panic the world server: {:?}",
            tree.health.would_panic
        );
    }

    #[test]
    fn every_existing_lua_stem_is_loader_safe() {
        goto_repo_root();
        for path in lua_tree().by_id.values() {
            let stem = Path::new(path).file_stem().unwrap().to_str().unwrap();
            assert_stem_is_loader_safe(stem);
        }
    }

    /// The `expected()` closure rescues panel-less button-replacements. Game-wide it adds exactly
    /// 10 ids -- every one an id the client really sends. Pinned so it cannot drift silently.
    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn the_expected_closure_adds_exactly_ten_ids() {
        let gd = game();
        let mut added: Vec<(String, u32)> = Vec::new();
        for job_id in gd.jobs.keys() {
            let panel = gd.panel_ids(*job_id);
            let role = gd.role_actions(*job_id);
            for id in gd.expected(*job_id) {
                if !panel.contains(&id) && !role.contains(&id) {
                    added.push((gd.jobs.get(job_id).unwrap().abbrev.clone(), id));
                }
            }
        }
        added.sort();

        let want: Vec<(String, u32)> = [
            ("AST", 8324u32), // Astrodyne, on the 7439 button
            ("AST", 16558),   // Horoscope, on the 16557 button
            ("DNC", 16191),   // Standard Finish variants, on the 15997 button
            ("DNC", 16192),
            ("DNC", 16193), // Technical Finish variants, on the 15998 button
            ("DNC", 16194),
            ("DNC", 16195),
            ("DNC", 16196),
            ("NIN", 2272),  // Ninjutsu, on the 2260 (Ten) button
            ("SCH", 37037), // Emergency Tactics (Lv100), on the 3586 button
        ]
        .iter()
        .map(|(a, i)| (a.to_string(), *i))
        .collect();
        assert_eq!(added, want);

        // Every one is job-less, sits on a button, and appears on NO panel anywhere.
        for (_, id) in &added {
            assert_eq!(gd.actions.get(id).unwrap().ClassJob, 0);
            assert!(gd.replaces.contains_key(id));
            assert!(!gd.all_panel_ids.contains(id));
        }
    }

    // --- Panel ------------------------------------------------------------------------------------

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn panel_subrow_counts() {
        let gd = game();
        // `.row()` on this subrow sheet would silently return 1 cell instead of 15/49.
        assert_eq!(gd.ui.get(&ACN).map(Vec::len), Some(15));
        assert_eq!(gd.ui.get(&SMN).map(Vec::len), Some(49));
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn panel_cell_decomposition() {
        let gd = game();
        let cells = gd.panel_cells(SMN);
        assert_eq!(cells.len(), 64);

        let no_upgrade = cells.iter().filter(|c| c.base == 0).count();
        let roots = cells
            .iter()
            .filter(|c| c.base != 0 && c.base == c.upgrade)
            .count();
        let edges = cells
            .iter()
            .filter(|c| c.base != 0 && c.base != c.upgrade)
            .count();
        assert_eq!((no_upgrade, roots, edges), (45, 7, 12));
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn panel_has_64_unique_action_ids() {
        let gd = game();
        assert_eq!(gd.panel_ids(SMN).len(), 64);
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn base_class_resolution_is_data_driven() {
        let gd = game();
        assert_eq!(gd.base_of(SMN), ACN);
        assert_eq!(gd.base_of(ACN), ACN);
        // DRK has no base class at all.
        assert_eq!(gd.base_of(32), 32);
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn kind_split_over_the_panel() {
        let gd = game();
        let mut player = 0;
        let mut replacement = 0;
        let mut pet = 0;
        let mut role = 0;
        let mut unknown = 0;
        for id in gd.panel_ids(SMN) {
            match gd.classify(id, Some((SMN, ACN))) {
                Kind::Player => player += 1,
                Kind::Replacement => replacement += 1,
                Kind::Pet => pet += 1,
                Kind::Role => role += 1,
                Kind::Unknown => unknown += 1,
            }
        }
        assert_eq!(
            (player, replacement, pet, role, unknown),
            (34, 23, 7, 0, 0),
            "kind split over the 64 unique panel action ids"
        );
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn role_actions_are_checked_before_pets() {
        let gd = game();
        // Arm's Length is IsRoleAction = true AND ClassJob = -1 -- the same ClassJob as a pet cast.
        let arms_length = gd.actions.get(&7548).unwrap();
        assert!(arms_length.IsRoleAction);
        assert_eq!(arms_length.ClassJob, -1);
        assert_eq!(gd.classify(7548, Some((SMN, ACN))), Kind::Role);
        // Wyrmwave is a real pet cast.
        assert_eq!(gd.actions.get(&7428).unwrap().ClassJob, -1);
        assert_eq!(gd.classify(7428, Some((SMN, ACN))), Kind::Pet);
    }

    // --- Ladders ----------------------------------------------------------------------------------

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn ladders_group_by_root() {
        let gd = game();
        let ladders = gd.ladders(SMN);
        assert_eq!(ladders.len(), 7, "distinct BaseAction roots");

        let fan_outs: Vec<u32> = ladders
            .iter()
            .filter(|l| l.members.len() > 2)
            .map(|l| l.root)
            .collect();
        assert_eq!(fan_outs, vec![163, 25800, 25802, 25803, 25804]);

        // BaseAction is the ROOT, not the predecessor.
        let ladder = ladders.iter().find(|l| l.root == 25802).unwrap();
        assert_eq!(ladder.members, vec![25802, 25805, 25838]);
        assert_eq!(gd.level_of(25802), 6);
        assert_eq!(gd.level_of(25805), 30);
        assert_eq!(gd.level_of(25838), 90);
        // The raw sheet has no 25805 -> 25838 edge: both point at root 25802.
        assert_eq!(ladder.predecessor(25838), Some(25805));
        assert_eq!(ladder.successor(25805), Some(25838));
        assert_eq!(ladder.successor(25838), None);

        // Exactly one member is effective at a level.
        assert_eq!(ladder.effective_at_level(gd, 100), Some(25838));
        assert_eq!(ladder.effective_at_level(gd, 89), Some(25805));
        assert_eq!(ladder.effective_at_level(gd, 5), None);
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn no_ladder_has_a_level_tie_in_any_job() {
        let gd = game();
        // A base class shares its ladders with its job, so the per-job loop sees the same ladder
        // twice. Dedupe by ROOT before counting, or the total is inflated.
        let mut fan_out_roots: BTreeSet<u32> = BTreeSet::new();
        let mut ties = 0;
        for job_id in gd.jobs.keys() {
            for ladder in gd.ladders(*job_id) {
                if ladder.members.len() > 2 {
                    fan_out_roots.insert(ladder.root);
                }
                for pair in ladder.members.windows(2) {
                    if gd.level_of(pair[0]) == gd.level_of(pair[1]) {
                        ties += 1;
                    }
                }
            }
        }
        assert_eq!(
            ties, 0,
            "level ordering within a ladder must be unambiguous"
        );
        // §7.1: 17 fan-out ladders across every job, none with a level tie.
        assert_eq!(fan_out_roots.len(), 17, "fan-out ladders across all jobs");
    }

    // --- Role actions + expected ------------------------------------------------------------------

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn role_actions_exclude_pvp_and_other_roles() {
        let gd = game();
        let role = gd.role_actions(SMN);
        assert_eq!(
            role.iter().copied().collect::<Vec<u32>>(),
            vec![7559, 7560, 7561, 7562, 25880],
            "SMN role actions"
        );
        // The PvP caster role actions must NOT be here: they would land in `missing` and instruct
        // the user to implement PvP action IDs.
        for pvp in [43252u32, 43254, 43291] {
            assert!(!role.contains(&pvp), "{pvp} is a PvP role action");
        }
        // Arm's Length is tank/melee/phys-ranged; Esuna and Rescue are healer-only.
        for other in [7548u32, 7568, 7571] {
            assert!(!role.contains(&other), "{other} is not an SMN role action");
        }
        assert_eq!(gd.role_actions(ACN).len(), 5);
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn expected_sets() {
        let gd = game();
        assert_eq!(gd.expected(SMN).len(), 69, "panel(64) + role(5)");
        assert_eq!(gd.expected(ACN).len(), 20, "panel(15) + role(5)");
    }

    // --- Hazard buckets ---------------------------------------------------------------------------

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn superseded_at_level_100() {
        let gd = game();
        let mut superseded: Vec<u32> = Vec::new();
        for ladder in gd.ladders(SMN) {
            let effective = ladder.effective_at_level(gd, 100);
            for member in &ladder.members {
                if Some(*member) != effective {
                    superseded.push(*member);
                }
            }
        }
        superseded.sort();
        assert_eq!(
            superseded,
            vec![
                163, 172, 181, 3581, 16511, 25800, 25802, 25803, 25804, 25805, 25806, 25807
            ]
        );
        // These ARE the Lv100 actives, so they must not be listed.
        for active in [3579u32, 25838, 36990] {
            assert!(!superseded.contains(&active), "{active} is active at Lv100");
        }
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn pvp_name_collisions() {
        let gd = game();
        let collisions = gd.name_collisions(SMN);
        assert_eq!(collisions.len(), 17, "SMN PvP name twins");

        let map: HashMap<u32, u32> = collisions
            .iter()
            .map(|c| (c.pvp_id, c.correct_pve_id))
            .collect();
        // The three PET twins are the most dangerous ones -- Kawari already implements pet actions.
        assert_eq!(map.get(&29676), Some(&7428), "Wyrmwave");
        assert_eq!(map.get(&29680), Some(&16517), "Everlasting Flight");
        assert_eq!(map.get(&29681), Some(&16519), "Scarlet Flame");
        assert_eq!(map.get(&41483), Some(&36990), "Necrotize");
        assert_eq!(map.get(&29664), Some(&3579), "Ruin III");
        // The pet twins have ClassJob == -1: a ClassJob filter would silently drop them.
        assert_eq!(gd.actions.get(&29676).unwrap().ClassJob, -1);

        // Multiplicity: no PvP id may match more than one expected action.
        let expected = gd.expected(SMN);
        let mut names: HashMap<&str, usize> = HashMap::new();
        for id in &expected {
            if let Some(action) = gd.actions.get(id)
                && !action.Name.is_empty()
            {
                *names.entry(action.Name.as_str()).or_default() += 1;
            }
        }
        for collision in &collisions {
            assert_eq!(
                names.get(collision.name.as_str()),
                Some(&1),
                "`{}` matches more than one expected action",
                collision.name
            );
        }
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn stale_tagged_is_empty_except_for_panelless_jobs() {
        let gd = game();
        assert_eq!(gd.stale_tagged(SMN).len(), 0);
        assert_eq!(gd.stale_tagged(ACN).len(), 0);
        // DoH/DoL are not anomalous: they have real panels.
        assert_eq!(gd.stale_tagged(MIN).len(), 0);
        assert_eq!(gd.stale_tagged(CRP).len(), 0);
        // BLU is the sole exception -- its spells are learned, not levelled.
        assert_eq!(gd.stale_tagged(BLU).len(), 125);

        let nonzero: Vec<u32> = gd
            .jobs
            .keys()
            .copied()
            .filter(|id| !gd.stale_tagged(*id).is_empty())
            .collect();
        assert_eq!(nonzero, vec![BLU], "exactly one job may be stale-tagged");

        // The skip rule is `panel.is_empty()`, not a hardcoded job id -- and the two sets coincide.
        let panelless: Vec<u32> = gd
            .jobs
            .keys()
            .copied()
            .filter(|id| gd.panel_ids(*id).is_empty())
            .collect();
        assert_eq!(panelless, vec![BLU]);
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn semantic_filter_is_tight_but_not_over_tight() {
        let gd = game();
        // ClassJobCategory[1] is "All Classes" (43/43 job bools true). Every named action tagged
        // with it must fail the filter, or the hazard buckets drown in 483 rows of noise.
        let broad = gd
            .actions
            .values()
            .filter(|a| a.ClassJobCategory == 1 && !a.Name.is_empty())
            .count();
        assert!(
            broad > 400,
            "sanity: expected a few hundred rows, got {broad}"
        );
        let broad_passing = gd
            .actions
            .values()
            .filter(|a| a.ClassJobCategory == 1 && !a.Name.is_empty() && is_real_player_skill(a))
            .count();
        assert_eq!(broad_passing, 0);

        // ..and the reverse: the filter must not be over-tight. Every `player` action on SMN's
        // panel must pass it.
        let players: Vec<u32> = gd
            .panel_ids(SMN)
            .into_iter()
            .filter(|id| gd.classify(*id, Some((SMN, ACN))) == Kind::Player)
            .collect();
        assert_eq!(players.len(), 34);
        let passing = players
            .iter()
            .filter(|id| is_real_player_skill(gd.actions.get(id).unwrap()))
            .count();
        assert_eq!(passing, 34, "34/34 player actions must pass the filter");
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn action_indirection_answers_which_button() {
        let gd = game();
        assert_eq!(gd.replaces.get(&25823), Some(&25883), "Ruby Rite/Gemshine");
        // A PET action WITH a button: proves `PreviousComboAction == 0` is not a pet test.
        assert_eq!(
            gd.replaces.get(&7449),
            Some(&7429),
            "Akh Morn/Enkindle Bahamut"
        );
        assert_eq!(gd.actions.get(&7449).unwrap().ClassJob, -1);
        // Indirection nests: Crimson Cyclone is itself a replacement and a button.
        assert_eq!(gd.replaces.get(&25835), Some(&25822));
        assert_eq!(gd.replaces.get(&25885), Some(&25835));

        // Every heuristic `replacement` on the panel sits on a non-zero button: 23/23.
        let replacements: Vec<u32> = gd
            .panel_ids(SMN)
            .into_iter()
            .filter(|id| gd.classify(*id, Some((SMN, ACN))) == Kind::Replacement)
            .collect();
        assert_eq!(replacements.len(), 23);
        let with_button = replacements
            .iter()
            .filter(|id| gd.replaces.contains_key(id))
            .count();
        assert_eq!(with_button, 23, "23/23 replacements must have a button");
    }

    // --- Orphans ----------------------------------------------------------------------------------

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn orphans_over_the_real_tree() {
        let gd = game();
        let tree = lua_tree();

        // The denominator spans ALL named jobs, not just the audited ones and not just the battle
        // jobs -- otherwise e.g. Prospect (227, a gatherer action) is falsely orphaned.
        let mut all_expected: BTreeSet<u32> = BTreeSet::new();
        for job_id in gd.jobs.keys() {
            all_expected.extend(gd.expected(*job_id));
        }

        let orphans: Vec<u32> = tree
            .by_id
            .keys()
            .copied()
            .filter(|id| !all_expected.contains(id))
            .collect();
        assert_eq!(orphans.len(), 13, "orphans: {orphans:?}");

        let mut system = 0;
        let mut pvp = 0;
        let mut suspect = 0;
        for id in &orphans {
            match orphan_reason(gd, *id) {
                "system" => system += 1,
                "pvp" => pvp += 1,
                _ => suspect += 1,
            }
        }
        assert_eq!((system, pvp, suspect), (13, 0, 0));

        // Sprint / Teleport / Return are `system`, never `suspect`.
        for id in [3u32, 5, 6] {
            assert_eq!(orphan_reason(gd, id), "system");
        }
        // Prospect is covered by role_actions(MIN), so it must not be an orphan at all.
        assert!(!orphans.contains(&227), "Prospect must not be orphaned");
        assert!(gd.role_actions(MIN).contains(&227));
    }

    // --- Named jobs -------------------------------------------------------------------------------

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn unsupported_jobs_are_excluded() {
        let gd = game();
        // The sheet has 44 NAMED rows (0=ADV .. 42=PCT, 43=BST). 10 are unsupported:
        // ADV (not a job), BST (no ClassJobCategory column), and the 8 DoH (CraftAction panels).
        assert_eq!(gd.jobs.len(), 44 - UNSUPPORTED_JOBS.len());
        assert_eq!(gd.jobs.len(), 34);
        for (abbrev, _) in UNSUPPORTED_JOBS {
            assert!(
                !gd.jobs.values().any(|j| j.abbrev == abbrev),
                "{abbrev} must be excluded"
            );
        }
        // The DoL jobs are NOT excluded -- they have real Action-sheet panels.
        for abbrev in ["MIN", "BTN", "FSH", "SMN", "PCT"] {
            assert!(gd.jobs.values().any(|j| j.abbrev == abbrev), "{abbrev}");
        }
    }

    /// The Replacement rule is `ClassJob == 0 && has an ActionIndirection entry` -- NOT
    /// `!IsPlayerAction`. These are the two live actions that prove it.
    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn indirection_reachable_replacements_are_expected() {
        let gd = game();
        const SCH: u32 = 28;
        const DRG: u32 = 22;

        // 37037 Emergency Tactics (Lv100) is on NO panel anywhere, but sits on SCH's 3586 button.
        assert!(!gd.panel_ids(SCH).contains(&37037));
        assert!(gd.actions.get(&37037).unwrap().IsPlayerAction);
        assert_eq!(gd.actions.get(&37037).unwrap().ClassJob, 0);
        assert_eq!(gd.replaces.get(&37037), Some(&3586));
        assert!(
            gd.expected(SCH).contains(&37037),
            "37037 must now be expected for SCH"
        );
        assert_eq!(
            gd.classify(37037, Some((SCH, gd.base_of(SCH)))),
            Kind::Replacement
        );

        // 36952 Drakesbane is on DRG's panel and used to classify as `unknown`.
        assert!(gd.panel_ids(DRG).contains(&36952));
        assert_eq!(
            gd.classify(36952, Some((DRG, gd.base_of(DRG)))),
            Kind::Replacement
        );
    }

    /// No bucket may contain an entry with no name at all -- that would tell the user to implement
    /// an action that does not exist. The two placeholder panel cells are the only offenders.
    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn no_expected_action_is_nameless() {
        let gd = game();
        for job_id in gd.jobs.keys() {
            for id in gd.expected(*job_id) {
                let action = gd.actions.get(&id);
                assert!(
                    action.is_some_and(|a| !a.Name.is_empty()),
                    "job {job_id} expects nameless action {id}"
                );
            }
        }
        // The placeholder cells are dropped, and the drop is reported, not swallowed.
        assert_eq!(gd.panel_dropped_cells(40), BTreeSet::from([41248])); // SGE
        assert_eq!(gd.panel_dropped_cells(20), BTreeSet::from([41249])); // MNK
        assert!(!gd.expected(40).contains(&41248));
        assert!(!gd.expected(20).contains(&41249));
        // ..and dropping them must not disturb the golden panels.
        assert_eq!(gd.panel_ids(SMN).len(), 64);
    }

    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn no_panel_action_classifies_as_unknown_in_any_job() {
        let gd = game();
        let mut unknowns: Vec<(u32, u32)> = Vec::new();
        for job_id in gd.jobs.keys() {
            for id in gd.expected(*job_id) {
                if gd.classify(id, Some((*job_id, gd.base_of(*job_id)))) == Kind::Unknown {
                    unknowns.push((*job_id, id));
                }
            }
        }
        assert_eq!(unknowns, vec![], "every expected action must classify");
    }

    /// After the rule extension, the only real player skills covered by no job are BLU's 125
    /// learned spells. 37037 is no longer among them.
    #[ignore = "requires a local FFXIV install; run with --include-ignored"]
    #[test]
    fn only_blu_spells_are_uncovered() {
        let gd = game();
        let mut all_expected: BTreeSet<u32> = BTreeSet::new();
        for job_id in gd.jobs.keys() {
            all_expected.extend(gd.expected(*job_id));
        }
        let uncovered: Vec<u32> = gd
            .actions
            .iter()
            .filter(|(id, a)| {
                is_real_player_skill(a)
                    && !a.IsPvP
                    && !a.Name.is_empty()
                    && !all_expected.contains(id)
            })
            .map(|(id, _)| *id)
            .collect();
        assert_eq!(
            uncovered.len(),
            125,
            "only the 125 BLU spells may be uncovered"
        );
        assert!(!uncovered.contains(&37037));
        assert!(
            uncovered
                .iter()
                .all(|id| gd.actions.get(id).unwrap().ClassJob == 36),
            "every uncovered action must be BLU"
        );
    }
}
