# Realme X2 Pro 当前检查点

2026-10-13，阶段151收尾。**已复现的A640 GPU CCU故障修复成功并已部署，本轮GPU定位结束。** 保留147内核和149 Mesa修复库；150不修改Mesa的降级候选只完成研究和独立进程验证，未部署。

## 当前实际状态

手机为内核#147、boot132/logdump147/modules132，software132加`mesa-vulkan-freedreno-26.2.4-r1`的本地修复库。`uname -r`仍带k132，`uname -v`实际为#147，不能按目录kernel136或旧版本后缀判断镜像。当前源码仍在WSL`/home/cy122/pmos-samurai-kernel136/kernel`。

151只读收尾六次观察、约20.6秒：同149验收启动，修复库和原库备份SHA一致，桌面与taint0保持，累计GPU fault3、新增0，WARN/DPU/DSI/DMA prepare0，无活动GPU测试、临时GPU追踪或待取core。Wi-Fi关联5180MHz，BlueZ服务started，modem/adsp running，SLPI offline。未刷写、重启或新增GPU负载。[收尾收据](reference/kernel151/closeout.json)

包数据库在2026-10-13 15:31之后与149收据摘要不同，原因未建立；仍936包，Mesa软件包版本仍26.2.4-r1，已部署修复库没有被覆盖。本轮数据库摘要稳定。初次收尾检查因旧数据库匹配断言失败已留档，不能宣称全部软件文件自149保持不变。这是独立的软件元数据待核对项。

## GPU 结论与保留材料

147针对旧式内核管理VM/GLES起点64 KiB对齐，20次像素验证和6次持续绘制通过。149针对自动VM_BIND地址对齐，原版和同构建基线均有空洞复现失败对照；修复库185次像素读回、160,820,781像素零差异，36次Settings面板打开，PM、稀疏重绑定、旧地址重放、Vulkan/GLES并发通过。[147](sessions/147-a640-gmem-alignment-fix.md)、[149](sessions/149-vulkan-ccu-alignment-fix-and-deployment.md)

这是当前故障和已测负载的验收，不等同所有Vulkan扩展、长期压力与跨启动全覆盖。显示接管、DSI及其它硬件待办独立保留。没有新故障证据时，不从旧136失败状态重复开始GPU定位。

公开Mesa补丁：`linux-port/patches/0015-mesa-turnip-a640-vm-bind-iova-alignment.patch`。已部署库SHA256为`97f3638851b534070f649fabfbdbb3d330b4ad0e2b0ea93b78026ad71d78fb5e`；原库与回退工具在手机`/var/lib/samurai/k149-deployment`，主机材料在`E:/edk2-samurai-out/kernel149`。完整构建源码在手机`/var/lib/samurai/k148-mesa`；SDK在`/tmp/k148-sdk`，重启后重新核对并准备。

普通Mesa升级可能覆盖本地`.so`，旧完整rootfs132也不含149更新。后续应把0015纳入对应Mesa软件包构建并生成匹配新rootfs；完成包更新后重新核对库和回归。不要只恢复旧rootfs后仍宣称GPU修复保持。

150候选通过拒绝EN_VM_BIND与VA_START回退GET_IOVA，会失去稀疏绑定、地址捕获重放及lazy BO。MSRTSS内部依赖lazy路径但仍报告支持，是新发现的未测风险。该候选未完整构建或部署，不能删除149库补丁后直接继续使用现有内核。[研究](reference/kernel150/README.md)、[功能与其他机型比较](reference/kernel150/peer-device-comparison.md)

## 下一阶段

优先显示首次接管/DSI生命周期，再推进充电控制保护和音频首次DMA准备失败。实体camera、完整传感器、蜂窝业务、GNSS真实fix、指纹、NFC读卡及振动物理确认仍未完成；已经可用的触摸、Wi-Fi、蓝牙扫描与USB需要补冷启动/休眠/长稳。[当前硬件清单](linux-port/docs/HARDWARE-STATUS.md)

规则仅以[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)为准。切换前重新读取实际设备状态，不复用旧切换身份或重复发送状态未明的切换命令。保护重要分区、NV、校准和工厂备份；电池FET/OTP/解封与温控边界保持；蓝牙只扫描不连接，振动不新增脉冲，私人数据不公开。

原始日志和身份在手机`/var/lib/samurai/k151-closeout`及主机私有输出目录。历史147至150的旧检查点已保存到[历史快照](archive/NEXT-SESSION-through150-2026-10-13.md)。本轮会话见[151收尾](sessions/151-gpu-closeout-and-hardware-handover.md)。
