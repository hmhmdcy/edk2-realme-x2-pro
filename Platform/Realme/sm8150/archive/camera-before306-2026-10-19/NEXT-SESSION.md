# Realme X2 Pro 当前检查点

2026-10-19：[305长焦几何／四摄回归](reference/kernel305/README.md)、[303硬件AE](reference/kernel303/README.md)、[304EEPROM](reference/kernel304/README.md)。目标active、未完成。长焦活动阵列已在sensor驱动修正并部署，完整多摄／ISP校准仍开放。

## 当前部署与启动身份

USB NCM和原严格密钥SSH已恢复。重连后启动ID变化，当前仍#298／7.3.0-rc6-rmx1931-samurai-k298+、taint0。新guard：/var/lib/samurai/k305-geometry-r2/boot-id-private.txt。305/host.py使用USB；303/304旧guard会拒绝当前启动，后续继承305入口并核当前状态，不覆盖历史guard。

当前298 Image加305单模块：778模块中仅s5k3m5.ko更新，SHA d1a85e75b9344423097c8189ed65a0320abcb3f7ba3d5fdac34e3c8758f056c9，intree=Y、加载note匹配。其余777模块／961包／50相机载荷及APK数据库／world保持。libcamera r24／config-r19及PW／SPA／Gst1.6.9-r3仍RAW＋CPU ISP，303候选未安装。本阶段未刷写或重启。

Image SHA eb8054e69991528cad4f126d7723b7ef4869b288fb85c992f4803cbfeab5ddaf；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d，boot276和固件保持。

最新内核树/home/cy122/x2pro-linux/camera305-sensor-kernel，samurai-geometry305／18b0a5a753e9363594f682049bf131169488c644，干净。原camera279-isp-kernel、samurai-blc298／c5e118faec21a6c4bd2e7d5b86b3b21ad9dc2117保持；未来完整构建应包含305修复。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

## 最新证据与边界

- 305先查Hotdog同sensor方案，核本机三份寄存器表，只改s5k3m5.c几何；SoC、板级DT、寄存器表不变。ACTIVE／TRY八查询及libcamera属性通过：阵列4208×3120，19.2MHz输出2104×1560，全阵列裁剪。24MHz仅核表；方向、静态属性和延迟未猜测。
- 产品四摄18段272帧，另补长焦中断64帧／重开12帧，共348帧，不能算硬件IPA校准。图、格式／裁剪／控制／video恢复，桌面PID保留、PW／WP重启。五sensor／lens、两CCI和CAMSS休眠，9供电用户0、MCLK／CCI0，fault／taint／pstore／CCI错误0，worker退出。[最终核对](reference/kernel305/final-health-validation.json)
- 303在上一启动完成IMX319联合恒EV480帧／36写入SOF＋2；硬件AE隔离／线程共960帧，17生效revision／34写入，81可辨响应域与元数据同帧。低照度最终3331行×16仍低于0.16目标；严格0.01误差检查false，只证明正确到上限，未证明目标收敛。[实机边界](reference/kernel303/README.md)
- AE仅双Auto或双Manual启动，混合／运行中切换拒绝；WB固定，RGB AWB、动态帧长、防频闪及完整IQ未做。主机DSO／线程1440合成帧另列，真机隔离已通过。
- 304纠正旧EEPROM XML后半错位，WB Q=1、LSC221点，双读4420通道值独立C/Python一致。完整schema、校验／有效标志、模组绑定、LSC几何／尺度和golden合成未确认，未应用个体值。[304](reference/kernel304/README.md)
- 原厂IMX319 BLS960 U14仅OEM参考，临时WB不是正式校准。旧GPU／modem／SSC问题未关闭，whole_system_healthy=false。

## 源码回退与下一步

SDK /home/cy122/x2pro-linux/libcamera214-root/work/libcamera299-inline为303源码，使用303/build-candidate.py；302源码／最终包保全，不重放旧安装器。305 R2因列表断言误判完整回退，R3修后成功；外部M=模块缺intree从未加载。安装／回归均终态，勿重放。

继续原厂S5K3M5模式调校、长焦独立硬件profile与控制延迟实测；补明亮场景AE正反向收敛、错误恢复、RGB统计／AWB、主前摄／其它模式与正式IQ。保持SoC／板级／sensor／IPA／模组数据分层。用户延期纯色／遮光保持。

构建卷按284/storage.py核backing，保留Rust环境；305树内同时构建CCI和sensor后恢复原输出。稳定#290及独立778模块、k132776／248备份保留。[操作边界](WORKING-BOUNDARIES.md)、[维护收据](reference/maintenance-2026-10-19/README.md)。上游接受与零补丁升级尚未证明。
