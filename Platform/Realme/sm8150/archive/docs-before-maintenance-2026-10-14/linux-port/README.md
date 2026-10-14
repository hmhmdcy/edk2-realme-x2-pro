# Linux 移植工作区（Realme X2 Pro / RMX1931 / samurai）

阶段151完成GPU故障收尾：当前147内核/software132加149 Mesa库保持，已复现CCU故障修复成功，暂无新增fault；150兼容候选未部署。当前15组硬件状态已整理到[HARDWARE-STATUS](docs/HARDWARE-STATUS.md)，完整交接见[检查点](../NEXT-SESSION.md)和[151会话](../sessions/151-gpu-closeout-and-hardware-handover.md)。显示、充电、音频及其它整机待办保持；以下为历史部署记录。

最新阶段149：可复现 A640 Vulkan CCU 翻译故障已修复并部署，当前 #147/software132 加 Mesa149 本地库补丁。185 次像素读回及 Settings/PM/稀疏/重放/并发验收通过，部署后新增 fault0，整机其它适配待办保持。源码补丁见 [0015](patches/0015-mesa-turnip-a640-vm-bind-iova-alignment.patch)，实际部署和限制见 [149会话](../sessions/149-vulkan-ccu-alignment-fix-and-deployment.md)。旧 rootfs132 镜像和普通 Mesa 包更新不包含本地改动；以下为历史阶段。

当前操作规则：[WORKING-BOUNDARIES](../WORKING-BOUNDARIES.md)。用户已撤销其余临时禁令；下方历史中的GPU禁测、固定时序、只读、禁复用及禁提交推送等条款不再适用。硬件状态和既有失败记录仍保留。

当前阶段145收尾：阶段145已只刷logdump并实际启动，系统/模块仍为132；boot/logdump回读、实际设备树、770模块、GPT18、persist及NV/原厂来源校验通过。Phosh/Phoc存在、taint0，累计DPU0/DSI0/GPU0/WARN0/TXprepare9，显示空闲，未做GPU专项负载。启动追踪未取得结果，未确认启动链根因；失败证据已封存，本轮临时开机服务已移除，k145-startup实例不存在。显示、GPU和充电均未新增验收成功。本轮按用户要求收尾并交接，完整适配目标仍未完成。

详见[实际部署与收尾](../sessions/145-dsi-deployment-and-session-closeout.md)。以下为按时间保留的历史记录，旧版本状态不能作为当前操作依据。

最新阶段144：阶段144：确认143重启路径把F1日志入队后立即关闭EUD，实际函数宿主模型复现未发送回执和关闭后TTY写硬件两项回归。新补丁26项测试在普通编译及ASAN/UBSAN下通过，驱动W=1编译无警告；完整镜像链接中断，工作盘约120MiB可用，未产出144镜像、未部署。构建树源码144，残留Image仍为拒收143；手机仍为回退140/software132。140/143亮屏快照五项关键时钟相同，但143有171条status=c欠载记录，动态带宽/触发时序未证明。显示、136迟发CCU GPU、充电控制保护均未验收，goal active。

详见[阶段144](../sessions/144-eud-reboot-handoff-and-display-clock-review.md)。以下为此前历史。

最新阶段143：阶段143线程化EUD候选已编译并实测：16项实际函数宿主测试通过，77字节日志调用0.540ms（旧140为73.346ms），异步发送期间CPU0有36次中断、最大事件空档6.417ms。97.563秒无丢失启动追踪DPU0，却有持续DSI FIFO/MDP欠载；恢复到启动管理器时F1确认回执缺失，候选拒收。已只刷logdump回退#140/software132，boot/logdump/liveDT/GPT18/persist/770模块及来源全通过；临时服务和自建trace已移除。回退后28.690秒8次观察桌面PID、taint0与计数不变，累计DPU0/DSI0/GPU0/WARN0/TXprepare9。显示、136迟发CCU GPU和充电控制保护仍未验收，goal active。

详见[阶段143](../sessions/143-threaded-console-live-regression-and-rollback.md)。以下为此前历史。

