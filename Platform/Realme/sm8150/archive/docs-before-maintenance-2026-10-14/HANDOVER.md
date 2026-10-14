---
id: "PRIVATE_UUID"
title: "realme X2 Pro (RMX1931/samurai) EDK2/UEFI 移植交接文档"
description: "realme X2 Pro（RMX1931/samurai/SM8150-AC）EDK2/UEFI 移植的完整交接：现状、已排除项、根因判断、本机原厂素材（UEFIFirmwareBackup/realme-rmx1931 的 uefiplat.cfg/APRIORI/DXE）、同 SoC 模板 realme-rmx2086、推荐改用 MU-sm8150pkg 的执行计划与待办。"
status: "active"
created_at: "2026-10-05T19:10:51.458Z"
updated_at: "2026-10-12T15:59:29Z"
content_hash: "43d0334130f6bcc51bb44a6793c288a5eb0d78d75fc9d6a91e54a397a95134bd"
source_paths:
  []
session_ids:
  - "session-PRIVATE_UUID"
memory_body_ids:
  []
---

# 交接文档：realme X2 Pro (RMX1931 / samurai) EDK2/UEFI 移植

当前操作规则仅以[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)为准；用户已撤销其他临时禁令，历史限制不再适用。

当前状态（2026-10-12 23:37）以[NEXT-SESSION](NEXT-SESSION.md)和[145部署收尾](sessions/145-dsi-deployment-and-session-closeout.md)为准。阶段145已只刷logdump并实际启动，系统/模块仍为132；boot/logdump回读、实际设备树、770模块、GPT18、persist及NV/原厂来源校验通过。Phosh/Phoc存在、taint0，累计DPU0/DSI0/GPU0/WARN0/TXprepare9，显示空闲，未做GPU专项负载。启动追踪未取得结果，未确认启动链根因；失败证据已封存，本轮临时开机服务已移除，k145-startup实例不存在。显示、GPU和充电均未新增验收成功。本轮按用户要求收尾并交接，完整适配目标仍未完成。

下方2026-10-06正文为历史资料，其“当前Android/卡logo/MU迁移”等不是现在状态，不能作为续作步骤。

> 生成时间：2026-10-06 (Asia/Shanghai)。设备当前正常，Android 可启动，boot 备份已校验。

## 0. 一句话状态
在 edk2-msm 上已做出**可构建**的 `boot-samurai.img`，但真机始终卡 Realme logo。
根因方向：**缺少设备专属内存映射/配置表（PlatformMemoryMapLib / PlatformConfigurationMapLib）**，通用 SM8150 表与 realme 实际内存布局不符。
已找到本机原厂完整素材（`Project-Aloha/UEFIFirmwareBackup/realme-rmx1931`）与同 SoC 现成移植（`mu_aloha_platforms` 的 `realme-rmx2086`）。
**下一步：改用 MU-sm8150pkg，以 realme-rmx2086 为模板建 realme-rmx1931，并用 rmx1931 原厂 uefiplat.cfg/Binaries。**

## 1. 设备与安全
- 型号：RMX1931CN（realme X2 Pro），代号 **samurai**，SoC **SM8150-AC（骁龙855+）**，平台 msmnile。
- BL 已解锁；当前系统：Android 16 自定义 ROM + KernelSU（`verifiedbootstate=orange`）。
- adb 序列号 `PRIVATE_DEVICE_ID`，当前可正常识别。
- **boot 备份（必须保留）**：`E:\edk2-samurai-out\backup\boot_stock_RMX1931.img`，sha256 `dfe18875661164e7cb64eba7942b856e80ffe20abb537aec815da4bf43995cdd`。
- 恢复流程：`adb reboot bootloader` → `fastboot flash boot <backup>` → `fastboot reboot`；卡 logo 时长按电源 15s，再按 音量下+电源 进 fastboot。
- platform-tools：`C:\Users\cy122\Downloads\platform-tools\platform-tools\{adb,fastboot}.exe`。
- 不要动分区表；最好备 EDL/9008 全量救砖包。

