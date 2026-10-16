# Realme X2 Pro 当前检查点

2026-10-16，阶段216：前摄模拟增益码上限按本机原厂从800补至960（名义16倍），RAW噪声响应/回低增益与默认客户端通过；215测试图修复保持。关灯、同一启动、未刷机/重启。完整外设goal active。[216报告](reference/kernel216/README.md)、[214相机包](reference/kernel214/README.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前运输reference/kernel216/host.py，guard为/var/lib/samurai/k216-baseline/boot-id-private.txt。最终3DSP running，相机休眠/供电时钟释放、taint/五fault0；GPS0/Signalsfalse/rate30、BT关闭无连接。216驱动r2 marker verified；215首次卸载失败无驱动变化的记录保留，旧动作不重放。
- boot211 c3bf043f…/DTB6f9f5b0f…，Image183 bfa72dd9…/logdump183 e73754c7…保持。IMX471当前1388a070…（215旧6b2bb0b4…）、CCI f9c9272a…/PM8008 d1ff82c0…/CAMSS82cbc052…/BT185保持，模块树772ko/786文件。TFTP207 b3bb82b9…/wifi854c9a8c…/MCFG helperd4c62be6…/MM191/helper421/init54/SSC9a1保持。
- 前摄静态CCI1 master1/0x10、MCLK2 19.2MHz、4lane/200MHz、CSIPHY2；独立TITAN_TOP域、裁剪和PM修复保持。PM8008源码&i2c4为0x890000、运行i2c-1，不能混淆总线编号。
- libcamera/IPA/tools为99990.7.2-r5，另装gstreamer/v4l2同r5及samurai-camera-config/stack0.1.0-r0，共944包；937个无关包记录保持，49条payload核对通过。完整auto/virtual与11子包都已构建，未把213三pipeline候选当完整包。5IPA内嵌公钥签名、全部13包签名/架构通过；未验证逐字重复构建。
- CPU配置已由配置包接管，/etc/libcamera目录0755/文件0644；两个heap模块自动加载，通用堆root/video0660+uaccess，FastRPC专用池root0600拒绝。WirePlumber已优雅重载新库，PipeWire/桌面身份保持。
- 214安装后暗场RAW六帧均值63.9844～63.9881、标准差0.4411～0.4423，相邻帧33.03%～33.14%变化；DMA同步、排除填充。数字白RAW六帧每像素1023，RGB从首帧起每字节254；真实暗场RGB黑位校正后可全0，不直接判bug。默认cam/GStreamer接口各6帧无错误；手机无gst CLI工具，使用有限标准API客户端。

## 源码、产物与回退依据

- kernel为/home/cy122/pmos-samurai-kernel136/kernel；215/216只在211基础上修IMX471图案位宽并将增益上限800→960，其余保存源码保持，25 tracked/11 untracked未暂存。配置fbde3690…、16798符号/order772、Image183及旧canonical DTB22c1…保持，旧canonical不能刷作当前树。[源码核对](reference/kernel216/source-final-validation.json)。
- 完整配方linux-port/packages/libcamera，配置配方相邻samurai-camera-config；linux-port/camera/deployment-lock.json记录13产物，三补丁canonical在camera/libcamera。外部IPA保留私钥和203 APK签名输入只在私人构建目录；源码/包不含私钥。新rootfs尚未生成，kernel/radio/Mesa整合债仍开放。
- 私人kernel214/camera-forward-repo保留完整13包，camera-selected-repo为实机7包；rollback-snapshot-apks的3个r4包来自实际已安装备份并由现有项目密钥签名，非原发行版签名。宿主实际940记录升级/回退通过，当前手机仅模拟回退，没有真实回退。手机原48记录在k214-baseline，事务备份在k214-package-transaction。[回退说明](reference/kernel214/README.md)。
- 回退需新鲜核对空闲状态：删stack移除4新包，用仅指向rollback/packages.adb的临时repo明确安装3个r4，再恢复原3配置/world、移除本轮repo并重载WP；不能混留r5数据库。boot回退仍私人210/boot-partition-k210-front.img，89242ade…，与相机包回退分开核验。
- sensor模块回退为k216-baseline/imx471-original.ko及r2/before-tree（215旧6b2bb0b4…），已导出；正常解绑传感器才能释放引用再卸载，不强卸。当前源码cc756279…、module1388a070…，boot211/Image183保持。
- 私人213归档227成员已补全；214原生归档167成员、215原模块/元数据99成员及216的86成员已核对。USB邻居重新发现恢复同地址连接、64KiB传输成功仅为恢复手段，213截断/超时根因未证明。历史失败保持，不重放旧动作。

## 续作与已知风险

用户关灯、室内窗边；保持无闪光灯/外部光源。RAW用DMA READ START/END、去stride填充、分通道直方图/方差/帧间变化判断；不能仅凭RGB全0判bug。215已将0600改CCI_REG16，与原厂0601低字节记录及同款传感器补丁一致；内部图案6帧RAW仅0/1023两级，RGB首帧非黑，关闭后恢复暗噪声。可用sensor或已确认的CSID作正对照，均须恢复控制/link。

216已核对原厂上限16倍/960；0/800/960/0的RAW噪声依次约0.47/0.95/2.35/0.44，非光照灵敏度标定，首帧延迟仍待定。配置前cam只列Contrast/Gamma，标准手动增益API未验收。前摄仍仅1928×1088，继续完整16MP、曝光/延迟/控制API及tuning/方向；AWB先核输入格式，packed10P已用8位，不能盲套unpacked补丁，后置6400万主摄/1300万长焦/800万超广角/200万人像四路逐个接入。未知PLDO输入不能猜。GPU ISP仍有CMA不足/黑帧/IOMMU unmap349 WARN/taint512的211证据；CPU通过不能替它验收，也不影响149已修CCU故障结论。

GNSS真实fix/正CNR未解决，无无遮挡户外或Android基线。209较小UTC误差未改善约6秒报告，候选未部署；208 ADC变化不能证明RF正常，勿重复同一UTC实验。[相关realme/OPPO/一加机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。UTC第8次准备成功和chrony Normal不等于定位成功。

207原厂MCFG173文件8,807,671B自动RAM复制/mdtime可读，PDC1平台/25软件活动无pending，mcfg.tmp仍0B；真实SIM注册/数据/通话/SMS/UIM未验。完整目标还包括BT phase5、传感器FastRPC共享池/SSR和SSC首次204退出、Wi-Fi第2轮PM35秒未关联/USB稳定性、音频长稳和耳机（用户暂无）、充电控制保护闭环、指纹/NFC真实读卡等。[完整清单](linux-port/docs/HARDWARE-STATUS.md)。
