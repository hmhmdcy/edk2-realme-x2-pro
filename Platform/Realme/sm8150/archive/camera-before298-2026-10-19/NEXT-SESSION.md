# Realme X2 Pro 当前检查点

2026-10-19：[297共享SOF与断粮恢复](reference/kernel297/README.md)、[296统计SRAM初始化](reference/kernel296/README.md)。多摄／骁龙ISP目标继续推进；BLC／偏色、硬件pipeline／IPA和完整画质未完成。

## 当前部署与启动身份

现机 **#297**、`7.3.0-rc6-rmx1931-samurai-k297+`，samurai-sof297／ab709d9670f6dcaa71858fd4f3e189522f669913。完整Image和独立778模块已部署读回，加载build-id匹配。boot276、DTB、原厂固件、961包／50相机载荷保持，libcamera r24／config-r19、PW／SPA／Gst1.6.9-r3保持。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

Image SHA ec3e50b7d7a0c086b6a0dc40013046785d7ccad6ff990eca35b95b056043f7a9；logdump e6cf910b3a3499232eecccc9d47524c19b949bb59ffc619174f44a78813f44ec；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

当前运输reference/kernel297/host.py与 `/var/lib/samurai/k297-work/boot-id-private.txt`，严格原SSH密钥、新端点；旧296 guard不用于当前启动。按entity发现，本次main6-0010／lens6-0072、tele8-002d、wide7-0010、front9-0010。Phoc3673／Phosh3899／PW5303／WP5316，start_ticks见[最终检查](reference/kernel297/final-health-validation.json)。

## 已验证与当前缺陷

- **PIX图像／统计改用共享CAMIF SOF标签**，不再分别按完成次数编号。两个驱动文件40增／18删；缺标签ERROR，参数报告下一SOF序号，无DT／固件／UAPI／产品包修改。实际旧函数负对照失败，新函数ASan／UBSan、相邻SOF先于DONE、缺标签、断粮、回绕及1000轮重排队通过。
- 长焦R2：126图像／111有效统计／128标准SOF，全部找到SOF，110组共同帧号配对；停统计改4×2 ROI再晚启，首包SOF19／人口2，旧计数18。耗尽三个统计buffer后图像继续，恢复序号保留7帧间隔。五次ROI变化首包与参数10／28／37／46／55一致。[关联与范围](reference/kernel297/sof-association-validation.json)
- WB11阶段颜色最大误差<1.235，10非法包拒绝、8参数完成，六次可观察颜色变化与参数帧号一致。未以最近完成时间配对，统计／图像完成相差可达−32100至102微秒。
- 首轮探针1图像／1统计后因空事件队列ENOENT处理不足退出，失败保留；实际图与资源已回收、fault0。独立R2修探针，无再次刷写。早期默认服务未就绪快照保留，后来默认成功，未重试SSC或nodeps。[过程](reference/kernel297/preparation-notes.json)
- 广角实景18图像／18有效统计，人口499392；曝光500→3000→500，Y75.6113→95.6392→75.6110，hist均值73.0162→120.0075→73.0164。已实际查看私人预览，结构可辨仍暗绿，BLC／AWB／IQ未校准。两成功探针合计144图像／129统计，不含R1失败。四摄RAW＋CPU ISP18段232帧，主摄SIGINT28后重开12通过。
- 多次未观测SOF合并、严重IRQ延迟、其它模式／长稳、多参数／Request API与硬件IPA未验收；广角没有独立订阅本轮SOF事件。ready_for_automatic_exposure=false，完整统计与画质仍未验收。
- 最终camera／lens／CCI／CAMSS suspended，九rails与共享IO关闭、MCLK／CCI clocks0，fault0／taint0／pstore空，无CCI错误。SSC／桌面／SensorProxy默认成功，Wi-Fi／HCI和modem／adsp／slpi正常。checked_runtime_healthy=true限定所列检查；旧SSC EPERM根因、GPU默认故障、旧modem watchdog及整机长稳未结案，whole_system_healthy=false。物理旋转／本启动AF未重测。

## 源码回退与下一步

维护树 `/home/cy122/x2pro-linux/camera279-isp-kernel` 干净samurai-sof297／ab709d9670f6dcaa71858fd4f3e189522f669913，本轮1本地提交未推送、未证明上游接受。完整构建138.08秒，五阶段诊断0，40CAMSS组件Werror、778模块及3嵌入BT模块一致。config SHA 82c5ab39f5749693c8e94b7bec7266a9d02a255212af86093e40dfe2e9a101da；input-initramfs297／modules297，输出/mnt/samurai-full282/build，先用284/storage.py核backing并挂载。296六产物保存在私人kernel297/completed-boot296。

固定四份Titan17x BLS12来源并交叉生成头：0x6b0配置、0x6b4／0x6b8阈值、lens enable bit11、14位offset、17位scale寄存器／Q11小数；[来源与数值](reference/kernel297/blc-protocol-validation.json)。尚未实现BLS或完成本机黑电平标定，不把其它手机参数或单场景截距当校准。下一步对应位深／模式的BLC与偏色验证，再接libcamera硬件pipeline／IPA；主／前摄硬件路径、AF Continuous／距离映射、Shine OV02A1B、GUI录像与长稳继续开放。

项目仍7.3rc6派生，54本地提交／177改动文件，libcamera配方28补丁含发行版既有、PipeWire6项目补丁，三个ignore_unused仍在；跨新内核／完整rootfs／上游接受未证明，不能承诺更新零或最小补丁。[更新审计](reference/kernel297/layering-validation.json)

稳定回退仍#290 logdump SHA0f169a331d1c4aac98cd67f636c9f30dd0c727ffc20a6031e4de142d7f57396a及原778模块；296／295／294／293／292／288等独立树、k132776及248整机备份保留，未回退往返。本轮一次启动切换，仅刷logdump；构建与所有采集已终态，勿盲目重放。私人目录E:/edk2-samurai-out/kernel297；像素、参考载荷、校准与密钥不公开。[边界](WORKING-BOUNDARIES.md)
