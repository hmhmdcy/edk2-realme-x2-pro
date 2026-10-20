# Realme X2 Pro 当前检查点

2026-10-19：[295有效BHIST与首包缺陷](reference/kernel295/README.md)、[294零计数失败与metadata修复](reference/kernel294/README.md)。多摄/骁龙ISP目标active，统计首包、BLC/IPA、产品硬件pipeline和完整画质未完成。

## 当前部署与启动身份

现机 **#295**、`7.3.0-rc6-rmx1931-samurai-k295+`；samurai-stats295／d249946aefa1a01d99fd5484825a4458423b7348。完整Image及独立778模块已部署读回；boot276、DTB、原厂固件、961包和50相机载荷保持，libcamera r24/config-r19、PW/SPA/Gst1.6.9-r3保持。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

Image SHA 39a3d712e7927a850b7e7a92d3181a407339026dd73d0dd62e415279176664d9；logdump ddd66658c711ff45efc0e578e291affc98a1301f8700d7bb88e47af7bc95b0b6；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

运输reference/kernel295/host.py、原SSH严格密钥、新端点及 `/var/lib/samurai/k295-work/boot-id-private.txt`。旧294/293 guard不再用于当前启动；按driver/entity发现设备。本次main6-0010/lens6-0072、tele8-002d、wide7-0010、front9-0010。Phoc4052/Phosh4312/PW5724/WP5736，start_ticks见[最终状态](reference/kernel295/final-health-validation.json)。

## 已验证与当前缺陷

- 294通用metadata DMA启停、注册错误回收、图像重启保留统计buffer、部分输出启动失败回收；实际旧函数负对照失败，修复后ASan/UBSan及30处注册故障注入通过。295将误认的RS bit5更正为BHIST bit4，独立端口枚举/原厂HAL指令证明并保留错误解释。修复在SoC/公共驱动，无新增板级DT/固件/产品包改动。
- #295长焦99图像/90统计包，稳定ROI全幅820560/半幅410280/最小2精确匹配；统计独立启停、图像重启后三buffer均出现。标准接口，无用户空间MMIO写入。WB11阶段颜色误差<1.235，10非法包、7完成，五次颜色变化首帧与参数序号一致；不等于Request API或统计SOF严格对应。
- **统计首包不合格**：长焦启动17567538901、图像重开1160356（期望820560）；广角首包17552007722（期望499392），却返回正常flag；之后稳定帧正确。当前统计验收passed=false、ready_for_automatic_exposure=false。[统计缺陷](reference/kernel295/statistics-pixel-validation.json)
- 用户已确认后摄无遮挡；广角18图像/18统计，曝光500→3000→500时Y74.8023→92.1108→74.8024，稳定hist均值bin71.4364→110.6519→71.4400，人口499392；预览能辨结构仍暗绿，BLC/AWB/IQ未校准。[实景统计](reference/kernel295/optical-statistics-validation.json)
- 原产品RAW＋CPU ISP四摄18段237帧通过，主摄SIGINT33/重开12。当前SSC/桌面/SensorProxy默认成功，未nodeps/重试；294同样成功，但293 EPERM/exit4偶发根因未关闭。物理旋转及本启动AF未重测。
- 778模块/50载荷/961包核对，camera/lens/CCI/CAMSS suspended，九rails/共享IO关闭，MCLK/CCI clocks0，fault0/taint0/pstore空；Wi-Fi/HCI和modem/adsp/slpi正常。checked_runtime_healthy=true仅覆盖所列检查，whole_system_healthy=false，GPU默认故障/旧modem watchdog和整机长稳未结案。

## 源码回退与下一步

维护树 `/home/cy122/x2pro-linux/camera279-isp-kernel` 干净samurai-stats295／d249946aefa1a01d99fd5484825a4458423b7348；293/294父分支保留，4个新增本地提交未推送、未证明上游接受。完整295构建148.55秒/五阶段诊断0、40CAMSS组件Werror、778模块及3嵌入BT模块一致。输出/mnt/samurai-full282/build，先用284/storage.py核backing并挂载；config SHA f084bcf761c222cb77ea00ecd26b944f40401de8abc9a71b308c4d0a9963871a，input-initramfs295/modules295。294 R2六产物已保存在私人kernel295/completed-boot294-r2。

先修统计RAM初始化/首份有效数据时机及错误标记，再做统计SOF关联、BLC、libcamera硬件pipeline/IPA。继续主/前摄硬件路径、模组校准、AF Continuous/距离映射、Shine OV02A1B、GUI录像及长稳。原厂DT提接线、内核/HAL提协议，画质须匹配模组与本机校准；不套其它手机调校或单场景黑电平。

主线基础仍7.3rc6，当前52本地提交/177改动文件；libcamera配方28补丁（含发行版既有）、PW另6项目补丁，三个ignore_unused仍在。已有底层收敛，**尚不能承诺主线内核/关键包更新零或最小补丁**；仍缺上游接受、跨版本与完整rootfs/冷启/PM验收。[分层审计](reference/kernel295/layering-validation.json)

稳定回退首选#290 logdump SHA0f169a331d1c4aac98cd67f636c9f30dd0c727ffc20a6031e4de142d7f57396a及原778模块；294/293/292/288各778、k132776、未启动292R1独立778及整机248备份保留。未做回退往返。本轮两次切换及所有构建/采集已终态，勿盲目重放。私人目录E:/edk2-samurai-out/kernel294、kernel295，像素/原厂载荷/校准/密钥不公开。[操作边界](WORKING-BOUNDARIES.md)
