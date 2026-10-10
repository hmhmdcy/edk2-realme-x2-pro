# 交接方案评估 + 本轮执行结果（realme X2 Pro / samurai / SM8150）

当前优先级（2026-10-10）：按用户要求，充电阶段收尾，下一项优先Wi-Fi。
最新实机/候选/未解决项见[session87](sessions/87-stage-wrap-up-and-wifi-prerequisites.md)和
[硬件状态](linux-port/docs/HARDWARE-STATUS.md)。下文为此前评估，涉及旧状态时以最新记录为准。


生成时间：2026-10-06 03:3x (Asia/Shanghai)。评估对象：HANDOVER.md（Mnemon 文档 e727fe02… / 本目录 HANDOVER.md）。
设备当前未连接（adb devices 为空），因此本轮产物**未经真机验证**；下方明确标注了哪些是已验证事实、哪些是推断。

## 0. 结论速览

1. 交接文档的**事实收集基本可靠**（设备信息、构建环境、备份、原厂素材位置、MLVM 段存在），但**根因归因和推荐路线都需要修正**。
2. 真凶（证据链最强）：**构建出的 boot 镜像布局背离了本项目自带、且已被同 SoC 机型验证过的规范布局**；其次是**运行时 DTB / 内存档位**问题，而不是"内存表数值填错"。
3. 交接主张的"改用 MU-sm8150pkg"是**成本最高**的路线，且其中若干细节是错的（见 §2）。EDK2-MSM 路线只需 4 处最小改动即可产出规范镜像 —— 本轮已完成。
4. 本轮已交付两个可刷候选镜像（§5），结构与已知可用的 boot-cepheus.img 一致，并额外按设备真值修正了 MLVM 保留区。

## 1. 经核实为「真」的部分

- 设备：RMX1931CN / samurai / SM8150-AC / msmnile；adb 序列号、BL 解锁、备份 sha256、恢复流程与现场一致。
- 构建环境与坑（GCC15 需 -std=gnu17、无 sudo 用 dpkg-deb 解 uuid-dev、msgfmt 桩、GCC5、tools/mkbootimg.py）实测仍有效。
- `Project-Aloha/UEFIFirmwareBackup` 确有 `realme-rmx1931`（266 个文件）：含 `RMX1931CN_xbl.img`、`2.uefif`、`Binaries/`（APRIORI.inc/DXE.inc/DXE.dsc.inc + 完整 DXE + RawFiles/uefiplat.cfg + Panel_*.xml）。
- `Project-Aloha/mu_aloha_platforms` 的 main 分支确有**完整**设备包 `Platforms/SurfaceDuo1Pkg/Device/realme-rmx2086/`（283 文件，含两个 Library 模板、DTB、ACPI、Binaries、PatchedBinaries）。
- PEI 的 `Silicon/Qualcomm/QcomPkg/Library/MemoryInitPeiLib/MemoryInitPeiLib.c` 确实 `#define FDT_DIRECT` 并通过 `GetFdt()` 取运行时 DTB；DTB 指针槽 `PcdDeviceTreeStore = 0x9E000000`（PrePi/ModuleEntryPoint.S 由 x0 写入）。
- rmx1931 的 `uefiplat.cfg` 确实把 `0xA0000000..0xB9400000` 标为 MLVM_APSS / MLVM_1 / MLVM（Reserv）。
- 原厂/能启动镜像确实是 **header v1 + gzip 内核 + 尾部追加 DTB**（已用脚本实测 stock 与 TWRP 镜像）。

## 2. 经核实为「错」或需要纠正的部分

(a) **"改用 MU-sm8150pkg"** → 不存在该包名。对应实现是 `Build/SurfaceDuo1Pkg`（平台 Sm8150，见 build_cfg/sm8150.json）。仓库中亦无 mu_edk2，其 edk2 fork 是子模块 `MU_BASECORE`。
(b) **"在 SurfaceDuo1.dsc/.fdf 注册 realme-rmx1931（BUILD_DEVICE_ID）"** → 全仓库不存在 BUILD_DEVICE_ID。注册机制 = 在 `Platforms/SurfaceDuo1Pkg/Device/` 下新建目录 + `./build_uefi.py -d <目录名>`；共享 DSC/FDF 通过 `$(TARGET_DEVICE)` 自动 include，**无需**改 dsc/fdf。
(c) **"FD_BASE：edk2-msm 0xCE000000 vs MU 0x9FC00000"** → 偷换概念。0x9FC00000 是 uefiplat.cfg 里 XBL 固件 FD 的保留地址；boot.img 流程中 BootShim 把 UEFI FD 拷贝到 `FD_BASE=0xCE000000`（`make UEFI_BASE=${FD_BASE}`，见 tools/BootShim/Makefile 与 build.sh:121）。两者不是同一类东西，不能作为选型依据。
(d) **"realme 实际 kernel 在 0xA8880000（非 0x80000000）"** → 这是 **KASLR 物理随机化**结果，不是设备固件布局。同一次 iomem 中 Kernel data 紧随其后（0xAB600000），而 DTB 的 memory 节点是从 0x80000000 起。该推断不成立（但由此引出的 MLVM 保留结论**方向正确**，理由见 §3）。
(e) **最关键的遗漏：内存表"档位"取决于 DTB**。`MemoryPeim()` 先用 `fdt_get_memory()` 累加 DTB 的 memory 节点，落到 7168–8704MB 才选 `Mem8G` 档；内存表里 0xC0000000 起的 2GB×N 常规内存**只在对应档位才被加入映射**。若运行时 DTB 缺失/未被修补 → 累加为 0 → `MemGB=4` → 0xC0000000+ 全部不映射 —— 而 BootShim 恰好把 7MB 的 FD 拷到 **0xCE000000**，正落在这个区间 → 必挂。**"DTB 是否正确传给 UEFI" 比 "内存表差几条" 更致命。**
(f) **布局被私自改坏**：现场留下的 `Platform/Realme/sm8150/samurai.sh.inc` 覆盖了项目默认钩子 `Silicon/platform.sh.inc`，做了三件与规范相反的事：内核**不压缩**、**不追加 DTB**、改用 **header v2 + 独立 dtb 段**（且把 BootShim.S 的 image_size 改成 UEFI_SIZE+0x90）。交接只记录了"试过各种参数"，没有记录"规范布局是否真被按项目默认方式测过"。