## 2. 构建环境（WSL Ubuntu 26.04，可复现）
- edk2-msm 工作区：`~/edk2-samurai/repo`（edk2-porting/edk2-msm + 子模块 Common/edk2、Common/edk2-platforms、Platform/EFI_Binaries、GPLDrivers/Library/SimpleInit(+freetype)、tools/Installer）。
- 环境坑与修复：
  1. GCC 15 默认 C23 让 BaseTools/Pccts 失败 → `tools/tools_def.txt` 的 `GCC_AARCH64_CC_FLAGS` 末尾加 `-std=gnu17`（build.sh 会拷到 edk2/Conf）。
  2. BaseTools：`make -C Common/edk2/BaseTools -j$(nproc) BUILD_CC="gcc -std=gnu17"`。
  3. 无 sudo：`uuid-dev` 用 `apt-get download` + `dpkg-deb -x` 解到 `~/edk2-samurai/local/uuid`，构建时设 `CPATH`/`LIBRARY_PATH`。
  4. `msgfmt` 用 `~/.local/bin/msgfmt` 桩。
  5. 工具链 `--toolchain GCC5`；mkbootimg 用仓库自带 `tools/mkbootimg.py`。
- 构建命令：
  ```bash
  cd ~/edk2-samurai/repo
  export PATH=$HOME/.local/bin:$PATH
  export CPATH=$HOME/edk2-samurai/local/uuid/usr/include
  export LIBRARY_PATH=$HOME/edk2-samurai/local/uuid/usr/lib/x86_64-linux-gnu
  make -C Common/edk2/BaseTools -j$(nproc) BUILD_CC="gcc -std=gnu17"   # 一次
  ./build.sh -d samurai --toolchain GCC5
  ```
- 现有 samurai 目标：`configs/devices/samurai.conf`；`Platform/Realme/sm8150/samurai.{dsc,fdf.inc,sh.inc}`；`FdtBlob{,/_compat}/samurai*.dtb`；`AcpiTables/samurai/DSDT.aml`；`ramdisk_samurai.img`；`Platform/EFI_Binaries/Drivers/Devices/samurai/{DALSys,ButtonsDxe,UsbPwrCtrlDxe}`（F.10 xbl 提取）。

## 3. 已做验证与排除结论
### 3.1 能启动的对照
- 自定义 ROM boot 与 TWRP 3.7.0/3.7.1：全部 **header v1 + gzip 真内核 + 追加 DTB + AVB footer**；TWRP ARM64 Image `text_offset=0x80000, image_size=0x2c62000/0x3493000, flags=0xa`。
- 本地：`C:\Users\cy122\Downloads\twrp-3.7.0_12-0-samurai.img`、`TWRP-3.7.1_12-0-SAMURAI-NEW-BUILD.img`。

### 3.2 已排除
- **AVB**：抹掉能启动 boot 的 AVB footer 后仍能启动 → 排除。
- **boot 头参数**：改成与能启动镜像一致（v1/4096/base0/kernel0x8000/ramdisk0x1000000/tags0x100）仍卡。
- **ramdisk**：真实 LZ4/gzip ramdisk 均无变化。
- **BootShim image_size**：补 `0x700090` 无变化。
- **base DTB**：原厂 F.10 / 当前 ROM base / 运行时合并 FDT 都试过。
- **非压缩 payload / header v2+dtb 段**：都回退 fastboot。

### 3.3 根因判断
- ABL `BootLinux` 失败会 `CpuDeadLoop()`（卡 logo）；非压缩版回 fastboot。
- UEFI PEI `MemoryInitPeiLib.c`：`#define FDT_DIRECT`，`Fdt = GetFdt()`（读 0x9E000000，UEFI 入口把 x0 DTB 指针存入），随后 `fdt_get_memory` 决定 4G/6G/8G/12G 配置。
- 通用 `PlatformMemoryMapLib` 把 `0xA0000000~0xBBB00000` 当普通 RAM，而 realme Kernel 在 **`0xA8880000`**，rmx1931 `uefiplat.cfg` 把 `0xA0000000~0xB9400000` 标为 **MLVM 保留区** → PEI 可能覆盖/崩溃。
- 设备内存：Kernel code `0xa8880000-0xaaffffff`、data `0xab600000-0xac190fff`（见 `backup/iomem.txt`）。