最新阶段142：阶段142仍为#140/software132，同内核重启一次、未写分区。96.948秒启动追踪无丢失，一个完整显示超时窗口的PP回调95.652ms、CPU0事件空档69.943ms；另一次超时早于新增追踪。空档与Q6 ready日志吻合，EUD同步日志A/B实测73.346ms对0.211ms，CPU0最大空档73.307ms对0.431ms，两条记录均保留在dmesg，配置已恢复、无新增错误。已确认控制台长延迟，原始显示故障完整因果仍待驱动修复验证。boot/logdump/liveDT/GPT18/persist/770模块及来源均通过；临时服务和两个自建追踪实例已移除。随后28.641秒8次被动观察PID/taint/计数不变，累计DPU2/DSI0/GPU0/WARN0/TXDMA0。显示、136迟发CCU GPU故障、充电控制保护及完整系统目标仍未验收。

详见[阶段142](../sessions/142-startup-irq-gap-and-eud-console-latency.md)。以下为此前历史。

最新阶段141：阶段141实际仍为#140/software132，普通亮屏53.835秒观察无新增错误；同一内核受控重启一次、未写分区。新启动86.699秒追踪保留两次显示超时完整窗口、无丢失，帧完成回调在91.018/95.291ms到达，83ms看门狗保持。桌面1869次GPU提交/刷新/退休对应、无fault，不能替代136专项迟发CCU故障的验收。首次TX诊断确认state=DOWN且channel为空，前有PDR监听超时和SSR唤醒失败；BAM分配失败/挂起拒绝诊断未出现。实际boot/logdump/liveDT/GPT18/persist/770模块及来源全通过；随后28.564秒8次观察桌面PID、taint0及计数不变，累计DPU3/DSI0/GPU0/WARN0/TXprepare9。显示、GPU、充电与完整系统目标仍active。

详见[阶段141](../sessions/141-normal-wake-and-loss-free-startup-display-trace.md)。以下为此前历史。

最新阶段140：当前实际#140/software132：保留139未提交TX回收，只增加首次NULL/BAM分配失败/挂起拒绝诊断，没有修改挂起顺序或GFP策略。139实际函数注入12项通过，100次失败后仍可发送，较早在途槽位与TID/PM回收保持。140四件套、770模块/DTB原字节和实际boot/logdump/liveDT/GPT18/persist/NV来源校验全通过，只刷logdump。140本次无TX DMA失败，三条诊断均未触发，不能证明根因已修。启动观察DPU1→4、桌面自主恢复；随后28.622秒8次被动观察，计数/PID稳定=True，累计DPU4/DSI0/GPU0/WARN0/DMA0，taint0。显示、GPU延迟CCU和充电控制保护仍未验收，完整系统goal active。

详见[阶段140](../sessions/140-first-dma-diagnostics-and-display-startup-timeouts.md)。以下为此前历史。

最新阶段139：阶段139实际加载#139/software132，NGD未提交DMA失败的槽位/completion/TID与PM回收已修；从132只改两SLIMbus文件，136/137增量撤出候选。实际函数宿主注入12项通过：原31次失败耗尽，修复后100次失败仍可继续有效发送；较早在途槽位与直接user所有权保持。770模块/DTB原字节、四件套及实际boot/liveDT/GPT18/persist/NV来源全部通过，只刷logdump。桌面自主恢复，28.692秒8次PID/taint0/错误计数不变；累计DPU2/DSI0/GPU0/WARN0/TX prepare70，仍不是无报错或整机验收。70次启动期prepare失败后codec再完成探测、未出现队列满/发送超时，但首NULL原因未证明。当前rootfs132936包/770模块不变，无134 USB额度驱动；GPU延迟CCU/显示启动timeout/充电控制保护仍待办。完整系统goal active。

详见[阶段139](../sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)。以下保留此前历史。

阶段136已构建/部署默认关闭的GPU legacy VM映射与切换追踪，固定800×600像素单项通过但仍两次CCU READ TRANSLATION。故障页表内44次映射操作不覆盖故障地址，7个转储BO均精确匹配自身映射；故障比最近颜色BO低32KiB，不能由另一页表数值地址相同推断跨进程访问或释放后使用。离线估计停在CCU resolve/提交收尾，非根因；OEM与当前A640的UBWC3/HBB15契约相符，未改GPU命令、全局debug、缓存刷新或分配对齐。阶段137补入上游WCD934x资源清理和首次DMA失败诊断，770模块/DTB原字节及四件套验证通过并实际只刷logdump。该boot无WCD/DMA告警、taint0，却大量DSI FIFO/MDP下溢和DPU3，候选拒绝，不能证明音频根因已修。已排空服务、freeze/F1各一次并只刷logdump回退#132，boot/logdump/liveDT/GPT18/persist/770模块/11来源全通过；桌面自主恢复，28.692秒8次守卫PID/taint0及计数不变，累计DPU3/DSI0/GPU0/WARN0/DMA0，仍未验收持续显示或整体GPU。阶段138只读24次寄存器交易并恢复同一MP2650观测客户端，配置与133全相同；原厂DT及REG07均2节，REG04=68得到整包目标8.725V/恢复阈值8.525V，实际8.624→8.547V仍高于恢复阈值、REG13为charge termination；零或小电流不证明充电故障，也不证明充电控制完成。当前仍为匹配rootfs132、无134 USB额度驱动；保护链、失联行为与持续充电控制待办，userdata未全量刷入。15组与完整系统goal active。

