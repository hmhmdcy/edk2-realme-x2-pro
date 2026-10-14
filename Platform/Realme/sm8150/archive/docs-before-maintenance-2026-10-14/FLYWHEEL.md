# 免按键测试飞轮：Linux → fastboot → 刷机 → 再启动

当前操作规则：[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)。用户已撤销其余临时禁令；下方历史中的GPU禁测、固定时序、只读、禁复用及禁提交推送等条款不再适用。硬件状态和既有失败记录仍保留。

阶段135完成MDSS reset候选的909节点单属性静态/schema验证、UEFI仅DT替换及真实双分区部署；实际新boot虽无原CTL/KMS失败，却WCD934x告警、DSI两处clock告警、682次codec ENOSPC、taint512且无Phosh，候选拒绝，根因未证明。已自动回退#132并逐项验核boot/logdump/live DT/GPT18/persist/770模块/11来源；原配置Phosh/Phoc与BlueZ/5180MHz自主恢复、taint0，无需面板重绑或greetd标记恢复。42.512秒8次被动守卫同PID/供电0/BlueZ/Wi-Fi及故障计数保持，boot累计DPU2/UART4/GPU0；CRTC active0，持续显示和GPU131迟发fault仍未验收。当前匹配完整镜像为rootfs132；最新候选rootfs134及770模块原字节复用/四件套重新完整hash和encoded UID10000读写通过，候选135不能作为稳定基线，userdata未全量刷入。134 USB额度驱动在当前132回退内核暂不存在，历史CDP1.5A证据保留；MP2650只读观测仍自动注册，实际充电控制继续待办。找到当前缺失的上游WCD934x regmap/irqchip清理补丁，下一项独立源码补丁/构建/实际部署，不能据此宣称efuse/ENOSPC根因已证实。15组硬件与完整系统goal active。

[阶段135](sessions/135-mdss-reset-candidate-rejected-and-stable132-rollback.md)。以下更早内容是历史，以当前132回退与135失败边界为准。

阶段134已实际刷入boot/logdump及770匹配模块，新内建只读USB supply自动注册：42.113秒8份标准事件均ONLINE1/CDP/CURRENT_MAX1500000，属性0444。首次启动却发生继承INTF停帧及CTL reset -22，KMS失败/无DRM；失败现场保留，一次原生panel bind恢复card0/renderD128，保存当前greetd初次会话标记后原配置Phosh/Phoc恢复，不能宣称永久显示修复。恢复后taint0/BlueZ/5180MHz及11来源保持，42秒无新增故障；新boot累计DPU timeout1、UART2、GPU0仅无专项负载窗口，GPU131迟发CCU故障仍未修。完整rootfs134为936包/770模块/21,137条目反向内容metadata零差异、双fsck、encoded UID10000读写及四件套通过，完整userdata未全量刷入。实际清理120/121旧对象1.78GiB、旧129/130 exports与冗余132 raw7.14GiB内部占用，134卷零区原生稀疏回收E盘2.30GiB，稳定源码/镜像和原WSL VHD保持。15组功能边界、完整充电控制及完整系统goal仍开放。

[阶段134](sessions/134-usb-input-budget-real-boot-and-display-startup-failure.md)。更早状态为历史，以当前134及失败边界为准。

阶段132已实际刷入boot与logdump，内核#132/770匹配模块及UEFI内嵌设备树通过，MP2650在QUP1/0x5c启动自动注册只读标准power_supply。42.13秒8份事件全部非空/ONLINE1/Charging，电压8/8为4.400–4.475V，输入电流7/8为400.00–418.75mA，另1份ENODATA；桌面PID/taint0/BlueZ/5180MHz与11来源保持，窗口无新增故障。新boot仍DPU超时4、BT UART重组错误2，GPU0仅此无负载启动窗口，131迟发CCU故障未修。完整rootfs132含936包/770模块/21,136条目反向metadata与内容零差异、双fsck、encoded UID10000读写及匹配四件套；完整userdata未全量刷入。两份可由稳定130 sparse完整重建的冗余raw删除3.63GiB，130 sparse/source/export和C128/129稳定源码/Image保持。15组功能边界和完整系统goal active。

[阶段132](sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)。以下131及更早内容为历史，当前状态以上述132记录为准。

