//! 整窗中间缓冲：完成 UI 与自定义三维回调后再一次性复制到窗口后缓冲。
#![expect(unsafe_code)]
// 与 Painter 相同：由窗口的渲染线程持有当前 GL 上下文后调用。
use glow::HasContext;

pub(crate) struct Target {
    pub(crate) framebuffer: glow::Framebuffer,
    color: Option<glow::Renderbuffer>,
    depth: Option<glow::Renderbuffer>,
    pub(crate) size: [u32; 2],
}

impl Target {
    pub(crate) fn new(gl: &glow::Context, size: [u32; 2]) -> Result<Self, String> {
        if size.contains(&0) || size.iter().any(|v| *v > i32::MAX as u32) {
            return Err("无效的窗口缓冲尺寸".into());
        }
        unsafe {
            let mut target = Self {
                framebuffer: gl.create_framebuffer()?,
                color: None,
                depth: None,
                size,
            };
            let result = (|| -> Result<(), String> {
                target.color = Some(gl.create_renderbuffer()?);
                target.depth = Some(gl.create_renderbuffer()?);
                gl.bind_framebuffer(glow::FRAMEBUFFER, Some(target.framebuffer));
                for (buffer, format, attachment) in [
                    (target.color, glow::RGBA8, glow::COLOR_ATTACHMENT0),
                    (target.depth, glow::DEPTH24_STENCIL8, glow::DEPTH_STENCIL_ATTACHMENT),
                ] {
                    gl.bind_renderbuffer(glow::RENDERBUFFER, buffer);
                    gl.renderbuffer_storage(glow::RENDERBUFFER, format, size[0] as i32, size[1] as i32);
                    gl.framebuffer_renderbuffer(glow::FRAMEBUFFER, attachment, glow::RENDERBUFFER, buffer);
                }
                gl.draw_buffers(&[glow::COLOR_ATTACHMENT0]);
                gl.read_buffer(glow::COLOR_ATTACHMENT0);
                let status = gl.check_framebuffer_status(glow::FRAMEBUFFER);
                if status != glow::FRAMEBUFFER_COMPLETE {
                    return Err(format!("整窗缓冲创建失败：{status:#x}"));
                }
                Ok(())
            })();
            gl.bind_renderbuffer(glow::RENDERBUFFER, None);
            if let Err(error) = result {
                gl.bind_framebuffer(glow::FRAMEBUFFER, None);
                target.destroy(gl);
                return Err(error);
            }
            Ok(target)
        }
    }

    pub(crate) fn bind(&self, gl: &glow::Context) {
        unsafe {
            gl.bind_framebuffer(glow::FRAMEBUFFER, Some(self.framebuffer));
            gl.draw_buffers(&[glow::COLOR_ATTACHMENT0]);
            gl.read_buffer(glow::COLOR_ATTACHMENT0);
        }
    }

    pub(crate) fn present(&self, gl: &glow::Context) {
        unsafe {
            gl.disable(glow::SCISSOR_TEST);
            gl.disable(glow::FRAMEBUFFER_SRGB);
            gl.color_mask(true, true, true, true);
            gl.bind_framebuffer(glow::READ_FRAMEBUFFER, Some(self.framebuffer));
            gl.read_buffer(glow::COLOR_ATTACHMENT0);
            gl.bind_framebuffer(glow::DRAW_FRAMEBUFFER, None);
            gl.draw_buffers(&[glow::BACK]);
            let [w, h] = self.size.map(|v| v as i32);
            gl.blit_framebuffer(0, 0, w, h, 0, 0, w, h, glow::COLOR_BUFFER_BIT, glow::NEAREST);
            gl.bind_framebuffer(glow::FRAMEBUFFER, None);
            gl.read_buffer(glow::BACK);
        }
    }

    pub(crate) fn destroy(&self, gl: &glow::Context) {
        unsafe {
            gl.delete_framebuffer(self.framebuffer);
            if let Some(buffer) = self.color { gl.delete_renderbuffer(buffer); }
            if let Some(buffer) = self.depth { gl.delete_renderbuffer(buffer); }
        }
    }
}
