# Realme X2 Pro 当前检查点

2026-10-16，235：真实IMX319 OF/runtime与P严格两路供电已实现/编译，候选boot已构建，三个模块已原子暂存；尚未加载候选、未读新后摄ID/出帧。仍233启动。完整goal active。[235](reference/kernel235/README.md)、[234归档](archive/NEXT-SESSION-through234-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- guard仍/var/lib/samurai/k233-runtime/boot-id-private.txt，235-baseline与其同boot；更早guard失效。运输reference/kernel235/host.py、私人235/current-work-private.json为续作指针。无活动worker/构建/切换/捕获。235未重启/刷分区/热卸PMIC，桌面/WP/音频保持。
- 运行boot232 45f398f2…/100663296B、DTB7e8345ae…、Image183 bfa72dd9…/logdump183 e73754c7…。运行MFD仍f633467f…/20520B、provider2223f337…/9744B；experimental_p_address_only=Y。P1-0008/Q1-0004/provider绑定，P身份已确认且仍无secondary/children/供电。
- 磁盘已暂存235：MFD6021a359…/22208B替换、lab22c28914…/17640B和IMX319 176f68d7…/36624B新增；775ko/789相关文件，kmod顺序及两种alias通过。配置已改experimental_p_imx319_power=1+原provider softdep，运行仍旧值；不可称默认/加载note相同。module-stage transaction verified，备份/元数据/原配置在设备k235-module-stage。
- 暂存后健康通过：taint0/模块taint空，WARN/Oops/GPU/DSP fatal/BT重组0；三个DSP running、SensorProxy三Has真，原FastRPC/前摄/CAMSS/BT/provider加载note匹配。P无secondary，前摄/CCI/CAMSS suspended，原分区读回不变。私有原生收据全成员核验；无场景像素。
- 前摄仍e49dab26…/29536B、CAMSS fae1ed40…/777360B，libcamera99990.7.2-r13/config0.1.0-r8；233冷循环后RAW/RGB各6帧有效是旧证据。纯色参照按用户延期，不再追问，不称色准/AE已验。图案0/fullresN，双轨关。FastRPC运行2abde0ea…/50192B/intreeY/ref1；944包保持。
- BT仍原185 f6c5ed35…/默认与加载note匹配，helper/config/keys保持、关/无连接。234两次完整phase5轨迹未复现错误，扫描脚本Not Powered退出后恢复；不是phase5修复。GNSS仍idle/无正CNR/TRACK/fix，室内窗边，无新注入/搜星。MM191无SIM/State−1原因2；真实蜂窝业务未验。

## 源码、产物与回退依据

- 完整235候选源/补丁/表/板片段/接入片段/构建及实际C故障测试在reference/kernel235。当前接受的旧232实验PMIC完整源仍linux-port/camera/pmic，235未冒作已验收。canonical /home/cy122/pmos-samurai-kernel136/kernel精确after228，16798符号/772全局顺序；相机仍旧216/旧CAMSS，不能刷整体Image/DTB。
- PMIC源99505695…/lab ce5c15bc…/header bccdd023…；树内W=1零诊断/intreeY/183 ABI，原Q及所有构建元数据恢复。465实际回调ASan/UBSan、3负对照；MFD40例/2负对照通过。故障属于父epoch；仅L1P1.104V/L4P2.8V/mask9，无假VIN。独立P assert+status成功才隔离/允许core平衡引用；失败不伪报OFF/不重复reset，仍有未回收引用/退出WARN风险。隔离不是寄存器恢复/电压实测。
- IMX319源ec1a278d…/header f366aba9…；原ACPI8模式表保持，OF三真实supply/managed child依赖/PM/checked GPIO+pinctrl。370实际power/identify/table/stream函数ASan/UBSan和4负对照通过，308配置写失败位置均测；ID失败/错ID零sensor写。模型不证明真实并发/devres/硬件。
- 两家独立vendor XML的global136/mode171完全一致，原BIN/payload保持。1632×1224 RAW10/RGGB/4lane、LLP2080/FLL3350、HBLANK448/VBLANK2126。177.6M元数据不自洽；link222M/VT209066666仅推导，须SOF测。原机CCI0/master1/0x10、MCLK1/GPIO14/19.2M、reset30、CSIPHY1；MCLK active/sleep6mA、reset2mA/sleep低，不复制前摄。
- DTB469e1456…/112137B相对真实232仅12新节点和3属性变化；camcc/TITAN_TOP/MCLK/供电/双向lane graph phandle全核对。boot235 44c6a215…/96MiB，私人235/boot-partition-k235-imx319-p-lab.img；解包仅内嵌FDT变化、固件代码/头/ramdisk/兼容DTB/尾及183 Image保持，30条既有固件诊断无新模板，不称完整kernel/rootfs/schema完成。
- 当前232 boot回退45f3在私人232/boot-partition-k232-pmic-identity.img；219回退156f0370…仍私人219。235回退先核新身份，恢复k235-module-stage/before中MFD和14元数据、原配置，移除精确两个新增module路径，再正常重启/必要时只刷已锁232 boot。不能热卸有children的MFD，不触NV/校准/工厂备份。锁在私人235/deployment-lock-private.json。

## 续作与已知风险

下一步直接准备新的受控过渡/原生验收，不再重复XML/已过host矩阵。当前磁盘与运行MFD不同，旧233/234默认清单已不适用；以235-module-stage清单核磁盘、以before note核运行。新清理工具需保留运行P/Q/provider，仅清相机端点；不能套233的provider未加载断言。新身份/几何后仅flash锁定235 boot一次，未明切换不重发；新boot建立新guard再核775/789、加载note/P两路/后摄ID/自动挂起，然后有界RAW RAM统计、回收及前摄回归。不保存照片/不加照明。

首次DTB校验把标签误当regulator-name，r1编译成功/检查退出；r2按前摄真实vif phandle核对通过。所有早期构建/模型失败私有保留。已执行脚本一次性目录/旧guard不能重放。235最终镜像/成员数以私人收据和source-final为准。

GNSS研究纠正：本树QRTR NS只接受本地lookup观察者，MPSS可在自身NS等公告；AP没看见52 lookup不能排除MEMSHARE需求，qrtr-lookup不能证明固件请求，现trace无服务参数。不要为此单独刷内核/伪服务/盲分配。继续真正RF/OEM差异。BT不堆未复现扫描；GENI功能补丁仍须真实端口锁/IRQ/console/RS485/PM验证。

其余四后摄/前摄颜色几何/GPU ISP/传感器精度SSR/USB与Wi-Fi PM/音频/充电保护/指纹/NFC/rootfs等见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。三路只读研究授权保持，手机由root串行；不得以局部通过完成全goal。