阶段131已证明旧glmark离屏尺寸错误：同一FD640/Mesa26.2.4场景在1080×2259失败、固定实际FBO800×600按原阈值通过；随后1.993/2.737秒出现两次不同IOVA的CCU READ TRANSLATION，GPU整体仍失败。新转储/7BO离线解码及59+21成员SHA验证完成，停止GPU负载，无GPU重置/桌面重启/刷机。转充电观测：当前129已含87 ADC重试/ENODATA修正，临时绑定8份标准uevent均非空、ONLINE1/Full；ADC电压5/8、电流4/8，其余ENODATA，11配置读数保持，测试后客户端移除。当前内核仍#129、最新完整rootfs130，15组功能边界/稳定回退保持，完整系统goal active。

[阶段131](sessions/131-fixed-size-pixel-validation-and-delayed-gpu-fault.md)。

[阶段130](sessions/130-standard-bluez-discovery-and-startup-integration.md)，[阶段129](sessions/129-initial-console-node-and-real-boot-verification.md)，[阶段128](sessions/128-wcn3990-pairwise-key-delete-and-5ghz.md)，[阶段127](sessions/127-rootfs-user-owner-fix-and-live-system-resource-ownership.md)，[阶段126](sessions/126-tpg-dma-guards-full-rootfs-and-real-deployment.md)，[阶段125](sessions/125-native-cpas-qos-full-iova-window-and-mount-serialization.md)，[阶段124](sessions/124-native-cphy-shared-rail-and-frequency-contract.md)，[阶段123](sessions/123-camss-dt-dma-interconnect-and-strict-disabled-validation.md)，[阶段122](sessions/122-complete-k121-rootfs-and-verified-build-cleanup.md)，[阶段121](sessions/121-pm8008-no-irq-and-native-reset-contract.md)，[阶段120](sessions/120-cci-device-tree-and-camera-pmic-contract.md)，[阶段119](sessions/119-k118-deployment-and-real-gpu-pixel-failure.md)，[阶段118](sessions/118-final-reset-read-build-and-host-space-recovery.md)，[阶段117](sessions/117-parser-boundaries-and-same-boot-desktop-recovery.md)，[阶段116摄像头基础](sessions/116-camss-foundation-and-own-sensor-binaries.md)，[继续检查点](NEXT-SESSION.md)。

阶段130补齐标准BlueZ5.87服务的本机DMS地址供应和default自动启动，实际两组LE/BR/EDR/混合扫描及HCI/MGMT发现事件通过；正常暖重启后无需手动服务/地址/网络激活，BlueZ运行且控制器默认关闭，5180MHz/网关/HTTPS/50.24秒窗口通过。当前内核仍#129，boot/logdump/770模块保持；完整rootfs130含936包、21,135条目反向内容与metadata零差异、双fsck/稀疏重建/encoded UID10000实际读写和四件套通过，服务/config/runlevel已增量部署，完整userdata未全量刷入。当前taint0/DPU0/GPU0/CRTC active1仅为本次启动窗口，旧GPU像素故障及持续显示未证明修复；BT启动UART错误累计2，配对/传输/冷启动/休眠与其余硬件边界保留，goal active。

阶段126已实际刷入#126及内嵌CAMSS设备树，live DT全节点/已有属性、boot/logdump/persist/GPT18/11来源/770模块验证通过。内部CSID0→VFE0 TPG三帧真实DMA通过：3个地址在原厂窗口、每帧96000字节覆盖预填充、raw10非恒定横向图案、IRQ和电源恢复核对；物理camera仍未验收。最终桌面进程/无线/音频恢复、taint0，50秒窗口无新增故障；启动仍DPU1、最终CRTC inactive，不能算显示长稳通过。完整126 rootfs的home UID1000与passwd10000缺口已由阶段127修复；原126镜像不应全量部署，最新匹配镜像见阶段130。清理3个obsolete构建的15189个生成ELF文件，实际分配2.49GiB，全部归档回读后删除，稳定镜像与源码保持。goal active。

阶段125完成本机CPAS版本守卫、175_100/101原厂IFE十项QoS、masked urgency和读回/时钟/ICC失败回滚；IOVA改用原厂完整窗口0x07400000..0xe0000000及两侧保留策略。实际C/ASan/UBSan、1024次真实内核分配器/rbtree测试及严格DTB正反例通过，#125完整Image/770模块包已构建；CAMSS disabled且未部署，真实SMMU/TPG DMA尚未验收。最新完整rootfs仍122匹配121；手机118/DPU2/GPU1/11来源hash保持，goal active。

