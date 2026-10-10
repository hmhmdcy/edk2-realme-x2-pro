# 文档索引（realme X2 Pro / samurai）—— 仓库与 Windows 工作区

> 2026-10-08 整理后。编辑在 Windows 的 E:\RealmeX2Pro edk2\ ，发布在仓库 hmhmdcy/edk2-realme-x2-pro（分支 master），单向同步见第 3 节。
> 本文件两边内容一致；改完文档跑一次 sync-docs-to-repo.sh 就会推上去。

## 1. 入口（先读这几份）

| 文件 | 内容 |
|---|---|
| sessions/75-a640-render-and-sofef03f-clock-fix.md、reference/kernel75/ | A640真实渲染、花屏失败证据及非连续DSI时钟的光学验收 |
| sessions/74-sm8150-display-boot-handoff.md、reference/kernel74/ | DPU5命令显示接管、失败迭代、两启动/18次电源循环与GPU loader预检 |
| sessions/73-native-sofef03f-dsi-dsc-display.md、reference/kernel73/ | 原生SOFEF03F/DSI/DSC、60Hz/CRC/电源循环、固件依赖与启动SMMU交接限制 |
| sessions/72-usb-ncm-and-autonomous-ssh.md、reference/kernel72/ | CDC NCM/密钥SSH自动启动、双向4MiB校验、EUD共存及仅logdump部署 |
| sessions/71-native-s3706-touch-bringup.md、reference/kernel71/ | 原生S3706触摸代码/供电/总线接入、boot/logdump部署、完整日志与输入事件校验 |
| linux-port/docs/HARDWARE-STATUS.md | 按用户功能分组的14类硬件接入/验收状态与优先级 |
| NEXT-SESSION.md、NEXT-SESSION-PROMPT.md | session75 GPU渲染/花屏修正、电池充电等剩余硬件、自动USB SSH与提示词 |
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
