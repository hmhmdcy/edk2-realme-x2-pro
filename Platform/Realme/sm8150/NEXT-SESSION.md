# Realme X2 Pro 当前检查点

用途：续作时核对部署、源码、回退依据和待办。设备事实最后核对：2026-10-14，阶段165后的用户实屏反馈及只读核对；本次文档维护未新增实机测试。操作规则以[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)为准。

## 最后核对的部署与验收范围

| 项目 | 最后核对结果 |
| --- | --- |
| 部署组合 | kernel163、boot164/logdump163、modules132/software132，加Mesa149本地修复库 |
| 身份判断 | release仍为`7.3.0-rc6-rmx1931-samurai-k132+`；按`uname -v`核对内核构建号，DRM按by-path解析 |
| 显示 | 用户确认EDK2之后无白屏/花屏，先黑屏等待，再显示Linux命令行；本次交接故障按已测范围收尾 |
| 反馈后新boot | boot/logdump读回与内核构建号匹配，桌面进程存在、taint0，显示/GPU/WARN/audio DMA prepare计数均0；该轮未发送重启或刷写命令，启动来源未知 |
| 165历史软件验收 | Phosh21.45秒、24次DPMS、12次首帧门控及601.15秒同boot/PID稳态通过；这些测量属于此前boot |
| 仍未闭环 | 黑屏等待时长、冷启动、休眠及更长期可靠性；164首次音频WARN1/DMA prepare917与157非指令重启原因未知 |

依据：[165验收与实屏反馈](reference/kernel165/README.md)、[实屏反馈核对](reference/kernel165/physical-feedback-validation.json)。各功能已证明能力与未验收范围统一见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

反馈后的私人身份收据保存在独立输出目录`kernel165/user-feedback-live-private.json`。165 first-boot、160及旧preflash/source身份均已过期；需要切换时重新核对真实设备身份。

## 源码、产物与回退依据

- Linux源码及主Image为163；15个显示相关文件与编译哈希一致。最后交接的WSL源码路径为`/home/cy122/pmos-samurai-kernel136/kernel`，目录名不表示运行构建号，续作先核对路径与源码。161空RMR/SMMU候选已拒收并撤销。
- EDK2 BDS源码为164候选，C/INF两文件有修改；构建时临时使用实际132/163 DTB，随后恢复源码树原有旧129 DTB。
- 工作区生成固件是`pristine132`对照，实际164包在独立`kernel164`输出目录。刷写包应依据[164构建证据](reference/kernel164/README.md)核对。
- 原版boot132及不可变logdump158/163备份保留。162时重建的#158主Image不是原始字节副本，未用于回退。
- [15文件内核合并补丁](reference/kernel165/kernel-display-fix-from154.patch)基于154，逆向apply检查通过；[固件164补丁](reference/kernel164/before-exit-panel-reset.patch)属于另一个仓库。原始日志、身份和密钥保存在私人目录。
- Mesa147/149修复保持；150无本地Mesa补丁的降级候选未部署。普通Mesa更新及旧rootfs132镜像可能覆盖本地库，后续软件包与完整rootfs需纳入[0015补丁](linux-port/patches/0015-mesa-turnip-a640-vm-bind-iova-alignment.patch)。

## 续作与已知风险

1. 先核对当前设备、源码及产物身份，读取[操作边界](WORKING-BOUNDARIES.md)。本次显示交接故障已收尾，后续工作按用户任务推进。
2. 音频首次DMA初始化/停止链与充电控制保护为下一阶段重点；音频任务入口见[AUDIO-NEXT-SESSION-PROMPT](AUDIO-NEXT-SESSION-PROMPT.txt)。164失败未在165及反馈后新boot重现，根因仍未知。
3. 151软件包数据库差异、实体camera、完整传感器、蜂窝业务/GNSS/指纹/NFC及跨功能冷启动、休眠、长稳见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。
4. 165临时启动记录器已停止并退出boot runlevel；历史测试收据与本次身份分开核对。显示电源回归使用`DisplayConfig.PowerSaveMode`；`wlr-randr --off`曾移除唯一输出并导致Phosh崩溃。

显示152—165的候选、失败、回退和验收顺序见[显示修复过程](sessions/display-handoff-152-165.md)。全部历史入口见[会话索引](sessions/INDEX.md)，维护与同步见[文档导航](DOCS-INDEX.md)。