阶段124完成本机camera_8150三相PHY表129项移植（保留与参考不同的三处0x24）、C-PHY输入/能力守卫、频率比例修正及本机共享L3 1.2V供电模型。#124完整Image/770模块/DTB和模块包通过，实际C/ASan/UBSan与schema正反例通过；CAMSS保持disabled，未部署，settle实际时序、CPAS/QoS、IOVA下界和sensor仍开放。完整rootfs仍122匹配121；手机仍118/DPU2/GPU1和11来源校验，完整goal active。

阶段123完成本机CAMSS寄存器/IRQ/SMMU资源交叉核对及隔离设备树、31bit保守DMA上限、4条ICC路径与双VFE HF AXI桥时钟请求；#123完整Image/770模块/DTB和模块包通过，严格disabled节点schema及7反例、实际C DMA 12场景通过。尚未部署，摄像头未stream，供电模型/C-PHY/QoS/IOVA下界仍待完成；最新完整软件rootfs仍122匹配121。手机保持118/DPU2/GPU1和11来源校验，完整goal active。

阶段122完成匹配#121的完整F2FS软件rootfs：936包/770模块、双fsck、稀疏逐块/空洞重建、21,134条目反向导出内容及权限/UID/GID/符号链接/xattr零差异；修复sload漏/dev/null和dump丢特殊权限位，启动/模块/rootfs四件产物核验完成，均未部署。按新增第6项清理4个已逐块证明可重建的旧WSL raw副本，释放7.26GiB实际占用，保留稀疏基线和回退；手机仍#118/DPU2/GPU1，完整硬件goal active。

阶段121完成PM8008无IRQ regulator-only驱动和配套绑定、实际C probe 18场景、schema 2正例/7反例、完整#121 Image/770模块/DTB及匹配模块包，均离线未部署。原厂双PMIC复位/地址恢复及0x950 chip-enable已核对，四组输入和冷启动地址仍待证实，未建立假供电节点。手机仍#118/taint0/原Phosh/Phoc PID/DPU2/GPU1，完整系统goal active。

阶段120完成隔离#120 CCI设备树及完整Image/770模块/DTB构建，绑定/真实DTB定向schema和故意坏DTB反例检查通过，匹配模块包depmod无诊断；未部署。当前手机仍#118，Phosh/Phoc原PID、taint0、DPU2/GPU1、PCM关闭、双功放静音、SLPI供电0，NV6/source4/vendor1保持。摄像头尚无传感器识别/stream，PM8008输入与无IRQ支持是下一实际缺口，goal继续active。

阶段119已只刷logdump部署#118，boot/DTB/764模块及userdata保持。新启动自动恢复DRM/card1、Phosh/Phoc和FD640，0 CTL reset失败/0 KMS bind失败/0 RCU stall、taint0；启动DPU2次超时，300秒空闲窗口0新增，最后CRTC停用，不能代表持续绘制。签名glmark2非root真实像素验证33项仅2成功/25失败/6未知，退出0后发生1次CCU READ TRANSLATION GPU fault，2.2MiB devcoredump已私有保存；桌面进程仍存活、taint0，GPU功能验收失败。NV6/source4/vendor/persist/GPT及音频空闲保持，goal继续active。 Mesa26.2.4官方源码离线crashdec已成功：51 BO不包含fault IOVA、TTBR一致、1个零页表项，估算停止在CP_WAIT_FOR_ME/CP_SET_BIN_DATA5附近；无VM历史，根因未证明，先转摄像头资源核对。

软件rootfs115 fixed镜像1,817,970,276字节、936包/764模块/本机IPA固件、zram/elogind修复，展开比对/双fsck通过，尚未刷入。隔离#116 CAMSS基础完整构建通过、未部署；本机sensor BIN解析在有界工具窗口未完成，不能称摄像头可用。

F1前仍要当前boot完整排空GUI/音频/功放/ADSP/无线/MPSS、NV核验、sync与fsfreeze回执。当前桌面已恢复，不能套用无GUI脚本或115旧boot守卫。不使用erase userdata的旧全量刷机脚本更新应用。

> 2026-10-08 建立（F1 核心已在真机验证）。用途：把「改代码 → 上机验证」从
> 5–10 分钟的人肉操作（断电 15 s + Vol-Down + Power + 手刷），压到 **1–4 分钟、
> 无人值守**的一轮。
> 关联：`HANDOVER-NEXT.md` §1/§7、`RX-CONSOLE.md`（RX 协议细节）、
> `linux-port/docs/28-flywheel.md`（原始设计：PON reboot-mode + EUD RX + fastboot flash）。

## 0. 一句话

