# 免按键测试飞轮：构建、部署、观测与回退

用途：测试流程与历史协议证据导航。整理日期：2026-10-14；实际设备、源码及回退包以[检查点](NEXT-SESSION.md)核对，当前操作规则见[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)。

## 一轮工作流程

1. 核对设备身份与状态，确定本次目标、源码差异、镜像及可核验回退；测试范围由具体任务决定。
2. 构建并验证对应改动，确认固件/内核/DTB/模块/rootfs的匹配关系；编译产物和原始回退副本分别记录。
3. 部署前确认当前设备状态，按所选路径完成正常关流、停机和文件系统处理，保存实际回执；同次切换状态未明时先核对现场。
4. 在确认的bootloader状态部署指定包并启动；启动后核对新身份和实际加载内容。
5. 保存问题对应的新日志与验收结果，区分软件返回、用户实屏/听音、短窗口和跨启动/长稳证据；失败、回退与未复现分别记录。
6. 退出临时记录器/服务并保存证据，将部署/回退变化写入检查点、功能验收变化写入硬件清单，过程进入sessions/或reference/。

## EUD与F1

历史命令通道使用`id=0x90`。`[90][02]`为已验证的F1 bootloader命令，长度2不能用作普通二字节TTY分片。TOP_CFG=0x11后的完整payload读取与RX53 console/IRQ处理已有真机证据；受理与输出仍有独立稳定性边界。

- [31 F1验证](sessions/31-flywheel-f1-verified.md)、[41原生RX](sessions/41-rx-ahb2phy-wait-state-fix.md)、[53 console边界](sessions/53-console-boundary-rx-service.md)
- [65 WSL TX缺口](sessions/65-wsl-full-packet-console-overlap-and-tx-gap.md)：EUD作为辅助观测，关键设备侧日志应保存完整副本并校验导出。
- [143线程化候选拒收](sessions/143-threaded-console-live-regression-and-rollback.md)、[144回执竞态](sessions/144-eud-reboot-handoff-and-display-clock-review.md)：工具和源码按对应验证范围使用。

EUD与普通USB NCM/SSH共存已有验收，[USB路径](linux-port/docs/USB-NCM-SSH.md)可用于当前任务。协议寄存器与旧实现细节见[EUD](EUD.md)、[RX-CONSOLE](RX-CONSOLE.md)。

## 构建、停机与回退证据

- [164固件构建](reference/kernel164/README.md)：实际BdsDxe差异、DTB与其他模块比较。
- [165同组合验收](reference/kernel165/README.md)：新身份停机、F2FS冻结、单次F1和独立启动收据。
- [157 RAM启动阻塞](reference/kernel157/README.md)、[158恢复](reference/kernel158/README.md)：特定失败现场的处置，不能脱离RAM-only状态证据复用。
- [旧完整流程、命令表与工具说明](archive/docs-before-maintenance-2026-10-14/FLYWHEEL.md)：按对应阶段解释时序和路径，当前版本与回退依据由检查点定位。

## 日志与维护

原始日志、身份、密钥和录音保存在私人目录；可审查补丁和脱敏收据按[会话索引](sessions/INDEX.md)组织。当前边界由WORKING-BOUNDARIES维护，工具参数与验证规模按具体工作选择。
