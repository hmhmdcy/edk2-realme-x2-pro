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
| SWD-JTAG.md | EUD SWD 9504 / JTAG 9503：传输层可用，AP DAP 被熔丝＋签名 debug policy 挡住 |
| RX-CONSOLE.md | EUD RX 寄存器、组帧、tty console；最新单字符修复与多字节未决问题，保留历史探针记录 |
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
- 待办：HANDOVER-NEXT.md 第 1 节。飞轮已可无按键迭代；单字符 RX 可用，多字节推进仍待解，后续优先取得 USB OUT 与芯片握手的新证据（`RX-CONSOLE.md`、`sessions/33-rx-access-and-production-policy.md`）。