## 3. 证据链（本轮新取得）

- **可用参照**：仓库自带 `boot-cepheus.img`（SM8150，OnePlus 7）：hdr v1 / page 2048 / kernel=gzip(BootShim+FD) / **尾部追加 cepheus.dtb** / ramdisk 1 byte。
- **失败产物**：改动前的 boot-samurai.img：hdr v2 / page 4096 / **未压缩** / dtb 走 v2 段 / ramdisk 4MB（原厂 LZ4）。
- **原厂镜像** `boot_stock_RMX1931.img`：hdr v1 / gzip(52MB) / 尾部追加 DTB(450826B) / LZ4 4MB ramdisk。
- **fdt_live.dtb（运行中 Android 的 DTB，已由 ABL 修补）**：memory 三段合计 8123MB → **8G 档**；低段为 0x80000000–0xBBB00000，与内存表 8G 档的 MLVM 段终点 0xBBB00000 **完全吻合**。
- **custom_base.dtb / samurai.dtb（原厂 boot.img 内 DTB）**：`/memory reg = (0,0)` → 证明 **ABL 在启动时修补 memory 节点**；所以追加的 DTB 必须是 ABL 认识、能与 dtbo overlay 匹配的那一份（用原厂提取的 samurai.dtb 正确）。
- **fdt_live.dtb 的 reserved-memory**：`qseecom_region 0xA0000000+0x1400000`、`cdsp_sec_regions 0xA4C00000+0xC00000` 均为 no-map。这正是 Linux iomem 中 0xA0000000–0xA13FFFFF、0xA4C00000–0xA57FFFFF 两段"保留"的来源，也解释了 rmx1931 uefiplat.cfg 的 MLVM 保留段。→ 证实交接"MLVM 必须保留"的结论，同时纠正其归因。
- **rmx2086 的内存表不能直接用于 rmx1931**（mu-scout 独立复核）：该表把 0xA0000000+ 当普通 RAM。

## 4. 本轮改动（edk2-msm 路线，最小改动集）

1. `git checkout -- tools/BootShim/BootShim.S` 恢复上游（撤销 image_size=UEFI_SIZE+0x90 的实验改动）。
2. `Platform/Realme/sm8150/samurai.sh.inc` → `.disabled`，改用项目默认钩子：`gzip(BootShim.bin + SM8150_UEFI.fd)` + 尾部追加 `FdtBlob_compat/samurai.dtb`。
3. `configs/devices/samurai.conf`：`BOOTIMG_HEADER_VERSION` 2 → **1**（与 cepheus / 原厂一致）。
4. `Platform/Realme/sm8150/samurai.dsc`：GCC 旗标加 `-DHAS_MLVM` → `PlatformMemoryMapLib` 在 8G 档把 `0xA0000000..0xBBB00000` 标为 **Reserv**（与设备真值/DTB no-map 段一致，同时仍保留 0xC0000000 起的 Conv 供 FD/BootShim 使用）。
5. 重新构建：`./build.sh -d samurai --toolchain GCC5`（edk2 编译 1 分 51 秒，无错误）。
6. 验证：最终 FD 内检出 `MLVM` 字符串 ×3（`HAS_MLVM` 确实生效）；产出的镜像结构与 boot-cepheus.img 逐字段一致（仅追加 DTB 大小不同）。

## 5. 产物（E:\edk2-samurai-out\）

