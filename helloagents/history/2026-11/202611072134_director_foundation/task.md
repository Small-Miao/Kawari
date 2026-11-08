# 任务清单

- [√] 取消、施法锁与重置生命周期。
- [√] Buff 来源、同步、查询、移除与变化回调。
- [√] MapEffect 可选状态及控制接口。
- [√] 回归测试、编译、格式与 Clippy 检查。
- [√] 输入安全检查与知识库同步。
- [√] 归档方案包。

## 验证结果

- `cargo check -p kawari-world --offline` 通过。
- `cargo test -p kawari-world --lib --offline`：162 通过，其中 12 项副本回归。
- `cargo test -p kawari --lib actor_control::tests --offline`：2 通过，其中 1 项新增控制编码回归。
- `cargo clippy -p kawari-world --all-targets --offline` 通过；现有其他模块告警保留，新增/修改的 Director、状态、网络及控制协议文件无 Clippy 告警。
- 修改文件的 rustfmt 检查与 `git diff --check` 通过。
- 首次受限环境的原生导航依赖构建停滞，停止该次构建后，经自动审批在本机环境完成验证。

## 实施边界

没有数据库迁移或依赖升级；没有重启当前服务器。地图初始状态仍由 onReset 设置；AOE 取消不删除未来 Lua 回调；状态查询为 tick 快照。完整绝亚及游戏内视觉验收不属于本轮实现。
