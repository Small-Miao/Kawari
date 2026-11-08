//! 独立 EObj 浏览器。仅使用本地 SqPack，不创建游戏进程或联网数据源。
use crate::{
    assets::viewers::layer::{self, scene},
    backend::Backend,
    settings::{BackendConfig, InstallLocation, LANGUAGE, SchemaLocation},
    utils::{PromiseKind, UnsendPromise, tick_promises},
};
use egui::{Color32, RichText, ScrollArea, containers::panel::Panel};
use ironworks::file::{File, layer::InstanceData, sgb::SharedGroupFile, tmb};
use serde::{Deserialize, Serialize};
use std::{
    collections::BTreeSet,
    io::Cursor,
    path::PathBuf,
    time::{Duration, Instant},
};

const CATALOG: &str = include_str!("../../../Data/catalog.json");
const DEMO: &str = "bgcommon/world/aet/shared/for_bg/sgbg_w_aet_001_01a.sgb";
const SWORD: &str = "bg/ex3/01_nvt_n4/shared/for_vfx/sgvf_n4gw_b3560.sgb";

#[derive(Clone, Deserialize, Serialize)]
struct Entry {
    id: u32,
    name: String,
    scene_id: u32,
    path: String,
}
#[derive(Deserialize)]
struct Catalog {
    #[serde(rename = "objects")]
    entries: Vec<Entry>,
}
#[derive(Clone, Serialize)]
struct Node {
    id: u32,
    name: String,
    layer: String,
    kind: String,
    path: String,
    position: [f32; 3],
    #[serde(skip)]
    at: glam::Mat4,
}
#[derive(Clone, Serialize)]
struct Command {
    id: i16,
    tick: i16,
    kind: String,
    detail: String,
    support: String,
}
#[derive(Clone, Serialize)]
struct Timeline {
    sub_id: i32,
    name: String,
    autoplay: bool,
    looping: bool,
    duration: f32,
    bindings: Vec<(i32, i32)>,
    commands: Vec<Command>,
}
#[derive(Clone, Serialize, Default)]
struct Description {
    path: String,
    nodes: Vec<Node>,
    timelines: Vec<Timeline>,
}

fn describe(path: &str, bytes: &[u8]) -> anyhow::Result<Description> {
    let file = SharedGroupFile::read(Cursor::new(bytes.to_vec()))?;
    let mut result = Description {
        path: path.to_owned(),
        ..Default::default()
    };
    for group in file.scene().layer_groups() {
        for layer in group.layers() {
            for node in layer.instances() {
                let (kind, resource) = match node.data() {
                    InstanceData::BgPart(p) => ("模型", p.asset_path().clone()),
                    InstanceData::SharedGroup(p) => ("子物件", p.asset_path().clone()),
                    InstanceData::Vfx(p) => ("特效", p.asset_path().clone()),
                    _ => ("其他节点", String::new()),
                };
                result.nodes.push(Node {
                    id: node.id(),
                    name: node.name().clone(),
                    layer: format!("{} / {}", group.name(), layer.name()),
                    kind: kind.to_owned(),
                    path: resource,
                    position: node.transform().translation(),
                    at: scene::matrix(node.transform()),
                });
            }
        }
    }
    for timeline in file.scene().timelines() {
        let mut duration = 0f32;
        let mut commands = Vec::new();
        for item in timeline.timeline().items() {
            match item {
                tmb::Item::Header(h) => duration = duration.max(h.duration() as f32 / 30.0),
                tmb::Item::Command(c) => {
                    let detail = format!("{:?}", c.kind());
                    let kind = detail.split(['(', ' ']).next().unwrap_or("未知").to_owned();
                    let support = if matches!(kind.as_str(), "C013" | "C018") {
                        "可预览变换"
                    } else {
                        "仅解析，未执行"
                    };
                    duration = duration.max(c.time() as f32 / 30.0);
                    commands.push(Command {
                        id: c.id(),
                        tick: c.time(),
                        kind,
                        detail,
                        support: support.to_owned(),
                    });
                }
                _ => {}
            }
        }
        commands.sort_by_key(|c| (c.tick, c.id));
        result.timelines.push(Timeline {
            sub_id: timeline.sub_id(),
            name: timeline.kind().clone(),
            autoplay: timeline.auto_play(),
            looping: timeline.looping(),
            duration,
            bindings: timeline.animated().to_vec(),
            commands,
        });
    }
    Ok(result)
}

