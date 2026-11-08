//! One-off EXD lookup tool: prints selected Status / Action / BNpcName / EObj rows from the
//! CN client sheets (the same sqpack the world server and actionaudit read). Exists because
//! CN 7.51 row ids do not always match the global ffxiv-datamining csv dumps — packet captures
//! must be resolved against the CN sheets themselves.
//!
//! Usage: cargo run -p kawari-actionaudit --bin exddump -- [game_path]
//!   game_path defaults to config.filesystem.game_path.

use icarus::{Action::ActionSheet, BNpcName::BNpcNameSheet, EObj::EObjSheet, Status::StatusSheet};
use kawari::config::get_config;
use physis::{
    Language,
    resource::{ResourceResolver, SqPackResource},
};

const STATUS_IDS: &[u32] = &[
    155, 157, 158, 150, 3880, 1217, 1218, 1219, 1872, 1873, 1911, 1912, 2161, 2162, 2708, 2709,
    2857, 2959, 3879, 3881, 3903, 3904, 43, 2, 3, 167, 160,
];

const ACTION_IDS: &[u32] = &[
    3569, 25862, 25864, 25893, 25895, 26108, 28507, 28540, 136, 16536, 37011, 7433, 25861, 7432,
    140, 125,
];

const BNPC_NAME_IDS: &[u32] = &[10349];

const EOBJ_IDS: &[u32] = &[1771];

fn main() {
    let game_path = std::env::args()
        .nth(1)
        .unwrap_or_else(|| get_config().filesystem.game_path.clone());
    let mut resolver = ResourceResolver::new();
    resolver.add_source(SqPackResource::from_existing(&game_path));

    let status = StatusSheet::read_from(&mut resolver, Language::ChineseSimplified)
        .expect("read Status sheet");
    println!("== Status ==");
    for &id in STATUS_IDS {
        match status.row(id) {
            Some(row) => println!("{id}: {:?} — {:?}", row.Name, row.Description),
            None => println!("{id}: <no row>"),
        }
    }

    let action = ActionSheet::read_from(&mut resolver, Language::ChineseSimplified)
        .expect("read Action sheet");
    println!("== Action ==");
    for &id in ACTION_IDS {
        match action.row(id) {
            Some(row) => println!("{id}: {:?}", row.Name),
            None => println!("{id}: <no row>"),
        }
    }

    let bnpc_name = BNpcNameSheet::read_from(&mut resolver, Language::ChineseSimplified)
        .expect("read BNpcName sheet");
    println!("== BNpcName ==");
    for &id in BNPC_NAME_IDS {
        match bnpc_name.row(id) {
            Some(row) => println!("{id}: {:?}", row.Singular),
            None => println!("{id}: <no row>"),
        }
    }

    let eobj = EObjSheet::read_from(&mut resolver, Language::None).expect("read EObj sheet");
    println!("== EObj ==");
    for &id in EOBJ_IDS {
        match eobj.row(id) {
            Some(row) => println!("{id}: data={:#x}", row.Data),
            None => println!("{id}: <no row>"),
        }
    }
}
