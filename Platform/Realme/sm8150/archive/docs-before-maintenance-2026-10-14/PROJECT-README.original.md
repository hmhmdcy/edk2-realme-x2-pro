# EDK2 / UEFI firmware for the realme X2 Pro (RMX1931 · "samurai")

阶段151已完成GPU故障收尾与交接：保留147内核及149 Mesa修复，已复现CCU故障修复成功；同boot、修复库、桌面与taint0保持，无新增fault。150降级候选未部署。当前剩余硬件与软件维护见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)、[检查点](NEXT-SESSION.md)和[151收尾](sessions/151-gpu-closeout-and-hardware-handover.md)。包数据库摘要变化单独记录，整机适配仍未完成。以下为部署依据和历史。

最新阶段149已修复并实际部署可复现的 A640 Vulkan VM_BIND CCU 翻译故障。手机为 #147/software132 加 Mesa149 本地库补丁；未刷分区、未重启。原驱动及同构建基线各首轮失败，完整 core 与映射/命令确认图像前方 8 KiB 未映射读取；64 KiB 自动 IOVA 对齐修复库完成 185 次像素读回、36 次 Settings 面板切换、PM/稀疏/旧地址重放与 Vulkan/GLES 并发验收，部署后新增 fault0、taint0、物理桌面保持。13 条收据的 3 条失败及工具限制均保留。普通 Mesa 包更新可能覆盖本地补丁，旧 rootfs132 镜像不含此次更新。详见 [149修复与部署](sessions/149-vulkan-ccu-alignment-fix-and-deployment.md)、[补丁和收据](reference/kernel149/README.md)及 [当前检查点](NEXT-SESSION.md)。下方旧阶段描述为历史。

当前操作规则：[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)。用户已撤销其余临时禁令；下方历史中的GPU禁测、固定时序、只读、禁复用及禁提交推送等条款不再适用。硬件状态和既有失败记录仍保留。

当前阶段148已按用户要求收尾：手机保持#147/software132，Vulkan VM_BIND修复尚未完成。阶段147限定GLES验收后，GNOME Settings新增CCU READ TRANSLATION，累计GPU fault为1。已隔离编译Mesa 26.2.4基线和A640自动IOVA采用64KiB对齐的候选；36条测试记录中32条返回成功、4条失败如实保留，没有新增fault。原始新故障尚未复现，候选未替换系统驱动。捕获窗口、测试进程及临时GPU追踪均已结束，证据持久归档并清理重复临时文件。详见[148调查](sessions/148-vulkan-vm-bind-diagnostic-candidate.md)和[候选与收据](reference/kernel148/README.md)。

阶段147历史验收：A640旧式内核管理GPU VM采用64KiB IOVA起点对齐，修复当时复现的GMEM迟发CCU fault。只刷logdump部署#147/software132；20次800×600像素验证和6次1080×2259连续绘制，逐次退出35–90秒观察无fault，taint0，GPU/WARN/DPU/DSI/DMA错误计数均0。770模块、config/DTB与原厂来源保持；该限定GLES验收不覆盖后来出现的新Vulkan故障。

详见[147修复与验收](sessions/147-a640-gmem-alignment-fix.md)与[补丁和报告](reference/kernel147/README.md)。下方为历史记录，不能作为当前状态依据。

当前阶段145收尾：阶段145已只刷logdump并实际启动，系统/模块仍为132；boot/logdump回读、实际设备树、770模块、GPT18、persist及NV/原厂来源校验通过。Phosh/Phoc存在、taint0，累计DPU0/DSI0/GPU0/WARN0/TXprepare9，显示空闲，未做GPU专项负载。启动追踪未取得结果，未确认启动链根因；失败证据已封存，本轮临时开机服务已移除，k145-startup实例不存在。显示、GPU和充电均未新增验收成功。本轮按用户要求收尾并交接，完整适配目标仍未完成。

详见[实际部署与收尾](sessions/145-dsi-deployment-and-session-closeout.md)。以下为按时间保留的历史记录，旧版本状态不能作为当前操作依据。

最新阶段144：阶段144：确认143重启路径把F1日志入队后立即关闭EUD，实际函数宿主模型复现未发送回执和关闭后TTY写硬件两项回归。新补丁26项测试在普通编译及ASAN/UBSAN下通过，驱动W=1编译无警告；完整镜像链接中断，工作盘约120MiB可用，未产出144镜像、未部署。构建树源码144，残留Image仍为拒收143；手机仍为回退140/software132。140/143亮屏快照五项关键时钟相同，但143有171条status=c欠载记录，动态带宽/触发时序未证明。显示、136迟发CCU GPU、充电控制保护均未验收，goal active。

详见[阶段144](sessions/144-eud-reboot-handoff-and-display-clock-review.md)。以下为此前历史。