fn sqpack_path(input: &str) -> anyhow::Result<PathBuf> {
    let base = PathBuf::from(input.trim().trim_matches('"'));
    for path in [base.join("game/sqpack"), base.join("sqpack"), base.clone()] {
        if path.join("ffxiv").is_dir() {
            return Ok(path);
        }
    }
    anyhow::bail!("目录中找不到 sqpack/ffxiv，请选择游戏根目录、game 或 sqpack 目录")
}

fn normalized_resource(input: &str) -> anyhow::Result<String> {
    let path = input.trim().replace('\\', "/").to_lowercase();
    anyhow::ensure!(
        path.ends_with(".sgb") && (path.starts_with("bg/") || path.starts_with("bgcommon/")),
        "请输入 bg/ 或 bgcommon/ 开头的 SGB 游戏资源路径"
    );
    anyhow::ensure!(!path.split('/').any(|p| p == ".."), "资源路径不能包含 ..");
    Ok(path)
}

struct Smoke {
    output: PathBuf,
    start: Instant,
    requested: bool,
    resize: bool,
    resize_stage: u8,
}
struct Browser {
    entries: Vec<Entry>,
    matches: Vec<usize>,
    query: String,
    mapped_only: bool,
    selected: Option<u32>,
    game: String,
    resource: String,
    backend: Option<Backend>,
    connecting: Option<UnsendPromise<anyhow::Result<Backend>>>,
    loading: Option<UnsendPromise<anyhow::Result<(String, Vec<u8>)>>>,
    pending: Option<String>,
    raw: Vec<u8>,
    description: Description,
    scene: Option<scene::Scene>,
    message: String,
    tab: usize,
    timeline: Option<usize>,
    effects: BTreeSet<u32>,
    playing: bool,
    time: f32,
    speed: f32,
    smoke: Option<Smoke>,
    loaded_at: Option<Instant>,
    viewport: egui::Rect,
    screenshot: Option<PathBuf>,
    history: Vec<String>,
    framed_models: usize,
    effect_loop: bool,
}

