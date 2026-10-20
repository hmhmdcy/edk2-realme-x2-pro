# 当前检查点：361（收尾交接）

2026-10-20。用户要求收尾、提交、更新文档并交接；本阶段已结束实机实验。完整多摄／骁龙 ISP 目标尚未完成，不能标记完成。按 WORKING-BOUNDARIES.md 选择相关验证，复用未改部分的结果。

## 已交付与未通过

360 将原厂曝光／手动防频闪和 IFE Gamma 合并为 r28／配置 r23 候选，完整构建、签名和 ARM64 组合检查通过，未安装。361 临时使用 348 Gamma 模块实机验证：四摄、五物理模式、十个原厂 Preview／Video 线程上下文均完成五段 EV／频闪／WB 请求，共 274 帧。

隔离 IPA 仍未通过。r4 在公共 EventDispatcherPoll 递归分发中断言；361 公共层补丁保留外层状态、最外层才回收条目，ARM64 旧版失败／新版通过的八组回归符合预期，接口／类布局未改。r5 用新 base 实机越过原断言，随后 CAMSS IspControls 队列重入导致空队列 pop_front。r4／r5 整轮均保留失败，未执行的广角实景不计通过。完整记录及补丁见 [361](reference/kernel361/README.md)。

下一步先修 CamssVfeData 待处理 ISP 队列在同步 applyIspControls() 前后的重入／所有权；r5 同一 source=12 重复处理。不要删断言、空队列跳过或禁用隔离。用新事务验证隔离主摄、一个线程上下文及广角实景，再制作下一版完整包。360 r28 APK 仍含旧 base；361 尚未生成 r29，不能直接把 r28 当隔离合格包安装。

## 当前设备

最后只读观察：原严格密钥 USB 169.254.42.1 SSH 可用；7.3.0-rc6-rmx1931-samurai-k298+，CAMSS338 note SHA256 0227d29bb5129e2fc69866529147b21b902d441c855f848fd5eaa3093c590297，taint0。libcamera 五运行包 r27、config／stack r22；PipeWire／WirePlumber 各一个、uid10000；CAMSS／双 CCI suspended；无活动361 worker、无 ICP实验模块或孤儿固件。r5清理九电源 disabled/users0，相关新内核故障0。[最终状态](reference/kernel361/closeout-device-validation.json)。

临时348及候选用户空间已撤回，安装文件未改，无重启／刷写。原版本四摄各4帧的基础检查见360，不重复未改组件全量测试。手机已恢复Linux，无需沿用357的强制重启请求。9008进入过程见357；退出触发未知，pstore为空。旧356 R5状态仍 load-boot-test／terminal=false、worker不存在，不改成成功。

## 源码、构建和私有资料

公共实现／脚本主工作区：E:\RealmeX2Pro edk2；Git提交位置：WSL /home/cy122/edk2-samurai/repo，子目录 Platform/Realme/sm8150。公共镜像不含个体校准、原厂固件、密钥及认证原始日志。

libcamera候选：/mnt/samurai-full282/libcamera361-event-dispatch-built/src/libcamera-v0.7.2；相对360只改公共 event_dispatcher_poll.cpp。已重建 base，核心／IPA／proxy取360实际打包载荷。临时bundle必须包含 .so.0.7 → .so.0.7.2 相对SONAME链接，r1/r2因遗漏链接误载系统r27。

360完整包／回退仓库、8份完整私有原厂用途配置：E:/edk2-samurai-out/kernel360；361实机原始观察：同级kernel361。手机事务 /var/lib/samurai/k361-request-r1..r5 保留，不重放。host361.ssh沿用host360新guard；private360/recovered-boot-adoption-private.json定位当前启动，旧305/356guard不变。

SDK /home/cy122/x2pro-linux/libcamera214-root；进入E盘ext4前调用storage284.mounted_build()，其mount含flock；SDK /work/libcamera临时bind不能并发，退出释放。已有执行handle只轮询，不因观察超时重复启动。C盘空间紧，不复制大型源码／产物到C。

内核 /mnt/samurai-full282/source354，branch samurai-iommu-node-lifetime357，commit ba61a62293e0f6bc5838c06f2e85e033e3d702a8。357 IOMMU节点引用修正已W1/Werror构建、未装。356第7构建已改Realme板级firmware 0x9ab00000／5MiB命名memory-region，从未发机；旧generic 0x8b700000实验失败，不能复用。尚无完整SYS_INIT／PING／PC_ACK成功。

## 后续范围

先完成隔离队列／新包，再推进正确内存下ICP／HFI及IPE完整会话，接350/351/352后级Gamma／LTM／CCM；动态FrameDurationLimits、自动频率检测、更多模式、光学／几何、多摄同步及连续AF仍待完成。十上下文TPG请求链不等于物理曝光响应或绝对校准，IFE Gamma不等于最终原厂显示色调。未知前摄裁剪保留generic，缺完整IQ的高分辨率不造表。

历史检查点保留在 [360及以前归档](archive/NEXT-SESSION-through360-2026-10-20.md)，各reference按当时记录解释。357认证／360原始日志可能含私密输入，不打印或镜像。