最新阶段143：阶段143线程化EUD候选已编译并实测：16项实际函数宿主测试通过，77字节日志调用0.540ms（旧140为73.346ms），异步发送期间CPU0有36次中断、最大事件空档6.417ms。97.563秒无丢失启动追踪DPU0，却有持续DSI FIFO/MDP欠载；恢复到启动管理器时F1确认回执缺失，候选拒收。已只刷logdump回退#140/software132，boot/logdump/liveDT/GPT18/persist/770模块及来源全通过；临时服务和自建trace已移除。回退后28.690秒8次观察桌面PID、taint0与计数不变，累计DPU0/DSI0/GPU0/WARN0/TXprepare9。显示、136迟发CCU GPU和充电控制保护仍未验收，goal active。

详见[阶段143](sessions/143-threaded-console-live-regression-and-rollback.md)。以下为此前历史。

最新阶段142：阶段142仍为#140/software132，同内核重启一次、未写分区。96.948秒启动追踪无丢失，一个完整显示超时窗口的PP回调95.652ms、CPU0事件空档69.943ms；另一次超时早于新增追踪。空档与Q6 ready日志吻合，EUD同步日志A/B实测73.346ms对0.211ms，CPU0最大空档73.307ms对0.431ms，两条记录均保留在dmesg，配置已恢复、无新增错误。已确认控制台长延迟，原始显示故障完整因果仍待驱动修复验证。boot/logdump/liveDT/GPT18/persist/770模块及来源均通过；临时服务和两个自建追踪实例已移除。随后28.641秒8次被动观察PID/taint/计数不变，累计DPU2/DSI0/GPU0/WARN0/TXDMA0。显示、136迟发CCU GPU故障、充电控制保护及完整系统目标仍未验收。

详见[阶段142](sessions/142-startup-irq-gap-and-eud-console-latency.md)。以下为此前历史。

最新阶段141：阶段141实际仍为#140/software132，普通亮屏53.835秒观察无新增错误；同一内核受控重启一次、未写分区。新启动86.699秒追踪保留两次显示超时完整窗口、无丢失，帧完成回调在91.018/95.291ms到达，83ms看门狗保持。桌面1869次GPU提交/刷新/退休对应、无fault，不能替代136专项迟发CCU故障的验收。首次TX诊断确认state=DOWN且channel为空，前有PDR监听超时和SSR唤醒失败；BAM分配失败/挂起拒绝诊断未出现。实际boot/logdump/liveDT/GPT18/persist/770模块及来源全通过；随后28.564秒8次观察桌面PID、taint0及计数不变，累计DPU3/DSI0/GPU0/WARN0/TXprepare9。显示、GPU、充电与完整系统目标仍active。

详见[阶段141](sessions/141-normal-wake-and-loss-free-startup-display-trace.md)。以下为此前历史。

最新阶段140：当前实际#140/software132：保留139未提交TX回收，只增加首次NULL/BAM分配失败/挂起拒绝诊断，没有修改挂起顺序或GFP策略。139实际函数注入12项通过，100次失败后仍可发送，较早在途槽位与TID/PM回收保持。140四件套、770模块/DTB原字节和实际boot/logdump/liveDT/GPT18/persist/NV来源校验全通过，只刷logdump。140本次无TX DMA失败，三条诊断均未触发，不能证明根因已修。启动观察DPU1→4、桌面自主恢复；随后28.622秒8次被动观察，计数/PID稳定=True，累计DPU4/DSI0/GPU0/WARN0/DMA0，taint0。显示、GPU延迟CCU和充电控制保护仍未验收，完整系统goal active。

详见[阶段140](sessions/140-first-dma-diagnostics-and-display-startup-timeouts.md)。以下为此前历史。

最新阶段139：阶段139实际加载#139/software132，NGD未提交DMA失败的槽位/completion/TID与PM回收已修；从132只改两SLIMbus文件，136/137增量撤出候选。实际函数宿主注入12项通过：原31次失败耗尽，修复后100次失败仍可继续有效发送；较早在途槽位与直接user所有权保持。770模块/DTB原字节、四件套及实际boot/liveDT/GPT18/persist/NV来源全部通过，只刷logdump。桌面自主恢复，28.692秒8次PID/taint0/错误计数不变；累计DPU2/DSI0/GPU0/WARN0/TX prepare70，仍不是无报错或整机验收。70次启动期prepare失败后codec再完成探测、未出现队列满/发送超时，但首NULL原因未证明。当前rootfs132936包/770模块不变，无134 USB额度驱动；GPU延迟CCU/显示启动timeout/充电控制保护仍待办。完整系统goal active。

详见[阶段139](sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)。以下保留此前历史。

