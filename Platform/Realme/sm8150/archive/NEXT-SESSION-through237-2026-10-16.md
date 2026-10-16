# Realme X2 Pro 当前检查点

2026-10-16，237：IMX319真实RAW六帧、前摄RAW/RGB各六帧回归通过，CAMSS回收已修；后摄近黑，曝光/光学/RGB/颜色待验。goal active。[237](reference/kernel237/README.md)、[236归档](archive/NEXT-SESSION-through236-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 仍236启动，guard /var/lib/samurai/k236-runtime/boot-id-private.txt，233及更早失效。运输reference/kernel237/host.py、私人237/current-work-private.json为操作指针。无活动手机worker/构建/切换，trace已删；未重启/刷分区。
- boot235 44c6a215…/100663296B、DTB469e1456…、Image183 bfa72dd9…、logdump183 e73754c7…保持。MFD6021a359…/22208B、lab5198e2bd…/17992B、provider2223f337…/9744B、imx319176f68d7…/36624B、前摄e49dab26…/29536B、FastRPC2abde0ea…/50192B、BT185 f6c5ed35…保持，默认/加载note匹配/intreeY。
- CAMSS已由fae1更新为ff9fdfa346249d836…/777680B。新鲜ref0/无相机客户端/五设备休眠后仅卸换CAMSS一次，两sensor及MFD/P/Q/provider保持。当前权威789文件清单为设备k237-camss-install/module-inventory-after-private.json，236清单中的旧CAMSS已过时；775ko/789文件中仅该ko摘要改变。
- 后摄imx319 7-0010现subdev14，前摄imx471 9-0010现subdev15，编号不固定。新probe同时核完整OF camera ID、Model、实体及sysfs对应关系，FrameSuccess、单预期stream/plane、序号/时间戳递增；旧219/233硬编码CCI1探针不可验后摄。
- 后摄1632x1224 RAW10六帧序号0..5、stride2048，每行2040有效字节+8padding，完成间隔32.621–33.445ms/窗口约30.15fps。样本62–78、均值64.2454–64.2656，帧间约32.36–32.59%值变化；不是全零，但接近黑电平64。完成时间不是SOF/曝光起点标定，未确认遮挡或其它原因，不称颜色/光学响应已可用。
- 前摄2304x1728 RAW、2296x1728 CPU RGB各6帧通过。三组均恢复整个媒体图、所有subdev格式、两sensor控制/翻转、sensor及CSID图案0，P/Q rails逐项保持；两sensor/CCI0/CCI1/CAMSS suspended、四相机rails OFF/users0、MCLK1/2关。实验unprocessed_fullres=N，用户延期的前摄纯色参照不再追问。只RAM统计，不存/显示场景/不闪光/不加照明。
- 首wrapper因错误参数名experimental_full_resolution在Popen之前失败，无帧；原源/失败/回收结果保留。r2首launcher又因复用xb日志路径在Popen之前退出，已核r2 context不存在/无worker，再改唯一日志名。实际r2三组各启动一次，无观察超时重放；finally逐步尽力恢复并累计错误，成功组restore_errors空。
- 最终775ko/789文件、944包/用户态/config/分区复核通过，三DSP running、SensorProxy三Has、Wi-Fi/chrony正常，taint及模块taint空、WARN/Oops/GPU/DSP fatal/BT重组0。BT开启/未发现/1连接仅观察，本轮未pair/connect/disconnect；GNSS0/Signalsfalse/rate30、watch空闲/timeprepared/dataworker0，无新搜星/注入或正CNR/fix。MM State−1/原因2/Power1，用户无SIM。

## 源码、产物与回退依据

- reference/kernel237/camss-source保存fae1四个SOF文件+video适配完整源。借鉴Hotdog47087509/0114：开流失败停此前成功下游、排除失败实体/保留原ret；正常stop个别错仍继续；VFE先摘指针/pending再只返ACTIVE且去重，active_num只在VFE170清，不写gen1 union。Linux7.3 prepare/unprepare及alloc_start、SOF/IRQ/clock/板级资源保持。375图启停+8192buffer实际函数ASan/UBSan与4负对照通过，非IRQ/并发或硬件故障注入。
- 树内W=1零诊断/183 ABI/符号/intree通过，canonical仍精确after228、16798符号/772顺序，Image/DTB保持；相机仍旧216/旧CAMSS，不刷旧输出。linux-port完整profile/kernel/rootfs仍开放，235/236冻结源保持。
- 237新探针native-physical-probe.cpp为29783f5b…，89112B二进制13b66342…，-Werror构建通过；显式pattern恢复/readback、stop/release检查、回调异常捕获。DMA_BUF start/end及有效RAW10像素统计保持。源码/产物/测试/原生收据见237，100原生成员已逐一私有校验，无像素或私有归档指纹公开。
- CAMSS旧fae1及元数据备份设备k237-camss-install/before，私人237证据归档含精确副本，新候选camss-build-r1；原fae1冻结源为私人223/kernel-before-paired-sof加sof-candidate-source四覆盖文件。回退需当前身份、停客户/ref0/PM和受控卸换，不直接重放本轮一次性脚本。235-stage/before仍有旧232 MFD+元数据/config，236-lab-fix/before有旧lab。当前lab有消费者，不能再用未绑定/ref0前提热换；不热卸有children的MFD。
- 235 boot私人235/boot-partition-k235-imx319-p-lab.img；232回退45f398f2…、219回退156f0370…继续保留。P仅mask9/L1P1.104V/L4P2.8V，无假VIN，其余五路不注册/写。PMIC父epoch故障、独立P复位隔离及I2C关闭+reset双失败的ref/WARN风险见236归档，隔离不等于寄存器恢复/物理电压实测。不触NV/校准/工厂备份。

## 续作与已知风险

下一步先补IMX319 libcamera helper：已查实际r13无helper/properties，gain code被直接当倍率，2.0只写code2约1x；真实2/4/8x为512/768/896。OEM3332行曝光被驱动默认1270行覆盖。再扩展exact探针验证显式曝光/增益及元数据、CPU RGB，不重放同样六帧。保持清理/前摄回归，无需纯色参照。222MHz link/209066666Hz VT仍推导，约30Hz完成不是时钟标定。

已授权只读代理：rear_camera_research审曝光链，peripheral_research审S5K3M5 19.2MHz，gnss_research离线审vendor GNSS ELF/rc/依赖。先读其结果，手机由主线程串行操作。

CSID need_vc_update使普通stop可能不写halt，但本轮单用户失败STREAMON和正常STREAMOFF均经unprepare→最后PM put→CSID IRQ/clock/poweroff，下次poweron重置。共享/持电重配语义仍开放，不宣称三hunk修好所有硬件故障。GNSS公开2024 SM8150/新SDK初始化不等于本机Android10版本，未找到可部署RF差异；不重复同CID/GSV/unlock/辅助矩阵，不盲分配MEMSHARE。[GNSS核对](reference/kernel237/GNSS-FOLLOWUP.md)、[近机型方案](reference/kernel236/RELATED-LINUX-SOLUTIONS.md)。其它后摄、传感器精度SSR、蜂窝业务、GPU ISP/PM/音频/充电/指纹/NFC/rootfs仍见[清单](linux-port/docs/HARDWARE-STATUS.md)。
