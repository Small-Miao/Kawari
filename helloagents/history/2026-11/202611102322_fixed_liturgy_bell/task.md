# 任务清单

- [√] 核对生成、AI 与录像模型证据。
- [√] 修正模型、生成槽位和固定落点行为。
- [√] 屏蔽地面召唤物的普通宠物移动/召回指令。
- [√] 通过位置、治疗中心、演出回归并构建。
- [√] 部署、健康检查并更新知识库。
  > 用户明确授权立即重启，并补充要求重新编译 world。按当前源码构建成功后停止旧进程 60968，启动新进程 56612；21063/21064 均由新进程监听，健康 HTTP 200。
- [?] 用户确认铃外形、走远后落点和治疗表现。
  > 备注：自动化位置与治疗回归已通过，客户端画面需要重新登录后实际确认。

## 验证与备份

- 227 项常规回归通过；2 项国服数据专项通过，验证模型、显示标志、客户端生成槽位、AI 固定、宠物命令隔离、队伍治疗原点、引爆顺序与退场。
- 构建日志：`target/bell-fixed-20261110/build.log`；测试日志：`target/job-replay-audit/bell-focused-tests.log`、`bell-regression-tests.log`。
- 旧程序完整备份：`target/bell-fixed-20261110/kawari-world.backup.exe`。运行中映像改名为同目录 `kawari-world.previous-running.exe` 后继续运行，避免停止在线服务即可准备候选程序。
- 已运行修复版路径：`target/debug/kawari-world.exe`，进程 56612。最终构建日志 `target/bell-fixed-20261110/rebuild-before-restart.log`；部署记录 `target/bell-fixed-20261110/deployment.json`。
- 最终二进制 SHA-256：`F9F5D35A4E99F2D03541C78A1BFE72998956E96AB1ECED47902D5F94721C47C4`。本次为按当前源码重新编译和部署，未重新宣称额外运行完整测试套件；上述测试为修复阶段的验证结果。