## 4. 本机专属 GitHub 素材（关键）
### 4.1 Project-Aloha/UEFIFirmwareBackup → realme-rmx1931（最重要）
`https://github.com/Project-Aloha/UEFIFirmwareBackup/tree/main/realme-rmx1931`
- `RMX1931CN_xbl.img`、`2.uefif`
- `Binaries/`（完整 DXE：QcomBds、DALSYSDxe、DisplayDxe、HALIOMMUDxe、TLMMDxe、UsbPwrCtrlDxe、UFSDxe、PmicDxe…）
- `Binaries/APRIORI.inc`、`Binaries/DXE.inc`、`Binaries/DXE.dsc.inc`（加载顺序）
- `Binaries/RawFiles/uefiplat.cfg`（**设备专属内存表 + ConfigParameters**）
- `Binaries/RawFiles/BDS_Menu.cfg`、`Panel_*.xml`（含 `Panel_samsung_sofef03f_m_amoled_fhd_90fps_dsc_cmd.xml`）

`uefiplat.cfg` 关键内容（务必抄进新内存表）：
```
[MemoryMap]
0x80000000,0x05700000,"Kernel",Reserv
0x8B700000,0x00100000,"PIL Reserved"
0x8B800000,0x0E600000,"PIL Reserved II"
0x99E00000,0x01C00000,"DXE Heap",Conv
0x9D000000,0x02400000,"Display Reserved"
0x9FA00000,0x00200000,"ABOOT FV"
0x9FC00000,0x00300000,"UEFI FD"
0xA0000000,0x04C00000,"MLVM_APSS",Reserv
0xA8800000,0x07800000,"MLVM_1",Reserv
0xB0400000,0x09000000,"MLVM",Reserv
[ConfigParameters]
TzAppsRegnAddr=0x87900000 ; TzAppsRegnSize=0x05E00000
ShmBridgememSize=0xA00000 ; NumCpus=8 ; NumActiveCores=8
EnableMultiThreading=1 ; EarlyInitCoreCnt=1 ; EnableDisplayThread=1
EnableUfsIOC=0 ; UfsSmmuConfigForOtherBootDev=1
SecurityFlag=0xC4 ; SharedIMEMBaseAddr=0x146BF000
DloadCookieAddr=0x01FD3000 ; DloadCookieValue=0x10
PwrBtnShutdownFlag=0x0 ; Sdc1/2GpioConfigOn=0x1E92 ; Off=0xA00
```

### 4.2 Project-Aloha/mu_aloha_platforms → realme-rmx2086（同 SoC 完整移植模板）
`Platforms/SurfaceDuo1Pkg/Device/realme-rmx2086/`：`Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c`、`Library/PlatformConfigurationMapLib/PlatformConfigurationMapLib.c`、`DeviceTreeBlob/{Android/android-rmx2086.dtb,Linux/linux-rmx2086.dtb}`、`ACPI/DSDT.aml`、`PatchedBinaries/DALSYSDxe.*`、`Binaries/`、`APRIORI.inc`、`DXE.inc`、`DXE.dsc.inc`、`Defines.dsc.inc`、`PcdsFixedAtBuild.dsc.inc`。主仓库目前没有 rmx1931，需要自己新建。

### 4.3 其他
- 内核/设备树：`AndroidBlobs/kernel_realme_RMX1931`、`AndroidBlobs/device_realme_RMX1931`、`crdroidandroid/android_device_realme_samurai`、`realme-sm8150-development/android_device_realme_sm8150-common`、`realme-kernel-opensource/realme_6pro_7pro_8pro_X2-AndroidR-kernel-source`、`alextrack2013/android_kernel_realme_sm8150`、`arnodorian-r/kernel_realme_RMX1931`
- `guozhidixian/edk2-SM8150`（`F11/Library/F11Lib/DeviceMemoryMap.h` 写法参考）
- TWRP：`alextrack2013/rmx1931-stuff`、`zahid5656/twrp_ofox_realme_x2pro_samurai_sm8150`

