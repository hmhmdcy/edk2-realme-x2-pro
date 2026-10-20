# Realme X2 Pro 当前检查点

2026-10-19：[296统计SRAM/首包修复](reference/kernel296/README.md)、[295首包真实缺陷](reference/kernel295/README.md)、[294零计数失败](reference/kernel294/README.md)。多摄/骁龙ISP目标active；统计SOF关联、BLC/IPA、产品硬件pipeline和完整画质未完成。

## 当前部署与启动身份

现机 **#296**、`7.3.0-rc6-rmx1931-samurai-k296+`，samurai-stats296／f86906688666c0ebaabaeeec96c28d5741257f50。完整Image及独立778模块已部署读回，加载build-id匹配；boot276、DTB、原厂固件、961包/50相机载荷保持，libcamera r24/config-r19、PW/SPA/Gst1.6.9-r3保持。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

Image SHA f226c1739061fd0f228f6efde9d05a6c55943c1296184723931eefdc9077ecc6；logdump 64616e8fd6e4327e6a07d5c738bea7b7707922703f8a69a97f11ec11af08605e；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

运输reference/kernel296/host.py、原SSH严格密钥、新端点及 `/var/lib/samurai/k296-work/boot-id-private.txt`；旧295等guard不用于当前启动。按driver/entity发现，本次main8-0010/lens8-0072、tele6-002d、wide9-0010、front7-0010。Phoc3670/Phosh3891/PW5256/WP5270，start_ticks见[最终状态](reference/kernel296/final-health-validation.json)。

## 已验证与当前缺陷

- **295首包随机/残留计数已在所测场景修复**。两个仓库固定版本含同一生成寄存器头blob，确认BHIST RAM选择0x3a、CGC bit4、DMI0xc24/0xc28/0xc30。SoC驱动在像素到来前清零1024槽并恢复共享DMI/时钟状态，无板级DT/固件/UAPI/产品包改动。旧函数负对照失败，新实际函数ASan/UBSan、10万ROI及buffer生命周期测试通过。
- 本轮硬件216图像/198统计：长焦99/90→广角18/18→切回长焦99/90；7个初始/图像重开/统计晚启动首包全部精确。长焦全幅820560、半幅410280、最小ROI2；广角全部18包人口499392。第二轮停统计时重开参数改4×2，再晚启统计首包为新ROI的2，未出现旧全幅计数。[汇总与范围](reference/kernel296/startup-fix-validation.json)
- 无丢弃首包、无用户空间MMIO写入、无CPU伪造直方图。严格图像—统计SOF、队列饥饿/合并IRQ、多参数Request API、其它模式/长稳未验收，ready_for_automatic_exposure仍false。下一步统计帧关联、BLC、硬件pipeline/IPA。
- WB首轮11阶段颜色误差<1.235、10非法包、7完成，五次颜色变化首帧与参数序号一致；第二轮额外停统计时重开参数，共8完成，不等于Request API验收。[颜色](reference/kernel296/stats-pixel-validation.json)
- 广角实景曝光500→3000→500：Y75.0741→93.3138→75.0732，hist均值bin71.9740→113.7148→71.9721；已查看私人预览，结构可辨仍暗绿，BLC/AWB/IQ未校准。原产品RAW＋CPU ISP四摄18段244帧通过，主摄SIGINT40/重开12。
- 当前SSC/桌面/SensorProxy默认成功，未nodeps/重试；#293 EPERM偶发根因仍未关闭。物理旋转/本启动AF未重测。778模块/50载荷/961包核对，camera/lens/CCI/CAMSS suspended，九rails/共享IO关闭，MCLK/CCI clocks0，fault0/taint0/pstore空；Wi-Fi/HCI、modem/adsp/slpi正常。checked_runtime_healthy=true仅限所列检查；GPU默认故障、旧modem watchdog、整机长稳未结案，whole_system_healthy=false。

## 源码回退与下一步

维护树 `/home/cy122/x2pro-linux/camera279-isp-kernel` 干净samurai-stats296／f86906688666c0ebaabaeeec96c28d5741257f50；295及更早分支保留，本轮1个本地提交未推送、未证明上游接受。完整构建153.08秒、五阶段诊断0、40CAMSS组件Werror；778模块与3嵌入BT模块一致。输出/mnt/samurai-full282/build，先用284/storage.py核backing并挂载；config SHA 82e39f7ea2ad2507417290cfbcd5754dd3f4ee431bb3a73b31e8f880e5e04233，input-initramfs296/modules296。295六产物已保存私人kernel296/completed-boot295。

后续统计与图像SOF关联、BLC、libcamera硬件pipeline/IPA，继续主/前摄硬件路径、模组调校、AF Continuous/距离映射、Shine OV02A1B、GUI录像及长稳。原厂DT提接线、内核/HAL提协议，算法与模组数据放IPA；不套其它手机调校或单场景黑电平。

仍以7.3rc6为基础，53本地提交/177改动文件；libcamera配方28补丁（含发行版既有）、PW另6项目补丁，三个ignore_unused仍在。已有底层收敛，尚不能承诺主线内核/关键包更新零或最小补丁，缺上游接受、跨版本与完整rootfs/冷启/PM验收。[分层审计](reference/kernel296/layering-validation.json)

稳定回退首选#290 logdump SHA0f169a331d1c4aac98cd67f636c9f30dd0c727ffc20a6031e4de142d7f57396a及原778模块；295/294/293/292/288各778、k132776、未启动292R1独立778及整机248备份保留，未做回退往返。本轮一次切换和全部构建/采集已终态，勿盲目重放。私人目录E:/edk2-samurai-out/kernel296，像素/参考载荷/校准/密钥不公开。[操作边界](WORKING-BOUNDARIES.md)