前次只读日志/供电/触摸前提审查看 [session70](sessions/70-pm8009-resource-and-touch-prerequisites.md)。
85404字节完整日志及cmd-db校验通过；PM8009无F资源/DT供电消费者，降为P3。
GENI/RMI4/i2c17尚未使触摸进入探测；无内核修改/刷机/新EUD实验，owner均已释放。

前次只读日志/USB审查看 [session69](sessions/69-usb-gadget-state-and-eud-coordination-audit.md)。
69499字节完整日志哈希/CRC通过，同 #60/taint0；UDC存在但未配置gadget。
实际legacy glue和EUD通知路径已核对，普通USB共存仍未验证；无刷机/控制切换/新EUD实验。
COM14 Windows/Shared/未Attached，owner关闭；postmarketOS的USB网络/SSH是后续通道前提。

2026-10-09 session 41 找到原生多字节 RX 方法：SM8150 SOUTH TOP_CFG=0x11，
整帧在 TX 锁内读取后再打印/交给 tty。UEFI 跨重启与 Linux 的 ABC/DEFG 正确，
原生多字节 shell 赋值也已执行。len=2 的 [90][02] 仍保留 F1；驱动在交还 PHY
给 ABL 前恢复原 TOP_CFG。本轮只刷 logdump，来源、逐步验证和最终设备状态见
`sessions/41-rx-ahb2phy-wait-state-fix.md`、reference/rx41。

当前内核交接看 [session68](sessions/68-firmware-dtb-and-cpu7-opp-verified.md)：
仅一次boot固件DTB更新使CPU7新OPP生效，live节点/调频表/max2956800及启动警告消失已验。
同 #60 Image，新完整52842字节日志通过设备SHA256/gzip CRC，taint=0，UDC仍在。
高频负载和实际USB通信待验。EFI loader使用固件DTB，不能重复FAT-only刷机。
前次HS PHY提供者内建见session67。
前次 CPU 调频提供者、PMIC ADC、earlycon 映射三项修复见 session66。
使用既有手动工具，一个连接 owner，finally close/dispose/detach；WSL shell 要保持
运行，attach 后先 lsusb 确认 9505。host COMMAND> 不代表 target 导出结束，必须等
实际 END 标记和 shell 提示符。只读 GPT 不可把“前34扇区”当成无分区数据的范围。
当前证据以session68/reference/kernel68为准，rootfs限制仍见session66；不做EUD参数实验。

前次 EUD 交接看 `sessions/65-wsl-full-packet-console-overlap-and-tx-gap.md`：
WSL一次busy-console原生LEN14/wire16输入正确受理并执行，990个零完整；同一owner
仍缺9个tty TX帧/36字节，CRC有效512记录中另外503直接匹配。全部正长度IN等于raw，
这次缺口不需要qcusbser或reopen。WSL保留Windows USB/IP下层，整体仍未解决。
首导出CRC失败保留，独立压缩导出同一快照通过。现有专用终端负责EUD帧协议，
不能直接当普通UART用通用终端；以后COM/PTY转接也不能代替丢帧修复。
一次现有镜像reboot及正常com-up，无刷机/新驱动/UAC/安全设置变化，finally释放/
detach，三节点OK、COM14旧绑定、Shared/not Attached，无owner/日志/ETW。
用户最新优先Linux内核问题，收束EUD实验；连续TX请求/取消/FIFO审查保留待办。
EUD仅辅助观察，关键日志在设备侧保留完整副本并校验导出，勿重复旧passing实验。
RX62/63候选仍未加载，RX64的受支持加载环境要求和完整Windows原生验收独立保留。
ZLP在DeviceAdd读取，不能和FileCreate保留翻转开关混测；方案reference/rx63/trial-review.md。
保留TOP_CFG0x11/整帧/RX53 console IRQ/F1/原生兼容终端/RX48回退。

前一轮交接看 `sessions/57-driver-raw-logging-boundary.md`：一个有界 Windows owner 已取得
实装驱动受理前原始日志，9550 字节与计数/raw 一致、512 软件发送帧直接匹配。
旧故障未重现，不算稳定性修复；首轮 PnP 返回值误判已记录并修正，两个单次 UAC 均已用。
两项临时 COM14 配置已恢复、串口/帮助进程关闭、三节点 OK；未刷机/手机重启或换驱动。
下一项必须取得真实缺口的前缓冲字节，不能原样重跑 passing 流程。

