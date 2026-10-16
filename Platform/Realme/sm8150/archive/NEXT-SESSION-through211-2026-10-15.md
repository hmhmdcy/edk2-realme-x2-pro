# Realme X2 Pro 当前检查点

2026-10-15，阶段211有限修复已验，完整外设goal active。CROP/TRY/ACTIVE和sensor独立TITAN_TOP供电域修复通过；默认GPU ISP仍失败，CPU仅后两帧非全黑、首帧黑。190份原生证据已私人归档核对；最终taint512来自新GPU IOMMU释放告警，不能称完整拍照可用。[211报告](reference/kernel211/README.md)、[210快照](archive/NEXT-SESSION-through210-2026-10-15.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- boot211 c3bf043f…/DTB6f9f5b0f…；Image183 bfa72dd9…/logdump183 e73754c7…保持。IMX471模块a28dd67a…，CCI f9c9272a…、PM8008 d1ff82c0…、CAMSS82cbc052…、BT185保持；完整树772ko/786文件。
- 当前运输reference/kernel211/host.py，当前211启动guard为/var/lib/samurai/k211-runtime/boot-id-private.txt。211三个切换marker均闭环，不可重放。当前GPU诊断后taint512；日志归档可见349条__arm_lpae_unmap，未发生Oops/DSP fatal等五类其它fault，CPU对照未新增告警。
- IMX471/PM8008静态绑定，media0为23实体。前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/200MHz、CSIPHY2。PMIC源码&i2c4为0x890000，运行i2c-1不等于源码&i2c1。210两轮共6帧1928×1088 RAW10已通过。
- 211独立sensor on/auto时，CAMSS/CCI仍休眠，sensor有自己的TITAN_TOP引用；MCLK及VDIG/VANA正常启停、最终全部释放，无新WARN。TRY/ACTIVE四类selection与非法target通过。
- heap自动加载及权限启动复查通过；通用堆root/video0660，FastRPC专用池root0600。默认GPU因CMA不足失败；强制system后全黑并触发GPU unmap WARN。CPU默认配置已安装，显式CPU对照首帧黑/后两帧非全黑；图像和日志均私下保留。

## 源码、产物与回退依据

- 内核/home/cy122/pmos-samurai-kernel136/kernel，211只改IMX471源码、板级DTS、sensor binding三文件；其余33份已保存改动保持，25 tracked/11 untracked未暂存。配置fbde3690…、16798符号/order772、Image183及旧canonical DTB22c1…保持。旧canonical不能刷作当前树。[源码验收](reference/kernel211/source-final-validation.json)。
- 私人211保存source-before、原模块/14元数据及完整190文件原生归档；当前boot-partition-k211-sensor-domain.img。回退私人210/boot-partition-k210-front.img，哈希89242ade…；正常回退需新身份核对，不能复用旧marker。
- 211旧boot清理两次MCLK WARN及恢复证据单独保留；其后新boot独立PM已实测修复。新的GPU unmap告警是不同问题，不能混为已修复。完整相机/kernel APK、新rootfs尚未重建。
- 207 TFTP回绕已修，原厂MCFG173文件8,807,671B自动RAM复制/mdtime可读，mcfg.tmp仍0B；PDC1平台/25软件活动无pending为207证据，没有PDC选择/激活和NV写入。radio/Mesa打包债保持。

## 续作与已知风险

212先进行当前211告警记录核对、正常停用和无刷写重启；验证CPU默认配置在干净启动取流、首帧/预热/增益及资源释放。五摄分别验收：前摄完整16MP/曝光色彩方向未完成，后置主摄/长焦/超广角/人像四路未接入，未知四路PLDO输入与冷启/长稳保持开放。

GNSS真实fix/正CNR仍未解决。用户确认手机室内窗边，无无遮挡户外验收；209较小UTC误差输入未改善约6秒报告周期，候选未部署。208 ADC变化不证明RF正常，不重复同一UTC/CNR实验。NTP延迟、GeoClue晚到Signals、原厂初始化/RF/LNA、精度冷启/SSR开放。[相关机型方案](reference/kernel205/GNSS-RELATED-DEVICES.md)。

完整目标继续：蜂窝真实SIM注册/数据/通话/SMS，传感器精度/FastRPC共享池与SSR/SSC首次204退出，BT phase5，Wi-Fi/USB PM，充电闭环与其它外设，radio/Mesa可复现APK和新rootfs均未完成。[全硬件清单](linux-port/docs/HARDWARE-STATUS.md)。