阶段136已构建/部署默认关闭的GPU legacy VM映射与切换追踪，固定800×600像素单项通过但仍两次CCU READ TRANSLATION。故障页表内44次映射操作不覆盖故障地址，7个转储BO均精确匹配自身映射；故障比最近颜色BO低32KiB，不能由另一页表数值地址相同推断跨进程访问或释放后使用。离线估计停在CCU resolve/提交收尾，非根因；OEM与当前A640的UBWC3/HBB15契约相符，未改GPU命令、全局debug、缓存刷新或分配对齐。阶段137补入上游WCD934x资源清理和首次DMA失败诊断，770模块/DTB原字节及四件套验证通过并实际只刷logdump。该boot无WCD/DMA告警、taint0，却大量DSI FIFO/MDP下溢和DPU3，候选拒绝，不能证明音频根因已修。已排空服务、freeze/F1各一次并只刷logdump回退#132，boot/logdump/liveDT/GPT18/persist/770模块/11来源全通过；桌面自主恢复，28.692秒8次守卫PID/taint0及计数不变，累计DPU3/DSI0/GPU0/WARN0/DMA0，仍未验收持续显示或整体GPU。阶段138只读24次寄存器交易并恢复同一MP2650观测客户端，配置与133全相同；原厂DT及REG07均2节，REG04=68得到整包目标8.725V/恢复阈值8.525V，实际8.624→8.547V仍高于恢复阈值、REG13为charge termination；零或小电流不证明充电故障，也不证明充电控制完成。当前仍为匹配rootfs132、无134 USB额度驱动；保护链、失联行为与持续充电控制待办，userdata未全量刷入。15组与完整系统goal active。

[阶段136](sessions/136-legacy-gpu-vm-trace-and-ccu-address-correlation.md)、[阶段137](sessions/137-wcd-resource-cleanup-display-failure-and-rollback.md)、[阶段138](sessions/138-readonly-charger-recharge-threshold.md)。下方为历史状态，以当前132回退和最新验证边界为准。

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

Unofficial EDK2/UEFI port for the **realme X2 Pro (RMX1931 / RMX1931CN)**, Qualcomm
**Snapdragon 855+ (SM8150-AC)**, platform **msmnile**, codename **"samurai"**.

