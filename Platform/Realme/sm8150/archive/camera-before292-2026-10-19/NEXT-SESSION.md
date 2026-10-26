# Realme X2 Pro 当前检查点

2026-10-19：[291 两颗实体sensor硬件FULL及RAW色彩对照](reference/kernel291/README.md)、[290完整部署](reference/kernel290/README.md)。完整多摄及骁龙ISP目标active，画质、统计/IPA及实体硬件ISP仍未完成。

## 当前部署与启动身份

现机 **#290**、`7.3.0-rc6-rmx1931-samurai-k290+`，源码15c8639d8badf5d4146bfd1b2c2fcb2460a137e5／samurai-full-route290；完整Image及独立release的778模块已部署并读回验证。boot276、DT、961包、libcamera r24/config-r19、PW/SPA/Gst1.6.9-r3和50相机载荷保持。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

Image SHA 132012f2e0b2c1191a959098ceae8bb026316001fce4985e196fb2ef50bd6d5f；logdump 0f169a331d1c4aac98cd67f636c9f30dd0c727ffc20a6031e4de142d7f57396a；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

运输用reference/kernel291/host.py委托290严格原SSH密钥、新USB端点和 `/var/lib/samurai/k290-work/boot-id-private.txt`；旧288 guard不再使用。按driver/实体发现设备：本轮main8-0010/lens8-0072、tele6-002d、wide9-0010、front7-0010。Phoc3717/Phosh3937/PW5294/WP5304；start_ticks见[最终健康](reference/kernel291/final-health-validation.json)及手机k291-services-verified-private.json。续作核实际身份，不重放已执行部署/构建/采集脚本。

## 已验证与当前缺陷

- 290的FULL路径门控、Gamma时钟及TPG历史隔离修复已部署；标准内部TPG三帧、黑白Y0/255与UV128通过，无用户态MMIO或D-PHY历史绕行。
- 291首次实体sensor→真实CSI→CSID175 IPP→VFE175 FULL NV12验证：IMX319 RGGB 1632×1224及S5K3M5 GRBG 2104×1560各做sensor图案RDI/PIX对照，每组18帧。独立R/B及601 full-range色块误差均小于1.235，长焦包含完整八色。输出320×240；静态垂直图案不证明完整几何/缩放质量或实际画质。[广角](reference/kernel291/physical-pixel-validation.json)、[长焦](reference/kernel291/tele-pixel-validation.json)
- 广角图案关闭的低→高→返回曝光，各取NV12及RDI18帧；NV12近均匀Y71，RAW均值仅约64.049/64.177/64.047，均无像素超过100。实景输入已接近黑电平，不能称光学验收或判定FULL丢细节；尚无BLC。已询问后摄正常照明/无遮挡，不以回复阻断其它适配。
- 六组共108帧均通过运输/清理，所有图/格式/选择/控件读回恢复。随后四摄18段229帧含SIGINT/重开通过，仍普通RAW＋CPU ISP。前摄/广角/长焦回退uncalibrated.yaml，主摄专用配置不等于原厂画质。[回归](reference/kernel291/four-camera-regression-validation.json)
- [291最终健康](reference/kernel291/final-health-validation.json)：778模块/50载荷/961包保持，旧288778及k132776项保存；相机/CCI/CAMSS suspended，九rails/共享IO OFF、MCLK/CCI clocks0，fault0/taint0/pstore空，原桌面/三DSP/SensorProxy正常。物理旋转、#290单次AF搜索/GUI录像未重测；历史GPU默认故障/CPU回退、modem watchdog及整机长稳开放。
- 278标准Auto AF/AE AF证据保留，9–12秒待加速，Continuous/距离标定、Shine OV02A1B与完整画质未完成。长焦RAW工具INPUT输出标签漏改，实际FORMAT/解包为2104×1560/stride2640；保留原哈希/日志。

## 源码回退与下一步

维护树 `/home/cy122/x2pro-linux/camera279-isp-kernel`，samurai-full-route290／15c8639d8badf5d4146bfd1b2c2fcb2460a137e5；父ff8d2e9fc及288部署8c79b7e保留，本地提交未推送，内核树内不等于上游接受。完整构建147.27秒/增量诊断0，39个CAMSS组件Werror；只改LOCALVERSION/INITRAMFS_SOURCE，BT嵌入模块与实际安装新release匹配。

构建输出/mnt/samurai-full282/build；先用284/storage.py核E盘backing并挂载，不往空挂载点写。config SHA9c1b4f24d42519af211b81fc015c948239ea6cfc1550d197469b07c779053581，input-initramfs290和modules290。旧289六项产物在私人kernel290/completed-boot289，旧288在kernel289/completed-boot288。

下一步推进真实参数/统计节点和帧级对应、libcamera硬件pipeline/IPA。175已有WB内部回调但仅支持零offset，尚无可用的实际参数/统计节点；优先沿公共typed params能力注册、做标准WB硬件对照，再按原厂协议接统计与黑电平模块。设备差异进入模组数据包，不把单场景64硬编码进SoC驱动。另补主/前摄硬件路径、正常实景、模组校准/黑电平/画质及GUI录像；实验MMIO仍只用于诊断。

仍有clk/pd/regulator_ignore_unused和下游内核/关键包补丁，不能承诺无补丁升级。目标是通用功能进入上游，设备差异留标准DT、固件和调校数据包；完整rootfs重建、关键栈跨版本及整机冷启/PM/长稳验收仍待做。

首选即时回退为保留的288 logdump镜像，SHA8ec8b1e4d28ed76906ac9c9d31d8d791cab9d190c28d7f27224f8fb47e4aa56c及原288独立778模块；boot276不变，旧k132的776模块/183 logdump及整机248备份保持。未做回退往返。私人资料E:/edk2-samurai-out/kernel290及kernel291；不公开像素、校准、密钥。[操作边界](WORKING-BOUNDARIES.md)、[硬件清单](linux-port/docs/HARDWARE-STATUS.md)
