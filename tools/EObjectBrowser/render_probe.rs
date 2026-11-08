//! 显式启用的连续 GPU 帧诊断，不改变动画或相机状态。
use glow::HasContext;
use serde::Serialize;
use std::{
    cell::RefCell,
    num::NonZeroU32,
    path::PathBuf,
    time::{Duration, Instant},
};

#[derive(Serialize)]
struct Reading {
    frame: usize,
    mean: f64,
    dark_fraction: f64,
    exposure: f32,
    measured: f32,
    clock: f32,
    ui_mean: f64,
    ui_hash: u64,
}
struct Capture {
    output: PathBuf,
    start: Instant,
    frames: Vec<(Reading, Vec<u8>)>,
    done: bool,
}
thread_local! {static CAPTURE: RefCell<Option<Capture>> = RefCell::new(std::env::var_os("EOBJ_RENDER_PROBE").map(|p|Capture{output:p.into(),start:Instant::now(),frames:Vec::new(),done:false}));}

pub fn install(ctx: &egui::Context, clock: f32) {
    if std::env::var_os("EOBJ_RENDER_PROBE").is_none() {
        return;
    }
    ctx.layer_painter(egui::LayerId::new(
        egui::Order::Debug,
        egui::Id::new("帧诊断"),
    ))
    .add(egui::PaintCallback {
        rect: ctx.content_rect(),
        callback: std::sync::Arc::new(egui_glow::CallbackFn::new(move |info, painter| {
            frame(painter.gl(), &info, painter.intermediate_fbo(), 0.0, 0.0, clock);
        })),
    });
}

pub fn frame(
    gl: &glow::Context,
    info: &egui::PaintCallbackInfo,
    framebuffer: Option<glow::Framebuffer>,
    exposure: f32,
    measured: f32,
    clock: f32,
) {
    CAPTURE.with(|state| {
        let mut state = state.borrow_mut();
        let Some(c) = state.as_mut() else {
            return;
        };
        if c.done || c.start.elapsed() < Duration::from_secs(10) {
            return;
        }
        let r = info.viewport_in_pixels();
        if r.width_px < 1 || r.height_px < 1 {
            return;
        }
        let mut pixels = vec![0u8; (r.width_px * r.height_px * 4) as usize];
        // 只读当前帧的实际绘制目标（可能是整窗中间缓冲），随后恢复读状态。
        unsafe {
            let old = gl.get_parameter_i32(glow::READ_FRAMEBUFFER_BINDING);
            let old_buffer = gl.get_parameter_i32(glow::READ_BUFFER);
            gl.bind_framebuffer(glow::READ_FRAMEBUFFER, framebuffer);
            gl.read_buffer(if framebuffer.is_some() { glow::COLOR_ATTACHMENT0 } else { glow::BACK });
            gl.read_pixels(
                r.left_px,
                r.from_bottom_px,
                r.width_px,
                r.height_px,
                glow::RGBA,
                glow::UNSIGNED_BYTE,
                glow::PixelPackData::Slice(Some(&mut pixels)),
            );
            gl.bind_framebuffer(
                glow::READ_FRAMEBUFFER,
                NonZeroU32::new(old as u32).map(glow::NativeFramebuffer),
            );
            gl.read_buffer(old_buffer as u32);
        }
        let count = pixels.len() / 4;
        let mean = pixels
            .chunks_exact(4)
            .map(|p| (p[0] as f64 + p[1] as f64 + p[2] as f64) / 3.0)
            .sum::<f64>()
            / count as f64;
        let dark = pixels
            .chunks_exact(4)
            .filter(|p| p[0] < 12 && p[1] < 12 && p[2] < 12)
            .count() as f64
            / count as f64;
        // 左侧目录是静态界面，动画播放期间它的像素应保持不变。
        let mut ui_sum = 0f64;
        let mut ui_count = 0usize;
        let mut ui_hash = 0xcbf29ce484222325u64;
        for row in pixels
            .chunks_exact(r.width_px as usize * 4)
            .skip(90)
            .take(r.height_px.saturating_sub(240) as usize)
        {
            for p in row.chunks_exact(4).take(210) {
                ui_sum += (p[0] as f64 + p[1] as f64 + p[2] as f64) / 3.0;
                ui_count += 1;
                for value in &p[..3] {
                    ui_hash = (ui_hash ^ *value as u64).wrapping_mul(0x100000001b3);
                }
            }
        }
        c.frames.push((
            Reading {
                frame: c.frames.len(),
                mean,
                dark_fraction: dark,
                exposure,
                measured,
                clock,
                ui_mean: ui_sum / ui_count.max(1) as f64,
                ui_hash,
            },
            pixels,
        ));
        if c.frames.len() == 64 {
            c.done = true;
            if let Err(e) = (|| -> anyhow::Result<()> {
                std::fs::create_dir_all(&c.output)?;
                let readings: Vec<_> = c.frames.iter().map(|x| &x.0).collect();
                std::fs::write(
                    c.output.join("frames.json"),
                    serde_json::to_vec_pretty(&readings)?,
                )?;
                let min = (0..c.frames.len())
                    .min_by(|a, b| c.frames[*a].0.mean.total_cmp(&c.frames[*b].0.mean))
                    .unwrap();
                let max = (0..c.frames.len())
                    .max_by(|a, b| c.frames[*a].0.mean.total_cmp(&c.frames[*b].0.mean))
                    .unwrap();
                for index in [0, 1, min, max, 63] {
                    let width = r.width_px as usize * 4;
                    let raw = &c.frames[index].1;
                    let upright: Vec<u8> =
                        raw.chunks_exact(width).rev().flatten().copied().collect();
                    image::save_buffer(
                        c.output.join(format!("frame-{index:02}.png")),
                        &upright,
                        r.width_px as u32,
                        r.height_px as u32,
                        image::ColorType::Rgba8,
                    )?;
                }
                Ok(())
            })() {
                log::error!("连续帧诊断失败：{e:#}");
            }
            c.frames.clear();
        }
    });
}
