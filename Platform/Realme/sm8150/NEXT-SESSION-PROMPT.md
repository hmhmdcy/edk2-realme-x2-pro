接手Realme X2 Pro（RMX1931/samurai）Linux适配。先读NEXT-SESSION.md、WORKING-BOUNDARIES.md、linux-port/docs/HARDWARE-STATUS.md，再读reference/kernel240/HANDOFF.md和README.md。

交接时适配目标为paused，未完成；后续继续/修复/测试请求即可推进，无需重复确认。硬件状态来自240最后实测，文档维护未连接或复测手机。接手时核真实设备、启动身份和现有进程；旧guard、目录名及内核release不能独立证明当前构建。

建议优先处理Snapshot缓冲所有权/帧率，拍照、切换与长稳按诊断需要安排。CPU预览已验，GPU根因、颜色和拍照未验；保留历史GPUfault与回收错误。S5K3M5仅源审、未构建部署，P共享电源lease未实现；GNSS仍无正CNR/fix。

使用检查点中的源码、产物、事务和回退依据。240脚本可按当前状态复用，处理非幂等步骤和结果覆盖。普通拍照、本地样本保存分析、补光及GPU测试按任务安排；纯色测试按用户延期。蓝牙只扫描、振动不新增脉冲。当前规则仅见WORKING-BOUNDARIES，历史实验方法不新增限制。完成后更新检查点、硬件清单和专题证据。
