# 文档索引（realme X2 Pro / samurai）—— 仓库与 Windows 工作区

> 2026-10-08 整理后。编辑在 Windows 的 E:\RealmeX2Pro edk2\ ，发布在仓库 hmhmdcy/edk2-realme-x2-pro（分支 master），单向同步见第 3 节。
> 本文件两边内容一致；改完文档跑一次 sync-docs-to-repo.sh 就会推上去。

## 1. 入口（先读这几份）

| 文件 | 内容 |
|---|---|
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
| sessions/49-usb-in-and-partial-timeout-audit.md、reference/rx49/ | 当前交接：7 组旧 IN 离线匹配，持续 libusb 的记录/IN/raw 对应与真实部分取消保留；未改内核/刷机 |
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
- 只刷 boot（和内核存放用的 logdump）分区；U 盘模式别让 PC 格式化；EUD 打开时占 USB，彻底断电要长按电源约 15 s。
- 待办：HANDOVER-NEXT.md 第 1 节、sessions/49-usb-in-and-partial-timeout-audit.md。保留 TOP_CFG=0x11 和 RX48 B、原生持续 owner/startup sync。已发记录/虚拟 IN/raw 在新样本中对应，但旧缺字未重现、wait 未触发，稳定性仍开放；下一步须有真实异常窗口或 GIC 进展，不能用重复成功样本扩大结论。
