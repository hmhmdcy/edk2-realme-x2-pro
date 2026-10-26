# 2026-10-26：已适配内容整理发布

用途：记录本轮 EDK2 仓库公开范围内的适配源码、用户态包、设备树和证据整理。硬件是否验收仍以[硬件清单](../../linux-port/docs/HARDWARE-STATUS.md)和[检查点](../../NEXT-SESSION.md)为准；发布不扩大任何实机结论。

## 发布范围

本轮目标分支为 `hmhmdcy/realme-x2-pro-edk2` 的 `master`。在原发布端点 `f28c0035` 之后，分类提交包括：

| 组别 | 提交 | 内容 |
| --- | --- | --- |
| 文档同步 | `14550ff7` | 按文件增量同步、公开 UUID allowlist、充电候选排除规则 |
| 运行时 DTB | `6304026d` | 音频、触觉与 RMTFS 动态节点更新 |
| GNSS | `383e7ca9` | 桌面定位、GeoClue、位置辅助服务及 `kernel250` 至 `kernel260` 证据 |
| 平台/桌面 | `278ea218` | Samurai platform/desktop 软件包、设备服务脚本与 `kernel261` 审计 |
| 蓝牙 | `3770dc6a` | 主机栈、传输、静态修复、原厂对照及 Windows/LE 对端调查 |
| 维护审计 | `9635f869` | 全量升级、仓库审计、包加固与 `kernel314` 相机静态材料 |
| 充电交接 | `dc88f8d7` | 当前只读调查、失败/回退记录和后续交接 |
| 蓝牙索引 | `30c1f4dc` | 蓝牙总体功能状态、协调与运行期窗口工具 |

代码、包、补丁和证据均来自工作区已有内容；本次没有新增设备实机结论。充电仍处于调查和交接阶段，不表示充电控制、PD/APSD 或完整电源管理已经完成。

## 正式源码归属与最终端点

内核态、用户态和 EDK2 不再混用同一个“源码仓库”。本次核对结果如下：

2026-10-26 起三个正式仓库统一采用 `realme-x2-pro-<组件>` 命名。活动入口、脚本和新建 clone 使用下表新名称；`archive/`、`sessions/`、版本化 `reference/` 以及 `linux-port/docs/` 过程日志中记录旧名称的链接保留原样，以维持当时证据的上下文。GitHub 对旧仓库名的重定向只是兼容层，不作为长期构建输入。

