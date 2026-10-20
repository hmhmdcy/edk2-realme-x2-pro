# Realme X2 Pro 当前检查点

2026-10-19：[293标准WB参数/FULL修复及实景](reference/kernel293/README.md)、[292真实失败](reference/kernel292/README.md)。多摄及骁龙ISP目标active，统计/BLC/IPA、产品硬件pipeline和完整画质未完成。

## 当前部署与启动身份

现机 **#293**、`7.3.0-rc6-rmx1931-samurai-k293+`，samurai-params293／1aa1955077c977b611c722eca0bc467c3bf052ed；完整Image和独立778模块已部署读回。boot276、DT、961包、libcamera r24/config-r19、PW/SPA/Gst1.6.9-r3及50相机载荷保持。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

Image SHA 71cf86febe5be283e7a5cdda56a2ad6ee375818afe2abc53793beb71e27cc4d6；logdump be6e413e27cd8914d64ff111e6e7b99941f7dac471c9e2c477e8ee6a2112cf74；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

运输用reference/kernel293/host.py、严格原SSH密钥、新端点及 `/var/lib/samurai/k293-work/boot-id-private.txt`。旧292/290guard不再用于当前操作。按实体/driver发现：本轮main8-0010/lens8-0072、tele6-002d、wide9-0010、front7-0010。Phoc5644/Phosh5714/PW7087/WP7089，start_ticks见[最终状态](reference/kernel293/final-health-validation.json)和手机k293-services-verified-private.json。

## 已验证与当前缺陷

- 292新增实际输出pad门控、VFE175零DMA参数节点及metadata link validator，但FULL原num_outputs==1校验遗漏，WB两次及实景均在QBUF EINVAL、0帧。媒体图/供电恢复，无新增fault；失败收据保留。293通用SoC修复允许可选零DMA参数输出，保留格式/client/plane/地址检查；旧实现负对照失败、新实际函数ASan/UBSan通过。
- #293长焦真实CSI→CSID175→VFE175 FULL：标准META_OUTPUT QCIP，10类非法包拒绝，7次参数完成，81帧九阶段。R/B/G四分之一、DISABLE、bypass更新、ENABLE、停参数流和重开默认值均与独立RAW色块参考匹配，最大通道误差<1.235；QBUF后改用户buffer不影响内核快照。[像素](reference/kernel293/wb-params-pixel-validation.json)
- 五次可观察变化首帧10/19/28/37/55与PARAM_DQ sequence精确相同；仅单参数更新/S5K3M5图案/320×240，不等同request API或完整pipeline。[帧对应](reference/kernel293/frame-association-validation.json)
- 用户已确认后摄无遮挡；本轮广角无图案实景18帧Y均值74.230→89.303→74.230，私人预览有可辨识边缘/结构，仍偏暗偏绿，BLC/AWB/画质未校准。四摄18段232帧含SIGINT28/重开12通过，普通cam仍RAW＋CPU ISP。[实景](reference/kernel293/optical-pixel-validation.json)、[回归](reference/kernel293/four-camera-regression-validation.json)
- **本次SSC默认启动失败**：FastRPC attach EPERM/exit4、SLPI offline，SensorProxy/自动旋转不可用。已一次临时nodeps恢复桌面，永久依赖配置不变，未盲目重试SLPI；旧273同现象根因未明。[故障](reference/kernel293/ssc-failure-validation.json)、[恢复](reference/kernel293/desktop-restore-validation.json)
- 最终778模块/50载荷/961包核对，sensor/lens/CCI/CAMSS suspended，九rails/共享IO关闭，MCLK/CCI clocks0，fault0/taint0/pstore空；modem/adsp、Wi-Fi/HCI正常。此项不覆盖SSC失败，也不代表GPU默认故障/旧modem watchdog或整机长稳已结案。

## 源码回退与下一步

维护树 `/home/cy122/x2pro-linux/camera279-isp-kernel` 干净samurai-params293／1aa1955077c977b611c722eca0bc467c3bf052ed，父86c7b9d及290/288分支保留，四个新本地提交未推送/未证明上游接受。完整构建152.74秒/五阶段诊断0，39CAMSS组件Werror；配套778模块、3个嵌入BT模块一致。

输出/mnt/samurai-full282/build；先用284/storage.py核backing并挂载。config SHA d0f794c784b3587002ba18f503ed899541a3c45f80e762673bd2bfbb2ce2f7dc，input-initramfs293/modules293。完整292 R2六产物已保存在私人kernel293/completed-boot292-r2；292 R1从未启动且778模块另存。所有本轮构建/切换/采集已终态，勿盲目重放。

下一步SSC attach根因、统计/BLC、libcamera硬件pipeline/IPA；补主/前摄硬件路径、模组校准、AF加速/Continuous/距离映射、Shine OV02A1B、GUI录像及长稳。278单次AF证据不晋升为#293重测。原厂接线归DT、协议归公共驱动、调校归IPA/模组数据，不硬编码单场景黑电平。

主线基础仍7.3rc6；当前树相对base有48本地提交/175改动文件，libcamera配方28补丁（含发行版既有补丁）、PW另6项目补丁，三项ignore_unused仍在。存在底层收敛，**尚不能承诺主线内核及关键包更新零/最小补丁**；需上游接受、跨版本及完整rootfs/冷启/PM验收。[分层审计](reference/kernel293/layering-validation.json)

即时稳定回退首选#290 logdump，SHA0f169a331d1c4aac98cd67f636c9f30dd0c727ffc20a6031e4de142d7f57396a及原778模块；292/288各778、k132776、183镜像和整机248备份保留，未做回退往返。私人资料E:/edk2-samurai-out/kernel292和kernel293，不公开像素/校准/密钥。[操作边界](WORKING-BOUNDARIES.md)、[硬件清单](linux-port/docs/HARDWARE-STATUS.md)