上一轮来源审查 `sessions/56-source-boundaries-and-focused-research.md`：当轮只读，未开串口/
attach/刷机/重启/改驱动或注册表。审查得受理缓冲前日志路径、reset selector 与 padding
边界，合并旧结论做针对性搜索；未取得新修复。下一项要在真实缺帧时区分 USB 到主机
与驱动前段丢失，普通 passing/F1/reset 循环不再算进展。

上一轮 `sessions/55-windows-perf-counter-and-reproduced-tx-gap.md`：未刷机/重启，
同 RX53 候选与安装终端。新 TX 缺 seq7376 在 raw 和 GET_STATS 受理缓冲计数中
均少 6 线缆字节；已排除纯终端显示/读取丢失，EUD/USB/驱动前段仍未区分。
启动首 Ctrl-U 仍可能未受理；只重试同步，后续数据只发一次。finally 关闭串口，
三节点 OK、Shared/not Attached。TOP_CFG=0x11/F1/console/兼容终端与回退保留。

前一轮 `sessions/54-console-rx-regression-and-host-counter-audit.md`：未改
logdump-rx53-console-rx/安装终端、未刷机，9 次手动长日志原生输入均经 console
整帧受理/执行、全部变量读回；6 次空 IRQ 计入 credit，IRQ active=1/fault=0。
完整 USB IN/raw 与 512 帧 TX 快照匹配，但并未诱发连续 8 次空 IRQ。
一次长日志期间 header-only F1 明确 via=console，独立核实 fastboot 后仅 reboot
同候选，TOP_CFG=0x11/tty/IRQ/原生新回执恢复；owner finally 关闭/dispose/detach，
三节点 OK、COM14 关闭、Shared/not Attached，立即回退仍是 unchanged RX48 B。
RX53 的 seq 7287 已发 TX 前缀缺失仍未定位；本轮 passing 回归不代表 TX/reopen 修复。
实装驱动 SerialGetStats 的累计接收字节提供下一项只读缓冲边界观测；尚未实测，
在现有诊断 overlapped handle 有界读取，与 raw/journal/queue/errors 对照，不复做
reset/仅掩码/旧零等待，不动熔丝或安装终端。RX53 的内核改动和 TX 缺口证据保留。
RX49 的完整虚拟 IN/部分取消核对、RX48 的 IRQ F1/同镜像重启实测仍保留。
`eud-terminal.cmd -Native` 持续 owner、启动同步、数据只发一次的用法不变。
旧 ETW reset/数据翻转假设仍未物理验证，勿重复仅掩码/reset/旧零等待实验。

计数边界看 `sessions/44-rx-receipt-counters.md`：只读计数把失败原生命令定位到
没有观测到 pending/头部拒绝/tty 投递的边界，成功 echo 的帧/字节计数准确。
当时为 logdump-rx44-rx-stats-ctrl-u.img 诊断镜像，仍未修复稳定性；只刷 logdump。
F1 已独立核对 fastboot，重启相同镜像后取得 Ctrl-U 新回执，COM14 关闭。

上一轮审查看 `sessions/43-native-terminal-evidence-audit.md`：原生整帧修复保留，RX41
数次“缺输出”经原始抓取更正；偶发缺回执在 Windows/libusb 均存在，根因尚未定位。
session 43 未刷机，复核原生 console、兼容终端和 F1；最终重启同一候选并读回原生
echo 响应，COM14 关闭。操作前仍须重新核实实时状态。

手机能从 Linux **自己**重启进 fastboot。主机通过 EUD COM 发一帧 `[0x90][0x02]`，
驱动打印 `eud: reboot2 bootloader requested`，先写 `CSR_EUD_EN(0x1014)=0` 把 USB PHY
交还常规通道，再 `kernel_restart("bootloader")`；PMIC PON 的 magic 由 reboot-mode
notifier 写入，ABL 读到后进 fastboot。

实测（2026-10-08）：

    主机 TX [90][02]
    phone  [  70.662708] eud: rx id=90 len=02 s1=07070707
    phone  [  70.702349] eud: reboot2 bootloader requested
    主机   COM 口立刻断开（"The port is closed"）
    PC     fastboot devices -> DEVICE_SERIAL fastboot      ← 无任何按键

## 1. 命令通道：用「长度」字段当命令码

当前协议使用 `id=0x90`（厂商驱动的 `UART_ID`）。session 41 已验证在 TOP_CFG=0x11
时读取完整多字节 payload。F1 仍编进长度字段，在读取头部后分派，不依赖 payload；
这条旧兼容命令继续保留，不是当前 payload 修复的方法。

