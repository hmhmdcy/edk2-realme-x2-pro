# Realme X2 Pro 当前检查点

2026-10-15，阶段212完成有限默认CPU ISP验证，完整外设goal active。普通桌面用户取得6帧1920×1088 RGB888：首帧黑、后5帧非全黑；系统CPU配置跨启动生效，未走DRM/EGL，最终taint/五类fault0。它不是完整拍照质量验收，后置四摄仍待接入。[212报告](reference/kernel212/README.md)、[211完整快照](archive/NEXT-SESSION-through211-2026-10-15.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前运输reference/kernel212/host.py，新guard为/var/lib/samurai/k212-runtime/boot-id-private.txt。212执行一次正常停用/restart2/fastboot reboot，没有刷写，两个marker已闭环；211的三个marker也已闭环，不可重放。k212-before-reboot及全部211 guard是旧启动。
- 当前boot211 c3bf043f…/DTB6f9f5b0f…；Image183 bfa72dd9…/logdump183 e73754c7…保持。IMX471模块a28dd67a…，CCI f9c9272a…/PM8008 d1ff82c0…/CAMSS82cbc052…/BT185保持；模块树772ko/786文件。TFTP207 b3bb82b9…/wifi854c9a8c…/MCFG helperd4c62be6…/MM191/helper421/init54/SSC9a1保持。
- IMX471/PM8008静态自动绑定，media0为23实体，sensor有独立TITAN_TOP域。前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/200MHz、CSIPHY2。PMIC源码&i2c4为0x890000，运行i2c-1不等于源码&i2c1。210两轮6帧1928×1088 RAW10及211独立sensor PM/裁剪接口修复保持。
- heap自动加载/权限跨启动通过，通用堆root/video0660、FastRPC专用池root0600。/etc/libcamera/configuration.yaml选择CPU，目录0755/文件0644。212首轮目录0700导致配置不可读/CMA不足，原失败保留；修正后默认配置6帧中首帧黑/后5帧非全黑、无新增fault。没有借环境变量隐藏配置问题。
- 226秒最终健康：三个DSP running，sensor/CAMSS/CCI suspended，VDIG/VANA disabled/users0，MCLK0、MMCX vote0；taint/五类fault0。GPS0/Signalsfalse/rate30，BT关闭无连接，NV及产品程序保持。自动UTC第8次准备成功、chrony Normal，无手动补时/收星。96份本轮原生文件私人快照归档并逐成员核对。

## 源码、产物与回退依据

- 内核/home/cy122/pmos-samurai-kernel136/kernel。211只改IMX471源码、板级DTS、sensor binding三文件，212无kernel源码变更。其余33份已保存改动保持，25 tracked/11 untracked未暂存。配置fbde3690…、16798符号/order772、Image183及旧canonical DTB22c1…保持；旧canonical不能刷作当前树。[211源码核对](reference/kernel211/source-final-validation.json)。
- 私人211保留source-before、原模块/14元数据、190文件原生归档；当前镜像为boot-partition-k211-sensor-domain.img。回退私人210/boot-partition-k210-front.img，哈希89242ade…；正常回退需新身份核对，不使用旧marker。完整kernel/camera APK及新rootfs尚未整合。
- 211旧boot清理的两次MCLK WARN及恢复证据保留，随后新boot独立PM已验证供电域修复。211 GPU ISP又出现CMA不足、全黑帧及IOMMU unmap告警（保存环形日志可见349条/taint512），与MCLK问题不同，仍未修复。212 CPU默认路径干净，不把旧GPU问题改写成通过。
- 207 TFTP回绕已修，原厂MCFG173文件8,807,671B自动RAM复制/mdtime可读，mcfg.tmp仍0B；PDC1平台/25软件活动无pending为207证据，没有选择/激活和NV写入。radio/Mesa打包债保持。

## 续作与已知风险

前摄下一步处理首帧黑、真实增益helper/控制延迟/静态属性和tuning，验曝光色彩方向及拍照应用；GPU路径需单独修CMA预算/黑帧/IOMMU释放。五摄分别验收：前摄完整16MP未完成，后置6400万主摄/1300万长焦/800万超广角/200万人像四路未接入；未知四路PLDO输入、其它模式、冷启/长稳保持开放。不能用非全黑RGB统计证明图像质量。

GNSS真实fix/正CNR仍未解决。用户已确认手机室内窗边，无无遮挡户外验收；209较小UTC误差输入未改善约6秒报告周期，候选未部署。208 ADC变化不能证明RF正常，不重复同一UTC/CNR实验。NTP延迟、GeoClue晚到Signals、原厂初始化/RF/LNA、精度冷启/SSR开放。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。

保留完整目标：蜂窝真实SIM注册/数据/通话/SMS，传感器精度/FastRPC共享池与SSR/SSC首次204退出，BT phase5，Wi-Fi/USB PM，充电闭环及其它外设，radio/Mesa可复现APK和新rootfs均未完成。[全硬件清单](linux-port/docs/HARDWARE-STATUS.md)。