当前交接：[NEXT-SESSION](../NEXT-SESSION.md)。下方为历史状态。

2026-10-11 rootfs 进展：用户选择 userdata/F2FS，已制作 ARM64 console rootfs 和配套原生内核候选，离线文件系统及 sparse 校验通过，尚未刷机。镜像、启动衔接和实机验收边界见 [F2FS 镜像说明](docs/ROOTFS-F2FS-IMAGE.md)。以下硬件状态保留原有实测记录。

当前连接状态：[session108](../sessions/108-display-flicker-and-panel-state-handover.md)，[下一阶段](../NEXT-SESSION.md)。
手机仍为Linux #106（阶段107镜像）；阶段108只做诊断、一次正常DRM开关屏和一次同镜像暖重启，没有构建新内核或刷分区，实际内核源码/config/DTB/CPIO/boot/logdump保持。
用户确认白底不规律滚动花屏；故障现场持续DSI status=c（FIFO/MDP FIFO下溢）、显示完成超时累计2。单次DRM开关屏虽然ioctl返回0，但用户确认黑屏；日志有DCS关屏/睡眠-110及already prepared/enabled。面板驱动断电后返回传输错误，使DRM core保留状态并跳过重新开启，状态处理缺陷已定位、尚未修复；不能把这次开关屏记为通过。
同镜像重启后用户确认黑底Linux命令行可见；405.44秒检查点DSI错误0、显示超时0、双DSP running、taint0。只证明本次命令行恢复，未复查纯白光学画面，未证明首次接管/长稳或永久修复。
新boot自动radio初始化auto0、三个modem服务公告result0、真实PD/固件/RAM COW请求和trace无丢失通过，无手动MPSS恢复。5GHz关联未在60秒窗口完成，后来COMPLETED/5180；最终DHCP和DNS有结果，但网关0/3、HTTP20秒终止且无正文，当前数据复测失败。107的5GHz全流程成功仍是历史证据；2.4GHz577B内容到达但wget收尾超时也保留，本轮未重测2.4GHz。
下一轮使用kernel109新前缀/新bootID/新完整备份，优先修SOFEF03F超时断电后的状态生命周期，再查DSI下溢及5GHz新启动数据失败；不盲目重复开关屏。蓝牙停止不配对，振动按用户要求只看日志/代码，NFC仅控制器，充电收尾保持；Android/data/GPT/NV/persist/SSH/rootfs01/F2FS与旧显示85–88快照保留，私人凭据/身份/固件/原日志/镜像不公开，不提交推送；全硬件goal active。

硬件功能清单：[HARDWARE-STATUS](docs/HARDWARE-STATUS.md)。


前次只读诊断：[session70](../sessions/70-pm8009-resource-and-touch-prerequisites.md)。
85404字节完整日志及cmd-db/状态副本校验通过；PM8009无F资源/DT供电消费者，降为P3。
GENI/RMI4及i2c17前提尚未启用，触摸未进入正常探测；本轮无源码变更或刷机。
logdump离线镜像空闲36737024字节，仍无已确认的大持久rootfs分区。

前次只读诊断：[session69](../sessions/69-usb-gadget-state-and-eud-coordination-audit.md)。
69499字节设备保存dmesg哈希/CRC通过；UDC/configfs存在但未配置普通USB功能。
实际legacy glue/VBUS override已核对，EUD与普通USB共存尚未验证；无内核修改/刷机。