This repository is a fork of [edk2-porting/edk2-msm](https://github.com/edk2-porting/edk2-msm)
with a device package for *samurai* (`Platform/Realme/sm8150/`, `configs/devices/samurai.conf`).
Everything below is specific to this phone - the generic framework documentation lives in the
upstream project.

> 中文简介见文末。

---

## Status

Boot verified on real hardware (2026-10): **PEI → DXE → BDS → Boot Manager → EFI Shell**.

Previous kernel audit: [session70](sessions/70-pm8009-resource-and-touch-prerequisites.md).
Fresh 85404-byte dmesg/cmd-db pass device SHA256/gzip CRC. No PM8009 F resources
or current DT supply consumers: lower its warning to P3 without removing nodes.
Native touch lacks enabled GENI/RMI4/bus prerequisites; hardware remains untested.
Preserved logdump image has 36737024 free bytes, not a verified full pmOS layout.
No kernel changes/flash/EUD experiments; COM14 Windows/Shared, owners released.

Previous kernel audit: [session69](sessions/69-usb-gadget-state-and-eud-coordination-audit.md).
Device-saved 69499-byte dmesg passes SHA256/gzip CRC; same #60/taint0, no flash
or kernel change. UDC/configfs exist but no gadget function is configured.
Actual DWC3 legacy glue/VBUS override and EUD notification paths were audited;
ordinary USB coexistence remains untested. COM14 Windows/Shared, owners closed.

Previous kernel fix: [session68](sessions/68-firmware-dtb-and-cpu7-opp-verified.md).
The firmware DTB activates CPU7's 2.9568 GHz OPP; live DT/table/max are verified
and its boot warnings disappear. Same #60 kernel, fresh boot_id, taint0; complete
52842-byte log passes device SHA256/gzip CRC. One boot-only flash; logdump and
Android data preserved. High-frequency stress remains untested. Previous
[session67](sessions/67-usb-provider-and-dtb-activation.md) restored HS PHY/dwc3/
UDC; actual USB traffic remains untested. Session66 restored CPU policies/PMIC
temperatures and removed the early mapping WARN. COM14 returned to Windows;
EUD stability remains unresolved. [Rootfs research](linux-port/docs/ROOTFS-PRESERVE-ANDROID.md)
preserves Android and all data; no safe large partition has been established.

Previous EUD stability handoff: [session65](sessions/65-wsl-full-packet-console-overlap-and-tx-gap.md).
WSL busy-console native14/wire16 input succeeds and executes; all990 console
digits arrive. The same continuous owner still loses nine tty TX frames/36
payload bytes: valid512-record journal matches the other503 directly, complete
positive virtual IN equals raw. This gap needs neither qcusbser nor reopen;
WSL retains Windows USB/IP/lower USB. Current tty/console is not reliably
lossless and requires dedicated EUD90/LEN framing tools; generic terminals
would need a future COM/PTY bridge. Original driver/terminal/firmware and
TOP_CFG/RX53/F1/rollback remain preserved; all owners finally disposed/detached.
No flash or new driver/security setting. User now prioritizes Linux kernel
issues; EUD experiments are deferred. Use EUD as auxiliary observation and
preserve device-side critical logs with verified exports.
RX62/63 Windows candidate remains unloaded/unvalidated; the supported loading
environment and full original acceptance matrix remain separate open work.

| Feature | Status | Notes |
|---|---|---|
| UEFI boot (Boot Manager / EFI Shell) | ✅ works | reaches the shell, `map`/`blk` show all UFS partitions |
| Display | ✅ works | framebuffer text console, 5x12 font (`FrameBufferSerialPortLib`), 1080x2400 |
| Volume-Up button | ✅ works | `SCAN_UP` |
| Power button | ✅ works | |
| **Volume-Down button** | ✅ works | factory realme `ButtonsDxe` + `OppoProject` + `ResetRuntimeDxe` (see `Platform/Realme/sm8150/BINARIES.md`) |
| UFS / block devices | ✅ works | 6 LUNs, GPT, `BLK*` devices in the shell |
| USB mass storage mode (phone as a USB disk) | ✅ works | via the built-in `LinuxSimpleMassStorage` kernel (see below) |
| USB keyboard / host mode | ❓ untested | no OTG device was available during development |
| Persistent UEFI variables | ❌ not implemented | no variable store partition configured, variables are lost on reboot |
| Windows (WoA) | ❌ not ready | DSDT is currently borrowed from a Xiaomi Mi 9 (cepheus); a samurai-specific DSDT is required |
| Mainline Linux | ⚠️ partially | touch, 60 Hz panel, USB NCM/SSH, GPU rendering and dual-band Wi-Fi tested; Bluetooth scanning and NFC controller tested; [remaining hardware](linux-port/docs/HARDWARE-STATUS.md) |

---

## The device

| | |
|---|---|
| Model | realme X2 Pro (RMX1931 / RMX1931CN) |
| Codename | **samurai** |
| SoC | Qualcomm **Snapdragon 855+** (SM8150-AC), msmnile |
| PMICs | PM8150 / PM8150L / PM8150B (SPMI) |
| RAM | 8 GiB (also sold with 12 GiB) |
| Storage | UFS 3.0, 6 LUNs, GPT |
| Display | 6.5" 1080x2400 Super AMOLED, 90 Hz (Samsung `sofef03f_m`) |
| Bootloader | realme/OPPO ABL (XBL). Unlocked bootloader required. **No `fastboot boot` support** - the image has to be flashed. |

---

## What this fork changes

```
configs/devices/samurai.conf                     device config (mkbootimg: header v1)
Platform/Realme/sm8150/samurai.dsc               platform DSC (PCDs, build options)
Platform/Realme/sm8150/samurai.fdf.inc           per-device FFS components (DXE drivers, ACPI, DTB)
Platform/Realme/sm8150/FdtBlob/samurai/*.dtb     mainline DTB  -> handed to Linux via the EFI configuration table
Platform/Realme/sm8150/FdtBlob_compat/samurai.dtb vendor DTB   -> appended to the boot image (ABL builds the runtime DTB from it)
Platform/Realme/sm8150/AcpiTables/samurai/DSDT.aml  (currently borrowed from cepheus)
Platform/Realme/sm8150/README.md                 device-level notes
```

Nothing else in the upstream tree is modified - no patches to PEI/DXE core, no BootShim changes.

### Device blobs

The per-device DXE drivers are Qualcomm/realme firmware. They ship with this
fork: the `Platform/EFI_Binaries` submodule points at
`hmhmdcy/edk2-msm-binary` branch `samurai-blobs`, so a recursive clone is enough:

```bash
git clone --recursive https://github.com/hmhmdcy/edk2-realme-x2-pro.git
```

They live in `Platform/EFI_Binaries/Drivers/Devices/samurai/`:

```
DALSys/DALSys.{efi,depex}                 UsbPwrCtrlDxe/UsbPwrCtrlDxe.{efi,depex}
ButtonsDxe/ButtonsDxe.{efi,depex}         TLMMDxe/TLMMDxe.{efi,depex}
ResetRuntimeDxe/ResetRuntimeDxe.{efi,depex}
OcdtDxe/OppoProject.{efi,depex}
```

`Platform/Realme/sm8150/fetch-binaries.sh` can re-create the same set from public
mirrors if you prefer to extract them yourself; `Platform/Realme/sm8150/BINARIES.md`
documents the sources and the required DEPEX patch.

## Building

```bash
git clone --recursive https://github.com/hmhmdcy/edk2-realme-x2-pro.git
cd edk2-realme-x2-pro
./build.sh -d samurai --toolchain GCC5
```

Output:
- `boot-samurai.img` - flashable Android boot image
- `workspace/Build/samurai/RELEASE_GCC5/FV/SM8150_UEFI.fd` - raw firmware volume

Host notes (Ubuntu, no sudo needed):
- On very new host GCC (e.g. GCC 15) BaseTools/Pccts fail with the default C23
  standard: append `-std=gnu17` to `GCC_AARCH64_CC_FLAGS` in `tools/tools_def.txt`
  (`build.sh` copies that file into `Common/edk2/Conf/`).
- `BaseTools` must be built once: `make -C Common/edk2/BaseTools -j$(nproc) BUILD_CC="gcc -std=gnu17"`.
- `uuid-dev` and `msgfmt` may have to be provided locally if you have no root.

---

## Flashing / testing

```bash
# ALWAYS keep a verified backup of your stock boot partition first:
fastboot flash boot boot_stock_RMX1931.img     # rollback

# flash the port:
fastboot flash boot boot-samurai.img
```

The realme/OPPO ABL does **not** implement `fastboot boot` (`FAILED (remote: 'unknown command')`),
so a temporary boot is not possible - you have to flash, and keep a backup for rollback.

To enter fastboot when the phone is stuck: hold **Power** for ~15 s to force power off, then hold
**Volume-Down + Power**.

---

## How the port works (porting notes for other SM8150 devices)

1. **Boot chain.** ABL loads the boot image "kernel" (which is `BootShim.bin` followed by the
   concatenated UEFI FD), jumps to it with `x0` = DTB, and BootShim copies the FD to
   `FD_BASE = 0xCE000000` and jumps into UEFI. PEI reads the runtime DTB from the address stored in
   `PcdDeviceTreeStore` (`0x9E000000`) to decide the memory size (4/6/8/10/12 GiB) and therefore
   which branch of the platform memory map is used.
2. **The boot image must keep the project default layout**:
   `header v1 + gzip(BootShim.bin + SM8150_UEFI.fd) + appended FdtBlob_compat/samurai.dtb`.
   Deviating (uncompressed payload, header v2 with a separate dtb section, or no appended DTB)
   makes ABL return to fastboot or hang. Do not override `platform_build_kernel` /
   `platform_build_bootimg` in a device `*.sh.inc`.
3. **Framebuffer console - the `0x9D000000` trap.** With `USE_UART=0` (default) the platform uses
   `Silicon/Qualcomm/QcomPkg/Library/FrameBufferSerialPortLib`, which draws *all* DEBUG output
   into the framebuffer with a 5x12 font. It uses `PcdMipiFrameBufferAddress`, whose platform
   default is `0x9C000000` (Xiaomi/OnePlus layout). On samurai the live framebuffer is at
   **`0x9D000000`**, so with the default value the log is written into invisible memory: the
   screen keeps showing the bootloader logo and the boot looks exactly like a hang.
   `samurai.dsc` therefore sets `PcdMipiFrameBufferAddress|0x9D000000`.
4. **`ButtonsDxe` needs three extra blobs.** The port uses the *factory* realme/OPPO
   `ButtonsDxe` (the only build with a correct key map for this board), but it is not
   self-contained: at run time it additionally wants `EFI_QCOM_TLMM_PROTOCOL` (`TLMMDxe`), the
   **OPPO project protocol** (`903C579D-...`, installed by `OcdtDxe/OppoProject.efi`) and the
   **reset-reason protocol** (`A022155A-...`, installed by `ResetRuntimeDxe`). It also reads the
   SMEM project entry (`Project:19781`) to select the per-project key map. Any missing piece makes
   it return `EFI_NOT_FOUND` and get unloaded - and then *no* side button works at all.
   Because it locates the OPPO project protocol only at run time (that GUID is not in its DEPEX),
   run `fix-buttons-depex.py` so the dispatcher guarantees `OppoProject` is installed first.
   See `Platform/Realme/sm8150/BINARIES.md`.
5. **DTB roles.** `FdtBlob/<device>/<device>.dtb` is the **mainline** DTB (published to the OS
   through the EFI configuration table); `FdtBlob_compat/<device>.dtb` is the **vendor/Android**
   DTB appended to the boot image. Do not swap them: with a vendor DTB in `FdtBlob`, the built-in
   `LinuxSimpleMassStorage` kernel falls back to `usb_nop_phy` and USB never comes up.
6. **Memory map / MLVM.** `samurai.dsc` builds with `-DHAS_MLVM`: for the 8 GiB branch this
   reserves `0xA0000000..0xBBB00000`, matching the `no-map` carveouts of the device DTB
   (`qseecom_region` at `0xA0000000+0x1400000`, `cdsp_sec_regions` at `0xA4C00000+0xC00000`).
   Without it UEFI may allocate memory inside protected regions.

---

## USB mass storage mode (phone as a USB disk)

The firmware contains BigfootACA's [linux-simple-mass-storage](https://github.com/BigfootACA/linux-simple-mass-storage)
kernel (`Platform/EFI_Binaries/Applications/LinuxSimpleMassStorage/LinuxSimpleMassStorage.efi`,
registered as the boot option **"USB Attached SCSI (UAS) Storage"**). Selecting it boots a small
Linux 6.1 kernel which exposes the phone's **raw UFS LUNs** to a host PC as UAS mass storage.

Verified: Windows enumerates `USB Attached SCSI (UAS) Mass Storage Device` plus 6 disks
(`Qualcomm sda` = 118 GB userdata, `sdb`..`sdf`), and a FAT partition (`op1`, containing
`simpleinit.uefi.cfg`) becomes mountable - a convenient way to copy files to/from the phone
without reflashing.

**Warning:** this exposes *raw partitions*. Never let the host OS initialise, repartition or
format those disks - that destroys data or bricks the firmware. When not needed, do not boot
this option. (On Windows you can protect yourself with
`Set-Disk -Number <n> -IsOffline $true`.)

---

## Debugging over USB (EUD)

This SoC exposes Qualcomm's **Embedded USB Debug hub (EUD)**: once enabled, the
host PC sees a `VID 0x05C6` USB hub that Qualcomm's OpenOCD fork can drive as a
JTAG/SWD adapter - no UART wiring, no disassembly. On this device **EUD is not
fused off** (verified from Android by writing `1` to
`/sys/module/eud/parameters/enable`).

EDK2 replicates the kernel's two register writes from `PlatformBootManagerAfterConsole`
(BDS, when the USB PHY is up):

```c
MmioWrite32 (0x088E0000 + 0x1014, 1);     /* EUD_REG_CSR_EUD_EN              */
MmioWrite32 (0x088E0000 + 0x0024, 0x1C);  /* INT1_EN_MASK: VBUS|CHGR|SAFE_MODE */
```

The block is guarded by `-DSAMURAI_ENABLE_EUD` (set in `samurai.dsc`) so it does
not affect other devices, and it prints `[SAMURAI-EUD] ...` to the framebuffer.
While EUD is active the USB port is dedicated to it, so fastboot and the U-disk
mode are unavailable until the next **full power cycle**.

Registers, caveats and host-side OpenOCD setup: `Platform/Realme/sm8150/EUD.md`.

Current status of the SWD/JTAG half (2026-10-08): the SWD (9504) and JTAG (9503)
functions can be enabled and driven from the PC (DAP route payload 0x00100445 /
JTAG 0x00000090), but the AP CoreSight DAP does not answer on this retail unit:
`ack = 0`, `freezio_latch = 1`, DPIDR reads 0. The `APPS_DBGEN_DISABLE` fuse and
signed APDP debug policy (`dpAP.mbn` in the F.14 package) are possible
restrictions; the device fuse state was not read and policy causation was not
established. These tests did not obtain AP halt. EUD COM therefore
remains the working debug channel here; the SWD/JTAG host tooling is kept for
debug-enabled devices. Never switch the internal DAP mux while Android is
running - it hangs the AP and needs a full power cycle. Details in RX-CONSOLE.md.

## Known issues / TODO

- **Volume-Down is now fixed.** It used to fail because the shared `ButtonsDxe` reads `VOL-`
  through the PMIC PON real-time IRQ while on samurai the key is wired to a GPIO. The port now
  uses the factory realme `ButtonsDxe` together with `OppoProject` + `ResetRuntimeDxe` and a
  patched DEPEX; verified on hardware (`SCAN_UP` / `SCAN_DOWN`). See note 4 above.
- No letter input: the EFI Shell cannot be typed into with the volume keys alone; a USB keyboard
  (host mode) is untested.
- A samurai-specific DSDT is required for Windows-on-ARM.
- Persistent UEFI variables (a variable store) are not configured.
- Optional: enable `USE_DISPLAYDXE` + the factory panel XML for a graphical console.

---

## Safety

- Only ever flash the `boot` partition; keep a verified backup
  (the stock image used during development has sha256
  `dfe18875661164e7cb64eba7942b856e80ffe20abb537aec815da4bf43995cdd`).
- Do not touch the partition table or any other partition (`xbl`, `abl`, `modem`, `persist`,
  `super`, `userdata`, ...).
- The U-disk mode described above exposes raw partitions - see the warning there.

---

## Credits

- [edk2-porting/edk2-msm](https://github.com/edk2-porting/edk2-msm) (Renegade Project) - the framework this port is built on, and SimpleInit
- [BigfootACA/linux-simple-mass-storage](https://github.com/BigfootACA/linux-simple-mass-storage) - the built-in mass-storage kernel
- [Project-Aloha/UEFIFirmwareBackup](https://github.com/Project-Aloha/UEFIFirmwareBackup) - factory firmware dumps (`realme-rmx1931`)
- [Project-Aloha/mu_aloha_platforms](https://github.com/Project-Aloha/mu_aloha_platforms) - source of the `OppoProject.efi` (OcdtDxe) blob
- [edk2-porting/edk2-msm device sources](https://github.com/edk2-porting/edk2-msm/tree/master/Platform) - cepheus (Mi 9) was used as the working SM8150 reference

## License

Same as upstream edk2-msm (BSD-2-Clause-Patent for EDK2 code). Device firmware blobs
(vendor DXE, DTBs, ACPI) are **not** distributed here - obtain them from your own device.

---

## 中文简介

**realme X2 Pro（RMX1931 / 代号 samurai）的 EDK2/UEFI 移植**，基于 `edk2-porting/edk2-msm`。

已在真机验证：UEFI 可启动到 Boot Manager 与 EFI Shell，framebuffer 文本控制台、**音量上 / 音量下 / 电源键全部可用**、
UFS 分区枚举、以及"把手机当 U 盘"的 USB 大容量存储模式都可用。Windows 化还需专属 DSDT。
UFS 分区枚举、以及"把手机当 U 盘"的 USB 大容量存储模式都可用。**音量下键也已修复**；
Windows 化还需专属 DSDT。

关键坑（详见上文）：
1. boot 镜像必须保持项目默认布局（v1 + gzip(BootShim+FD) + 尾部追加 `FdtBlob_compat` 的安卓 DTB）；
2. `PcdMipiFrameBufferAddress` 必须改成 **0x9D000000**，否则 edk2 日志"静默"、看起来就是卡死；
3. 按键驱动用**原厂 realme ButtonsDxe**，并需同时引入 `OppoProject`（OPPO project 协议）与 `ResetRuntimeDxe`（reset reason 协议），且要给 ButtonsDxe 的 DEPEX 加上 `903C579D`（详见 `Platform/Realme/sm8150/BINARIES.md`）；
4. `FdtBlob` 放主线 DTB、`FdtBlob_compat` 放安卓 DTB，别放反（放反会导致 U 盘模式失效）。

⚠️ **安全**：只刷 `boot` 分区，先备份；U 盘模式会暴露原始分区，切勿让 PC 端格式化/初始化。

## Status update 2026-10-07 (EUD console works; two real bugs found)

* console=eud (a real nbcon console for the EUD COM FIFO) is verified on hardware:
  with keep_bootcon removed the log now continues past the 1.2 s mark where it used
  to die.  Firmware cmdline: earlycon=eud,mmio,0x88e0000 console=tty0 console=eud ...
  and the DTB in the firmware volume carries the serial@88e0000 node for it.
* Two independent bugs kept the kernel from reaching userspace:
  1. 7.3 reads the RPMh regulator voltage back at boot.  On SM8150 the AOSS never
     answers: the read occupies an ACTIVE TCS and blocks every later write (10 s
     timeout = RPMH_TIMEOUT_MS, then "failed to read VOLTAGE ret = -110", rpmh_write
     WARNs, dwc3 -ETIMEDOUT).  Worked around in drivers/soc/qcom/rpmh.c: no read
     commands on qcom,sm8150 / qcom,sc8180x.
  2. The built-in initramfs carried 305 absolute symlinks into the host tree
     (busybox --install -s with an absolute path), so /init could not exec:
     "Kernel panic - not syncing: No working init found" -> panic=15 reboot loop.
     Symlinks are relative now and the cpio is rebuilt.
* Test image: Image-rmx1931-samurai-initfix (RPMh + initramfs fix).
  Full story and hashes: HANDOVER-NEXT.md section 26.

## Status update 2026-10-08 (userspace reached; what is a shortcut and what is not)

* The kernel now reaches userspace on hardware: "Run /init as init process", all
  six UFS LUNs enumerated, no panic - and the initramfs banner reaches the EUD
  COM console after the init script was changed to write to /dev/kmsg.  Writing
  to /dev/console does not work yet, because the console has no tty binding, so
  those writes land on the VT (screen only).
* The phone reboots shortly after the diagnostic dump.  The panic text has to be
  read from /sys/fs/pstore/console-ramoops (ramoops@0xb7e00000 is in the DTB).
* HANDOVER-NEXT.md section 27 records, for the first time, which parts of the
  current setup are temporary information-gathering shortcuts (S1-S13: the
  /dev/kmsg dump on every boot, the sleep-forever init, the kernel store in the
  logdump partition, the RPMh SoC quirk, the missing tty layer, ...) and which
  are the proper goals (a real tty console, a reviewable DTS, ESP + GRUB, a real
  root filesystem, pstore as the durable log channel, upstreamable patches).
  Read that section before building anything on top of this setup.
## Status update 2026-10-08 (button-free fastboot; fastboot can write the kernel store)

* Reboot into fastboot without touching the phone: the vendor DTB's PMIC PON already
  carries mode-bootloader = <0x02>, mainline's qcom-pon.c plus the generic reboot-mode
  framework are enabled in the build, and this board only lacks the two mode- lines in
  its device tree.  With a ~15 line static reboot2 helper, Linux (and later EDK2) can
  ask for fastboot by itself.
* fastboot can write the logdump partition, i.e. the kernel store: verified
  byte-exact, 64 MiB in 1.8 s, so the iteration loop no longer needs Android at all.
  The Image sits contiguously at offset 90,112 and is always 30,116,352 bytes, so
  updating it is a single in-place write, and a corrupted FAT is recoverable in 1.8 s
  straight from fastboot.
* The EUD COM channel has an RX half too (host to device, registers
  0x088E000C/0x10/0x14, documented by the official QUIC host library), so a
  "control it like adb" command channel is a software task - useful later for rescuing
  a firmware that is stuck before BDS, where neither adb nor fastboot exists.
* Details, evidence and the unattended flywheel plan: HANDOVER-NEXT.md section 28.

## Status update 2026-10-08 (SWD/JTAG transport verified; AP DAP unresponsive)

* Both EUD debug peripherals can be brought up from Windows: SWD 9504 with
  `CTLOUT_CLR 0x000E0090` + `CTLOUT_SET 0x00100445` (DAP route, no VBUS pulse)
  and JTAG 9503 with `0x00000090` + the VBUS pulse. They bind to qdbusb and
  expose `\\.\Qualcomm EUD SWD Device 9504\DEBUG` / `... JTAG Device 9503\DEBUG`
  (no "(0004)" suffix). SWD STATUS is `07 01`, JTAG FREQ_RD is `0F 01`.
* The OpenOCD-equivalent DAP connect sequence (FREQ, line reset, JTAG-to-SWD
  0xE79E, ABORT, DP CTRL/STAT = 0x50000000, read DPIDR) returns
  `data = 0x00000000, status = 0x00010020, ack = 0, freezio_latch = 1` in
  every state tried, including with SRST/TRST held over SWD bitbang. Switching
  the internal DAP mux while Android runs hangs the AP (black screen).
* Possible restrictions: Qualcomm debug fuses and an OEM-signed policy in
  `apdp`; neither was established as the cause of this unit's failed DAP reads.
  This phone's F.14
  package carries `dpAP.mbn`, a signed ELF with the OPPO CA chain, so it cannot
  be replaced. OpenOCD's own quickstart enables EUD at the U-Boot stage and
  expects DPIDR 0x5ba02477, i.e. it targets debug-enabled devices.
* Consequence for this port: EUD COM stays the primary log/debug channel
  (firmware DEBUG(), Linux `earlycon=eud`/`console=eud`, the EudLogDxe ring).
  Keep the SWD/JTAG tooling in `E:\eud-host` for an engineering device, and try
  `maxcpus=1` when debugging the Linux SMP bring-up.
* Final confirmation 2026-10-08, UEFI stage: the officially recommended flow was
  tested too - flash the firmware, let BDS enable EUD, then attach. The result is
  identical (`data = 0x00000000, status = 0x00010020, ack = 0`). This repetition
  does not locate the gate or prove a fuse/policy cause. See SWD-JTAG.md for
  the current evidence limits; no fuse or APDP modification is proposed.


## Status update 2026-10-08 (EUD is a real console: ttyEUD0, /dev/console, RX commands)

The EUD COM FIFO is now driven by a proper uart driver instead of a bare
console, and the receive side is understood well enough to be used.

* Single writer: the firmware command line no longer carries keep_bootcon, so
  the early console retires when the real console registers
  ("printk: legacy bootconsole [eud0] disabled").  Every register write is paced
  (200 us) and every frame spaced (2 ms); a 210 s capture reassembles with zero
  lost frames.
* /dev/ttyEUD0 exists and works end to end, and /dev/console is bound to it.
* Command channel: [0x81][len][payload], payload[0] is the code (0x01 ping,
  0x02 register dump, 0x03 status).  Typing: [0x82][len][payload] is inserted
  into the tty, so a shell on /dev/ttyEUD0 can be driven from the PC.
* The RX payload register is 0x14 (a FIFO read port); 0x0c/0x10 are latches that
  hold the last message's header.  Details in RX-CONSOLE.md.
* Caveat: reading 0x14 too eagerly wedges the EUD block - the console goes
  silent until a full power cycle.  The payload read must be gated on a
  completed header.