impl Browser {
    fn new(cc: &eframe::CreationContext<'_>) -> Self {
        let mut fonts = egui::FontDefinitions::default();
        if let Ok(bytes) = std::fs::read("C:/Windows/Fonts/msyh.ttc") {
            fonts
                .font_data
                .insert("中文".into(), egui::FontData::from_owned(bytes).into());
            fonts
                .families
                .entry(egui::FontFamily::Proportional)
                .or_default()
                .insert(0, "中文".into());
            fonts
                .families
                .entry(egui::FontFamily::Monospace)
                .or_default()
                .push("中文".into());
        }
        cc.egui_ctx.set_fonts(fonts);
        cc.egui_ctx.set_theme(egui::ThemePreference::Dark);
        LANGUAGE.set(&cc.egui_ctx, ironworks::excel::Language::ChineseSimplified);
        let mut style = (*cc.egui_ctx.style_of(egui::Theme::Dark)).clone();
        style.spacing.item_spacing = egui::vec2(9.0, 7.0);
        style
            .text_styles
            .insert(egui::TextStyle::Body, egui::FontId::proportional(16.0));
        style
            .text_styles
            .insert(egui::TextStyle::Button, egui::FontId::proportional(16.0));
        cc.egui_ctx.set_style_of(egui::Theme::Dark, style);
        let entries = serde_json::from_str::<Catalog>(CATALOG)
            .expect("随程序发布的目录无效")
            .entries;
        let args: Vec<String> = std::env::args().collect();
        let smoke = args
            .iter()
            .position(|s| s == "--smoke")
            .and_then(|i| args.get(i + 1))
            .map(|s| Smoke {
                output: s.into(),
                start: Instant::now(),
                requested: false,
                resize: args.iter().any(|s| s == "--resize-smoke"),
                resize_stage: 0,
            });
        let initial = args
            .iter()
            .position(|s| s == "--open")
            .and_then(|i| args.get(i + 1))
            .cloned()
            .unwrap_or_else(|| DEMO.into());
        let game = args
            .iter()
            .position(|s| s == "--game")
            .and_then(|i| args.get(i + 1))
            .cloned()
            .or_else(|| cc.storage.and_then(|s| s.get_string("eobject-game")))
            .unwrap_or_else(|| "D:\\Games\\FFXIVCN".into());
        let mut app = Self {
            matches: (0..entries.len()).collect(),
            entries,
            query: String::new(),
            mapped_only: false,
            selected: None,
            game,
            resource: initial.clone(),
            backend: None,
            connecting: None,
            loading: None,
            pending: Some(initial),
            raw: Vec::new(),
            description: Description::default(),
            scene: None,
            message: String::new(),
            tab: 0,
            timeline: None,
            effects: BTreeSet::new(),
            playing: true,
            time: 0.0,
            speed: 1.0,
            smoke,
            loaded_at: None,
            viewport: egui::Rect::NOTHING,
            screenshot: None,
            history: Vec::new(),
            framed_models: 0,
            effect_loop: true,
        };
        app.connect();
        app
    }
    fn filter(&mut self) {
        let q = self.query.trim().to_lowercase();
        self.matches = self
            .entries
            .iter()
            .enumerate()
            .filter(|(_, e)| {
                (!self.mapped_only || !e.path.is_empty())
                    && (q.is_empty()
                        || e.id.to_string().contains(&q)
                        || e.name.to_lowercase().contains(&q)
                        || e.path.contains(&q))
            })
            .map(|(i, _)| i)
            .collect();
    }
    fn connect(&mut self) {
        let path = match sqpack_path(&self.game) {
            Ok(p) => p,
            Err(e) => {
                self.message = e.to_string();
                return;
            }
        };
        self.backend = None;
        self.loading = None;
        self.scene = None;
        self.loaded_at = None;
        let config = BackendConfig {
            api_url: String::new(),
            location: InstallLocation::Sqpack(path.to_string_lossy().into_owned()),
            schema: SchemaLocation::Local(String::new()),
        };
        self.connecting = Some(UnsendPromise::new(Backend::new(config)));
        self.message = "正在读取本地 SqPack…".into();
    }
    fn open(&mut self, input: String) {
        if !self.description.path.is_empty() && self.description.path != input {
            self.history.push(self.description.path.clone());
        }
        self.scene = None;
        self.resource = input.clone();
        self.raw.clear();
        self.description = Description::default();
        self.loading = None;
        self.loaded_at = None;
        self.timeline = None;
        self.effects.clear();
        self.time = 0.0;
        self.playing = true;
        self.tab = 0;
        let path = if let Ok(id) = input.trim().parse::<u32>() {
            self.selected = Some(id);
            match self.entries.iter().find(|e| e.id == id) {
                Some(e) if !e.path.is_empty() => e.path.clone(),
                Some(_) => {
                    self.message = format!(
                        "EObj {id} 没有独立 SGB：可能由地图布局绑定，或仅包含逻辑。需要具体布局资源，不能仅凭这个 ID 确定外观。"
                    );
                    return;
                }
                None => {
                    self.message =
                        format!("目录中没有 EObj {id}。目录来自本地 CSV 快照，可重新导出更新。");
                    return;
                }
            }
        } else {
            self.selected = None;
            match normalized_resource(&input) {
                Ok(p) => p,
                Err(e) => {
                    self.message = e.to_string();
                    return;
                }
            }
        };
        self.resource = path.clone();
        let Some(backend) = self.backend.clone() else {
            self.pending = Some(input);
            return;
        };
        self.message = "正在解析物件及其依赖…".into();
        self.loading = Some(UnsendPromise::new(async move {
            let (_, bytes) = backend.files().read_stream(&path).await?;
            Ok((path, bytes))
        }));
    }
    fn rebuild(&mut self) {
        if self.raw.is_empty() {
            return;
        }
        let result = (|| -> anyhow::Result<_> {
            let mut file = SharedGroupFile::read(Cursor::new(self.raw.clone()))?;
            if let Some(index) = self.timeline {
                anyhow::ensure!(file.preview_timeline(index), "无效时间线索引");
            }
            Ok(layer::shared_scene(&self.description.path, file))
        })();
        match result {
            Ok(mut scene) => {
                scene.eobject_fit();
                self.framed_models = 0;
                self.scene = Some(scene);
            }
            Err(e) => {
                self.message = format!("解析失败：{e:#}");
                self.scene = None;
            }
        }
    }
    fn poll(&mut self) {
        if self.connecting.as_ref().is_some_and(PromiseKind::ready) {
            match self.connecting.take().unwrap().block_and_take() {
                Ok(b) => {
                    self.backend = Some(b);
                    self.message = "本地资源已连接".into();
                    if let Some(p) = self.pending.take() {
                        self.open(p);
                    }
                }
                Err(e) => self.message = format!("读取游戏目录失败：{e:#}"),
            }
        }
        if self.loading.as_ref().is_some_and(PromiseKind::ready) {
            match self
                .loading
                .take()
                .unwrap()
                .block_and_take()
                .and_then(|(path, bytes)| Ok((describe(&path, &bytes)?, bytes)))
            {
                Ok((description, raw)) => {
                    self.description = description;
                    self.raw = raw;
                    self.rebuild();
                    self.loaded_at = Some(Instant::now());
                    self.message = format!(
                        "已读取 {} 个根节点、{} 条时间线；子物件会继续按需加载",
                        self.description.nodes.len(),
                        self.description.timelines.len()
                    );
                    // 自动验证显式启用第一项特效；正常浏览由用户自己选择。
                    if self.smoke.is_some()
                        && self.description.nodes.iter().all(|n| n.kind != "模型")
                    {
                        if let Some(n) = self.description.nodes.iter().find(|n| n.kind == "特效")
                        {
                            self.effects.insert(n.id);
                        }
                    }
                }
                Err(e) => self.message = format!("资源加载失败：{e:#}"),
            }
        }
    }
    fn header(&mut self, ui: &mut egui::Ui) {
        Panel::top("头部").show(ui, |ui| {
            ui.horizontal(|ui| {
                ui.heading("EObject 离线浏览器");
                ui.label(
                    RichText::new("本地资源 · 无需运行游戏")
                        .color(Color32::from_rgb(113, 207, 178)),
                );
            });
            ui.horizontal(|ui| {
                ui.label("游戏目录");
                ui.add(egui::TextEdit::singleline(&mut self.game).desired_width(330.0));
                if ui.button("浏览…").clicked() {
                    if let Some(path) = rfd::FileDialog::new().pick_folder() {
                        self.game = path.display().to_string();
                    }
                }
                if ui.button("读取目录").clicked() {
                    self.pending = Some(self.resource.clone());
                    self.connect();
                }
                if ui.button("示例：以太之光").clicked() {
                    self.open(DEMO.into());
                }
                if ui.button("光尘之剑").clicked() {
                    self.open("2014199".into());
                }
            });
            ui.horizontal(|ui| {
                if ui
                    .add_enabled(!self.history.is_empty(), egui::Button::new("返回"))
                    .clicked()
                {
                    if let Some(path) = self.history.pop() {
                        self.description.path.clear();
                        self.open(path);
                    }
                }
                ui.label("SGB / ID");
                let response = ui.add(
                    egui::TextEdit::singleline(&mut self.resource)
                        .desired_width((ui.available_width() - 90.0).max(100.0)),
                );
                if ui.button("打开").clicked()
                    || response.lost_focus() && ui.input(|i| i.key_pressed(egui::Key::Enter))
                {
                    self.open(self.resource.clone());
                }
            });
        });
        Panel::bottom("状态").show(ui, |ui| {
            ui.label(&self.message);
        });
    }
    fn catalog_ui(&mut self, ui: &mut egui::Ui) {
        Panel::left("目录")
            .default_size(255.0)
            .size_range(220.0..=500.0)
            .show(ui, |ui| {
                ui.heading("EObj 目录");
                if ui
                    .add(
                        egui::TextEdit::singleline(&mut self.query)
                            .hint_text("输入 ID、中文名或路径")
                            .desired_width(f32::INFINITY),
                    )
                    .changed()
                {
                    self.filter();
                }
                if ui
                    .checkbox(&mut self.mapped_only, "仅显示有关联 SGB 的物件")
                    .changed()
                {
                    self.filter();
                }
                ui.weak(format!(
                    "{} / {} 项 · CSV 快照",
                    self.matches.len(),
                    self.entries.len()
                ));
                ui.separator();
                let mut selected = None;
                ScrollArea::vertical()
                    .auto_shrink([false, false])
                    .show_rows(ui, 42.0, self.matches.len(), |ui, range| {
                        for i in range {
                            let entry = &self.entries[self.matches[i]];
                            let name = if entry.name.is_empty() {
                                "未命名 EObj"
                            } else {
                                &entry.name
                            };
                            let suffix = if entry.path.is_empty() {
                                " · 布局 / 逻辑"
                            } else {
                                ""
                            };
                            if ui
                                .selectable_label(
                                    self.selected == Some(entry.id),
                                    format!("{}{}\n{}", entry.id, suffix, name),
                                )
                                .clicked()
                            {
                                selected = Some(entry.id);
                            }
                        }
                    });
                if let Some(id) = selected {
                    self.open(id.to_string());
                }
            });
    }
    fn controls(&mut self, ui: &mut egui::Ui) {
        self.timeline_selector(ui);
        ui.weak("时间线：预览变换轨道；未支持的指令请在详情页查看。");
        ui.horizontal(|ui| {
            if ui
                .button(if self.playing { "暂停" } else { "播放" })
                .clicked()
            {
                self.playing = !self.playing;
            }
            if ui.button("从头播放").clicked() {
                self.time = 0.0;
                self.playing = true;
                self.rebuild();
            }
            if ui.button("重置视角").clicked() {
                if let Some(s) = &mut self.scene {
                    s.eobject_fit();
                }
            }
            ui.label("速度");
            ui.add(
                egui::Slider::new(&mut self.speed, 0.1..=3.0)
                    .suffix("×")
                    .fixed_decimals(1),
            );
            if ui.button("保存截图").clicked() {
                if let Some(p) = rfd::FileDialog::new()
                    .add_filter("PNG", &["png"])
                    .set_file_name("EObject.png")
                    .save_file()
                {
                    self.screenshot = Some(p);
                    ui.ctx()
                        .send_viewport_cmd(egui::ViewportCommand::Screenshot(Default::default()));
                }
            }
        });
        let duration = self
            .timeline
            .and_then(|i| self.description.timelines.get(i))
            .map_or(120.0, |t| t.duration.max(1.0));
        let before = self.time;
        let end = duration.max(self.time);
        let mut scrub = self.time;
        let scrub_response = ui.add(
            egui::Slider::new(&mut scrub, 0.0..=end)
                .text("秒")
                .fixed_decimals(2),
        );
        if scrub_response.changed()
            && (scrub_response.dragged() || scrub_response.clicked() || scrub_response.has_focus())
        {
            // Slider 会对显示值取整；只在用户操作播放条时回写。
            self.time = scrub;
            self.playing = false;
            if self.time < before {
                self.rebuild();
            }
        }
        ui.weak("左键拖动转向 · 右键平移 · 滚轮前后 · WASD / QE 移动 · Shift 加速");
    }
    fn timelines_ui(&mut self, ui: &mut egui::Ui) {
        ui.label("SGB 内部时间线（SubId 不等于服务器动画索引）");
        self.timeline_selector(ui);
        ui.colored_label(
            Color32::from_rgb(238, 190, 114),
            "当前可播放变换轨道；其他指令保留原始参数，不自动执行。特效可在右侧单独预览。",
        );
        ScrollArea::vertical().id_salt("时间线详情").show(ui, |ui| {
            for (i, t) in self.description.timelines.iter().enumerate() {
                if self.timeline.is_some_and(|selected| selected != i) {
                    continue;
                }
                ui.collapsing(
                    format!("{} / {} · {} 条指令", t.sub_id, t.name, t.commands.len()),
                    |ui| {
                        ui.label(format!(
                            "自动={}  循环={}  时长={:.3}s",
                            t.autoplay, t.looping, t.duration
                        ));
                        ui.label(format!("Actor → 实例绑定：{:?}", t.bindings));
                        for c in &t.commands {
                            ui.collapsing(
                                format!(
                                    "{:>6.2}s  {}  #{} · {}",
                                    c.tick as f32 / 30.0,
                                    c.kind,
                                    c.id,
                                    c.support
                                ),
                                |ui| {
                                    ui.label(&c.detail);
                                },
                            );
                        }
                    },
                );
            }
            if self.description.timelines.is_empty() {
                ui.label("这个 SGB 没有内置时间线。可继续打开子物件检查。");
            }
        });
    }
    fn timeline_selector(&mut self, ui: &mut egui::Ui) {
        let previous = self.timeline;
        egui::ComboBox::from_id_salt("时间线")
            .selected_text(
                self.timeline
                    .and_then(|i| self.description.timelines.get(i))
                    .map_or("默认自动播放".into(), |t| {
                        format!("{} · {}", t.sub_id, t.name)
                    }),
            )
            .width(340.0)
            .show_ui(ui, |ui| {
                ui.selectable_value(&mut self.timeline, None, "默认自动播放");
                for (i, t) in self.description.timelines.iter().enumerate() {
                    ui.selectable_value(
                        &mut self.timeline,
                        Some(i),
                        format!("{} · {}  ({:.2}s)", t.sub_id, t.name, t.duration),
                    );
                }
            });
        if self.timeline != previous {
            self.time = 0.0;
            self.rebuild();
        }
    }
    fn effects_ui(&mut self, ui: &mut egui::Ui) {
        ui.heading("手动特效预览");
        ui.checkbox(&mut self.effect_loop, "预览循环（每 5 秒重播）");
        ui.weak("独立播放 AVFX，不代表已执行所选时间线。根节点列在下面；子物件可在层级页打开。");
        let mut changed = false;
        for n in self.description.nodes.iter().filter(|n| n.kind == "特效") {
            let mut enabled = self.effects.contains(&n.id);
            if ui
                .checkbox(
                    &mut enabled,
                    format!(
                        "{} · {}",
                        n.id,
                        n.path.rsplit('/').next().unwrap_or(&n.path)
                    ),
                )
                .on_hover_text(&n.path)
                .changed()
            {
                if enabled {
                    self.effects.insert(n.id);
                } else {
                    self.effects.remove(&n.id);
                }
                changed = true;
            }
        }
        if changed {
            self.time = 0.0;
            self.playing = true;
            self.rebuild();
        }
        if self.description.nodes.iter().all(|n| n.kind != "特效") {
            ui.label("没有根级 AVFX 节点");
        }
        ui.separator();
        ui.label("导出内容包括资源路径、实例变换、时间线、绑定和指令原始字段。");
        if ui.button("导出物件分析 JSON").clicked() {
            if let Some(p) = rfd::FileDialog::new()
                .add_filter("JSON", &["json"])
                .set_file_name("EObj-analysis.json")
                .save_file()
            {
                match serde_json::to_vec_pretty(&self.description)
                    .map_err(anyhow::Error::from)
                    .and_then(|bytes| {
                        std::fs::write(&p, bytes)?;
                        Ok(())
                    }) {
                    Ok(()) => self.message = format!("已导出：{}", p.display()),
                    Err(e) => self.message = format!("导出失败：{e}"),
                }
            }
        }
    }
    fn hierarchy_ui(&mut self, ui: &mut egui::Ui) {
        let mut open = None;
        ScrollArea::both().show(ui, |ui| {
            for n in &self.description.nodes {
                ui.collapsing(format!("{} · {} · {}", n.id, n.kind, n.name), |ui| {
                    ui.label(&n.layer);
                    ui.label(format!("位置：{:?}", n.position));
                    ui.label(&n.path);
                    if n.kind == "子物件" && ui.button("打开这个子物件").clicked() {
                        open = Some(n.path.clone());
                    }
                    if !n.path.is_empty() && ui.button("复制资源路径").clicked() {
                        ui.ctx().copy_text(n.path.clone());
                    }
                });
            }
        });
        if let Some(path) = open {
            self.open(path);
        }
    }
    fn screenshot_events(&mut self, ctx: &egui::Context) {
        for event in ctx.input(|i| i.events.clone()) {
            if let egui::Event::Screenshot { image, .. } = event {
                let target = self
                    .screenshot
                    .take()
                    .or_else(|| self.smoke.as_ref().map(|s| s.output.join("window.png")));
                if let Some(path) = target {
                    let rgba: Vec<u8> = image.pixels.iter().flat_map(|p| p.to_array()).collect();
                    match image::save_buffer(
                        &path,
                        &rgba,
                        image.width() as u32,
                        image.height() as u32,
                        image::ColorType::Rgba8,
                    ) {
                        Ok(()) => self.message = format!("截图已保存：{}", path.display()),
                        Err(e) => self.message = format!("保存失败：{e}"),
                    }
                    if let Some(smoke) = &self.smoke {
                        let mut viewport_colors = std::collections::HashSet::new();
                        let scale = image.width() as f32 / ctx.content_rect().width();
                        let min = self.viewport.min * scale;
                        let max = self.viewport.max * scale;
                        for y in (min.y as usize).min(image.height())
                            ..(max.y as usize).min(image.height())
                        {
                            for x in (min.x as usize).min(image.width())
                                ..(max.x as usize).min(image.width())
                            {
                                viewport_colors
                                    .insert(image.pixels[y * image.width() + x].to_array());
                            }
                        }
                        let metrics = serde_json::json!({"path":self.description.path,"nodes":self.description.nodes.len(),"timelines":self.description.timelines.len(),"counts":self.scene.as_ref().map(|s|s.eobject_counts()),"effects":self.scene.as_ref().map(|s|s.eobject_diagnostics()),"viewport_colors":viewport_colors.len(),"manual_effects":self.effects,"seconds":self.time,"message":self.message,"resize_stage":smoke.resize_stage});
                        let _ = std::fs::write(
                            smoke.output.join("result.json"),
                            serde_json::to_vec_pretty(&metrics).unwrap(),
                        );
                        let _ = std::fs::write(
                            smoke.output.join("analysis.json"),
                            serde_json::to_vec_pretty(&self.description).unwrap(),
                        );
                        ctx.send_viewport_cmd(egui::ViewportCommand::Close);
                    }
                }
            }
        }
    }
}

