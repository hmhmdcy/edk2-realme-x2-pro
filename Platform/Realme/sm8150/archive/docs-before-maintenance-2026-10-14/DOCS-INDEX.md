# 文档索引（realme X2 Pro / samurai）—— 仓库与 Windows 工作区

当前操作规则：[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)。用户已撤销其余临时禁令；下方历史中的GPU禁测、固定时序、只读、禁复用及禁提交推送等条款不再适用。硬件状态和既有失败记录仍保留。

当前进展与交接：[163内核复位](reference/kernel163/README.md)、[164固件复位](reference/kernel164/README.md)、[165同组合复测](reference/kernel165/README.md)、[用户实屏验收](reference/kernel165/physical-feedback-validation.json)、[当前检查点](NEXT-SESSION.md)、[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。用户确认EDK2之后无白屏/花屏，先黑屏等待再出现命令行。当前新boot仍kernel163+boot164读回匹配、关键计数0、taint0；此前165的24次DPMS/12次首帧门控/601秒稳态通过，Phosh21.45秒为此前boot测量。本次显示故障按已测范围收尾，冷启动/休眠/长期可靠性及音频首次WARN原因仍开放。

相关机型源码核查：[一加/真我显示交接对比](reference/display-handoff-comparison/README.md)。普通面板复位有先例，EDK2退出前保持复位是本机实现；一加8T历史提案明确避开复位，不能推广为统一策略。

- [阶段151收尾证据](reference/kernel151/README.md)：当前状态与软件数据库差异、未完成硬件和历史文档归档。

- [阶段150：无需Mesa本地补丁的GPU研究](sessions/150-no-mesa-patch-gpu-research.md)：原版库36次像素验证通过，内核兼容候选已编译、未部署；功能降级与完整功能路线见[研究结论](reference/kernel150/README.md)。

- [阶段148：Vulkan候选和未复现调查](sessions/148-vulkan-vm-bind-diagnostic-candidate.md)
- [阶段147：旧式GPU VM对齐修复](sessions/147-a640-gmem-alignment-fix.md)

- [阶段145：DSI追踪构建与E盘旧产物清理](sessions/145-dsi-observation-and-old-build-cleanup.md)

- [阶段144：重启回执竞态定位与显示时钟核对](sessions/144-eud-reboot-handoff-and-display-clock-review.md)

- [阶段143：线程化控制台实机回归与140回退](sessions/143-threaded-console-live-regression-and-rollback.md)

- [阶段142：启动中断空档与EUD控制台延迟](sessions/142-startup-irq-gap-and-eud-console-latency.md)

- [阶段141：普通亮屏和新启动显示追踪](sessions/141-normal-wake-and-loss-free-startup-display-trace.md)

- [阶段140：DMA首次诊断和显示启动超时](sessions/140-first-dma-diagnostics-and-display-startup-timeouts.md)

- [阶段139：未提交TX回收与实际启动](sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)

- [阶段136](sessions/136-legacy-gpu-vm-trace-and-ccu-address-correlation.md)、[阶段137](sessions/137-wcd-resource-cleanup-display-failure-and-rollback.md)、[阶段138](sessions/138-readonly-charger-recharge-threshold.md)：GPU页表证据、WCD清理候选与显示失败回退、实际充电恢复阈值。

- [阶段135](sessions/135-mdss-reset-candidate-rejected-and-stable132-rollback.md)：MDSS复位候选实际失败与132自动回退、完整镜像复用/匹配基线、音频资源清理新线索。

- [阶段134](sessions/134-usb-input-budget-real-boot-and-display-startup-failure.md)：标准USB源额度真实部署、显示首次启动失败及自动恢复、完整134镜像和证明清理。

- [阶段133](sessions/133-usb-power-budget-and-charge-contract.md)：输入限值与USB预算缺口、采集超时后的只读收尾、GPU检索核对。

- [阶段132](sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)：持久充电观测实际刷入、新boot及完整匹配132四件套、冗余130 raw证明清理。

- [阶段131](sessions/131-fixed-size-pixel-validation-and-delayed-gpu-fault.md)：固定离屏尺寸实机对照通过，但迟发GPU故障仍存在；当前129充电观测事件8次非空验收。

- [阶段130](sessions/130-standard-bluez-discovery-and-startup-integration.md)：实际标准蓝牙扫描、DMS地址与服务自动启动暖重启验收、完整匹配129内核的rootfs130。

- [阶段129](sessions/129-initial-console-node-and-real-boot-verification.md)：初始console实际启动修复、新启动5GHz自主连接、完整匹配rootfs129及安全清理。

- [阶段128](sessions/128-wcn3990-pairwise-key-delete-and-5ghz.md)：真实刷入128与单播key删除等待修复、5GHz自动连接、完整匹配rootfs128及安全清理。

- [阶段127：rootfs用户权限修正和实机系统属主增量验收](sessions/127-rootfs-user-owner-fix-and-live-system-resource-ownership.md)：正确的127完整镜像匹配126内核，21131条目与encoded降权访问通过，85项增量实机回读。

- [阶段126：内部TPG实机DMA、嵌入DT修正和完整rootfs语义检查](sessions/126-tpg-dma-guards-full-rootfs-and-real-deployment.md)：已刷入126、3帧数据/IRQ/power验收；rootfs home权限待127修正，保留稳定回退。

- [阶段125：CPAS QoS、原厂完整IOVA与挂载串行化](sessions/125-native-cpas-qos-full-iova-window-and-mount-serialization.md)：#125离线候选/770模块及真实C与分配器自动验证，未部署。

- [阶段124：原厂C-PHY、共享L3与频率合同](sessions/124-native-cphy-shared-rail-and-frequency-contract.md)：#124离线候选、native129项/真实C故障和schema正反例；未部署。

- [阶段123：CAMSS DT/DMA/ICC与strict disabled校验](sessions/123-camss-dt-dma-interconnect-and-strict-disabled-validation.md)：本机资源交叉、#123离线候选、真实C12场景与schema7反例；未部署。

- [阶段122：完整#121 rootfs与过时构建清理](sessions/122-complete-k121-rootfs-and-verified-build-cleanup.md)：21,134项反向验收、设备节点修正、匹配产物、WSL安全清理；未部署。

- [阶段121：PM8008无IRQ与本机复位](sessions/121-pm8008-no-irq-and-native-reset-contract.md)：完整构建/18 probe场景/schema反例/770模块包；未部署。

- [阶段120：CCI与PM8008摄像头契约](sessions/120-cci-device-tree-and-camera-pmic-contract.md)：隔离完整build/schema/770模块包，原厂PM8008缺口；未部署。

历史：[阶段119](sessions/119-k118-deployment-and-real-gpu-pixel-failure.md)、[阶段118](sessions/118-final-reset-read-build-and-host-space-recovery.md)、[阶段117](sessions/117-parser-boundaries-and-same-boot-desktop-recovery.md)、[阶段116](sessions/116-camss-foundation-and-own-sensor-binaries.md)、[阶段115部署](sessions/115-own-ipa-modem-and-zram-rootfs.md)、[继续检查点](NEXT-SESSION.md)。历史：[阶段108](sessions/108-display-flicker-and-panel-state-handover.md)、[阶段107](sessions/107-qrtr-hello-reply-and-automatic-wifi-start.md)、[阶段106](sessions/106-first-modem-hello-race-and-core-query-tracing.md)、[阶段105](sessions/105-apr-rebind-and-first-modem-crash-smem-diagnostics.md)、[阶段104](sessions/104-native-digital-microphones-and-first-boot-radio-failure.md)、[阶段103](sessions/103-native-max98937-card-pcm-and-zero-microphone.md)、[阶段102](sessions/102-wcd934x-and-real-max98937-identification.md)、[下一轮](NEXT-SESSION.md)。

> 2026-10-08 整理后。编辑在 Windows 的 E:\RealmeX2Pro edk2\ ，发布在仓库 hmhmdcy/edk2-realme-x2-pro（分支 master），单向同步见第 3 节。
> 当前任务只本地保存；旧 sync-docs-to-repo.sh 会推送，未经用户明确授权不要运行。

## 1. 入口（先读这几份）

| 文件 | 内容 |
|---|---|
| sessions/119-k118-deployment-and-real-gpu-pixel-failure.md、reference/kernel119/ | 新boot部署118/自动桌面、300秒idle边界、真实GPU25项像素失败及CCU迟发fault/coredump |
| sessions/118-final-reset-read-build-and-host-space-recovery.md、reference/kernel118/ | 显示最终读最小候选/实际C测试、E盘隔离构建、764模块/FAT校验与现机300秒健康；未部署 |
| sessions/117-parser-boundaries-and-same-boot-desktop-recovery.md、reference/kernel117/ | 有界BIN解析失败边界、同boot面板reprobe与既有initial_session恢复、45秒健康/CTL旧状态返回源码证据 |
| sessions/116-camss-foundation-and-own-sensor-binaries.md、reference/kernel116/ | 本机五sensor.so/六sensormodule BIN只读来源、SM8150 CAMSS基础API适配和完整未部署构建 |
| sessions/115-own-ipa-modem-and-zram-rootfs.md、reference/kernel115/ | 本机IPA/固件与ModemManager、完整115 rootfs/zram服务、TX delay修正、RCU/CTL reset显示启动回归与当前边界 |
| sessions/108-display-flicker-and-panel-state-handover.md、reference/kernel108/ | 滚动花屏/DSI下溢、错误关屏黑屏状态链、同镜像重启恢复命令行及5GHz新失败；未改内核/刷机 |
| sessions/88-wifi-dependency-build-and-read-only-firmware-service.md、reference/kernel88/ | #89依赖内核、只读固件服务与本地拒写测试、33项MPSS固件校验、实际内嵌DTB部署前交接 |
| sessions/87-stage-wrap-up-and-wifi-prerequisites.md、reference/kernel87/ | 阶段收尾、未部署的DPU候选与回归、Wi-Fi依赖缺口/候选配置和固件校验 |
| sessions/86-mp2650-input-status-and-real-display-timeout-snapshot.md、reference/kernel86/ | MPS输入位核实、ADC实测、只读接口失败/候选修正及首次真实显示超时快照 |
| sessions/85-oem-chemistry-and-short-ic-observations.md、reference/kernel85/ | 58身份ENXIO、LION/0054实测、原厂温补缺省和失联容错、安全与充电状态边界 |
| sessions/84-display-boot-tracing-and-timeout-snapshots.md、reference/kernel84/ | #85首次启动事件/超时快照、两次600翻页与完整跟踪、失败迭代及MP配置保持 |
| sessions/83-androidr-and-cyborg-charging-source-comparison.md、reference/kernel83/ | 官方Android R与用户cyborg源码定位、14项本机策略对照、驱动相同/初始化差异及I2C匹配边界 |
| sessions/82-charging-policy-units-and-android-backup-provenance.md、reference/kernel82/ | 温控负值/单节与包电压单位、原函数错误路径测试、OPLUS保护来源及Android备份来源纠正 |
| sessions/81-stock-gauge-state-temperature-and-display-timeouts.md、reference/kernel81/ | 原厂封存/计量与标准温度、两次既有DRM超时纠正、600翻转对照及本机无线固件准备 |
| sessions/80-gauge-identity-and-stock-cell-observations.md、reference/kernel80/ | 旧式FFA5/扩展2719身份差异、原厂双电芯实测、USB输入来源；权限足够 |
| sessions/79-mp2650-read-only-bus-and-current-settings.md、reference/kernel79/ | QUP1仅总线部署、MP2650三次实测配置和充电保护边界；gh API成功 |
| sessions/78-first-boot-display-controls-and-pageflips.md、reference/kernel78/ | 三次相同镜像首次启动对照、600双缓冲翻转/CRC、7nm绑定核对；间歇性故障仍开放 |
| sessions/77-bq28z610-live-gauge-and-display-regression.md、reference/kernel77/ | 真实电量计两启动45样本、仅boot部署、首次显示接管下溢回归 |
| sessions/76-charging-source-and-safety-review.md、reference/kernel76/ | 本机/OPPO/OnePlus充电源码、原厂DT差异、主线电量计与MP2650安全边界；只读研究 |
| sessions/75-a640-render-and-sofef03f-clock-fix.md、reference/kernel75/ | A640真实渲染、花屏失败证据及非连续DSI时钟的光学验收 |
| sessions/74-sm8150-display-boot-handoff.md、reference/kernel74/ | DPU5命令显示接管、失败迭代、两启动/18次电源循环与GPU loader预检 |
| sessions/73-native-sofef03f-dsi-dsc-display.md、reference/kernel73/ | 原生SOFEF03F/DSI/DSC、60Hz/CRC/电源循环、固件依赖与启动SMMU交接限制 |
| sessions/72-usb-ncm-and-autonomous-ssh.md、reference/kernel72/ | CDC NCM/密钥SSH自动启动、双向4MiB校验、EUD共存及仅logdump部署 |
| sessions/71-native-s3706-touch-bringup.md、reference/kernel71/ | 原生S3706触摸代码/供电/总线接入、boot/logdump部署、完整日志与输入事件校验 |
| linux-port/docs/HARDWARE-STATUS.md | 按用户功能分组的15类硬件接入/验收状态与优先级 |
| NEXT-SESSION.md、NEXT-SESSION-PROMPT.md | session108当前进展/真正短提示词；显示状态修复、DSI下溢、5GHz数据回归、kernel109新守卫及保留边界 |
| HANDOVER-NEXT.md | 交接入口：第 0–7 节 = 当前状态 / 下一步 / 仓库状态 / 工具 / 坑 / 安全 / 未决；末尾是 history index（旧第 8–30 节 → 文件） |
| README.md | 项目门面：fork 介绍、构建、刷机、各阶段 status update |
| DOCS-INDEX.md | 本文：文档地图、同步方式与维护规则 |
| EUD.md | EUD 设备事实、寄存器、CTL/COM 协议、固件日志环、ArmMmuLib 崩溃真因 |
| SWD-JTAG.md | EUD SWD 9504 / JTAG 9503：传输层可用，AP DAP 无应答；未读熔丝，权限原因未证实 |
| RX-CONSOLE.md | EUD RX 寄存器、组帧、tty console；原生 payload 推进修复与剩余终端问题，保留历史探针记录 |
| BINARIES.md | 设备 blob 来源、ButtonsDxe DEPEX 补丁 |
| linux-port/README.md、linux-port/docs/00-INDEX.md | 主线 Linux 侧（内核、DTB、patch、脚本、参考） |
| FLYWHEEL.md | 免按键测试飞轮：命令表、一轮流程、构建打包、硬约束与坑 |

## 2. 历史记录放在哪

| 位置 | 内容 |
|---|---|
| reference/DECISIONS.md | 旧第 8–11 节：Linux 引导路径与持久变量决策、移植清单、分区改动规则、EDL (9008) 资源 |
| sessions/NN-<topic>.md | 旧第 12–18、29、30 节：EDK2 与内核侧会话（NN = 旧节号） |
| sessions/2026-10-06-*.md | 两篇早期记录：诊断镜像抓取、EUD 首次试水（原先拼在 DIAG-CAPTURE.md 里） |
| linux-port/docs/NN-<topic>.md | 旧第 19–28 节：主线 Linux 侧会话，命名与索引见该目录的 00-INDEX.md |
| sessions/31-flywheel-f1-verified.md | 旧第 31 节：飞轮 F1 打通（命令通道 `[90][02]`→fastboot、实测证据、主机端口卡死事故） |
| sessions/32-rx-printk-interference.md | 原探针 90 90；去掉前置 printk 后单字符 RX 修复、多字节仍未解；跨机型源码与真机证据 |
| sessions/33-rx-access-and-production-policy.md | 整帧锁、MMIO/读序/主机实验、上下游审查、量产权限证据边界；多字节仍未解 |
| sessions/34-temporary-eud-terminal.md | TX/RX 区分、临时键盘/命令终端、tty/console 真机输出与退出验证 |
| sessions/35-rx-next-session-handoff.md | 下一会话原生 RX 排查交接、已排除路径、所需新证据与短提示词 |
| sessions/36-rx-usb-descriptors-and-legacy-qcusbser.md、reference/rx36/ | 实机 USB 描述符、旧 WDM qcusbser / SM8150 审查；libusb/WSL 完整 OUT 受理后仍多字节失败 |
| sessions/37-rx-source-search-and-phy-lifecycle.md、reference/rx37/ | 同机型源码、QUIC 重载更正、2026-09-29 PHY v9 与本机历史 probe 延迟；未取得原生 RX 修复 |
| sessions/38-rx-pre-linux-and-usb-boundaries.md、reference/rx38/、linux-port/uefi-rx-probe/ | Linux 之前 UEFI 也重复首字节；合法满包/ZLP、reset 未改善；实际 SNPS PHY 更正、只刷 logdump 后恢复基线 |
| sessions/39-rx-tight-arrival-poll.md、reference/rx39/ | UEFI 紧轮询仍重复首字节；受理/恢复边界、原基线恢复、新 boot HWIO 来源限制 |
| sessions/40-rx-register-map-and-stock-firmware-audit.md、reference/rx40/ | 完整旧 DSP EUD_ACORE 表、原厂 SM8150 静态审查，无推进规格；未刷机，单字节回执核对 |
| sessions/41-rx-ahb2phy-wait-state-fix.md、reference/rx41/ | 原厂 SM8150 映射、TOP_CFG=0x11 有效 RX 方法，UEFI/Linux 完整 payload、tty 执行与输出验证 |
| sessions/42-native-terminal-next-session-handoff.md | 历史交接与短提示词：仅文档更新；其中缺输出样本已由 session 43 更正 |
| sessions/43-native-terminal-evidence-audit.md、reference/rx43/ | 原始抓取更正缺输出，BusyBox/tty/TX 审查，已修复配置下双 USB 路径的缺回执边界与最终状态 |
| sessions/44-rx-receipt-counters.md、reference/rx44/ | 只读计数定位到未观测 pending，原生输出/F1 保留，IRQ/超时来源审查与熔丝证据限定 |
| sessions/45-rx-mask-before-arrival.md、reference/rx45/ | 接收前只启用 RX 掩码仍失败；完整 LEN=14 输出/F1、恢复 RX44，排除仅掩码方案 |
| sessions/46-rx-irq-and-host-trace-boundary.md、reference/rx46/ | 真实 IRQ 接收与完整输出/F1；失败 Windows 帧未增 IRQ，libusb 对照与一次 Windows USB ETW |
| sessions/47-native-terminal-session-boundary.md、reference/rx47/ | 原生终端持续打开/启动同步、重开缺 RX 与端点 reset；真实 TX 缺字、看门狗退回及轮询 F1 |
| sessions/48-irq-grace-and-tx-journal.md、reference/rx48/ | IRQ 有界宽限、CRC 发送记录 512 帧匹配；wait 分支未触发，兼容/F1/重启保留，稳定性仍开放 |
| sessions/49-usb-in-and-partial-timeout-audit.md、reference/rx49/ | 7 组旧 IN 离线匹配，持续 libusb 的记录/IN/raw 对应与真实部分取消保留；未改内核/刷机 |
| sessions/50-windows-receive-and-driver-buffer-audit.md、reference/rx50/ | 当前连接正常；Windows 接收观测与实装 qcusbser 精确 PDB 审查，287 重叠 TX 帧匹配，旧故障未复现 |
| sessions/51-console-overlap-and-issued-frame-loss.md、reference/rx51/ | 长 console 输出期间 7 字节缺 RX；恢复状态缺一个已发 4 字节帧，511/512 直接匹配，根因仍开放 |
| sessions/52-same-owner-usb-overlap-and-continuous-in.md、reference/rx52/ | 同 owner 长日志缺 RX，完整 OUT/IN；持续 IN 对照改善请求空窗/TX 匹配，RX 仍未修复 |
| sessions/53-console-boundary-rx-service.md、reference/rx53/ | console 帧边界整帧 RX 在 USB/Windows 同触发通过；兼容/F1/重启保留，最后仍缺一个已发 TX 前缀 |
| sessions/54-console-rx-regression-and-host-counter-audit.md、reference/rx54/ | 9 次手动 console RX/F1 回归通过、6 次空 IRQ 正确计数；实装 Windows worker/累计接收计数审查，未刷机、TX 缺口仍开放 |
| sessions/55-windows-perf-counter-and-reproduced-tx-gap.md、reference/rx55/ | 同 owner GET_STATS/raw/CRC 快照重现缺 TX seq7376，缺口在驱动受理缓冲计数之前；启动首 Ctrl-U 仍未受理，未刷机/重启 |
| sessions/56-source-boundaries-and-focused-research.md、reference/rx56/ | 修复/测量结论收敛与定向新资料；实装 pre-buffer/reset/padding 审查、旧 ETW 489 字节离线复核，只读未修复 |
| sessions/57-driver-raw-logging-boundary.md、reference/rx57/ | 前缓冲驱动日志实测：9550 字节与计数/raw 相等、512 帧匹配；首轮脚本误判更正，配置恢复，旧故障未触发 |
| sessions/58-reopen-first-frame-and-driver-completion-gates.md、reference/rx58/ | 三次真实缺口均为重开后首状态首帧；精确失败读/日志盲区，联合测量方案已准备未执行 |
| sessions/59-joint-capture-and-forced-odd-reopen-gap.md、reference/rx59/ | 两轮联合抓取恢复；75 奇数 IN / 偶数短 OUT 干预重现首帧缺失，同步 ETW 无失败正长度 IN，翻转候选及 0x1e 更正 |
| sessions/60-even-reopen-reversal-and-toggle-candidate.md、reference/rx60/ | 74 偶数反向重开首帧完整、512/512 匹配；无管理员有界抓取与未安装的 WDF 保留翻转候选，14 离线用例 |
| sessions/61-eud-wdf-package-and-build-preparation.md、reference/rx61/ | 固定完整 WDF 源码、9505 专用 INF/project、旧驱动精确回退副本；EWDK 下载进行，完整构建/签名/上机尚待验证 |
| sessions/62-eud-wdf-build-and-test-signed-package.md、reference/rx62/ | 真实九模块 WDK 构建、Win11 INF/catalog、文件内测试签名与 PE 核对通过；未安装/上机，加载环境待决定 |
| sessions/63-single-device-driver-compatibility-and-trial-tools.md、reference/rx63/ | 原生只读候选/回退匹配、当前 CI 策略、单设备试装工具 15 保护用例；ZLP 读取阶段明确，安装与上机未运行 |
| reference/rx64/ | 同一加载环境连续三轮受阻审查、最新只读设备/策略状态、完整原始验收仍未完成 |
| sessions/65-wsl-full-packet-console-overlap-and-tx-gap.md、reference/rx65/ | WSL长console整包LEN14正确受理/执行，但持续owner缺9个tty TX帧；CRC有效快照503/512直接匹配，完整虚拟IN等于raw，仍需专用帧协议工具 |
| sessions/66-verified-kernel-logs-and-builtins.md、reference/kernel66/ | 完整日志校验、CPU/PMIC内建依赖和early mapping三项真机修复；实际异常优先级、失败证据与关闭状态 |
| sessions/67-usb-provider-and-dtb-activation.md、reference/kernel67/ | HS PHY 单项内建后 PHY/dwc3/UDC 真机通过，完整日志校验；CPU7 FAT-DTB 候选未激活、缺回执/损坏导出保留、COM14 回归 Windows |
| sessions/68-firmware-dtb-and-cpu7-opp-verified.md、reference/kernel68/ | boot固件DTB激活CPU7高OPP，live节点/调频表/max与完整日志真机通过；其余模块仅版本字符串变动，失败证据保留，COM14回Windows |
| sessions/69-usb-gadget-state-and-eud-coordination-audit.md、reference/kernel69/ | 前次只读日志/USB功能审查：69499字节完整日志校验、gadget为空、实际legacy glue/VBUS override；EUD共存尚未证明，普通USB网络/SSH路径说明 |
| sessions/70-pm8009-resource-and-touch-prerequisites.md、reference/kernel70/ | 当前资源/触摸前提审查：85404字节日志及cmd-db校验，无PM8009 F资源/DT消费者，降为P3；GENI/RMI4/i2c17未启用，rootfs剩余容量核对 |
| linux-port/docs/ROOTFS-PRESERVE-ANDROID.md | 保留Android和全部数据的rootfs研究：GPT备份边界、logdump小rootfs/外置/文件方案，未确认安全大分区 |
| archive/ | 原 109 KB 的 HANDOVER-NEXT.md 全文备份 |
| HANDOVER.md、EVALUATION-AND-PLAN.md | 2026-10-06 的历史文档，保留原样（含已被推翻的判断） |

规则：一节一文件；同一事实只写一处；镜像只指路、不复制。

## 3. 同步与提交（Windows → 仓库，单向）

1. bash /mnt/e/RealmeX2Pro\ edk2/linux-port/scripts/mirror-linux-port.sh   —— 镜像 linux-port/
2. bash /mnt/e/RealmeX2Pro\ edk2/linux-port/scripts/sync-docs-to-repo.sh   —— 顶层文档 + 健康检查 + commit + push

- docs-health-check.sh（已被上面第二个脚本内置调用）：每个旧节号只能有一个家、archive/ 与 git 一致、Windows 与仓库无漂移，并列出最大文件与重复标题。
- origin 是上游 edk2-porting/edk2-msm，只推 fork。
- 本机 GitHub 走 127.0.0.1:7890 代理、时好时坏：ls-remote 成功不代表 push 成功，push 常需重试 2–3 次。

## 4. 维护规则（防止再长成 109 KB）

1. 时间线只写进 sessions/YYYY-MM-DD-<topic>.md（或 Linux 侧 linux-port/docs/NN-<topic>.md），并在 HANDOVER-NEXT.md 末尾索引表加一行；不要再往交接文档追加正文。
2. 每个文档头部写清：用途 / 来源 / 最后核对日期 / 关联文档。
3. 一节一文件，引用用「文件 + 节号」；旧的 section 26 一类引用通过索引表仍然有效。
4. 不纳入版本库：linux-port/artifacts/（30 MB Image、dtb 等可重建产物）、tools/ 里的旧 README 快照、DEVICE-README.md（旧版机型说明）、Windows 侧的旧 HANDOVER.md。

## 5. 安全与待办

- HANDOVER-NEXT.md 第 22.6 节：内核侧用的 PAT 需要轮换（文档里没有明文 token）。
- 只刷 boot（和内核存放用的 logdump）分区；U 盘模式别让 PC 格式化；EUD连接保持单一owner，普通USB/EUD共存尚未验收；彻底断电要长按电源约 15 s。
- 待办：HANDOVER-NEXT.md 第 1 节、sessions/65-wsl-full-packet-console-overlap-and-tx-gap.md。用户最新优先Linux内核具体问题，收束EUD实验，关键日志保存设备侧完整副本并校验导出。保留TOP_CFG0x11/RX53 console IRQ/F1/现有终端/RX48回退；连续WSL TX请求/取消/FIFO审查及Windows受支持环境的开关/完整原生/回退验收保留独立待办；不重复旧passing/reset/零等待。
