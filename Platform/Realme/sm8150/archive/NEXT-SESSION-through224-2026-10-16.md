# Realme X2 Pro 当前检查点

2026-10-16，224：完整libcamera r11/config-r6已安装，RAW自动统计/元数据和停止取消修复通过；boot219/e49/fae1保持，全外设goal active。[224记录](reference/kernel224/README.md)、[边界](WORKING-BOUNDARIES.md)、[历史through223](archive/NEXT-SESSION-through223-2026-10-16.md)。

## 当前部署与已验证状态

- 运输reference/kernel224/host.py，严格USB邻居/原公钥；guard /var/lib/samurai/k224-baseline/boot-id-private.txt，与219-runtime/220/221/222/223-baseline同boot。218及219-baseline/before-reboot旧身份不可用。224事务verified、实机任务终态；BT只扫描、不新增振动。
- boot219 156f0370…/DTB a214fd6b…，Image183 bfa72dd9…/logdump183 e73754c7…；本轮未刷/重启。IMX471 e49dab26…/29536B，CAMSS fae1ed40…/777360B文件及loaded-note核对。772ko保持；CCI f9c9272a…/PM8008 d1ff82c0…及其它外设指纹见219。
- libcamera/IPA/tools/gstreamer/v4l2=99990.7.2-r11，config/stack=0.1.0-r6；944包/937无关记录保持、49payload核对。world只更新stack版本，CPU/system heap YAML不变。通用堆root/video0660+uaccess，FastRPC池root0600。WP为手动UID10000；重载须现取argv/env，桌面/PipeWire保持。
- 前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认1928×1088/2304×1728。4608×3456须模块+用户态双实验开关，当前N。真实CROP/FOV/CFA开放；TPG普通Bayer不证明真实Quad颜色。
- 219三模式真实RAW/CPU RGB证据、2MP RAW约57.82fps保持，未验RGB30fps；220逐配置sensorInfo修复行时长。223 CAMSS仅SM8150/VFE170发布FRAME_SYNC，缓冲保存真实SOF号，重排清标签，缺标签buffer error，时间戳仍EOF；libcamera捕获时按采集号快照DelayedControls，统计用副本，IPA仍请求号。
- 224的0015 CPU RAW-only只读/DMA同步原缓冲，无RGB输出，接通软件IPA配置/启动/请求/统计/元数据；非CPU直通RAW旧路径保持。0016 live frame map按所有权各取消一次；0017给未处理用户输出传播捕获取消/错误。r9重复cancel断言、r10 RGB取消状态失败及产物保留，均未部署。
- r11候选128帧、安装后128帧（各64RAW/64RGB，2M/4M×普通/隔离IPA）通过，捕获历史/曝光增益换算<1µs/自动调节验证。候选两IPA和安装后各同Camera五次重配，20完成+20取消，无挂起/断言；测试二进制与断言相同。安装后16MP RAW/RGB各36帧，cam/GStreamer各6帧通过。实验N/WP恢复。
- 关灯暗光证据仍223：4MP RAW/RGB各6帧只RAM统计，RAW62–133/std约2.66/相邻约56.2%变化，两者无全零帧；未验真实颜色/曝光。224元数据测试未保存场景/闪光/外部照明。CPU ISP确实读RAW，客户端不检查像素，两个报告歧义字段已更正、原输出私人保留。
- 224最终：相机/CCI/CAMSS休眠，两前摄电源关/用户0、图案0/参数N；GPS0/Signalsfalse/rate30，watch空闲0workers，chrony Normal；三DSP running、BT关无连接、taint/五fault0、NV源保持。Modem State−1/原因2/Power1；UIM两槽absent/no-atr是221历史结果，不证明未插卡。

## 源码、产物与回退依据

- canonical kernel /home/cy122/pmos-samurai-kernel136/kernel仍216 IMX源cc756279…/对象1388a070…/旧DTB22c1…、CAMSS原82c对应源；25 tracked/11 untracked、16798符号保持。当前IMX源61931497…/e49/a214与223 CAMSS另存，不能刷旧canonical输出。
- 223 CAMSS四源/模块在私人kernel223/sof-candidate-source、qcom-camss-sof223.ko；公共camera/kernel/0005及source-lock.camss锁定。原180源/对象/模式通过JSON清单恢复，不用NTFS仿真模式。224未改内核源锁、模块、Image或DTB。
- 完整r11官方abuild13包/34ARM64 ELF/5IPA匹配保留核心公钥、Qt/Python通过，17补丁/tuning/完整子包保留。SDK /home/cy122/x2pro-linux/libcamera214-root原/work/libcamera2254文件/链接/模式恢复，无before224/r10/r11快照；r9/r10/r11分别保留224-built、224-r10-built、224-r11-built，r8缓存223-built。原IPA214/APK203私钥外置复用，不生成/公开；二次逐字重建未验。
- 当前配方/配置/源锁/部署锁已提升r11/r6，保留fae1。设备224事务k224-r11-package-transaction保存前world/repo/配置；实际r8/r3七包在k223-r8-package-candidates/forward及私人223/camera-forward-repo。签名/payload/降级模拟通过，未完整往返。
- 当前r11→r8仅降级七包、恢复224事务前world/repo并重载WP，保持fae1/e49。更早r7/82c配套回退见through223，不混用。IMX回退k219-timing-baseline/imx471-original.ko d82c941d…；boot回退私人211/boot-partition-k211-sensor-domain.img c3bf043f…，须现取身份并核对。
- 私人kernel224/current-work-private.json，原生归档见224/final-evidence-validation.json；223为281、22271、22137、220146、219512成员。USB严格邻居/64KiB只是截断绕过，根因开放。

## 续作与已知风险

下一步标准曝光/增益独立Auto/Manual、AeEnable优先级、Auto期间忽略手动值、切换冻结、Camera::start控制和真实生效模式元数据；不能只回显请求。RAW自动链已修，物理控制2/1帧延迟未标定。

真实CFA/几何/颜色/方向/曝光/标定/GUI/性能、后置GW1/3M5/IMX319/人像及未知PLDO输入继续，不猜供电。GPU ISP211 CMA/黑帧/unmap349 WARN/taint512开放，149 CCU修复保持。

GNSS仍无fix/正CNR、室内窗边；221GPS强制/GLO-BDS-QZSS-GAL启用及四黑名单0不证明RF，多频GET error57不证明无L5。209缩小UTC误差未改善约6秒报告，勿重复。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。207MCFG173文件/8807671B RAM复制、mdtime/PDC活动无pending通过，mcfg.tmp仍0B；SIM/注册/数据/通话/SMS开放，外发需明确目标。

BT phase5、传感器FastRPC/SSR/首启、Wi-Fi/USB PM、音频长稳/耳机（暂无）、充电保护、指纹/NFC实卡及rootfs132整合按[清单](linux-port/docs/HARDWARE-STATUS.md)继续，全goal active。
