# Realme X2 Pro 当前检查点

2026-10-19：[290 原厂协议、FULL路径修复与完整部署](reference/kernel290/README.md)。完整多摄及骁龙ISP目标active，画质、统计/IPA及实体硬件ISP仍未完成。

## 当前部署与启动身份

现机 **#290**、`7.3.0-rc6-rmx1931-samurai-k290+`，源码15c8639d8badf5d4146bfd1b2c2fcb2460a137e5／samurai-full-route290；完整Image及独立release的778模块已部署并读回验证。boot276、DT、961包、libcamera r24/config-r19、PW/SPA/Gst1.6.9-r3和50相机载荷保持。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

Image SHA 132012f2e0b2c1191a959098ceae8bb026316001fce4985e196fb2ef50bd6d5f；logdump 0f169a331d1c4aac98cd67f636c9f30dd0c727ffc20a6031e4de142d7f57396a；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

运输用reference/kernel290/host.py，严格原SSH密钥、新USB端点和 `/var/lib/samurai/k290-work/boot-id-private.txt`；旧288 guard不再使用。按driver/实体发现设备：本轮main8-0010/lens8-0072、tele6-002d、wide9-0010、front7-0010。Phoc3717/Phosh3937/PW5294/WP5304；start_ticks见[最终健康](reference/kernel290/final-health-validation.json)及手机k290-services-verified-private.json。续作核实际身份，不重放已执行部署/构建/采集脚本。

## 已验证与当前缺陷

- 原厂HAL与固定CamX参考共同确认VFE175 0x4c bit4为FULL后处理路径门控。原来缺此位使10-bit数值取低8位；临时有界对照证明补齐后128/256/512/1023准确变为32/64/128/255，输出clamp生效，无需猜改CST字段、矩阵或packer。[协议](reference/kernel290/full-route-contract-validation.json)
- 公共SoC后端生命周期已实现门控，连同289的TPG内部D-PHY历史隔离及Gamma SRAM时钟修复部署。仅SoC驱动修复，无机型判断、DT/用户态变化。checkpatch0错误0警告，实际函数ASan/UBSan及完整Image/778ko构建通过。
- #290四摄18段235帧、主摄SIGINT退出及重开全部通过，仍RAW＋CPU SoftwareIsp。最后主摄C-PHY后直接标准MC/V4L2内部TPG→CSID175 IPP→VFE175 FULL NV12取得3帧320×240，无用户态MMIO或D-PHY历史绕行。像素与先前临时正确路径逐字相同，黑白Y0/255、U/V128，绿/品红响应通过。[标准采集](reference/kernel290/standard-tpg-validation.json)、[像素](reference/kernel290/standard-tpg-pixel-validation.json)
- 该TPG的R=B，不能独立证明红蓝顺序；实体sensor硬件PIX、真实统计/参数及libcamera硬件pipeline/IPA仍待接通。前摄/广角/长焦日志实际回退uncalibrated.yaml；主摄专用配置不是完整原厂调校。[实际用户态路径](reference/kernel290/regression-path-validation.json)、[原厂资料边界](reference/kernel276/OEM-TUNING.md)
- 首次新启动检查服务尚未就绪，后续自然启动，无手动重启或改配置；失败及诊断保留。最终五sensor/lens/双CCI/CAMSS suspended、九rails及共享I/O OFF/users0、MCLK/CCI clocks0、fault0/taint0/pstore空，三DSP/SensorProxy及桌面正常。历史GPU默认故障/CPU回退与modem watchdog不因此结案。
- 278标准单次Auto AF及AE下AF证据保留，#290尚未重测AF搜索、实景、旋转、GUI或录像。AF约9–12秒待加速，Continuous/距离标定、Shine OV02A1B与完整画质仍开放。

## 源码回退与下一步

维护树 `/home/cy122/x2pro-linux/camera279-isp-kernel`，samurai-full-route290／15c8639d8badf5d4146bfd1b2c2fcb2460a137e5；父ff8d2e9fc及288部署8c79b7e保留，本地提交未推送，内核树内不等于上游接受。完整构建147.27秒/增量诊断0，39个CAMSS组件Werror；只改LOCALVERSION/INITRAMFS_SOURCE，BT嵌入模块与实际安装新release匹配。

构建输出/mnt/samurai-full282/build；先用284/storage.py核E盘backing并挂载，不往空挂载点写。config SHA9c1b4f24d42519af211b81fc015c948239ea6cfc1550d197469b07c779053581，input-initramfs290和modules290。旧289六项产物在私人kernel290/completed-boot289，旧288在kernel289/completed-boot288。

下一步用可区分R/B的标准RAW图案补色序验证，再将普通Bayer广角实体sensor接入硬件FULL；使用标准选择/格式/控制接口，保存恢复图、模式、选择和controls。之后补真实统计/参数、帧级对应及libcamera pipeline/IPA，按模组版本解析原厂配置/EEPROM并实测标定。实验MMIO工具仅诊断，不作为应用生产接口。

仍有clk/pd/regulator_ignore_unused和下游内核/关键包补丁，不能承诺无补丁升级。目标是通用功能进入上游，设备差异留标准DT、固件和调校数据包；完整rootfs重建、关键栈跨版本及整机冷启/PM/长稳验收仍待做。

首选即时回退为保留的288 logdump镜像，SHA8ec8b1e4d28ed76906ac9c9d31d8d791cab9d190c28d7f27224f8fb47e4aa56c及原288独立778模块；boot276不变，旧k132的776模块/183 logdump及整机248备份保持。未做回退往返。私人资料E:/edk2-samurai-out/kernel290；不公开像素、校准、密钥。[操作边界](WORKING-BOUNDARIES.md)、[硬件清单](linux-port/docs/HARDWARE-STATUS.md)