| 主机发 | 含义 | 状态 |
|---|---|---|
| `[90][01][字符]` | tty 输入一个字符 | 已有真实字符回显；受理后停止重发，见 session 32 |
| `[90][02]` | `reboot bootloader` → fastboot | **真机已验证** |
| `[90][3..14][payload]` | 原生 tty 输入：TX 锁内一次缓存整帧，读完才记录/投递 | sessions 41/43 验证完整 payload、命令/console 响应；偶发缺回执仍未解 |

禁止把 2 字符 tty 分片发成 `[90][02][payload]`；len=2 专用于头部 F1。

设计约束：**收到头部即可判定命令**。驱动曾经等 payload 收齐才分发，结果
`len=02` 的帧在第 1 个字节后门控清零就被放弃，命令永远到不了——所以命令分支
必须在读到头部时立即执行（`EUD_F1_EARLY`）。

## 2. 一轮的完整流程

| # | 谁 | 动作 | 耗时 |
|---|---|---|---|
| 1 | PC/WSL | 改内核，`make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image` | 增量 ~45 s |
| 2 | PC | 把 Image 打进 logdump 模板（原地） | ~1 s |
| 3 | PC | `fastboot flash logdump logdump-<tag>.img` | 1.9 s |
| 4 | PC | `fastboot reboot`（手机自动进 EDK2 → Linux） | — |
| 5 | phone | 固件 → Linux，EUD 控制台起来 | ~40 s |
| 6 | PC | 等 9501 → `eudtool com-up` → 找 COM → 开端口抓包 | ~10 s |
| 7 | PC | 手动有界发送实验帧，取得新回执即停止重发（见 §5） | 依实际回执 |
| 8 | PC | 发 `[90][02]` → 手机自己回 fastboot | ~10 s |
| 9 | — | 回到第 3 步 | — |

只改主机脚本的实验：跳过 1–4，**一轮 < 1 分钟**。

## 3. 构建与打包

内核（WSL）：

    cd /home/cy122/x2pro-linux/linux
    make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image        # ~45 s 增量
    make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- qcom/sm8150-samurai.dtb

`make Image` **不会**重建 DTB，改了 DTS 必须单独跑上面第二条。

logdump 打包（Windows，`E:\edk2-samurai-out\patch-logdump.py`）：

以下 offset/长度是 session 31 的旧镜像记录，不能直接用于当前 RX41 Image。
当前迭代以 session 41 的镜像/源码为起点，在原 FAT 副本中替换 Image，核对内容与 DTB；
不要运行会用旧 Windows initramfs 镜像覆盖真实 WSL initramfs 的 build-image.sh。
RX53 Image 已增至 30181888 字节，不能使用旧固定长度原地补丁；沿用 session 53
的 mcopy 包装和抽取比较。当前/回退完整 SHA 见 session 53/reference/rx53。

    Image 在 FAT 里的固定位置：offset 90112，长度恒为 30116352 B（原地替换）
    FAT 里的 \samurai.dtb：     offset 30208000，长度 94739 B（原地替换，尺寸没变）
    模板：logdump-intrx2.img；产出 64 MiB 的 logdump-<tag>.img

DTB 的两条路径都要照顾（否则猜不准哪条生效）：

1. **固件**：`Platform/Realme/sm8150/FdtBlob/samurai/sm8150-realme-samurai.dtb`
   ← 权威路径，EFI stub 从固件配置表取 DTB。改完要重编固件（`./build.sh -d samurai
   --toolchain GCC5`，产物 `boot-samurai.img`）并 `fastboot flash boot`。
2. **FAT 副本**：logdump 里的 `\samurai.dtb`（见上表），一并换掉。

> PON reboot-mode 的两个属性来自 DTS：
> `&pon { mode-bootloader = <0x02>; mode-recovery = <0x01>; };`
> 配置项 `POWER_RESET_QCOM_PON=y`、`REBOOT_MODE=y` 已开。
> **不需要 reboot2 小工具**：驱动是内建的，直接 `kernel_restart("bootloader")`，
> notifier 会写 magic（文档 28.1 设想的 userspace helper 用不上）。

## 4. 主机侧脚本

