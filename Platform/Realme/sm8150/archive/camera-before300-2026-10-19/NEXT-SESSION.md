# Realme X2 Pro 当前检查点

2026-10-19：[299原厂BLS、EEPROM与在线候选](reference/kernel299/README.md)。实际内核仍#298，产品仍RAW＋CPU ISP。原厂BLS与本机EEPROM双读已取得证据；正式校准、硬件pipeline／IPA与完整IQ未完成。

## 当前部署与启动身份

现机 **#298**、`7.3.0-rc6-rmx1931-samurai-k298+`，干净samurai-blc298／c5e118faec21a6c4bd2e7d5b86b3b21ad9dc2117。完整Image和独立778模块已部署读回，加载build-id匹配。boot276、DTB、原厂固件、961包／50相机载荷保持，libcamera r24／config-r19、PW／SPA／Gst1.6.9-r3保持。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

Image SHA eb8054e69991528cad4f126d7723b7ef4869b288fb85c992f4803cbfeab5ddaf；logdump dfef7be4f358c5c16e8e716a60c24da8a139de73b1e07912d70f2b58613d80df；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

当前运输reference/kernel298/host.py与 `/var/lib/samurai/k298-work/boot-id-private.txt`，严格原SSH密钥、新端点。按entity发现：main8-0010／lens8-0072、tele6-002d、wide9-0010、front7-0010。Phoc3789／Phosh4029／PW5436／WP5438，start_ticks见[最终检查](reference/kernel299/final-health-validation.json)。旧297 guard不用于本启动。

## 已验证与当前缺陷

- SoC两个文件55增／2删：复用公共WB相等减偏移U16→U14 BLS，Q11 scale保持unity；拒绝不等减偏移和非零加偏移，旁路缓存／恢复、停流、重开默认0。无新UAPI／DT／固件／产品包补丁。[协议](reference/kernel298/blc-protocol-validation.json)、[补丁](reference/kernel298/blc-candidate.patch)
- 长焦126图像／111统计／128SOF；11阶段减黑／WB对照独立RDI RAW最大通道误差<1.337，六次可观察图像变化与参数首个生效帧完全对应。110组共享SOF配对、5次ROI对应、断粮恢复保留7帧间隔，晚启首包SOF19／人口2。单参数／特定模式验证不等于完整IPA验收。
- 广角18帧RAW曝光500→3000→500／2×gain，六倍曝光场景拟合R／Gr／Gb／B截距中位数64 DN；不是遮光标定。临时灰世界R2.22／B1.90未安装为调校。另126硬件图像／111统计：只减黑Y98.199→65.927，联合WB后76.229，4×模拟增益后106.833；减黑后G相对R/B比1.493→1.019，4×时1.014。实际查看前后私人预览，暗绿改善但非色彩准确度证明。[实景](reference/kernel298/scene-analysis-validation.json)
- 两硬件探针合计252图像／222统计，独立RAW18帧；四摄产品回归18段233帧，含主摄SIGINT29后重开12。结束资源全部回收，fault0／taint0／pstore0，无CCI错误；SSC／桌面／SensorProxy默认成功，Wi-Fi／HCI与三个DSP正常。
- 用户选择正常场景、暂不遮光，不能把实景截距当暗场标定；没有安装临时场景系数。严重IRQ延迟／多丢失SOF／多参数、其它模式、主／前摄硬件路径和完整画质仍开放，statistics_ready_for_automatic_exposure=false。GPU默认故障、旧modem watchdog、SSC偶发EPERM根因与长稳未关闭，whole_system_healthy=false。GUI录像／物理旋转／本启动AF未重测。

## 源码回退与下一步

完整构建158.45秒，五阶段诊断0、40CAMSS组件Werror、778模块与3嵌入BT模块一致。config SHA b103243f1545f053913fc040cc77815729132fce6ccec1250e2d9918395f2715；input-initramfs298／modules298，输出/mnt/samurai-full282/build，先用284/storage.py核backing并挂载，保持Rust工具环境。297六产物保存在私人kernel298/completed-boot297。

299：原厂Sunny IMX319全部16个IFE BLS模式／288区域均960 U14、阈值0，独立原厂解析器与直接解码一致；归一化减偏移3840、显式2175/2048范围伸展已做长焦54帧图案及广角54帧实景对照，WB仍临时场景估计。线性BHIST观测为BLS后／WB前，不能替代RGB AWB。EEPROM两次各12287字节相同并传回私人根；完整布局／原厂校验未通过，未应用个体数值，未写EEPROM。用户暂不遮光。

真实r24 libipa编码器通过；新增在线libcamera handler候选在SDK/work/libcamera299-inline，独立构建／显式启用，未替换产品库。保留原始kernel sequence避免各队列独立归零错配，处理请求／三队列／超时／停流重开；目前仅手动单NV12路径，IPA IPC与自动算法未接。[候选构建](reference/kernel299/inline-build-validation.json)与IMX319三轮各24帧通过，72图像／统计／SOF及参数回执独立核对，重开不重新配置；[关联证据](reference/kernel299/inline-request-association-validation.json)。R1选错ID、R2固定1秒采样CCI尚活跃均保留；R3轮询1305ms自然休眠，未强制挂起。接下来补晚启动统计、取消／丢失SOF及逐请求参数验收，再接IPA、sensor helper／DelayedControls、实测延迟与有效颜色统计，继续多摄、多模式、AE／AWB及EEPROM校验。原厂参考配置不当SensorBlackLevels或暗场标定。

维护树 `/home/cy122/x2pro-linux/camera279-isp-kernel`：7.3rc6派生55本地提交／177改动文件；libcamera配方28补丁含发行版既有，PW6项目补丁，三个ignore_unused仍在。未推送或证明上游接受／跨新版本迁移；不能承诺零或最小升级补丁。[更新审计](reference/kernel298/layering-validation.json)

稳定回退仍#290 logdump SHA0f169a331d1c4aac98cd67f636c9f30dd0c727ffc20a6031e4de142d7f57396a及独立778模块。297／296／295等旧树、k132776和248备份保留。一次启动切换，仅刷logdump；首次尺寸预检拦下脚本数值替换错误，修正并重新核对后才写，未重复重启／刷写。[保留过程](reference/kernel298/preparation-notes.json)

本轮构建／采集均终态且worker／fixture均无匹配活进程；新动作前核当前身份，已执行采集勿盲目重放。私人根E:/edk2-samurai-out/kernel299（298保留），像素／个体校准／密钥不公开。[边界](WORKING-BOUNDARIES.md)
