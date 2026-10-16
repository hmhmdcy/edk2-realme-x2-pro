# Realme X2 Pro 相机接入

文档交接时完整适配目标为paused、未完成；下述为240最后实测，本次维护未复测手机。续作建议、脚本风险及回退入口见[240交接](../../reference/kernel240/HANDOFF.md)，当前规则仅见[操作边界](../../WORKING-BOUNDARIES.md)。

当前236启动/boot235、前摄e49/IMX319176f/CAMSSff9和libcamera r15/config-r10保持。240补桌面接入：Megapixels缺本机配置且不走libcamera；Snapshot原默认Vulkan出现GPU故障，现使用仅该应用的Cairo＋线性DMA-BUF CPU映射回退。[问题、失败与修复证据](../../reference/kernel240/README.md)、[部署锁](deployment-lock.json)。

桌面“相机（Snapshot）”及实际D-Bus激活均继承GSK_RENDERER=cairo、GDK_DISABLE=gl,vulkan,offload。用户级desktop/service覆盖，原签名包文件不变，不改Phosh全局环境；新服务目录创建后已ReloadConfig并实测。原生签名安装只新增14包至958，r15/r10的49载荷和原944包记录不变。完整rootfs仍须纳入这些应用/启动配置；用户覆盖不是新rootfs镜像。

前摄16秒及用户要求的30秒重试分别取得765/1436个递增PTS、324/600次1920×1080 XR24:0 CPU mmap，0paintable Bus Error、无应用GPU设备FD/新增内核fault；关闭后图/格式/控制/rail/PM/MCLK恢复。历史480条默认Vulkan故障保留。163/301次缓冲未回收错误、帧积压仍待修，不能称完整拍照或光学验收。当轮未触发快门、保存或转移场景像素；普通拍照、本地样本分析和补光可按任务安排。前摄纯色测试按用户延期。

IMX319竖放同request RAW/RGB24组均非零，32ms仍92.35% RAW≤80；非零/曝光响应不代表正常光学。S5K3M5的917初始化＋模式3表和PM候选已源审，尚未编译部署；本机P L2/L6共享lease未实现。其它后摄、颜色/方向、GPU ISP、性能/长稳和完整kernel/rootfs开放。[近机型参考](../../reference/kernel239/RELATED-LINUX-SOLUTIONS.md)。

r15首参数修复与两次start验收、r15→r13/r8七包模拟回退及实际旧包保留见[239](../../reference/kernel239/README.md)。canonical在240核对时仍after228，复用旧产物时按当前模块/板源核对；卸载lab/MFD前先停流、释放并移除消费者。

当前已部署的[desktop副本](snapshot-launcher/org.gnome.Snapshot.desktop)和[D-Bus service副本](snapshot-launcher/org.gnome.Snapshot.service)按原生事务hash保存，供后续rootfs打包；不是已生成的新rootfs。回退时用事务manifest识别两项用户覆盖并保留用户后续修改；驱动或应用补丁按任务需要修改、打包。