前次内核修复：[session68](../sessions/68-firmware-dtb-and-cpu7-opp-verified.md)。
仅更新boot固件DTB，live CPU7新OPP/调频表/max2956800已通过，原启动报错消失。
同 #60 Image/config/init，完整52842字节日志哈希/CRC通过、taint=0，UDC仍在。
高频负载/实际USB通信待验。0006补丁保留原candidate文件名，其实际固件部署本轮已验证。
前次 `kernel67-builtins.config` 只有SM8150 HS PHY的m->y；EUD/PON/bootargs镜像同步
来自既有实际树，非本轮改动。不重复只换FAT DTB的无效部署。
COM14 已释放给 Windows；不运行旧 build-image.sh，真实 initramfs 与 EUD 修复保留。

前次已验证内核修复：[session66](../sessions/66-verified-kernel-logs-and-builtins.md)。
校验完整日志后依次内建 OSM L3、ADC5/VADC_COMMON，修正 earlycon CSR 的临时映射。
真机 #59 已有 CPU policy0/4/7 和三路 PMIC 温度，taint=0，完整 dmesg 的设备哈希/CRC
通过；CPU7 2956800 kHz OPP 与 USB deferred 仍待查。配置增量是
`kernel66-builtins.config`，映射补丁 `patches/0005-eud-early-csr-mapping.patch` 针对实际
earlycon 基线 SHA `f0de320d4028d180099d0251b115371ca68bc84b51757910e6b0cdf94a9ddd53`，
不直接 git am 到旧 0001。实测前后源码与构建脚本见 `../reference/kernel66`；不要
运行旧 build-image.sh 或用落后的 Windows initramfs 覆盖实际 WSL initramfs。
rootfs 保留 Android/全部数据的结论见 [ROOTFS-PRESERVE-ANDROID](docs/ROOTFS-PRESERVE-ANDROID.md)。

> 2026-10-09 session 41：`eud.c` 接入实际 SM8150 SOUTH AHB2PHY TOP_CFG=0x11
> 并验证回读，在 TX 锁内一次读取整帧，读完才记录回执/投递 tty。UEFI 跨重启和 Linux
> 的 ABC/DEFG 均正确；原生多字节 shell 赋值已执行。len=2 保留 F1，len=1、3..14 为 tty。
> 源码、实测、镜像与输出限制见 [session 41](../sessions/41-rx-ahb2phy-wait-state-fix.md)。
> patches/0004 是针对已验证 rx33 eud.c 的增量；此前 patches/0003 不是当前完整驱动。
> 0004 为零上下文补丁，先核对 session 41 的基线源码 SHA256，再用 `git apply --unidiff-zero`
> 或 `patch -p1`；本轮已对原源码做 dry-run。

终端 `scripts/eud-terminal.cmd`（副本 E:\eud-host\）默认按单字节回执发送，
兼容当前驱动；`-Native` 启动先 Ctrl-U 同步，持续打开串口，发送最多 14 字节原生帧，
两字节尾片拆成 1+1，命令帧不重试。交互与重启验证见
[session 47](../sessions/47-native-terminal-session-boundary.md)。原生帧也可用 `scripts/eud-step.ps1` 单步测试，finally 关闭串口；
`-RetryJitterMs 800` 仅改变有界重试时间，不保证所有 OUT 都受理。
不要使用旧 build-image.sh 重建 initramfs；本轮保留真实 WSL initramfs 和原 DTB。

历史交接见 [session 49](../sessions/49-usb-in-and-partial-timeout-audit.md)。当轮不改内核、
未刷机或重启手机；持续 libusb 的 CRC 发送记录与全部 IN/raw 对应，部分取消数据
实测保留，但未重现旧缺字或触发宽限。Windows 原生终端已恢复、COM14 关闭。
诊断变更见 [session 48](../sessions/48-irq-grace-and-tx-journal.md)。本 eud.c 为 RX48 B
诊断：保留 SPI 492/hwirq 524、RX-only 掩码、整帧 IRQ 缓存、工作上下文 tty/F1 和
TOP_CFG=0x11；watchdog 首次 pending 留给 IRQ 服务，100 ms 持续未受理才退回轮询。
只读 irq_watch/irq_state 与带 CRC 的 binary tx_journal 提供新证据边界。实测 512 个
已发 TX 记录全部匹配 raw，30 行输出/兼容/F1/重启正常，但 waits=0，宽限分支未验证。
兼容 startup 仍需一次重试，RX47 的真实缺字/退回及更早缺回执不作撤回。
稳定性仍未解决；立即回退为 RX46 B，更早回退为 RX44。仅刷 logdump，init/DTB 不变。
`scripts/eud-etw-step.ps1` 用内置 USB ETW 对照主机 OUT/完成，需管理员权限；
语法核对和实际抓包结果见 session 46；RX47-49 没有新管理员 ETW 抓包。
端点 reset 的目标事件另存 reference/rx47，物理 DATA0/1 未测。所有设备 ETL 保留本地，不直接入库。
RX45 已排除仅掩码方案；不要原样重复。

