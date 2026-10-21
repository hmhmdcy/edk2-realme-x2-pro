# Realme X2 Pro 文档导航与维护

用途：阅读入口、专题证据、历史位置和维护方法。最后整理：2026-10-20；实际硬件结果和未验收范围见功能清单与当前检查点。

## 入口与职责

| 需要了解 | 唯一维护位置 |
| --- | --- |
| 当前适配进展 | [423 主摄自动TMC／LTM与实拍](reference/kernel423/README.md)、[当前检查点](NEXT-SESSION.md) |
| 最后核对的部署、源码/产物差异、回退依据与续作项 | [NEXT-SESSION](NEXT-SESSION.md) |
| 历史清理、保留产物与重建方法 | [2026-10-19交接](reference/maintenance-2026-10-19/README.md) |
| 当前有效操作规则 | [WORKING-BOUNDARIES](WORKING-BOUNDARIES.md) |
| 各功能已证明能力、缺陷及待验收范围 | [HARDWARE-STATUS](linux-port/docs/HARDWARE-STATUS.md) |
| 项目介绍与通用构建说明 | [README](README.md) |
| Linux源码、补丁、rootfs和工具导航 | [Linux README](linux-port/README.md)、[技术文档索引](linux-port/docs/00-INDEX.md) |
| 仓库提交记录、工具路径与旧8—30节映射 | [HANDOVER-NEXT](HANDOVER-NEXT.md) |
| 新会话阅读提示 | [通用提示词](NEXT-SESSION-PROMPT.md)、[音频任务提示词](AUDIO-NEXT-SESSION-PROMPT.txt) |

提示词引用检查点，README和交接导航引用功能清单。实验过程写入sessions/或reference/，入口不再累积阶段摘要。

2026-10-19已精简流程：当前规则由[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)维护，验证按改动范围选择，取消默认全量核验和无关限制。旧实验条件按历史解释。

## 专题与证据

| 专题 | 阅读入口 |
| --- | --- |
| 用户态复现、上游维护与补丁纯度 | [249整合与独立核验](reference/kernel249/README.md) |
| 显示152—165候选、失败、回退与实屏验收 | [过程汇总](sessions/display-handoff-152-165.md)、[165证据](reference/kernel165/README.md)、[实屏反馈](reference/kernel165/physical-feedback-validation.json) |
| GPU旧CCU修复与Snapshot新负载故障 | [240故障及CPU回退](reference/kernel240/README.md)、[147内核修复](sessions/147-a640-gmem-alignment-fix.md)、[149 Mesa修复](sessions/149-vulkan-ccu-alignment-fix-and-deployment.md)、[151收尾](sessions/151-gpu-closeout-and-hardware-handover.md) |
| 音频首次初始化与停止链 | [139 TX回收](sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)、[104 DMIC](sessions/104-native-digital-microphones-and-first-boot-radio-failure.md)、[164失败](reference/kernel164/README.md) |
| 电池/充电控制与输入预算 | [132观测部署](sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)、[133预算研究](sessions/133-usb-power-budget-and-charge-contract.md)、[138恢复阈值](sessions/138-readonly-charger-recharge-threshold.md) |
| GNSS标准链路、相关机型与modem文件服务 | [253原厂弱GPS、UTC实注与RF/初始化](reference/kernel253/README.md)、[252原厂SBAS与基带零测量](reference/kernel252/README.md)、[251原厂室内与Linux对照](reference/kernel251/README.md)、[250第三方Android初始化与室外正信号](reference/kernel250/README.md)、[247启动MEMSHARE与OEM配置差异](reference/kernel247/README.md)、[246真实RF/Clock与modem原始C/No](reference/kernel246/README.md)、[245锁/DIAG/MEMSHARE与active MCFG](reference/kernel245/README.md)、[244首次启动DIAG与真实测量](reference/kernel244/README.md)、[243开窗/PDC/DIAG与其它手机修复](reference/kernel243/README.md)、[242 ROM/modem一致性与时钟关联采集](reference/kernel242/README.md)、[241本机HAL调用对照与630秒实测](reference/kernel241/README.md)、[239当前ODM来源及运行采用疑点](reference/kernel239/README.md)、[239近机型Linux路线](reference/kernel239/RELATED-LINUX-SOLUTIONS.md)、[206 RAM工作文件与实测](reference/kernel206/README.md)、[205机型对照](reference/kernel205/GNSS-RELATED-DEVICES.md)、[201 UTC/有效期/GeoClue](reference/kernel201/README.md)、[191协议修复](reference/kernel191/README.md) |
| 最新相机驱动与调校边界 | [306长焦原厂BLS／硬件AE](reference/kernel306/README.md)、[305长焦几何与四摄回归](reference/kernel305/README.md)、[304原厂EEPROM布局](reference/kernel304/README.md)、[303硬件AE实机／边界](reference/kernel303/README.md)、[302硬件IPA控制／有效帧](reference/kernel302/README.md)、[301曝光／增益时序](reference/kernel301/README.md)、[300硬件IPA与生命周期](reference/kernel300/README.md)、[299原厂BLS、EEPROM与在线候选](reference/kernel299/README.md)、[298黑电平与暗绿对照](reference/kernel298/README.md)、[297共享SOF与断粮恢复](reference/kernel297/README.md)、[296统计SRAM/首包修复](reference/kernel296/README.md)、[295首包缺陷](reference/kernel295/README.md)、[294零计数及metadata修复](reference/kernel294/README.md)、[293WB/实景](reference/kernel293/README.md)、[291实体色彩](reference/kernel291/README.md)、[原厂调校资料](reference/kernel276/OEM-TUNING.md) |
| 传感器板级方向与桌面启动顺序 | [269旋转修复与验证边界](reference/kernel269/README.md)、[平台配方](linux-port/packages/samurai-platform/README.md)、[桌面依赖配方](linux-port/packages/samurai-desktop/README.md) |
| 蓝牙、Wi-Fi与USB | [130 BlueZ](sessions/130-standard-bluez-discovery-and-startup-integration.md)、[128 Wi-Fi](sessions/128-wcn3990-pairwise-key-delete-and-5ghz.md)、[USB NCM/SSH](linux-port/docs/USB-NCM-SSH.md) |
| EUD/调试与固件来源 | [EUD](EUD.md)、[RX](RX-CONSOLE.md)、[SWD/JTAG](SWD-JTAG.md)、[BINARIES](BINARIES.md)、[测试飞轮](FLYWHEEL.md) |
| 同平台显示交接比较 | [参考说明](reference/display-handoff-comparison/README.md) |
| 2026-10-17后续修复发布与返回文件 | [发布记录](reference/publication-2026-10-17/README.md)、[248备份状态](reference/kernel248/STATUS.md) |
| 2026-10-14分类提交与公开副本范围 | [发布记录](reference/publication-2026-10-14/README.md) |

