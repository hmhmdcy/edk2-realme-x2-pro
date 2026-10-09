# EDK2 / UEFI firmware for the realme X2 Pro (RMX1931 · "samurai")

Unofficial EDK2/UEFI port for the **realme X2 Pro (RMX1931 / RMX1931CN)**, Qualcomm
**Snapdragon 855+ (SM8150-AC)**, platform **msmnile**, codename **"samurai"**.

This repository is a fork of [edk2-porting/edk2-msm](https://github.com/edk2-porting/edk2-msm)
with a device package for *samurai* (`Platform/Realme/sm8150/`, `configs/devices/samurai.conf`).
Everything below is specific to this phone - the generic framework documentation lives in the
upstream project.

> 中文简介见文末。

---

## Status

Boot verified on real hardware (2026-10): **PEI → DXE → BDS → Boot Manager → EFI Shell**.

Current EUD stability handoff: [session63](sessions/63-single-device-driver-compatibility-and-trial-tools.md).
RX62's built/test-signed candidate remains unloaded. RX63's native SetupAPI
audits recognize both exact candidate and rollback nodes for current 9505.
Single-device trial tools default to Audit; 15 gate cases pass, zero actual
stage/bind calls. Current CI confirms TESTSIGN off/HVCI enforced; selected
loading environment is pending. ZLP loads at DeviceAdd, not ordinary reopen.
Keep primary toggle comparison separate; full original acceptance is open.
Original driver/terminal/firmware and TOP_CFG/RX53/F1/rollback are preserved.

| Feature | Status | Notes |
|---|---|---|
| UEFI boot (Boot Manager / EFI Shell) | ✅ works | reaches the shell, `map`/`blk` show all UFS partitions |
| Display | ✅ works | framebuffer text console, 5x12 font (`FrameBufferSerialPortLib`), 1080x2400 |
| Volume-Up button | ✅ works | `SCAN_UP` |
| Power button | ✅ works | |
| **Volume-Down button** | ✅ works | factory realme `ButtonsDxe` + `OppoProject` + `ResetRuntimeDxe` (see `Platform/Realme/sm8150/BINARIES.md`) |
| UFS / block devices | ✅ works | 6 LUNs, GPT, `BLK*` devices in the shell |
| USB mass storage mode (phone as a USB disk) | ✅ works | via the built-in `LinuxSimpleMassStorage` kernel (see below) |
| USB keyboard / host mode | ❓ untested | no OTG device was available during development |
| Persistent UEFI variables | ❌ not implemented | no variable store partition configured, variables are lost on reboot |
| Windows (WoA) | ❌ not ready | DSDT is currently borrowed from a Xiaomi Mi 9 (cepheus); a samurai-specific DSDT is required |
| Mainline Linux | ⚠️ partially | the built-in mass-storage kernel runs; a full distro needs a mainline DTB + rootfs |

---

## The device

| | |
|---|---|
| Model | realme X2 Pro (RMX1931 / RMX1931CN) |
| Codename | **samurai** |
| SoC | Qualcomm **Snapdragon 855+** (SM8150-AC), msmnile |
| PMICs | PM8150 / PM8150L / PM8150B (SPMI) |
| RAM | 8 GiB (also sold with 12 GiB) |
| Storage | UFS 3.0, 6 LUNs, GPT |
| Display | 6.5" 1080x2400 Super AMOLED, 90 Hz (Samsung `sofef03f_m`) |
| Bootloader | realme/OPPO ABL (XBL). Unlocked bootloader required. **No `fastboot boot` support** - the image has to be flashed. |

---

## What this fork changes

```
configs/devices/samurai.conf                     device config (mkbootimg: header v1)
Platform/Realme/sm8150/samurai.dsc               platform DSC (PCDs, build options)
Platform/Realme/sm8150/samurai.fdf.inc           per-device FFS components (DXE drivers, ACPI, DTB)
Platform/Realme/sm8150/FdtBlob/samurai/*.dtb     mainline DTB  -> handed to Linux via the EFI configuration table
Platform/Realme/sm8150/FdtBlob_compat/samurai.dtb vendor DTB   -> appended to the boot image (ABL builds the runtime DTB from it)
Platform/Realme/sm8150/AcpiTables/samurai/DSDT.aml  (currently borrowed from cepheus)
Platform/Realme/sm8150/README.md                 device-level notes
```

Nothing else in the upstream tree is modified - no patches to PEI/DXE core, no BootShim changes.

### Device blobs

The per-device DXE drivers are Qualcomm/realme firmware. They ship with this
fork: the `Platform/EFI_Binaries` submodule points at
`hmhmdcy/edk2-msm-binary` branch `samurai-blobs`, so a recursive clone is enough:

```bash
git clone --recursive https://github.com/hmhmdcy/edk2-realme-x2-pro.git
```

They live in `Platform/EFI_Binaries/Drivers/Devices/samurai/`:

```
DALSys/DALSys.{efi,depex}                 UsbPwrCtrlDxe/UsbPwrCtrlDxe.{efi,depex}
ButtonsDxe/ButtonsDxe.{efi,depex}         TLMMDxe/TLMMDxe.{efi,depex}
ResetRuntimeDxe/ResetRuntimeDxe.{efi,depex}
OcdtDxe/OppoProject.{efi,depex}
```

`Platform/Realme/sm8150/fetch-binaries.sh` can re-create the same set from public
mirrors if you prefer to extract them yourself; `Platform/Realme/sm8150/BINARIES.md`
documents the sources and the required DEPEX patch.

## Building

```bash
git clone --recursive https://github.com/hmhmdcy/edk2-realme-x2-pro.git
cd edk2-realme-x2-pro
./build.sh -d samurai --toolchain GCC5
```

Output:
- `boot-samurai.img` - flashable Android boot image
- `workspace/Build/samurai/RELEASE_GCC5/FV/SM8150_UEFI.fd` - raw firmware volume

Host notes (Ubuntu, no sudo needed):
- On very new host GCC (e.g. GCC 15) BaseTools/Pccts fail with the default C23
  standard: append `-std=gnu17` to `GCC_AARCH64_CC_FLAGS` in `tools/tools_def.txt`
  (`build.sh` copies that file into `Common/edk2/Conf/`).
- `BaseTools` must be built once: `make -C Common/edk2/BaseTools -j$(nproc) BUILD_CC="gcc -std=gnu17"`.
- `uuid-dev` and `msgfmt` may have to be provided locally if you have no root.

---

## Flashing / testing

```bash
# ALWAYS keep a verified backup of your stock boot partition first:
fastboot flash boot boot_stock_RMX1931.img     # rollback

# flash the port:
fastboot flash boot boot-samurai.img
```

The realme/OPPO ABL does **not** implement `fastboot boot` (`FAILED (remote: 'unknown command')`),
so a temporary boot is not possible - you have to flash, and keep a backup for rollback.

To enter fastboot when the phone is stuck: hold **Power** for ~15 s to force power off, then hold
**Volume-Down + Power**.

---

## How the port works (porting notes for other SM8150 devices)

1. **Boot chain.** ABL loads the boot image "kernel" (which is `BootShim.bin` followed by the
   concatenated UEFI FD), jumps to it with `x0` = DTB, and BootShim copies the FD to
   `FD_BASE = 0xCE000000` and jumps into UEFI. PEI reads the runtime DTB from the address stored in
   `PcdDeviceTreeStore` (`0x9E000000`) to decide the memory size (4/6/8/10/12 GiB) and therefore
   which branch of the platform memory map is used.
2. **The boot image must keep the project default layout**:
   `header v1 + gzip(BootShim.bin + SM8150_UEFI.fd) + appended FdtBlob_compat/samurai.dtb`.
   Deviating (uncompressed payload, header v2 with a separate dtb section, or no appended DTB)
   makes ABL return to fastboot or hang. Do not override `platform_build_kernel` /
   `platform_build_bootimg` in a device `*.sh.inc`.
3. **Framebuffer console - the `0x9D000000` trap.** With `USE_UART=0` (default) the platform uses
   `Silicon/Qualcomm/QcomPkg/Library/FrameBufferSerialPortLib`, which draws *all* DEBUG output
   into the framebuffer with a 5x12 font. It uses `PcdMipiFrameBufferAddress`, whose platform
   default is `0x9C000000` (Xiaomi/OnePlus layout). On samurai the live framebuffer is at
   **`0x9D000000`**, so with the default value the log is written into invisible memory: the
   screen keeps showing the bootloader logo and the boot looks exactly like a hang.
   `samurai.dsc` therefore sets `PcdMipiFrameBufferAddress|0x9D000000`.
4. **`ButtonsDxe` needs three extra blobs.** The port uses the *factory* realme/OPPO
   `ButtonsDxe` (the only build with a correct key map for this board), but it is not
   self-contained: at run time it additionally wants `EFI_QCOM_TLMM_PROTOCOL` (`TLMMDxe`), the
   **OPPO project protocol** (`903C579D-...`, installed by `OcdtDxe/OppoProject.efi`) and the
   **reset-reason protocol** (`A022155A-...`, installed by `ResetRuntimeDxe`). It also reads the
   SMEM project entry (`Project:19781`) to select the per-project key map. Any missing piece makes
   it return `EFI_NOT_FOUND` and get unloaded - and then *no* side button works at all.
   Because it locates the OPPO project protocol only at run time (that GUID is not in its DEPEX),
   run `fix-buttons-depex.py` so the dispatcher guarantees `OppoProject` is installed first.
   See `Platform/Realme/sm8150/BINARIES.md`.
5. **DTB roles.** `FdtBlob/<device>/<device>.dtb` is the **mainline** DTB (published to the OS
   through the EFI configuration table); `FdtBlob_compat/<device>.dtb` is the **vendor/Android**
   DTB appended to the boot image. Do not swap them: with a vendor DTB in `FdtBlob`, the built-in
   `LinuxSimpleMassStorage` kernel falls back to `usb_nop_phy` and USB never comes up.
6. **Memory map / MLVM.** `samurai.dsc` builds with `-DHAS_MLVM`: for the 8 GiB branch this
   reserves `0xA0000000..0xBBB00000`, matching the `no-map` carveouts of the device DTB
   (`qseecom_region` at `0xA0000000+0x1400000`, `cdsp_sec_regions` at `0xA4C00000+0xC00000`).
   Without it UEFI may allocate memory inside protected regions.

---

## USB mass storage mode (phone as a USB disk)

The firmware contains BigfootACA's [linux-simple-mass-storage](https://github.com/BigfootACA/linux-simple-mass-storage)
kernel (`Platform/EFI_Binaries/Applications/LinuxSimpleMassStorage/LinuxSimpleMassStorage.efi`,
registered as the boot option **"USB Attached SCSI (UAS) Storage"**). Selecting it boots a small
Linux 6.1 kernel which exposes the phone's **raw UFS LUNs** to a host PC as UAS mass storage.

Verified: Windows enumerates `USB Attached SCSI (UAS) Mass Storage Device` plus 6 disks
(`Qualcomm sda` = 118 GB userdata, `sdb`..`sdf`), and a FAT partition (`op1`, containing
`simpleinit.uefi.cfg`) becomes mountable - a convenient way to copy files to/from the phone
without reflashing.

**Warning:** this exposes *raw partitions*. Never let the host OS initialise, repartition or
format those disks - that destroys data or bricks the firmware. When not needed, do not boot
this option. (On Windows you can protect yourself with
`Set-Disk -Number <n> -IsOffline $true`.)

---

## Debugging over USB (EUD)

This SoC exposes Qualcomm's **Embedded USB Debug hub (EUD)**: once enabled, the
host PC sees a `VID 0x05C6` USB hub that Qualcomm's OpenOCD fork can drive as a
JTAG/SWD adapter - no UART wiring, no disassembly. On this device **EUD is not
fused off** (verified from Android by writing `1` to
`/sys/module/eud/parameters/enable`).

EDK2 replicates the kernel's two register writes from `PlatformBootManagerAfterConsole`
(BDS, when the USB PHY is up):

```c
MmioWrite32 (0x088E0000 + 0x1014, 1);     /* EUD_REG_CSR_EUD_EN              */
MmioWrite32 (0x088E0000 + 0x0024, 0x1C);  /* INT1_EN_MASK: VBUS|CHGR|SAFE_MODE */
```

The block is guarded by `-DSAMURAI_ENABLE_EUD` (set in `samurai.dsc`) so it does
not affect other devices, and it prints `[SAMURAI-EUD] ...` to the framebuffer.
While EUD is active the USB port is dedicated to it, so fastboot and the U-disk
mode are unavailable until the next **full power cycle**.

Registers, caveats and host-side OpenOCD setup: `Platform/Realme/sm8150/EUD.md`.

Current status of the SWD/JTAG half (2026-10-08): the SWD (9504) and JTAG (9503)
functions can be enabled and driven from the PC (DAP route payload 0x00100445 /
JTAG 0x00000090), but the AP CoreSight DAP does not answer on this retail unit:
`ack = 0`, `freezio_latch = 1`, DPIDR reads 0. The `APPS_DBGEN_DISABLE` fuse and
signed APDP debug policy (`dpAP.mbn` in the F.14 package) are possible
restrictions; the device fuse state was not read and policy causation was not
established. These tests did not obtain AP halt. EUD COM therefore
remains the working debug channel here; the SWD/JTAG host tooling is kept for
debug-enabled devices. Never switch the internal DAP mux while Android is
running - it hangs the AP and needs a full power cycle. Details in RX-CONSOLE.md.

## Known issues / TODO

- **Volume-Down is now fixed.** It used to fail because the shared `ButtonsDxe` reads `VOL-`
  through the PMIC PON real-time IRQ while on samurai the key is wired to a GPIO. The port now
  uses the factory realme `ButtonsDxe` together with `OppoProject` + `ResetRuntimeDxe` and a
  patched DEPEX; verified on hardware (`SCAN_UP` / `SCAN_DOWN`). See note 4 above.
- No letter input: the EFI Shell cannot be typed into with the volume keys alone; a USB keyboard
  (host mode) is untested.
- A samurai-specific DSDT is required for Windows-on-ARM.
- Persistent UEFI variables (a variable store) are not configured.
- Optional: enable `USE_DISPLAYDXE` + the factory panel XML for a graphical console.

---

## Safety

- Only ever flash the `boot` partition; keep a verified backup
  (the stock image used during development has sha256
  `dfe18875661164e7cb64eba7942b856e80ffe20abb537aec815da4bf43995cdd`).
- Do not touch the partition table or any other partition (`xbl`, `abl`, `modem`, `persist`,
  `super`, `userdata`, ...).
- The U-disk mode described above exposes raw partitions - see the warning there.

---

## Credits

- [edk2-porting/edk2-msm](https://github.com/edk2-porting/edk2-msm) (Renegade Project) - the framework this port is built on, and SimpleInit
- [BigfootACA/linux-simple-mass-storage](https://github.com/BigfootACA/linux-simple-mass-storage) - the built-in mass-storage kernel
- [Project-Aloha/UEFIFirmwareBackup](https://github.com/Project-Aloha/UEFIFirmwareBackup) - factory firmware dumps (`realme-rmx1931`)
- [Project-Aloha/mu_aloha_platforms](https://github.com/Project-Aloha/mu_aloha_platforms) - source of the `OppoProject.efi` (OcdtDxe) blob
- [edk2-porting/edk2-msm device sources](https://github.com/edk2-porting/edk2-msm/tree/master/Platform) - cepheus (Mi 9) was used as the working SM8150 reference

## License

Same as upstream edk2-msm (BSD-2-Clause-Patent for EDK2 code). Device firmware blobs
(vendor DXE, DTBs, ACPI) are **not** distributed here - obtain them from your own device.

---

## 中文简介

**realme X2 Pro（RMX1931 / 代号 samurai）的 EDK2/UEFI 移植**，基于 `edk2-porting/edk2-msm`。

已在真机验证：UEFI 可启动到 Boot Manager 与 EFI Shell，framebuffer 文本控制台、**音量上 / 音量下 / 电源键全部可用**、
UFS 分区枚举、以及"把手机当 U 盘"的 USB 大容量存储模式都可用。Windows 化还需专属 DSDT。
UFS 分区枚举、以及"把手机当 U 盘"的 USB 大容量存储模式都可用。**音量下键也已修复**；
Windows 化还需专属 DSDT。

关键坑（详见上文）：
1. boot 镜像必须保持项目默认布局（v1 + gzip(BootShim+FD) + 尾部追加 `FdtBlob_compat` 的安卓 DTB）；
2. `PcdMipiFrameBufferAddress` 必须改成 **0x9D000000**，否则 edk2 日志"静默"、看起来就是卡死；
3. 按键驱动用**原厂 realme ButtonsDxe**，并需同时引入 `OppoProject`（OPPO project 协议）与 `ResetRuntimeDxe`（reset reason 协议），且要给 ButtonsDxe 的 DEPEX 加上 `903C579D`（详见 `Platform/Realme/sm8150/BINARIES.md`）；
4. `FdtBlob` 放主线 DTB、`FdtBlob_compat` 放安卓 DTB，别放反（放反会导致 U 盘模式失效）。

⚠️ **安全**：只刷 `boot` 分区，先备份；U 盘模式会暴露原始分区，切勿让 PC 端格式化/初始化。

## Status update 2026-10-07 (EUD console works; two real bugs found)

* console=eud (a real nbcon console for the EUD COM FIFO) is verified on hardware:
  with keep_bootcon removed the log now continues past the 1.2 s mark where it used
  to die.  Firmware cmdline: earlycon=eud,mmio,0x88e0000 console=tty0 console=eud ...
  and the DTB in the firmware volume carries the serial@88e0000 node for it.
* Two independent bugs kept the kernel from reaching userspace:
  1. 7.3 reads the RPMh regulator voltage back at boot.  On SM8150 the AOSS never
     answers: the read occupies an ACTIVE TCS and blocks every later write (10 s
     timeout = RPMH_TIMEOUT_MS, then "failed to read VOLTAGE ret = -110", rpmh_write
     WARNs, dwc3 -ETIMEDOUT).  Worked around in drivers/soc/qcom/rpmh.c: no read
     commands on qcom,sm8150 / qcom,sc8180x.
  2. The built-in initramfs carried 305 absolute symlinks into the host tree
     (busybox --install -s with an absolute path), so /init could not exec:
     "Kernel panic - not syncing: No working init found" -> panic=15 reboot loop.
     Symlinks are relative now and the cpio is rebuilt.
* Test image: Image-rmx1931-samurai-initfix (RPMh + initramfs fix).
  Full story and hashes: HANDOVER-NEXT.md section 26.

## Status update 2026-10-08 (userspace reached; what is a shortcut and what is not)

* The kernel now reaches userspace on hardware: "Run /init as init process", all
  six UFS LUNs enumerated, no panic - and the initramfs banner reaches the EUD
  COM console after the init script was changed to write to /dev/kmsg.  Writing
  to /dev/console does not work yet, because the console has no tty binding, so
  those writes land on the VT (screen only).
* The phone reboots shortly after the diagnostic dump.  The panic text has to be
  read from /sys/fs/pstore/console-ramoops (ramoops@0xb7e00000 is in the DTB).
* HANDOVER-NEXT.md section 27 records, for the first time, which parts of the
  current setup are temporary information-gathering shortcuts (S1-S13: the
  /dev/kmsg dump on every boot, the sleep-forever init, the kernel store in the
  logdump partition, the RPMh SoC quirk, the missing tty layer, ...) and which
  are the proper goals (a real tty console, a reviewable DTS, ESP + GRUB, a real
  root filesystem, pstore as the durable log channel, upstreamable patches).
  Read that section before building anything on top of this setup.
## Status update 2026-10-08 (button-free fastboot; fastboot can write the kernel store)

* Reboot into fastboot without touching the phone: the vendor DTB's PMIC PON already
  carries mode-bootloader = <0x02>, mainline's qcom-pon.c plus the generic reboot-mode
  framework are enabled in the build, and this board only lacks the two mode- lines in
  its device tree.  With a ~15 line static reboot2 helper, Linux (and later EDK2) can
  ask for fastboot by itself.
* fastboot can write the logdump partition, i.e. the kernel store: verified
  byte-exact, 64 MiB in 1.8 s, so the iteration loop no longer needs Android at all.
  The Image sits contiguously at offset 90,112 and is always 30,116,352 bytes, so
  updating it is a single in-place write, and a corrupted FAT is recoverable in 1.8 s
  straight from fastboot.
* The EUD COM channel has an RX half too (host to device, registers
  0x088E000C/0x10/0x14, documented by the official QUIC host library), so a
  "control it like adb" command channel is a software task - useful later for rescuing
  a firmware that is stuck before BDS, where neither adb nor fastboot exists.
* Details, evidence and the unattended flywheel plan: HANDOVER-NEXT.md section 28.

## Status update 2026-10-08 (SWD/JTAG transport verified; AP DAP unresponsive)

* Both EUD debug peripherals can be brought up from Windows: SWD 9504 with
  `CTLOUT_CLR 0x000E0090` + `CTLOUT_SET 0x00100445` (DAP route, no VBUS pulse)
  and JTAG 9503 with `0x00000090` + the VBUS pulse. They bind to qdbusb and
  expose `\\.\Qualcomm EUD SWD Device 9504\DEBUG` / `... JTAG Device 9503\DEBUG`
  (no "(0004)" suffix). SWD STATUS is `07 01`, JTAG FREQ_RD is `0F 01`.
* The OpenOCD-equivalent DAP connect sequence (FREQ, line reset, JTAG-to-SWD
  0xE79E, ABORT, DP CTRL/STAT = 0x50000000, read DPIDR) returns
  `data = 0x00000000, status = 0x00010020, ack = 0, freezio_latch = 1` in
  every state tried, including with SRST/TRST held over SWD bitbang. Switching
  the internal DAP mux while Android runs hangs the AP (black screen).
* Possible restrictions: Qualcomm debug fuses and an OEM-signed policy in
  `apdp`; neither was established as the cause of this unit's failed DAP reads.
  This phone's F.14
  package carries `dpAP.mbn`, a signed ELF with the OPPO CA chain, so it cannot
  be replaced. OpenOCD's own quickstart enables EUD at the U-Boot stage and
  expects DPIDR 0x5ba02477, i.e. it targets debug-enabled devices.
* Consequence for this port: EUD COM stays the primary log/debug channel
  (firmware DEBUG(), Linux `earlycon=eud`/`console=eud`, the EudLogDxe ring).
  Keep the SWD/JTAG tooling in `E:\eud-host` for an engineering device, and try
  `maxcpus=1` when debugging the Linux SMP bring-up.
* Final confirmation 2026-10-08, UEFI stage: the officially recommended flow was
  tested too - flash the firmware, let BDS enable EUD, then attach. The result is
  identical (`data = 0x00000000, status = 0x00010020, ack = 0`). This repetition
  does not locate the gate or prove a fuse/policy cause. See SWD-JTAG.md for
  the current evidence limits; no fuse or APDP modification is proposed.


## Status update 2026-10-08 (EUD is a real console: ttyEUD0, /dev/console, RX commands)

The EUD COM FIFO is now driven by a proper uart driver instead of a bare
console, and the receive side is understood well enough to be used.

* Single writer: the firmware command line no longer carries keep_bootcon, so
  the early console retires when the real console registers
  ("printk: legacy bootconsole [eud0] disabled").  Every register write is paced
  (200 us) and every frame spaced (2 ms); a 210 s capture reassembles with zero
  lost frames.
* /dev/ttyEUD0 exists and works end to end, and /dev/console is bound to it.
* Command channel: [0x81][len][payload], payload[0] is the code (0x01 ping,
  0x02 register dump, 0x03 status).  Typing: [0x82][len][payload] is inserted
  into the tty, so a shell on /dev/ttyEUD0 can be driven from the PC.
* The RX payload register is 0x14 (a FIFO read port); 0x0c/0x10 are latches that
  hold the last message's header.  Details in RX-CONSOLE.md.
* Caveat: reading 0x14 too eagerly wedges the EUD block - the console goes
  silent until a full power cycle.  The payload read must be gated on a
  completed header.
