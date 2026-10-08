# 文档索引（realme X2 Pro / samurai）—— 仓库与 Windows 工作区

> 生成：2026-10-08（Asia/Shanghai）。
> **真源 = 本仓库**（`hmhmdcy/edk2-realme-x2-pro`，分支 master）；Windows 工作区 `E:\RealmeX2Pro edk2\` 只是镜像/草稿盘。
> 本文同时存在于两边，内容一致；改动请同时更新（或只改这份再复制过去）。

## 1. 文档地图

| 位置 | 角色 | 状态 |
|---|---|---|
| `README.md`（仓库根） | 项目门面（fork 介绍、构建、刷机） | ✅ |
| `Platform/Realme/sm8150/README.md` | 机型包说明：能力矩阵、关键修复、坑 | ✅ |
| `Platform/Realme/sm8150/HANDOVER-NEXT.md` | 会话交接 + 全部历史时间线（30 节，109 KB） | ⚠️ **要拆**：§20–§27 与 `linux-port/docs/sectionNN-*.md` 内容重复；§19、§28 两边已漂移 |
| `Platform/Realme/sm8150/EUD.md` | EUD 大合集：寄存器、CTL/COM、日志环、SWD/JTAG、RX console | ⚠️ 建议拆成 EUD / SWD-JTAG / RX-console 三份 |
| `Platform/Realme/sm8150/BINARIES.md` | 设备 blob 来源与 DEPEX 补丁 | ✅ |
| `Platform/Realme/sm8150/HANDOVER.md` | 2026-10-06 早期交接（含已被推翻的判断） | 历史，保留 |
| `Platform/Realme/sm8150/DIAG-CAPTURE.md` | 2026-10-06 诊断镜像（音量下键）抓取记录；文件内其实拼了两篇 | 历史；建议拆开 |
| `Platform/Realme/sm8150/EVALUATION-AND-PLAN.md` | 2026-10-06 方案评估（纠正交接里的错误判断） | 历史，保留 |
| `Platform/Realme/sm8150/linux-port/**` | 主线 Linux 侧镜像（README、docs/sectionNN、dts、patches、scripts、refs、initramfs） | ✅ 由 `scripts/mirror-linux-port.sh` 从 Windows 侧同步 |
| `E:\RealmeX2Pro edk2\DEVICE-README.md`、`tools\*` | 旧版机型说明 / 旧 README 快照 | 未纳入仓库（内容已被上面覆盖，可删） |
| `E:\RealmeX2Pro edk2\HANDOVER.md` | 早期交接的另一版本（与仓库里的 `HANDOVER.md` 不同） | 未纳入，内容见 Mnemon `e727fe02` |
| `E:\RealmeX2Pro edk2\linux-port\artifacts\*` | 30 MB 内核 Image、dtb、反编译 dts | 可重建，故意不纳入 |
| `E:\Realme X2 Pro移植主线Linux\` | 2026-10-05 的早期主线移植工作区（自带 docs/ 6 篇 + sources.lock.json） | 独立目录，未纳入；属历史路线 |

**Mnemon 托管文档**（≥6 篇，重叠）：`e727fe02` 原始交接 · `5ed117b8` 方案评估 · `6af43daf` 里程碑 · `d650cb6b` 按键+U 盘 · `d01a9dce` 总结与索引 · `06827d0c` EUD SWD/JTAG。缺唯一入口，互相用裸 UUID 引用。

**运行时 MEMORY.md**：7 条 / 9383 字节（上限 10240，≈92%），混有带日期的会话日志 → 应只留指针。

## 2. 需要整理的事项（按优先级）

- **P0** ① MEMORY.md 瘦身（日期日志迁出，只留结论+指针）；② Mnemon 指定唯一入口、老交接标 superseded。
- **P1** ③ 拆 `HANDOVER-NEXT.md`：§0–§7 → 常驻入口（当前状态/下一步/工具/坑/安全），§2+§8–§11 → 事实与决策，§12–§30 → `sessions/`；§19–§28 直接指向已有的 `linux-port/docs/sectionNN`，不再复制；④ 拆 `DIAG-CAPTURE.md`、`EUD.md`。
- **P2** ⑤ 文档只有一个真源，镜像文件头部标 `镜像自 <repo>@<commit>`；⑥ `linux-port/docs/` 加索引、`sectionNN` 改名 `NN-<topic>`；⑦ 每次同步后跑「文档体检」：最大文件、重复标题、失效链接、过期日期。

## 3. 维护规则

1. 一个主题一个文件；文件头写：用途 / 真源位置 / 最后核对日期 / 关联文档。
2. 时间线只追加到 `sessions\YYYY-MM-DD-<topic>.md`；入口文档只改「当前状态 + 下一步」。
3. 同一事实只写一处，其它位置写指针（文件 + 节号）。
4. Windows 侧 `linux-port/` 用 `scripts/mirror-linux-port.sh` 同步（该脚本会 `git add -f refs/`，因为顶层 `.gitignore` 忽略了 `*.dts`）；机型包顶层文档目前靠手工复制，建议并入同一脚本。
5. 提交并推送到 fork（`git push fork master`）；`origin` 是上游 `edk2-porting/edk2-msm`，不要往那边推。

## 4. 已知的安全待办

- `HANDOVER-NEXT.md` §22.6：内核侧用的 PAT 需要轮换（文档里没有明文 token）。
- 只刷 `boot` / `logdump` 分区；U 盘模式不要被 PC 格式化；EUD 打开时占 USB，必须长按电源约 15 s 才能彻底断电。