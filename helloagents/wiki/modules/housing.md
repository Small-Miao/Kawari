# 个人住宅

## Sapphire 的实现

- `HousingZone` 用地区和区号建立住宅区实例。它在入场时读取区内地块和庭院物件，按分区下发外观。地块状态改变后通知同区玩家。房屋建成后用地块布局数据定位入口。[HousingZone.cpp](https://raw.githubusercontent.com/SapphireServer/Sapphire/master/src/world/Territory/HousingZone.cpp)
- `HousingMgr` 按住宅地址管理地块、房屋和家具容器。购买校验空地、余额和个人持有数量，建房消耗许可证并按 `HousingPreset` 填充模型。室内和庭院分别使用库存槽位及摆放坐标。[HousingMgr.cpp](https://raw.githubusercontent.com/SapphireServer/Sapphire/master/src/world/Manager/HousingMgr.cpp)

## Kawari 实现

- 海雾村、薰衣草苗圃、高脚孤丘、白银乡和穹顶皓天使用同一套逻辑。每个住宅区有 30 个区，每区含主区和扩建区的 60 块地。服务端以地区、区号、地块区分室内实例。
- `HousingLandSet` 提供地块价格、尺寸和告示牌布局 ID。个人地块即时购买，每个角色可持有一块。世界数据库以唯一约束防止重复购买，在一个事务中保存所有权和余额。
- 建房读取随身背包的房产证书，校验地区和尺寸后，在一个事务中消耗证书并保存房屋。外观与基础内装取自客户端 EXD。
- 新建住宅默认允许访客进入。已建住宅使用数据库中保存的访客权限，房主可随时开关。访客只读取房屋与家具，离开后返回原区、原地块。区号与室内地址随角色位置保存。
- 室内和庭院的摆放、移动、收纳及取回均按地块保存。家具跨背包和住宅容器移动时一起提交；室内亮度随住宅保存。
- 客户端以现有住宅菜单完成浏览、购买和建房。兼容指令包括 `!housing buy 地块号`、`!housing build 许可证物品ID`、`!housing enter 地块号`、`!housing open`、`!housing close` 和 `!housing leave`。指令使用显示给玩家的 1–60 号地。
- 在「指定小区」确认移动后，国服客户端通过 `ExitRange` 场景 0 的结束回包返回成功标记、从 0 开始的区号和住宅区 ID。服务端关闭菜单后按回包区号传送。事件脚本在每次打开住宅菜单时读取。
- 空地告示牌打开后，客户端通过 1105 请求报价。世界服以 opcode 141 返回固定价格，购买时用同一份 EXD 价格校验余额。国服原生个人购买仍要求至少一个战斗职业 50 级，且当前军团军衔达到 9。
- 告示牌在空地、已购地和已建房三个阶段都可交互。「进入房屋」物件仅随已建房屋生成，绑定国服的 `WarpHousingEnterHouse` 事件。房门和出屋落点使用 `HousingLandSet.RoomExit` 对应的坐标，告示牌操作使用 `PlacardId` 对应的坐标。右键房门时，服务端校验距离与访客权限，再切区进入对应室内。

当前业务覆盖个人住宅。抽签、部队及公寓产权、搬迁、拆除和拆迁补偿仍待实现。客户端界面与分区切换需要按[手工测试清单](../../history/2026-11/202611101723_housing/manual-test.md)验收。