## 5. 推荐执行方案（MU-sm8150pkg 建 realme-rmx1931）
1. 浅克隆（注意 300s 超时，分步/后台）：`git clone --depth 1 https://github.com/Project-Aloha/mu_aloha_platforms.git ~/mu-aloha`（子模块按 `build_setup.sh`/`stuart` 再拉；构建建议 Ubuntu 20.04 容器/venv）。
2. 复制 `Platforms/SurfaceDuo1Pkg/Device/realme-rmx2086/` → `.../realme-rmx1931/`。
3. sparse 拉取原厂素材：`git clone --filter=blob:none --sparse https://github.com/Project-Aloha/UEFIFirmwareBackup.git` → `git sparse-checkout set realme-rmx1931`。
4. 由 `uefiplat.cfg` 生成 `PlatformMemoryMapLib.c` / `PlatformConfigurationMapLib.c`（MemoryMap → `ARM_MEMORY_REGION_DESCRIPTOR_EX` 表；ConfigParameters → `CONFIGURATION_DESCRIPTOR_EX` 表，格式照抄 rmx2086）。
5. 用 rmx1931 原厂 `Binaries/` + `APRIORI.inc`/`DXE.inc`/`DXE.dsc.inc` + `RawFiles/` 替换设备二进制与加载顺序。
6. 编译 samurai 的 `android-samurai.dtb` / `linux-samurai.dtb`（可先用 rmx2086 DTB 占位）。
7. 在 `SurfaceDuo1Pkg/SurfaceDuo1.dsc`/`.fdf` 注册 `realme-rmx1931`（`BUILD_DEVICE_ID`），设 1080x2400。
8. `./build_uefi.py -d realme-rmx1931` → 刷 `boot` 测试，保留备份回滚。

## 6. 备选：继续 edk2-msm
在 `Silicon/Qualcomm/sm8150/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c` 增加 realme 专属表（照抄 rmx1931 uefiplat.cfg，尤其 MLVM/Display/UEFI FD 段），设备 DXE 换成 rmx1931 原厂/rmx2086 Patched 版。注意 FD 基址差异：edk2-msm `FD_BASE=0xCE000000`，MU 用 `0x9FC00000`。

## 7. 待办
- [ ] 克隆 mu_aloha_platforms（本轮被中断，`~/mu-aloha` 为空）
- [ ] 建 realme-rmx1931 设备目录
- [ ] 由 uefiplat.cfg 生成设备专属内存表/配置表
- [ ] 导入原厂 DXE + 加载顺序 + RawFiles
- [ ] 编译 samurai Android/Linux DTB
- [ ] 构建 + 刷机测试（UEFI Shell → 按键/USB/显示/UFS）
- [ ] Windows 支持：适配 samurai DSDT

## 8. 关键路径速查
- Windows 产物/备份：`E:\edk2-samurai-out\`；boot 备份 `backup\boot_stock_RMX1931.img`；当前镜像 `boot-samurai.img`；裸 FD `SM8150_UEFI-samurai.fd`；提取 DXE `dxe-samurai\`；DTB `custom_base.dtb`/`fdt_live.dtb`/`boot_dtb.dtb`；设备内存/命令行 `backup\iomem.txt`/`backup\cmdline.txt`。
- WSL：edk2-msm `~/edk2-samurai/repo`；venv `~/edk2-samurai/venv`；研究资料 `~/edk2-samurai/research/`（BootLinux.c/Decompress.c）。

## 9. 常用命令
```powershell
adb devices -l
adb shell su -c "cat /proc/iomem"
adb shell su -c "sha256sum /dev/block/by-name/boot"
fastboot flash boot boot-samurai.img
fastboot flash boot E:\edk2-samurai-out\backup\boot_stock_RMX1931.img
```
```bash
cd ~/edk2-samurai/repo && ./build.sh -d samurai --toolchain GCC5
```
