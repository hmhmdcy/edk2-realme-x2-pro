# Realme X2 Pro 当前检查点

2026-10-15，阶段209，完整外设goal active。UTC不确定度单变量对照未改善接收器约6秒报告或真实收星；候选未部署，产品仍207状态。已核对常态摄像头缺失的DTS与模块，下一步推进持久化相机接入。209没有重启/刷写。[209报告](reference/kernel209/README.md)、[完整208快照](archive/NEXT-SESSION-through208-2026-10-15.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前运输 `reference/kernel209/host.py`，guard `/var/lib/samurai/k209-baseline/boot-id-private.txt`，已核对仍是207第二boot。209比较worker终态，原mask63/GPS0/Signalsfalse/rate30恢复，无待确认切换。207两轮重启、208两个诊断worker都已完成，旧marker不得重放。
- 产品保持TFTP b3bb82b9…/wifi854c9a8c…/MCFG复制d4c62be6…，Image183/boot204 cdd16e29…/实际DTB b9d9c2a1…/CAMSS82cbc052…、原BT185、MM191/签名APK203/helper421/init54/SSC9a1。本轮未替换产品程序，无RF/供电/原厂NV、BT配对连接、振动或相机取流动作。
- 同一MM GPS会话先采25秒1000ms原策略，再按chrony实测167.87ms界限+250ms余量向上取整418ms注入，静置3秒后采60秒。前后25/60组PQWM1均报告约6.000秒不确定度，TimeValid1/source3、恢复错误0；184/427条NMEA校验均0，fix/正CNR均0。调用ACK+完成23.15ms成功不代表基带采用较小误差。本次不支持把固定1000ms当作零CNR根因。
- 自动helper本轮无XTRA下载/注入，当前窗口不变；finally发送一次原1000ms输入策略的当前UTC（ACK/完成23.44ms），GPS关闭、mask63恢复/CID关闭。唯一worker91.88秒完成、错误/五类fault增量0。SDK时间来源UNKNOWN/AP/NTP/NTS仅库侧核对，未证明旧基带使用此可选字段，产品仍UNKNOWN。
- 3301.29秒独立健康：三个DSP running、taint/五类fault0，mask63/GPS0/Signalsfalse/rate30无需归一化；watch累计3/3，辅助窗口当前168h，NV源与原185模块/产品hash保持。48份本轮原生文件私人归档逐成员核对。
- 只读常态相机核对：CAMSS绑定、media0的22内部实体无IMX471；CCI0/1均disabled，DTS没有PM8008/IMX471。安装树缺imx471/v4l2-cci，配置未启VIDEO_IMX471/V4L2_CCI、modules.order无IMX471。PM8008安装原模块189299…，200开发MFD不能当作已安装。S8C1.352V/users3；PM8150L VIO LDO1 1.8V/users0/state unknown、无phandle，unknown不等于关闭。

## 源码、产物与回退依据

- 209仅新增reference诊断/算法/检查脚本，手机工具在/var/lib/samurai/k209-tools，无产品替换需回退。clock_uncertainty候选未入产品/APK；不要因输入数字较小就安装。所有原始NMEA（含PQWP2位置字段）、NTP身份/端点、MCFG清单及归档指纹仅在E:/edk2-samurai-out。
- 内核 `/home/cy122/pmos-samurai-kernel136/kernel` 仍204源码，25 tracked/11 untracked未暂存，板级DTS439db943…、IMX471源110977b8…、PM8008源057ccd62…、CCI源9b189c25…；Image183/config55f1…/旧canonical DTB22c1…/符号16793/order770保持。205诊断早撤回，GENI产品源码未改，旧harness缺TIOCM_LOOP的首次失败未续完。
- 207已修复TFTP回绕并验1,048,603字节/两回绕与14次26,580字节回归；本机原厂MCFG173文件8,807,671字节自动复制、mdtime可读，mcfg.tmp仍0字节，整体蜂窝配置未验收。PDC1平台/25软件、活动存在无pending是207实测。208还确认XTRA预测GPS/GLO/BDS/GAL/QZSS覆盖30/21/13/26/3，接收星历均0；ADC变化不等于RF/天线正常。
- TFTP原件/环境手机k207-tftp-deploy，MCFG部署前helper在k207-mcfg-deploy-r2。按当前boot/PID核对后仅回退TFTP无需MPSS重启。新radio尚未APK化，旧rootfs132未整合。207的290份、208的57份归档和原厂备份保持。

## 续作与已知风险

下一步优先做常态前摄接入：按200实体RAW成功拓扑补齐可持久构建/安装的IMX471、V4L2 CCI库及匹配PM8008模块/Kconfig/DTS；先核对204源码构建的基准DTB与实际b9d9…，不能误用旧22c1 canonical DTB。直接静态引用VIO应让编译器生成phandle，不依赖旧临时301或开发helper。CCI1 master1/地址0x10、MCLK2 19.2MHz、四lane/200MHz、CSIPHY2及MCLK sleep pull-down是200已验拓扑；当前phandle/GPIO/owner须新核对。四路PLDO输入网仍未知，不虚构电源父节点，完整冷启/其它镜头/用户态仍需验收。

GNSS真实fix/正CNR仍未解决；时间精度候选无改善，不再重复同一对照。NTP启动延迟、GeoClue晚到Signals/rate、原厂初始化/RF/LNA/天空条件、精度冷启/SSR开放。已异步询问手机摆放条件，尚未得到答复，不能假定环境；继续相机工作不依赖该回复。[相关机型对照](reference/kernel205/GNSS-RELATED-DEVICES.md)。

保留完整目标：蜂窝真实SIM注册/数据/通话/SMS、传感器精度/FastRPC共享池与SSR/SSC首次204退出、BT phase5、Wi-Fi/USB PM、完整充电和其它外设、radio/Mesa可复现APK与新rootfs均未完成。[完整硬件清单](linux-port/docs/HARDWARE-STATUS.md)。
