# Realme X2 Pro 当前检查点

2026-10-16，220：保持boot219/e49模块，完整libcamera r7/config-r2已部署；修复2MP曝光元数据错用4MP行时长，288帧及独立IPA进程通过，GStreamer六帧通过。全外设goal active。[220记录](reference/kernel220/README.md)、[219像素验收](reference/kernel219/README.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 运输reference/kernel220/host.py；新邻居/原严格公钥认证，当前guard /var/lib/samurai/k220-baseline/boot-id-private.txt。与219-runtime同一启动；218及219-baseline/before-reboot属于旧启动，不能授权新切换。220所有试验终态，参数N/WirePlumber恢复；无重启/刷写。219切换marker closed，220包事务verified。BT只扫描、不新增振动。
- boot219 156f0370…/DTB a214fd6b…，前摄200/400/748.8MHz；Image183 bfa72dd9…/logdump183 e73754c7…保持，persist/NV保持。当前IMX471 e49dab26…，CCI f9c9272a…/PM8008 d1ff82c0…/CAMSS82cbc052…/BT185等保持，772ko/786文件。TFTP207/MCFG、MM191/GNSS/SSC、Wi-Fi指纹见219，均无本轮改动。
- 前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP。默认1928×1088和2304×1728；完整4608×3456需模块及用户态两个实验开关，当前默认关。错误COMPOSE已删除，真实CROP/FOV/CFA语义仍开放。
- libcamera/IPA/tools/gstreamer/v4l2为99990.7.2-r7，config/stack0.1.0-r2，944包/937无关记录保持，49条payload核对。mode cpu/dma_heap system，配置payload与r1相同；通用堆root/video0660、DSP池root0600。WP为手动进程；重载仅停WP并现取argv/env/UID10000，桌面/PipeWire身份保持。
- 219已证明4MP/实验16MP真实RAW与CPU RGB各六帧，暗RAW噪声约0.47/0.60、变化35%/51%，全有效像素DMA同步、无图片保存。r5第三个4MP RGB缓冲分配失败，r6起同尺寸四缓冲system heap通过。完整TPG仍普通Bayer周期，只验传输/非黑输出，不代表Quad真实颜色；暗RGB近黑不能单独判bug。
- 驱动时序已修：旧行长实读5120，三模式阵列速率387200000/326400000/578133333，不改PLL；各120帧RAW速率约57.82018/30.00030/60.03122/30.01381，与控件吻合，不证明CPU RGB30fps。
- 220发现软件IPA init缓存4MP行时长，2MP1290行元数据报10117µs，应约17057.85µs。新增0013每次configure传当前sensorInfo，已装r7报17057µs；候选3模式+独立IPA2模式+已装3模式共288帧，换算差均<1µs整数化，未宣称物理曝光精度/延迟。标准API仍只证明Contrast/Gamma，手动曝光未接入。
- 13包/34 ARM64 ELF/5IPA公钥、Qt/Python及默认GStreamer六帧通过；cam三模式各36帧，隔离代理另2×36。隔离只用临时配置，产品YAML保持；本轮不改像素算法，算法证据见219。
- 最终健康k220-final-health：相机/CCI/CAMSS suspended，两前摄电源disabled/用户0、MCLK/本域票释放、图案0、参数N；三DSP running、GPS0/Signalsfalse/rate30、BT关无连接、watch空闲、chrony Normal、taint/五fault0，NV/非相机程序保持。

## 源码、产物与回退依据

- kernel /home/cy122/pmos-samurai-kernel136/kernel的canonical仍216源cc756279…/对象1388a070…/旧DTB22c1…，原25 tracked/11 untracked保持；不能把旧DTB当当前部署树刷写。实际219源私人timing-source/imx471.c 61931497…，模块e49dab26…/DTB a214fd6b…；四补丁链已独立重放相同源码/板级树。
- 时序模块回退：设备k219-timing-baseline/imx471-original.ko d82c941d…及k219-timing-driver-test-r2/before-tree；更早216在k219-baseline。先现取身份/确认空闲，正常解绑/卸载/恢复/depmod/加载/策略恢复，不强卸。boot回退私人211/boot-partition-k211-sensor-domain.img c3bf043f…，与模块回退分别核对。
- SDK /home/cy122/x2pro-linux/libcamera214-root。220复用原完整对象缓存，44目标编译+官方abuild rootpkg/index；原214目录2254文件/链接已恢复在/work/libcamera，无待恢复快照。候选完整源/对象保留/work/libcamera220-built，配方/work/libcamera220与/work/samurai-camera-config220；13包在/packages220、/packages-config220和私人kernel220/camera-forward-repo，QA前缀libcamera220-qa-prefix/chroot/candidate220。
- 220两次构建/打包失败及GStreamer前置失败均保留并恢复；全部任务已终态，勿重放。详情见220记录。
- canonical配方/配置/源码锁/部署锁为r7/r2，0013补丁d6aa409f…，原12补丁/tuning/YAML保留。原IPA214与APK203私钥复用，未生成/上传。尚未证明二次构建逐字相同；canonical内核及完整rootfs整合继续。
- 当前事务k220-r7-package-transaction verified，原944包DB/world/repo/config已保存。实际r6/r1回退七包在设备k219-r6-package-candidates/forward及私人219/camera-forward-repo，签名/当前旧payload核对与安装后七包降级模拟通过，未执行完整回退往返。更早r5/r4分别保留，不混用。
- 220原生私人归档146成员逐一核对，219另512成员保持；不公开指纹/密钥/场景/坐标。USB严格新邻居/原密钥/64KiB有效，截断根因仍未修。当前capsule私人kernel220/current-work-private.json，完整旧交接保存在archive/NEXT-SESSION-through219-2026-10-16.md。

## 续作与已知风险

用户关灯、室内窗边；无闪光灯/外部光源。前摄手动曝光API、实际曝光/延迟、真实CFA/几何/颜色/方向/标定/GUI与RGB性能继续；后置GW1/3M5/IMX319/人像四路未接入，未知PLDO输入不猜。211 GPU ISP CMA/黑帧/IOMMU unmap349 WARN/taint512开放，CPU通过不替代GPU，149 CCU修复保持。

GNSS真实fix/正CNR未解决，无无遮挡户外/Android基线；209小UTC误差未改善约6秒报告，208 ADC不证明RF正常。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。207 MCFG173文件/8807671B RAM复制、mdtime/PDC活动无pending通过，mcfg.tmp仍0B；真实SIM/数据/通话/SMS/UIM开放，通话发信需用户明确目标。

BT phase5、传感器FastRPC reclaim/SSR与首次启动失败、Wi-Fi/USB PM、音频长稳/耳机（暂无）、充电保护闭环、指纹/NFC及旧rootfs132软件整合按[硬件清单](linux-port/docs/HARDWARE-STATUS.md)推进。不要因相机局部修复完成/暂停全外设goal。