计数边界见 [session 44](../sessions/44-rx-receipt-counters.md)。当时 eud.c 在 RX41
硬件方法上增加只读 sysfs 接收计数，Ctrl-U 回执也含计数；没有改动 FIFO 顺序、20 ms
轮询或正常原生帧回执。诊断镜像仅更新 logdump；失败输入没有增加 pending/坏帧头/tty
计数，成功 echo 的帧/字节准确。根因仍未定位，不能把诊断称为稳定性修复。

上一轮审查看 [session 43](../sessions/43-native-terminal-evidence-audit.md)。
payload 推进的修复使用真实整帧，不依赖临时终端逐字发送。RX41 数次“缺输出”经
原始抓取核对撤回；Windows/libusb 的新原生命令也返回了完整输出。偶发缺回执仍未解，
已核对其在 RX 日志之前的边界，下一步需要 USB/EUD/STATUS1 的新受理证据。

全新开始，不使用 `E:\Realme X2 Pro移植主线Linux`（旧工程已废弃；它的准确性核实
结论见 [docs/OLD-PROJECT-VERIFICATION.md](docs/OLD-PROJECT-VERIFICATION.md)，
里面有 3 处**必须丢弃**的错误写法）。

## 位置

- WSL 源码树：`/home/cy122/x2pro-linux/linux`（git 基线 + 改动，无 remote）
- WSL 补丁：`/home/cy122/x2pro-linux/patches/`
- 本目录：设备树源码、补丁、脚本与可复核产物（`dts/ patches/ artifacts/ scripts/ docs/`）

## 源码来源（可独立校验）

- Linux v7.3-rc6, commit `a90ee4305c4a5df72c11b31dacfdc76e00fcf78a`
- sha256 `0ee910353dee732a3f1517750dc58cbd6ba8026d6e4e1c5ae7e2a4a2d2829766`
- 基线提交：`baseline: Linux v7.3-rc6 pristine`

## 已完成

### 1. EUD earlycon —— 提交 `e4858b30a`

`drivers/tty/serial/eud_earlycon.c`（100 行），Kconfig / Makefile 已注册。
编译通过；`checkpatch --strict`：0 errors / 0 warnings / 0 checks。
补丁：`patches/0001-tty-serial-add-Qualcomm-EUD-COM-early-console.patch`。

内核命令行：

    earlycon=eud,mmio,0x88e0000

PC 侧：`eudtool.exe com-up` 让 9505 COM 枚举，再用 `comlog.exe` 之类帧重组工具读取。

**为什么必须自己写**

- 主线 `drivers/usb/misc/qcom_eud.c` 只是 USB 角色切换驱动，不提供 console。
- 厂商 4.14 的 `drivers/soc/qcom/eud.c` 注册 `ttyEUD` 可当 console，但要驱动模型
  probe，只能在内核后期出日志，正好错过黑屏最常见的早期阶段。
- earlycon 在 `parse_early_param` 阶段工作，早于驱动模型，所以必须自写。

**设计要点**

- EUD COM 是寄存器 FIFO（TX_ID / TX_LEN / TX_DAT），非 8250 兼容，故组
  `[0x90][LEN][DATA]` 帧。
- 帧长 6 字节，逐帧轮询 `INT_STATUS_1` bit1（原厂 `eud_tx_empty` 用的同一位）流控；
  轮询有上限。
- 定时器未校准，不能用 `udelay`，只能有界轮询。
- setup 写 `CSR_EUD_EN`（幂等）：EDK2 路径固件已开，Android 引导链完全不开。
- 故意不写 `INT1_EN_MASK`，避免在中断控制器就位前武装中断源。

### 2. samurai 主线设备树 —— 提交 `31491583b`

源码：`dts/sm8150-samurai.dts`（进树路径
`arch/arm64/boot/dts/qcom/sm8150-samurai.dts`），补丁
`patches/0002-arm64-dts-qcom-add-realme-samurai-X2-Pro-bring-up-description.patch`。

