# Realme X2 Pro 文档导航与维护

用途：阅读入口、专题证据、历史位置和维护方法。最后整理：2026-10-25；实际硬件结果和未验收范围见功能清单与当前检查点。

## 入口与职责

| 需要了解 | 唯一维护位置 |
| --- | --- |
| 当前适配进展 | [当前检查点](NEXT-SESSION.md)、[484四摄原厂自动调校](reference/kernel484/README.md)、[充电离线交接](reference/charging-management-20261023/charging-adaptation-handoff-20261025.md) |
| 最后核对的部署、源码/产物差异、回退依据与续作项 | [NEXT-SESSION](NEXT-SESSION.md) |
| 历史清理、保留产物与重建方法 | [2026-10-19交接](reference/maintenance-2026-10-19/README.md) |
| 当前有效操作规则 | [WORKING-BOUNDARIES](WORKING-BOUNDARIES.md) |
| 原厂固件/公开仓库提取优先与快速迭代 | [PORTING-WORKFLOW](linux-port/docs/PORTING-WORKFLOW.md) |
| 各功能已证明能力、缺陷及待验收范围 | [HARDWARE-STATUS](linux-port/docs/HARDWARE-STATUS.md) |
| 项目介绍与通用构建说明 | [README](README.md) |
| Linux源码、补丁、rootfs和工具导航 | [Linux README](linux-port/README.md)、[技术文档索引](linux-port/docs/00-INDEX.md) |
| 仓库提交记录、工具路径与旧8—30节映射 | [HANDOVER-NEXT](HANDOVER-NEXT.md) |
| 新会话阅读提示 | [通用提示词](NEXT-SESSION-PROMPT.md)、[音频任务提示词](AUDIO-NEXT-SESSION-PROMPT.txt) |

提示词引用检查点，README和交接导航引用功能清单。实验过程写入sessions/或reference/，入口不再累积阶段摘要。

续作先读检查点、当前规则和适配工作流，再按本轮缺口查对应功能与证据；不要求通读历史。2026-10-23进一步取消日常全量文档检查、同步、固定测试规模和报告修订后的无必要回滚；硬件/校准优先复用或提取原厂资料、公开仓库实现，缺项再实测。旧实验条件按历史解释。

## 专题与证据

| 专题 | 阅读入口 |
| --- | --- |
| 用户态复现、上游维护与补丁纯度 | [249整合与独立核验](reference/kernel249/README.md) |
| 显示152—165候选、失败、回退与实屏验收 | [过程汇总](sessions/display-handoff-152-165.md)、[165证据](reference/kernel165/README.md)、[实屏反馈](reference/kernel165/physical-feedback-validation.json) |
| GPU旧CCU修复与Snapshot新负载故障 | [240故障及CPU回退](reference/kernel240/README.md)、[147内核修复](sessions/147-a640-gmem-alignment-fix.md)、[149 Mesa修复](sessions/149-vulkan-ccu-alignment-fix-and-deployment.md)、[151收尾](sessions/151-gpu-closeout-and-hardware-handover.md) |
| 音频首次初始化与停止链 | [139 TX回收](sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)、[104 DMIC](sessions/104-native-digital-microphones-and-first-boot-radio-failure.md)、[164失败](reference/kernel164/README.md) |
| 电池/充电控制与输入预算 | [2026-10-23充电适配当前进度](reference/charging-management-20261023/PROGRESS.md)、[候选源码与离线验证](reference/charging-management-20261023/README.md)、[132观测部署](sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)、[133预算研究](sessions/133-usb-power-budget-and-charge-contract.md)、[138恢复阈值](sessions/138-readonly-charger-recharge-threshold.md) |
| GNSS标准链路、原厂对照与modem文件服务 | [260桌面定位](reference/kernel260/README.md)、[258原生/原厂对照](reference/kernel258/README.md)、[253 RF/初始化](reference/kernel253/README.md)、[239近机型方案](reference/kernel239/RELATED-LINUX-SOLUTIONS.md)、其它阶段见[会话索引](sessions/INDEX.md) |
| 相机驱动、原厂调校与完整范围 | [相机入口](reference/linux-port-camera/README.md)、[484当前实装](reference/kernel484/README.md)、[491暂停交接](reference/kernel491/HANDOFF.md)、[363完整范围](reference/kernel363/REMAINING-CAMERA-SCOPE.md)、[原厂提取工作流](linux-port/docs/PORTING-WORKFLOW.md) |
| 传感器板级方向与桌面启动顺序 | [269旋转修复与验证边界](reference/kernel269/README.md)、[平台配方](reference/linux-port-packages/samurai-platform/README.md)、[桌面依赖配方](reference/linux-port-packages/samurai-desktop/README.md) |
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

旧的Windows工作区同步脚本已移到[reference/linux-port-scripts](reference/linux-port-scripts/)保存历史。归档脚本中的固定工作目录仅供追溯，不再作为公开复现入口。活动树使用以下检查：

```bash
python3 Platform/Realme/sm8150/tools/check-portable-tree.py
./build.sh -d samurai --toolchain GCC5 --skip-rootfs-gen
python3 Platform/Realme/sm8150/tools/verify-bootimg.py
```

活动树禁止出现开发者主目录、Windows盘符路径或`/mnt/<盘符>/`路径。会话、reference和archive可以保留历史原文，但其中的设备标识、启动ID和真实无线地址继续视为私有资料；密码、密钥和私人备份不得导出。

## 日常维护约定

1. 每份入口写清用途与核对日期。文档整理日期和设备实测日期分别说明。
2. 新会话保存问题、改动、实际结果、失败/回退、证据和未验收范围；已有reference记录可以直接索引，无需再复制一份正文。
3. 设备组合和回退身份只维护在检查点；功能验收只维护在硬件清单；当前限制只维护在WORKING-BOUNDARIES。
4. 入口链接到已有来源，不再逐阶段追加“当前”摘要；过程集中在专题记录。已有原文与证据直接复用，重要且不可重建的内容被覆盖前才补充保存。
5. 按文件检查和按需同步，索引仅在条目/标题变化时更新；完整维护按上面的触发条件执行。原始日志、密钥、私人身份/录音及重要备份保留在私人目录，生成镜像不由文档同步工具复制。