| 文件 | 大小 | sha256 | 说明 |
|---|---|---|---|
| boot-samurai-canonical.img | 6,713,344 | 3f7829fcb14c6662730829730d2790d5838479d723defabd543dca49f28e9bca | **首选**：v1 / page 2048 / gzip+追加DTB / 1B ramdisk（等同 cepheus 规范） |
| boot-samurai-canonical-stockhdr.img | 10,731,520 | ec0a85ed2ee9300210a59fc6517be6bbac761df2350db0a8b21b9c1fbc67d512 | 备选：同一内核载荷，但用原厂 header 几何（page 4096 / kernel 0x8000 / ramdisk 0x1000000 / tags 0x100）+ 原厂 LZ4 ramdisk |
| SM8150_UEFI-samurai-canonical.fd | 7,340,032 | b6e1b1e4641741eedeaee84feb77dca192ca5785df8549bbcd87a4ca7e41c05b | 裸固件卷（含 samurai DXE + DTB + ACPI + HAS_MLVM 内存表） |

两者共用同一内核载荷（= gzip(144B BootShim + 7,340,032B FD) + 450,826B 追加 DTB），差别只在 header 几何与 ramdisk。

## 6. 真机测试协议（必须先做，且只做 fastboot boot）

前置：保留 `backup\boot_stock_RMX1931.img`（sha256 dfe18875…）；回滚命令见交接 §1。

关键：**先不要 flash，用 `fastboot boot` 临时启动**，同时观察三件事（这是区分"UEFI 没跑起来"和"UEFI 跑起来了但没显示"的唯一低成本手段）：

1. **USB 侧**：Windows 设备管理器 / `adb devices` / `lsusb` 是否出现新设备（SimpleInit + UsbPwrCtrlDxe 会枚举 USB）。出现 = UEFI 已经在跑。
2. **屏幕**：是否有任何变化（背光、花屏、黑屏、logo 闪烁）。
3. **是否自动回到 fastboot**（= ABL 拒绝镜像，说明布局仍不对）。

判读：
- USB 有反应、屏黑 → 问题已从"启动/内存"转移到"显示"（下步开 USE_DISPLAYDXE + 原厂 Panel_samsung_sofef03f_m_amoled_fhd_90fps_dsc_cmd.xml）。
- 完全无反应 → 需要 UART（research/ 里有 BootLinux.c / Decompress.c），或转 MU 路线。
- 回到 fastboot → 换第 2 个候选镜像（stockhdr 几何）再试。

顺序建议：先 boot-samurai-canonical.img → 不行再 boot-samurai-canonical-stockhdr.img。

## 7. MU 路线（战略备选）现状与本轮进展

- `~/mu-aloha` 已克隆（blob:none，19434 文件；sparse 出 SurfaceDuo1Pkg + build_cfg）。
- 已委派 mu-scout 生成 `Platforms/SurfaceDuo1Pkg/Device/realme-rmx1931/`：由 rmx1931 自己的 uefiplat.cfg 生成 PlatformMemoryMapLib / PlatformConfigurationMapLib，按 rmx2086 顶层风格重写 APRIORI.inc/DXE.inc/DXE.dsc.inc（用 rmx1931 自己的驱动集，避免引用它没有的 OGaugeAuthDxe/OcdtDxe/PhoenixDxe），PcdsFixedAtBuild 改 1080x2400/SMBIOS rmx1931/PcdMLVMBase=0xA0000000，DTB/DSDT 先用 rmx2086 占位并标注。
- **真正构建的前置成本很高**：需初始化 10 个子模块（MU_BASECORE = edk2 fork、Common/MU、SurfaceDuoBinaries-fork、openssl…，GB 级），build_setup.sh 需要 sudo apt（本机无 sudo）→ 建议 Docker；且 build_setup.sh 里 `CLANGPDB_BIN=/usr/lib/llvm-38/bin/` 疑似 bug（llvm-38 不存在）。
- 结论：**先用本轮 edk2-msm 镜像真机验证**。若 UEFI 能起来，是否迁 MU 再议；若起不来，再投入 MU 路线的构建成本。

## 8. 遗留 / 待办

- [ ] 真机验证本轮镜像（设备未连接，本轮无法执行）。
- [ ] 若 UEFI 已跑但不显示：启用 USE_DISPLAYDXE + 导入原厂 panel XML / DBI 相关驱动。
- [ ] Windows 化：DSDT 仍是 cepheus 借用版，需按 samurai 适配（Mu 路线的 ACPI/DSDT.aml 亦为占位）。
- [ ] samurai 专属 Linux/Android DTB（当前是原厂 DTB 占位）——用于 postmarketOS/主线时再换。
- [ ] 若要长期维护：把本轮 4 处改动正规化为 device hook（例如 Platform/Realme/sm8150/realme-memmap.patch 说明），并给 edk2-msm 上游提 PR（新增 MEMMAP_REALME / 设备 conf）。

## 9. 复现命令

    cd ~/edk2-samurai/repo
    export PATH=$HOME/.local/bin:$PATH
    export CPATH=$HOME/edk2-samurai/local/uuid/usr/include
    export LIBRARY_PATH=$HOME/edk2-samurai/local/uuid/usr/lib/x86_64-linux-gnu
    ./build.sh -d samurai --toolchain GCC5
    # 产物: ./boot-samurai.img  (== boot-samurai-canonical.img)