- 以 `sm8150-mtp.dts` 为底板：本机原厂基础 DTB 自称
  `Qualcomm Technologies, Inc. SM8150 v2 SoC` + MTP board-id，本身就是 MTP 派生，
  PM8150 稳压器拓扑可以直接用。
- 按实机重写 reserved-memory：21 个保留区，逐项对齐运行中 `/proc/device-tree`
  与原厂 DTBO，核对表见 `artifacts/reserved-memory.txt`。
- 音量键按实机：`&pm8150_gpios` 6/7、active-low、`bias-disable`、`power-source = <1>`、
  115/114、15 ms；禁用 MTP 的 `&pon_resin`。
- UFS 保持 MTP 的 `vccq2 = &vreg_s4a_1p8`（实机 DTBO 写的也是 `pm8150_s4`；
  旧工程改成的 L7A 是错的）。
- ramoops 地址沿用实机的 `0xb7e00000`，几何按 bring-up 用途重写（去掉主线不支持的
  `devinfo-size`）。
- GPU / WiFi / 四个 remoteproc / uart2 一律 `disabled`，等能验证时再说。
- binding：`qcom.yaml` 增加 `realme,samurai`，`vendor-prefixes.yaml` 增加 `realme`。

构建与产物：

    make -s ARCH=arm64 qcom/sm8150-samurai.dtb
    # artifacts/sm8150-samurai.dtb
    # 94623 字节, sha256 1c760ec9cf74389c246e1b64a032c52910f6437dab29772371a506ead5d67b81

`dtbs_check` 没跑（WSL 里没有 dtschema）；`qcom,msm-id` / `qcom,board-id` /
`oppo,dtsi_no` 是有意保留的厂商属性（走 Android 启动链时 ABL 需要），它们会产生
schema 警告。

## 重要发现：EDK2 现在给内核的 DTB 是小米 9 的

`Platform/Realme/sm8150/FdtBlob/samurai/sm8150-realme-samurai.dtb`
（91012 字节，sha256 `7755cd89…`）反编译出来是：

    model = "Xiaomi Mi 9";
    compatible = "xiaomi,cepheus", "qcom,sm8150";

还带着 cepheus 的 `simple-framebuffer@9c000000` 和 `stdout-path`。也就是说
"DTB passed ✅" 这一项目前是把**别的机器的设备树**交给 Linux。新 DTB 应当替换它
（替换属于 EDK2 侧改动，需要重建 boot.img 并刷机，尚未执行）。

## 建议用 EDK2 启动该内核

固件在 BDS 已开 EUD，主机可在固件菜单界面提前打开 COM14，消除"内核已崩而主机
尚未 attach"的竞态；内核做成 EFI stub 由 EDK2 加载。

## 进度与下一步

**第 1 步（诊断内核）已完成**：配置以旧工程的 `bringup.config` 为基线（它本身
**没有** `CONFIG_EFI`/`CONFIG_EFI_STUB`），另加 EFI stub、EFI 配置表 DTB 支持
（`EFI_ARMSTUB_DTB_LOADER`）、EFI GOP 帧缓冲控制台（`SYSFB_SIMPLEFB + DRM_SIMPLEDRM +
FRAMEBUFFER_CONSOLE`，让内核日志能直接上手机屏）、`SERIAL_EUD_EARLYCON=y`、
`PSTORE_RAM=y`，并内置一个诊断 initramfs（busybox，只打印 CPU/内存/块设备/UFS/
帧缓冲然后挂起）。GPU/WiFi/remoteproc 继续关闭。产物：

    Image  30,116,352 字节  sha256 3d5665abcf53b1b97ee5b2c32b4aaaee45265a4c45af99463b4d3c2b35427ba3
    kernelrelease = 7.3.0-rc6-rmx1931-samurai+

**第 2 步（换 DTB + 把内核装进固件）已完成**，详见
[docs/EDK2-KERNEL-EMBED.md](docs/EDK2-KERNEL-EMBED.md)（EDK2 仓库提交 `47c3efb`）：

    boot-samurai-linux-cmdline.img  15,185,920 字节  sha256 0d1ec54656fed0550a90ac8453918a8d589d93ed890914959ffba31f2b0a3439
    （E:\edk2-samurai-out\，另有裸 FD 与 Image）

