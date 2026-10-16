# Realme X2 Pro 当前检查点

2026-10-16，阶段219：boot219/时序模块与完整r6/config-r1已部署；真实4MP/实验16MP RAW及CPU RGB、默认系统库cam/GStreamer的4MP取流通过。全外设goal active。[219报告](reference/kernel219/README.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 运输reference/kernel219/host.py，新启动guard /var/lib/samurai/k219-runtime/boot-id-private.txt。218及219-baseline/before-reboot属于旧启动，不可授权新切换。219刷写/重启marker closed，时序模块verified；所有完整模式试验已finish，当前N/WirePlumber恢复。BT只扫描，不新增振动。
- boot219 156f0370…/DTB a214fd6b…，仅前摄endpoint增加400/748.8MHz、200保留；Image183 bfa72dd9…/logdump183 e73754c7…保持，persist/NV不变。当前IMX471 e49dab26…；CCI f9c9272a…/PM8008 d1ff82c0…/CAMSS82cbc052…/BT185保持。772ko/786文件，其余771ko不变。
- TFTP207 b3bb82b9…/wifi854c9a8c…/MCFG helperd4c62be6…/MM191 b350c55b…/GNSS42168f33…/init54b81745…/SSC9a1fd03f…保持。新boot早期就绪延迟后原服务自动启动，未手动restart，不称SSC修复。
- 前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认1928×1088与2304×1728，4608×3456需模块参数及用户态实验配置，当前均默认关闭。删除错误COMPOSE，CROP/FOV/标准CFA语义仍开放。
- libcamera/IPA/tools/gstreamer/v4l2为99990.7.2-r6，config/stack0.1.0-r1，944包、937无关记录保持、49条payload核对通过。mode cpu/dma_heap system；通用堆root/video0660，DSP池root0600。WP为手动进程，正常重载仅停WP并现取argv/env/UID10000，桌面/PipeWire身份保持。
- r5的2296×1728 RGB第三缓冲分配失败保留；r6相同尺寸/四缓冲通过。13包签名/34个ARM64 ELF、5IPA与r6核心公钥、Qt/Python入口通过。完整r6库手机50组/780337408像素合成测试通过；隔离与安装r6各八组实机取流、每组六帧通过。默认系统库cam/GStreamer显式4MP各六帧通过，后者只验元数据、不宣称CPU像素同步统计。
- 真实4MP暗RAW噪声约0.47/变化35%，16MP约0.60/变化51%，各六帧有效像素DMA同步统计，无图片保存。处理后暗RGB近黑不单独判bug。完整模式TPG实测仍是普通2×2 Bayer周期，只证明完整传输/分配/非黑输出，不能验收真实Quad颜色；真实滤色阵列/画质仍开放。
- 时序旧行长实读5120、原报2328，三模式阵列速率修为387200000/326400000/578133333，不改PLL。四组120帧约57.82018/30.00030/60.03122/30.01381fps与控件吻合；只读帧元数据，无像素访问。早期错误DMA方法标签已更正，私人原始输出保留。这是RAW速率，不证明CPU RGB实时30fps。
- 最终健康在k219-final-health-r2：三相机设备suspended，两前摄电源disabled/用户0、MCLK/本域票释放、图案0、参数N；三DSP running、GPS0/Signalsfalse/rate30、BT关闭无连接、watch空闲、chrony Normal、taint/五fault0。首轮检查因新r1配置与旧212指纹不同退出，已按签名包归属修正核验，原失败保留，无安装/硬件重放。

## 源码、产物与回退依据

- kernel /home/cy122/pmos-samurai-kernel136/kernel的canonical仍216源cc756279…/对象1388a070…、旧canonical DTB22c1…；原25 tracked/11 untracked保持，不能把旧DTB当当前部署树刷写。实际219源私人timing-source/imx471.c 61931497…、timing-build模块e49dab26…/DTB a214fd6b…；W=1/增量checkpatch0。linux-port/camera/kernel四补丁链已独立重放为相同源码/板级树。
- 当前时序回退设备k219-timing-baseline/imx471-original.ko d82c941d…与k219-timing-driver-test-r2/before-tree；更早216在k219-baseline。先现取启动身份/确认空闲，正常解绑/卸载/恢复/depmod/加载/策略恢复，不强卸。boot回退私人211/boot-partition-k211-sensor-domain.img c3bf043f…，与模块回退分开核对。
- 完整r6构建session40635已完成，不能重启同一abuild all。chroot /home/cy122/x2pro-linux/libcamera214-root，配方/work/libcamera219与/work/samurai-camera-config219；输出/packages219、/packages-config219及私人kernel219/camera-forward-repo共13包。abuild常规清理r6 src/pkg，旧214/218源码与原产物仍保留；libcamera219-qa-prefix及chroot/candidate219解包前缀保留。
- IPA验证复用保留的上游ipa_verify，已核对它实际加载新r6核心/base并取其公钥。原IPA214和APK203私钥复用，未生成/上传新私钥。canonical配方、配置、源码锁与部署锁现为r6/r1；尚未重复构建证明逐字相同，完整kernel/rootfs整合仍待完成。
- r6事务k219-r6-package-transaction状态verified；旧944包DB/world/repo/config已保存。实际r5回退七包在设备k214-package-candidates/forward，host私人214/camera-forward-repo；七包签名/当前旧payload已验，安装后原生七包降级模拟通过，未执行本轮完整回退往返。勿混用214更早的三个r4快照。
- 本轮私人原生归档成员逐一核对通过，见219归档收据；源脚本/原失败与本轮新健康均保留。USB严格新邻居/原密钥/64KiB分块有效，原大传输截断根因仍未修。当前capsule私人kernel219/current-work-private.json；所有过渡marker终态后再执行新切换。

## 续作与已知风险

用户关灯、室内窗边，无闪光灯/外部光源，场景/坐标不公开。前摄标准CFA/几何、真实颜色/曝光/API/延迟/方向/标定/GUI与实际RGB性能继续；后置GW1/3M5/IMX319/人像四路未接入，未知PLDO输入不得猜。211 GPU ISP CMA不足/黑帧/IOMMU unmap349 WARN/taint512仍开放，CPU通过不代替GPU，149 CCU修复结论保持。

GNSS真实fix/正CNR未解决，无无遮挡户外或Android基线；209小UTC误差未改善约6秒报告，208 ADC不证明RF正常。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。207 MCFG173文件/8807671B自动RAM复制、mdtime/PDC活动无pending通过，mcfg.tmp仍0B；真实SIM注册/数据/通话/SMS/UIM开放，通话发信需用户明确目标。

BT phase5、传感器FastRPC reclaim/SSR与首次启动失败、Wi-Fi/USB PM、音频长稳/耳机（暂无）、充电保护闭环、指纹/NFC与旧rootfs132软件整合按[硬件清单](linux-port/docs/HARDWARE-STATUS.md)推进。不要因相机局部进展完成/暂停全外设goal。