impl eframe::App for Browser {
    fn clear_color(&self, _: &egui::Visuals) -> [f32; 4] {
        // 原生工具窗口不使用框架默认的半透明清屏色。
        egui::Color32::from_rgb(24, 24, 24).to_normalized_gamma_f32()
    }
    fn save(&mut self, storage: &mut dyn eframe::Storage) {
        storage.set_string("eobject-game", self.game.clone());
    }
    fn ui(&mut self, ui: &mut egui::Ui, _: &mut eframe::Frame) {
        let ctx = ui.ctx().clone();
        self.poll();
        self.header(ui);
        self.catalog_ui(ui);
        if ctx.current_pass_index() == 0 && self.playing && self.scene.is_some() {
            self.time += ctx.input(|i| i.stable_dt).min(0.1) * self.speed;
        }
        if let Some(t) = self
            .timeline
            .and_then(|i| self.description.timelines.get(i))
        {
            if self.time > t.duration.max(1.0) {
                if t.looping {
                    self.time = 0.0;
                    self.rebuild();
                } else {
                    self.time = t.duration.max(1.0);
                    self.playing = false;
                }
            }
        }
        Panel::right("特效")
            .default_size(280.0)
            .size_range(230.0..=500.0)
            .show(ui, |ui| {
                ScrollArea::vertical().show(ui, |ui| self.effects_ui(ui));
            });
        egui::CentralPanel::default().show(ui, |ui| {
            if let Some(id) = self.selected {
                ui.label(RichText::new(format!("EObj {id}")).strong());
            }
            ui.horizontal(|ui| {
                for (i, name) in ["三维预览", "时间线 / 指令", "物件层级"].iter().enumerate()
                {
                    ui.selectable_value(&mut self.tab, i, *name);
                }
            });
            ui.separator();
            if self.scene.is_none() {
                ui.label(&self.message);
                if self.loading.is_some() || self.connecting.is_some() {
                    ui.spinner();
                }
                return;
            }
            match self.tab {
                0 => {
                    self.controls(ui);
                    if std::env::var_os("EOBJ_UI_ONLY").is_some() {
                        ui.label("界面诊断：已暂停三维绘制");
                        return;
                    }
                    if let (Some(scene), Some(backend)) = (&mut self.scene, &self.backend) {
                        scene.eobject_time(self.time);
                        scene.fire(
                            self.description
                                .nodes
                                .iter()
                                .filter(|n| self.effects.contains(&n.id))
                                .map(|n| scene::Fired {
                                    id: n.id as u64,
                                    path: n.path.clone(),
                                    at: n.at,
                                    frame: ((if self.effect_loop {
                                        self.time % 5.0
                                    } else {
                                        self.time
                                    }) * 30.0) as i32,
                                    tint: glam::Vec4::ONE,
                                })
                                .collect(),
                        );
                        self.viewport = ui.available_rect_before_wrap();
                        scene::ui(ui, scene, backend);
                        let (_, ready, _, _) = scene.eobject_counts();
                        if ready > self.framed_models {
                            self.framed_models = ready;
                            scene.eobject_fit();
                        }
                    }
                }
                1 => self.timelines_ui(ui),
                _ => self.hierarchy_ui(ui),
            }
        });
        self.screenshot_events(&ctx);
        if let Some(smoke) = &mut self.smoke {
            // 仅自检实例执行缩小、放大、还原，覆盖整窗附件的重建与释放。
            if smoke.resize {
                let stage = self.loaded_at.map_or(0, |t| (t.elapsed().as_secs() / 3).min(3) as u8);
                if stage > smoke.resize_stage {
                    smoke.resize_stage = stage;
                    let size = [[1100.0, 700.0], [1600.0, 950.0], [1440.0, 900.0]][stage as usize - 1];
                    ctx.send_viewport_cmd(egui::ViewportCommand::InnerSize(size.into()));
                }
            }
            if !smoke.requested
                && self
                    .loaded_at
                    .is_some_and(|t| t.elapsed() > Duration::from_secs(18))
            {
                let _ = std::fs::create_dir_all(&smoke.output);
                smoke.requested = true;
                ctx.send_viewport_cmd(egui::ViewportCommand::Screenshot(Default::default()));
            }
            if smoke.start.elapsed() > Duration::from_secs(90) {
                let _ = std::fs::create_dir_all(&smoke.output);
                let _ = std::fs::write(smoke.output.join("failure.txt"), &self.message);
                ctx.send_viewport_cmd(egui::ViewportCommand::Close);
            }
        }
        tick_promises(&ctx);
        crate::render_probe::install(&ctx, self.time);
        // 播放时由交换缓冲的垂直同步统一节奏，避免 16ms 定时器叠加 VSync。
        // 静止页保留 egui 输入事件和资源 Promise 的唤醒，不持续重刷整窗。
        if (self.playing && self.tab == 0 && self.scene.is_some()) || self.smoke.is_some() {
            ctx.request_repaint();
        }
    }
}

