# Realme X2 Pro 当前检查点

2026-10-16，223：CAMSS fae1和libcamera r8/config-r3已配套部署，安装后回归及健康通过；全外设goal active。[223记录](reference/kernel223/README.md)、[边界](WORKING-BOUNDARIES.md)。旧完整交接[through222](archive/NEXT-SESSION-through222-2026-10-16.md)。

## 当前部署与已验证状态

- 运输reference/kernel223/host.py，当前USB邻居/原严格公钥；guard /var/lib/samurai/k223-baseline/boot-id-private.txt，与219-runtime/220/221/222-baseline同boot。218及219-baseline/before-reboot旧身份不可授权切换。223部署state verified，所有实机任务终态；BT只扫描、不新增振动。
- boot219 156f0370…/DTB a214fd6b…，Image183 bfa72dd9…/logdump183 e73754c7…；本轮未刷/重启。IMX471 e49dab26…/29536B，CAMSS fae1ed40…/777360B文件及loaded-note核对。772ko、其他771文件及权限保持；CCI f9c9272a…/PM8008 d1ff82c0…与其它外设指纹见219保持。
- 完整libcamera/IPA/tools/gstreamer/v4l2=99990.7.2-r8，config/stack=0.1.0-r3；944包/937无关记录保持、49payload核对。world仅stack版本更新，产品CPU/system heap YAML不变。通用堆root/video0660+uaccess，DSP池root0600。WP手动UID10000， reload须现取argv/env，桌面/PipeWire身份保持。
- 前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认1928×1088/2304×1728。4608×3456须模块+用户态双实验开关，当前N。COMPOSE已删，真实CROP/FOV/CFA开放。
- 219三模式时序/真实4MP与实验16MP RAW/CPU RGB证据保持；2MP RAW约57.82fps，未验RGB30fps。TPG完整模式仍普通Bayer，不能验真实Quad颜色。220逐配置sensorInfo修复误用行时长，原288帧证据保留。
- 223修复BUF_DONE连续号遗漏丢帧，以及请求号误索引控制历史：CAMSS仅SM8150/VFE170发布FRAME_SYNC，缓冲保存SOF号；重排清标签，缺标签buffer error，完成时间戳仍EOF。libcamera在捕获回调按采集号快照DelayedControls，统计只用该副本；IPA仍请求号，无frameStart保留旧路径。
- 临时原r7+新驱动64帧、新驱动+r8 96帧，160缓冲均对应独立SOF事件，无缺标签；r8普通/隔离IPA候选64+安装后64 RGB帧均核对历史索引/增益/曝光换算<1µs。实验16MP另36帧、默认cam/GStreamer各6帧通过，实验开关/WP已恢复。标准手动API未加入，光学延迟未校准。
- 关灯4MP RAW/RGB各6帧只在RAM统计：RAW62–133，std约2.66，相邻约56.2%像素变化；两者无全零帧。支持暗光噪声输出，不验颜色/曝光质量。没有存图、闪光或外部照明。首个安装后检查误判/run探针为候选库，16帧本身正常；原报告保留，改库映射过滤后新目录回归通过。
- k223-final-health：相机/CCI/CAMSS休眠，两前摄电源关闭/用户0，图案0/参数N；GPS0/Signalsfalse/rate30，watch空闲0workers，chrony Normal；三DSP running、BT关无连接、taint/五fault0、NV源保持。Modem State−1/原因2/Power1；UIM两槽no-atr/absent是221历史只读结果，不证明未插卡。

## 源码、产物与回退依据

- canonical kernel /home/cy122/pmos-samurai-kernel136/kernel仍216 IMX源cc756279…/对象1388a070…/旧DTB22c1…，CAMSS仍原82c对应源；25 tracked/11 untracked保持。当前219实际IMX源61931497…/e49/a214与223 CAMSS候选源另存，不能刷旧canonical输出。
- 223源码/模块私人kernel223/sof-candidate-source、qcom-camss-sof223.ko，公共linux-port/camera/kernel/0005-camss-sm8150-paired-sof.patch及source-lock.camss锁基线/四文件/模块。W1/checkpatch0、符号/vermagic/intree通过；构建前显式JSON模式清单核对180原源/对象/模式已恢复，不用NTFS仿真权限。
- r8官方abuild完整13包/34ARM64 ELF/5IPA匹配核心公钥、Qt/Python入口通过；原13补丁/tuning/全子包保持，新0014捕获快照。SDK /home/cy122/x2pro-linux/libcamera214-root原/work/libcamera2254文件/链接/权限已恢复，无待恢复快照；候选/work/libcamera223-built，r7缓存220-built保留。原IPA214/APK203私钥外置复用，不生成/上传；二次逐字重建未验。
- 产品配方/配置/源码锁/部署锁已更新r8/r3+fae1。设备原82c回退/世界/仓库/配置在k223-r8-paired-deployment，实际七个r7/r2包在k220-r7-package-candidates/forward及私人220/camera-forward-repo，签名/payload/降级模拟通过，未完整回退往返。更早r6/r1在219，分开保留。
- 同boot现取身份/空闲后，停止WP、正常解绑/卸载CAMSS、APK七包降级（恢复原world/repo）、恢复82c/depmod/加载、恢复图/格式、按现取上下文重启WP；不要只回退其中一边。IMX回退设备k219-timing-baseline/imx471-original.ko d82c941d…；boot回退私人211/boot-partition-k211-sensor-domain.img c3bf043f…，各自核对。
- 私人capsule kernel223/current-work-private.json。222私人71、22137、220146、219512成员归档保持；223本轮归档另见final-evidence-validation.json。USB严格邻居/原密钥/64KiB仅绕过截断，根因未修。

## 续作与已知风险

下一步标准曝光/增益独立Auto/Manual、AeEnable优先级、Auto期间忽略手动值、切换冻结、Camera::start控制及真实生效模式元数据；不要只回显请求。RAW-only目前绕过SWISP配置/统计，须实现真实控制/元数据链，不能仅验RGB。控制物理2/1帧延迟尚未校准。

真实CFA/几何/颜色/方向/曝光/标定/GUI/性能、后置GW1/3M5/IMX319/人像及未知PLDO输入继续；不猜供电。GPU ISP211 CMA/黑帧/unmap349 WARN/taint512开放，149 CCU修复保持。

GNSS仍无fix/正CNR，手机室内窗边；221GPS强制/GLO-BDS-QZSS-GAL启用与四黑名单0不证明RF，多频GET error57不证明无L5。209小UTC误差未改善约6秒报告，勿重复。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。207MCFG173文件/8807671B RAM复制、mdtime/PDC活动无pending通过，mcfg.tmp仍0B；实际SIM/注册/数据/通话/SMS开放，外发需明确目标。

BT phase5、传感器FastRPC/SSR/首启失败、Wi-Fi/USB PM、音频长稳/耳机（暂无）、充电保护、指纹/NFC实卡和rootfs132整合按[清单](linux-port/docs/HARDWARE-STATUS.md)继续；全goal保持active。