| 脚本 | 用途 |
|---|---|
| `eud-f1-flash.ps1` | 刷 boot（新固件）+ logdump，然后 reboot |
| `eud-f1-cmd.ps1` | 等 CTL → com-up → 找 COM → 开端口 → 发 `[90][02]` → 等 fastboot |
| `eud-A.ps1` / `eud-B.ps1` / `eud-C.ps1` | 抓包 + 按节奏发帧的实验脚本（历史） |
| `parse-eud.ps1` | 把 `eud-*.log` 里的 `[id][len][payload]` 帧**重组成可读文本**（原始日志每 4 字节就被 `..` 打断，直接 grep 没用） |
| `linux-port/scripts/eud-step.ps1` | session 32 的单步发送/抓包；finally 关端口，tty 字符可用 -Ack 在受理后停重发并继续排空 2 s |
| `linux-port/scripts/decode-eud-capture.py` | 重组上述 .raw 抓包并保存 .txt；报告 frames / stray bytes |
| `linux-port/scripts/eud-terminal.cmd` / `.ps1` | 临时交互终端，ASCII 输入逐字受理重试、TX 多字节帧重组；Ctrl-] 关闭端口后再发 F1。用法见 linux-port/docs/EUD-TERMINAL.md |

`eudtool.exe` 命令：`list|dump|probe|ctlin|ctlout|attach|detach|com-up|com-off|swd-up|swd-gpio|swd-off|jtag-up|jtag-off|dbg-up|dbg-off|raw HEX...|rst|set|clr`

## 5. 硬约束与坑（每条都真实卡过一次）

1. **主机 COM 口会被卡死**。中断的抓包脚本会让 Windows 的 qcser 驱动把端口钉在
   "resource in use"，此后 `com-off`/`com-up`、`detach`、`rst(CTL 0x09 PERIPH_RST)`、
   杀进程、子进程打开、**手机重启**…… 全部无效。
   只有 **换 USB 口（换设备节点）** 或 **重启主机** 能解。
   → 飞轮脚本必须：`try/finally { Close(); Dispose() }`、一次只让一个进程开端口、
   每轮实验用新进程，绝不在常驻会话里裸开端口。
2. **旧测试收到回执的比例较低，不能当当前固定投递率**。session 41 仍有空抓取，
   主机 `Write()` 成功不证明设备受理，缺回执也不证明设备拒收。使用有界重试，
   收到新回执即停；现有协议无序号/去重，重发可能重复执行，优先用幂等诊断输入。
3. **抓包必须先起**。设备 TX FIFO 只有几格，没人排空就会丢日志；而且"EUD 哑了"
   常常是主机侧没读。
4. **普通 warm reboot 可能保留 EUD 状态**：EUD 开着时 USB 被占（fastboot/UMS
   都看不到）。飞轮 handler 已先关闭 EUD 再 reboot；完整断电是其失效后的兜底。
5. `-OnlyLogdump` 这类 **switch 参数不能用 `[bool]` 强转**（PS 5.1 下恒为 `true`，
   会导致"静默跳过刷 boot"）——用 `.IsPresent`。
6. 抓包脚本里 `fastboot devices` 在**常驻会话**里可能挂死；放进 `Start-Job` 就正常。
7. 只刷 boot / logdump；U 盘模式下绝不让 PC 初始化/格式化 UFS 分区。
8. 长命令容易被工具链截断/挂起：写 .py/.ps1 文件再执行，比内联长命令可靠。

## 6. 历史排查：`0x14` 到底给的是什么（sessions 32-40）

以下“未修复”“主假设”“尚未跑”只描述当时阶段。session 41 已验证 TOP_CFG=0x11
后的真实整帧推进；当前剩余问题与下次判据以 sessions 41/42 为准。

**2026-10-09 session 40 更新：** 仅搜索/静态审查，无刷机、无新的多字节实验。
旧 DSP 完整表及原厂 SM8150 固件仍未提供 RX advance 修法；基线 Windows 单字节回执正常，
COM14 finally 关闭，6-5 Shared/未 Attached。本轮未重新触发 F1。
见 `sessions/40-rx-register-map-and-stock-firmware-audit.md`、reference/rx40。

**2026-10-09 session 39 更新：** 只刷诊断 logdump 的 UEFI 紧轮询对照仍为 AAA/DDDD，
详见 `sessions/39-rx-tight-arrival-poll.md`。Windows 无回执后 libusb 加 PORT_RESET 恢复，
F1 有新回执且另确认 DEVICE_SERIAL fastboot，随后只刷回 rx33-console；Linux/tty/shell 被动
启动抓包与 Windows Ctrl-U 首次受理均正常，COM14 已关闭，6-5 Shared、未 Attached。
EIO 断开本身不是 F1 成功证明；没有回执的 Windows OUT 不算受理。原生多字节仍未修复。

