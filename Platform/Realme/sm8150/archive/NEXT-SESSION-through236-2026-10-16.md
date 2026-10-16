# Realme X2 Pro 当前检查点

2026-10-16，236：IMX319真实ID0x0319、挂起/P两路关闭、libcamera双摄枚举通过，尚无后摄帧。goal active。[236](reference/kernel236/README.md)、[235归档](archive/NEXT-SESSION-through235-2026-10-16.md)、[检索](reference/kernel236/RELATED-LINUX-SOLUTIONS.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前guard /var/lib/samurai/k236-runtime/boot-id-private.txt，233及更早全部失效；k236-baseline属于切换前233 boot。运输reference/kernel236/host.py、私人236/current-work-private.json为操作指针。无活动worker/切换/构建/捕获，trace实例已删除；桌面自动恢复。
- quiesce terminal0后仅一次Linux→bootloader，console尾收据截断；fresh fastboot身份/产品/几何核验后只flash235 boot及reboot各一次，分区读回通过。boot44c6a215…/100663296B、DTB469e1456…；Image183 bfa72dd9…/logdump183 e73754c7…保持。
- 运行/默认MFD6021a359…/22208B、lab5198e2bd…/17992B、provider2223f337…/9744B、IMX319 176f68d7…/36624B加载note匹配/intreeY。配置experimental_p_imx319_power=1、原provider softdep；运行地址模式N/供电模式Y。P1-0008/Q1-0004/provider绑定，secondary1-0009及唯一特殊lab child已绑定，仅L1/L4两个rdev。
- 首observer terminal1保留：235白名单拒绝内核unflatten合成name，lab probe−22，发生在claimed/审计/注册之前。236最小修正严格核name长度5/非NULL/完整ldo1或ldo4含NUL，其他策略/回调逐字保持。仅在未绑定/ref0时卸换lab一次，MFD/P/Q/provider保持；自动deferred probe触发后摄，不再手动bind或reset。
- 三条严格sensor addr/adapter/msg方向过滤的I2C trace实得[00-16]→read→[03-19]，全部CPU overrun/dropped0，证明真实ID。后摄7-0010/imx319已绑定并suspended，前摄现9-0010/imx471；两CCI/CAMSS suspended，MCLK1/2 enable0，P1.104V/2.8V读值正确/OFF/users0，Q七路状态/电压保持。寄存器读值不是物理电压/频率测量。
- cam -l成功列出前摄+IMX319，media graph双sensor存在；无取帧/不存照片/不加照明。前摄e49dab26…/29536B、CAMSS fae1ed40…/777360B、libcamera99990.7.2-r13/config0.1.0-r8保持，图案默认0/fullresN；纯色参照按用户延期，不再追问。233 RAW/RGB是旧启动证据。
- 775ko/789文件、944包及用户态/config/分区复核通过，当前清单为设备k236-lab-fix/module-inventory-after-private.json和module-tree-after.sha256，235-stage含旧lab摘要已过时。FastRPC2abde0ea…/50192B/ref1，三DSP running/SensorProxy三Has，Wi-Fi connected/chrony Normal，taint0/全部模块taint空，WARN/Oops/GPU/DSP fatal/BT重组0。
- 蓝牙当前原185 f6c5ed35…默认/加载note匹配，但已观察Powered=true/Discovering=false/1连接，来源未判定；本轮未发起pair/connect/disconnect，不能再写蓝牙关/无连接。首健康检查在旧OFF假设处失败，r1源/失败/部分收据保留；r2只记录实况，不验连接功能。GNSS0/Signalsfalse/rate30、watch空闲/timeprepared/dataworker0；无新搜星/注入/正CNR。MM State−1/原因2/Power1，用户报告无SIM。

## 源码、产物与回退依据

- 235完整MFD/IMX319/表/DT片段与构建冻结在reference/kernel235；236完整lab源04d16c82…、同布局header bccdd023…、最小patch/树内构建/79例实际DT-validator ASan/UBSan+3负对照在reference/kernel236。其它power callbacks与原465例逐字相同；不把旧模型冒作覆盖live OF，真实首次失败保留。每次build后canonical/Q/元数据恢复。
- canonical /home/cy122/pmos-samurai-kernel136/kernel仍精确after228，16798符号/772顺序；相机仍旧216/旧CAMSS，不刷整套Image/DTB。linux-port/camera/pmic旧232源尚未提升为236 profile；当前源锁/产物见235/236，不称完整kernel/rootfs/供电schema完成。
- P严格mask9，只有L1P1.104V/L4P2.8V，无假VIN；其余五路不注册/写，仅全芯ENABLE审计会读使能位。故障属于父MFD epoch，独立P assert+status成功才隔离；隔离不等于原寄存器恢复/电压实测。若I2C关闭和独立reset同时失败，仍有未回收ref/退出WARN风险，未宣称全部硬件故障闭环。
- 当前235 boot私人235/boot-partition-k235-imx319-p-lab.img；232回退45f398f2…在私人232，219回退156f0370…另保留。7产物锁私人236/deployment-lock-private.json，lab修正另锁lab-fix-lock-private.json。235-stage/before有旧232 MFD+14元数据、原config；236-lab-fix/before有旧lab+14元数据。回退须新身份和正常受控重启，恢复精确文件/元数据/config，必要时只刷锁定232 boot；当前lab已绑定/有消费者，不再满足本次ref0卸换前提，不能重放旧脚本/热卸有children的MFD，不触NV/校准/工厂备份。
- 236证据逐成员私有核验，含失败observer、name、修正/ID/枚举、r1/r2健康；无场景像素。镜像收据见私人236及source-final，未提交/推送。

## 续作与已知风险

下一直接做IMX319 1632×1224真实RAW RAM统计及完整回收/前摄回归。旧219/233 native-mode-probe的C++选择器硬编码cci@ac4b000，改sensor参数仍选前摄，不能用于后摄。准备新探针同时核Model/OF Camera ID/子设备，恢复全图/格式/控制，sensor/CSID图案0、GPU实验关；不得把cam列表或ID当图像。link222M/VT209066666仍推导，LLP2080/FLL3350、初始HBLANK448/VBLANK2126，须真实SOF验证。先记录失败/清理结果，不直接重复lab reload/reset。

新检索：Hotdog固定47087509公开SM8150四摄libcamera实采和S5K3M5/IMX471/失败回收补丁；本机3M5需CCI1/master0/0x2d、MCLK3 19.2M/reset23/CSIPHY3，不能搬其24M/PM8009/PLL/DTS。后续在本机OEM表上实现profile。X2Pro Halium#324仅build/boot，test_gps/camera未验；RenoAce仅官方BSP，无本轮可核完整Linux功能记录。

GNSS新一手真fix是同SM8150 Surface Duo厂商HAL→GeoClue，非本机直接QMI；其keepalive旧建议已被e20c534移除。Hotdog仅LOC启停无坐标；Surya同CID和GSV补丁本机已覆盖相应层，不能修raw CNR0；其unlock针对Start错误，本机Start成功，不套循环/NV。AP无lookup52不能排除远端MEMSHARE，不为此单独刷内核/伪服务/盲分配。GNSS/其它后摄/传感器精度SSR/蜂窝业务/GPU ISP/PM/音频/充电/指纹/NFC/rootfs等仍见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)，完整goal active。
