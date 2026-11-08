// 原生离线窗口；没有游戏注入入口。
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
fn main() -> eframe::Result {
    viewer::eobject::run()
}