| 层 | 正式仓库与分支 | 最终远端端点 | 内容 |
| --- | --- | --- | --- |
| 内核 bring-up | [`hmhmdcy/realme-x2-pro-linux@samurai-bringup`](https://github.com/hmhmdcy/realme-x2-pro-linux/tree/samurai-bringup) | `04d4d4f93171574201db1837a1b195e3aeccde4e` | 早期完整 camera/PMIC bring-up 历史 |
| 内核相机公共层 | [`hmhmdcy/realme-x2-pro-linux@samurai-camera-common`](https://github.com/hmhmdcy/realme-x2-pro-linux/tree/samurai-camera-common) | `1f5da50bbcba4fbe89917db7987429fdf078f257` | common driver、静态 DT 描述与后续相机基线 |
| 内核 VFE175/GTM | [`hmhmdcy/realme-x2-pro-linux@samurai-vfe175-gtm-reopen434`](https://github.com/hmhmdcy/realme-x2-pro-linux/tree/samurai-vfe175-gtm-reopen434) | `9bc07e6339128ae8d3525c7d5c9bca5d0fbc46f3` | VFE175、GTM/LTM 与 PD10 相机处理 |
| 内核当前端点 | [`hmhmdcy/realme-x2-pro-linux@samurai-ipe-variable-pd10-441`](https://github.com/hmhmdcy/realme-x2-pro-linux/tree/samurai-ipe-variable-pd10-441) | `5b0e7a9ac5b311a4c4fe17cf48b7ed4fc9a7b91d` | variable-size PD10、无 SOF 与 auxiliary restart 诊断 |
| 用户态配方 | [`hmhmdcy/realme-x2-pro-pmaports@samurai-userspace`](https://github.com/hmhmdcy/realme-x2-pro-pmaports/tree/samurai-userspace) | `6e3b915fdf55c95ffee8a4be7ef2e1bd44342bcd` | APKBUILD、补丁、OpenRC/udev/桌面配置和服务脚本 |
| 快照与证据 | [`hmhmdcy/realme-x2-pro-edk2@master`](https://github.com/hmhmdcy/realme-x2-pro-edk2/tree/master) | 本次发布索引提交之后的 `master` | EDK2、DTB、历史源码快照、发布索引和验证证据 |

用户态分支在原有 6 个主题提交之后追加 6 个提交，未改写并普通推送：

| 提交 | 内容 |
| --- | --- |
| `b2a62dd` | libcamera r33、52 个相机补丁、四摄 CAMSS/simple YAML 与源码锁 |
| `2f51999` | GNSS 无 SIM 电源策略、14 项测试与 GeoClue ModemManager 生命周期修复 |
| `7255bd2` | PipeWire r3 与 6 个相机缓冲生命周期补丁 |
| `e4ea949` | SensorProxy 方向、PipeWire Bluetooth、USB `MaxPower`/重绑定与旧 PMIC lab 配置移除 |
| `01dc099` | bootstrap、rootfs/source 检查、52 补丁重放和仓库归属文档 |
| `6e3b915` | 三个正式仓库统一为 `realme-x2-pro-<组件>` 命名并更新活动引用 |

该端点的 GitHub Actions 源码作业成功，且运行记录的 `headSha` 与上表一致：[run 40251202806](https://github.com/hmhmdcy/realme-x2-pro-pmaports/actions/runs/40251202806)。该工作流本次只执行 `check-sources.py`，没有触发可选的全量 ARM64 包构建，更没有进行手机刷写或硬件验收。

本地发布前检查还得到：16 个配方、149 个本地 SHA512、168 个源码/脚本/补丁文件和 1 个 pmbootstrap 工具补丁通过；libcamera 52 个补丁以 `--fuzz=0` 重放成功，最终树 SHA256 为 `ae7785b15bc1c9d7434e0804961a0a6713f737beade9668630b8541680587307`；GNSS 电源策略 14 项场景通过。以上均为离线结果，`hardware_tested=false`。

## 尚未闭环

- `libcamera 99990.7.2-r34` / `samurai-camera-config 0.1.0-r29` 只有离线打包、签名和缓存求解记录，不是已安装发布版本；当前证据端点仍为 r33/r28。
- GNSS 仍为零 CNR、无 fix；新电源策略和 GeoClue 生命周期修复没有证明定位根因已经解决。
- 相机 Manager 重开与 long-run、实屏色彩、编码录像/HDR、多摄同步和第五摄仍未闭环。
- 最新 Linux 分支仍含实验 OF fixture、前摄 overlay、专用 trace 和历史 lab PMIC 机制。源码已进入正确内核仓库不等于已经纯化成可合入上游的驱动。

## 公开边界

公开副本继续使用[同步清单](../../linux-port/scripts/docs-sync-manifest.json)生成。以下未完成且含测试构建产物的候选目录只保留在本地私人工作区，不进入公开镜像或仓库：

- `reference/charging-session-20261023/`
- `reference/charging-ui-audit-20261023/`
- `reference/charging-oem-audit-20261023/`

设备身份、真实无线地址、密钥、原始日志和可执行/归档二进制仍按既有规则排除或脱敏。蓝牙证据保留了来源锁文件对应的原始字节，包括部分 CRLF 文本，以免改写后破坏 SHA256 证据。

## 核对结果

- 完整文档镜像同步覆盖 20,185 个文件，更新 199 个文件，公开镜像检查通过。
- GNSS 电源策略 14 项测试全部通过。
- 相关 Python 编译检查、JSON 解析和 Shell `bash -n` 检查通过。
- 更新后的 DTB 可由 `dtc -I dtb -O dts` 正常解析。
- `reference/kernel259` 与 `reference/kernel260` 的 CRLF JSON 已统一为 LF。
- 内核四个远端分支和用户态 `samurai-userspace` 端点均由 `git ls-remote` 重新读取；用户态 Actions 源码作业成功。
- 本轮提交推送后，应以 `git ls-remote` 读取的分支端点作为最终公开状态。

本次整理提交自身不重复列入上表；当前部署、未完成项与回退边界见[充电交接](../charging-management-20261023/charging-adaptation-handoff-20261025.md)及[检查点](../../NEXT-SESSION.md)。