**2026-10-09 session 36 更新：** 未刷机，仍用 rx33-console；F1 本轮未重新触发。
实机 OUT 为 0x02 / max packet 16；旧 WDM qcusbser 与 SM8150 握手源码的新审查见
`sessions/36-rx-usb-descriptors-and-legacy-qcusbser.md`。libusb/WSL 完整 ABC、DEFG
均成功提交并被受理，仍只读到首字节随后 90，qcusbser 不是必要触发条件。
新单步工具已设备验证，正常释放资源；detach 后一次 COM 重连恢复 Windows 回执，
手机仍为 Linux。不要把没有受理回执的轮次当有效 payload 失败。

**2026-10-09 session 33 更新：** 当前镜像为 `logdump-rx33-console.img`，单字符与
F1 均再次验证。整帧禁止 TX、MMIO 属性/屏障、数据先于头部等实验仍未解决多字节；
门控并非每次首次读后立即清零，量产权限假设也尚无 COM 专属证据。完整记录见
`sessions/33-rx-access-and-production-policy.md`。当前 RX 状态、头部和首次 DAT
读取共用 TX 锁。只改内核时只刷 logdump。

**2026-10-08 session 32 更新：** 以下为 F1 阶段的旧观测。原探针实际是
`90 90`；去掉读取前的 printk 后首字节能读到真正 payload（ABC → 41，DEFG →
44），不支持跳过 2 字节。单字符输入已修正，多字节仍不前进：连续读为重复首
字节，200 μs / readb 未改善，20 ms 缓存后打印为 `41 90 90`。当前版本把
长度 3..14 留作诊断，具体证据、跨机型参考与产物见
`sessions/32-rx-printk-interference.md`；不要再把下面「尚未跑」当当前状态。

事实（2026-10-08 实测）：

* 收到头部时 `INT_STATUS_1(0x44)` = `0x07`（BIT(0)=`EUD_INT_RX` 置位）；
  读一次 `0x14` 之后变 `0x06`（置位被清）。
* 读回的第 1 个字节**永远是 `0x90`（id 本身）**，而不是 payload：
  `len=01` 时 `byte[1/1]=90`，`len=03` 时 `byte[1/3]=90`。
* 读到的字节确实被送去 tty：设备回显了一帧 `90 01 3F`（`?`）。

参考实现（上游）**全是"消息级门控 + 帧内 burst 读"**，没有谁做逐字节门控：

* `kernel/msm` tty 驱动：RX 中断（`EUD_INT_RX`）→ 读 `RX_ID` → 读 `RX_LEN` →
  burst 读 `len` 次 `0x14`，中间不再查状态位；`MAX_FIFO_SIZE 14`。
* QUIC 官方主机库规范（`E:\eud-host\quic-eud\src\com_api.cpp`）：
  *"poll device for data. if you get data, byte 0 is Exec Env ID. byte 1 is how many
  bytes data. remaining bytes are data."* —— 门控只到"有没有数据"这一层。

**逐字节门控是本项目为绕开"burst 读会卡死 COM 块"而发明的偏离。**

主假设（未证）：这台机器的 `0x14` 装的是**整帧原始字节** `[id][len][payload…]`，
所以第 1 个字节 = `0x90`、第 2 个 = len、第 3 个才是 payload；门控位在第一次读后
被清，所以上游"读 len 次"在这台机器上只能读到头部。
→ 探针 `[90][len≥3]`（读 `len-1` 字节、逐个打印、门控清零也不放弃）就是为判定它
而写的，**尚未跑**（被 §5.1 的端口卡死挡住）。

已知的另一条线索：COM 口是**命令帧与数据帧共用**的（`com_eud.h`）：
`0`=NOP、`1`=TX_TMOUT、`2`=RX_TMOUT、`3`=PORT_RESET，形态是
`{opcode,0xFF,0xFF,0x00,0x00}`（见 `E:\eud-host\comtool.cpp`）；
数据帧首字节才是 `0x90`。设备侧按首字节分派（<4 当命令、`0x90` 当数据）。

## 7. F2 守护进程（未做）

把 §2 的 3→9 步串成无人值守循环：等 CTL → com-up → 开端口（新进程）→ 抓包 →
发帧（重发 N 次）→ 发 `[90][02]` → 等 fastboot → 刷下一个镜像 → 循环；
一轮一个日志文件。必须满足 §5.1 的端口约束，并给每一步加超时与重试。