## 历史位置

- [sessions/INDEX](sessions/INDEX.md)：会话和reference目录入口，按现有文件生成；包括只有reference记录的晚期阶段。
- [reference/DECISIONS](reference/DECISIONS.md)：旧8—11节决策；[Linux技术索引](linux-port/docs/00-INDEX.md)保留19—28节入口。
- [维护前快照](archive/docs-before-maintenance-2026-10-14/README.md)：旧README、交接、检查点和脚本原文，manifest.json保留SHA256；快照中的相对链接按原路径解释。
- `archive/`：早期拆分全文和已保存的状态快照。历史的“当前”和临时禁令只描述对应阶段。
- [HANDOVER](HANDOVER.md)、[旧方案评估](EVALUATION-AND-PLAN.md)、[旧机型说明](DEVICE-README.md)为历史入口，正文已归档。

## 检查与同步

Windows工作区是编辑源，WSL EDK2仓库的`Platform/Realme/sm8150`为镜像。在WSL运行：

```bash
python3 '/mnt/e/RealmeX2Pro edk2/linux-port/scripts/generate-session-index.py'
bash '/mnt/e/RealmeX2Pro edk2/linux-port/scripts/docs-health-check.sh' --local-only
bash '/mnt/e/RealmeX2Pro edk2/linux-port/scripts/sync-docs-to-repo.sh' --copy-only
bash '/mnt/e/RealmeX2Pro edk2/linux-port/scripts/docs-health-check.sh'
```

同步清单见[docs-sync-manifest.json](linux-port/scripts/docs-sync-manifest.json)，覆盖通用/音频提示词、检查点、边界、技术导航、会话、证据、归档、Mesa0015补丁及文档维护脚本。仓库使用脱敏公开副本，设备标识、启动ID和真实无线地址替换为PRIVATE标记，密码/密钥禁止导出；本地原始资料保持。Python缓存、备份及原始二进制属性不纳入同步或提交。仅同步模式不提交或推送。需要提交推送时显式使用`--publish '提交说明'`；工具只暂存清单范围，仓库存在预先暂存改动时停止发布，避免混入其他工作。

`mirror-linux-port.sh`是旧的全Linux侧镜像/提交脚本，只有需要同步Linux源码与全部脚本时才按具体任务使用。日常文档维护使用上面的清单工具。

健康检查验证入口的本地链接、旧8—30节唯一归属、生成索引、归档哈希、文档体积、仓库记录及公开镜像一致性。本地归档是逐字快照；仓库归档是脱敏副本，清单分别记录原文和公开副本SHA256。快照链接按原路径解释；历史技术正文的全目录链接审计可用`--audit-history`查看。历史脚本中的PRIVATE标记需由本地私人输入补齐，不能直接作为设备身份使用。

## 日常维护约定

1. 每份入口写清用途与核对日期。文档整理日期和设备实测日期分别说明。
2. 新会话保存问题、改动、实际结果、失败/回退、证据和未验收范围；已有reference记录可以直接索引，无需再复制一份正文。
3. 设备组合和回退身份只维护在检查点；功能验收只维护在硬件清单；当前限制只维护在WORKING-BOUNDARIES。
4. 入口通过链接指向来源；检查点过程较长时整理进专题历史，并保留原文快照与哈希。
5. 改动后重生成会话索引、运行检查并同步。原始日志、密钥、私人身份/录音及重要备份保留在私人目录；生成镜像不由文档同步工具复制。