pub fn run() -> eframe::Result {
    let _ =
        env_logger::Builder::from_env(env_logger::Env::new().default_filter_or("warn")).try_init();
    let smoke = std::env::args().any(|s| s == "--smoke");
    eframe::run_native(
        "EObject 离线浏览器 1.0.3",
        eframe::NativeOptions {
            depth_buffer: 24,
            glow_options: egui_glow::GlowConfiguration {
                composited: true,
                vsync: true,
                ..Default::default()
            },
            viewport: egui::ViewportBuilder::default()
                .with_transparent(false)
                .with_inner_size([1440.0, 900.0])
                .with_min_inner_size([1050.0, 650.0])
                .with_visible(!smoke),
            ..Default::default()
        },
        Box::new(|cc| Ok(Box::new(Browser::new(cc)))),
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn catalog_ids_and_real_paths() {
        let c: Catalog = serde_json::from_str(CATALOG).unwrap();
        let sword = c.entries.iter().find(|e| e.id == 2014199).unwrap();
        assert_eq!(sword.path, SWORD);
        assert!(
            c.entries
                .iter()
                .find(|e| e.id == 2007457)
                .unwrap()
                .path
                .is_empty()
        );
        assert_eq!(
            c.entries
                .iter()
                .map(|e| e.id)
                .collect::<BTreeSet<_>>()
                .len(),
            c.entries.len()
        );
    }
    #[test]
    fn resource_validation() {
        assert_eq!(normalized_resource(" BG\\a.sgb ").unwrap(), "bg/a.sgb");
        for p in ["http://x/a.sgb", "bg/../x.sgb", "C:/a.sgb", "bg/a.mdl"] {
            assert!(normalized_resource(p).is_err());
        }
    }
    #[test]
    fn missing_install_returns_error() {
        assert!(sqpack_path("Z:/not-a-game-install-12345").is_err());
    }
    #[test]
    fn rejects_invalid_sgb() {
        assert!(describe("bg/test.sgb", b"not an SGB").is_err());
    }

}