⚠️ EDK2 仓库里的 `Platform/Realme/sm8150/LinuxKernel/Image` 是**构建产物、未入 git**。
全新 clone 后要先把它拷回去（[artifacts/Image-rmx1931-samurai](artifacts/Image-rmx1931-samurai)
或 `E:\edk2-samurai-out\Image-rmx1931-samurai`，sha256 `3d5665ab…`），或按
[scripts/build-image.sh](scripts/build-image.sh) 重编，否则 `./build.sh -d samurai` 会失败。

**第 3 步（真机验证）待办**：手机当前未连接。步骤：

```powershell
# 1) 主机先备好 EUD 日志通道（重启后 9501 出现时执行）
E:\eud-host\eudtool.exe com-up
E:\eud-host\comlog.exe COM14 600 E:\eud-host\samurai-linux.log
# 2) 刷入并重启
fastboot flash boot E:\edk2-samurai-out\boot-samurai-linux-cmdline.img
fastboot reboot
# 3) 屏幕出现 UEFI 菜单后，用音量键选到 "Linux (mainline samurai)"，电源键确认
# 4) 看 comlog 里是否出现 "Booting Linux on physical CPU …" 等早期日志
# 回滚（EUD 开着时 USB 被占用，必须先长按电源 15 s 彻底断电）
fastboot flash boot E:\edk2-samurai-out\backup\boot_stock_RMX1931.img
```

验收标准：comlog 里出现内核 earlycon 输出（8 核、内存、UFS、initramfs 横幅），
而不只是 EDK2 菜单或黑屏。

其余未做：panel（SOFEF03F_M，已拿到下游 806 行 init 序列）、触控（S3706，接线已
拿到）、WCN3990、充电、持久变量、SWD/JTAG。

## Android 设备树参考（refs/19781/）

本机是 OPPO/realme 的"项目号 19781"，官方 AndroidR 内核里
`arch/arm64/boot/dts/19781/` 就是它的设备树源码，其中 `sm8150-mtp.dtsi` 是板级文件。
这份源码（旧工程留下的 187 MB 浅克隆，可离线读取）已挑出关键文件放进
[refs/19781/](refs/19781/)：按键/UFS 用它复核过（与主线 DTS 一致），触控与面板的
接线、时序从里面拿到了。评估、映射表和坑见
[docs/ANDROID-DT-REFERENCE.md](docs/ANDROID-DT-REFERENCE.md)。

## scripts/

| 脚本 | 用途 |
|---|---|
| `install-samurai-dts.sh` | 把 `dts/sm8150-samurai.dts` 装进 WSL 树、注册 binding、编译、提交、生成补丁 |
| `verify-samurai-dtb.sh` | 反编译新 DTB、导出 reserved-memory 核对表、识别 EDK2 现有占位 DTB |
| `test-old-dts.sh` | 核实旧工程：应用旧补丁并复现它的 DTB（应得 `f0c3a820…`） |
| `dump-live-dt.sh` | 解包实机 `/proc/device-tree` 转储，导出 ramoops / reserved-memory 真值 |
| `collect-artifacts.sh` | 整理补丁编号、把补丁/DTB/核对表复制回本目录 |
| `patch-bootmanager-cmdline.py` | 把内核命令行做成 boot option 的 LoadOptions（HANDOVER-NEXT.md §19） |
| `build-cmdline-firmware.sh` | WSL 里重编 samurai 固件 |
| `verify-cmdline-firmware.py` | 离线核对 LoadOptions / 启动项 / FD / boot.img |
| `archive-cmdline-firmware.sh` | 归档产物到 `E:\edk2-samurai-out\` 并提交 |

## 2026-10-07（下午）：内核命令行进了 LoadOptions

`boot-samurai-linux.img` 之后多了一个超集 **`boot-samurai-linux-cmdline.img`**
（sha256 `b9fb2064…`）：启动项 "Linux (mainline samurai)" 现在把与设备树逐字相同的
内核命令行作为 LoadOptions 一起传进去，设备树万一没带 bootargs 也不会黑屏静默。
改动、证据与真机步骤见 `HANDOVER-NEXT.md` §19（EDK2 提交 `c2a3697`）。

**第 3 步真机验证仍未做**：本轮手机没有连接（`adb devices` 为空、Windows 上没有
`VID_05C6`），所以只做了离线加固与验证。手机接上后刷的是
`boot-samurai-linux-cmdline.img`，步骤同上面第 3 步。
