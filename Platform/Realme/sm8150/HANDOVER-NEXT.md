# Session handover - realme X2 Pro (samurai) EDK2/UEFI

> Rewritten 2026-10-07 00:4x (Asia/Shanghai), at the end of the session that got
> EDK2 DEBUG output flowing over EUD COM and verified it on real hardware.
> Details for everything below live in the repo documents:
>   Platform/Realme/sm8150/EUD.md      (EUD registers, CTL/COM protocol, driver)
>   Platform/Realme/sm8150/BINARIES.md (firmware blobs and where they come from)
>   Platform/Realme/sm8150/HANDOVER.md (earlier build/handover notes)

## 0. TL;DR - where the project stands

* The port boots on hardware; all three side buttons work
  (factory ButtonsDxe + OppoProject + ResetRuntimeDxe + TLMMDxe + DEPEX patch).
* EDK2 enables EUD at BDS - verified on hardware (9500 hub + 9501 control
  appear; CTL probe returns version/device-id/status).
* DEBUG output now goes out over EUD COM - verified end to end on hardware:
  "[SAMURAI-EUD-COM] SerialPortLib test 29" was captured on COM14 and
  reassembled by the host logger.
* Host side is solved on Windows with no Zadig / no usbipd / no WSL:
  the installed Qualcomm QDSS driver (qdbusb, oem58.inf) already exposes the
  EUD CTL node, and the older QUD.WIN.1.1 10057.4 package supplies the signed
  qcser.inf that turns EUD COM 9505 into a real COM port (COM14 here).
* The phone currently runs the "30 s test loop" image.  The final image
  (single marker line, no boot delay) is built but NOT flashed yet:
      E:\edk2-samurai-out\boot-samurai-eudcom.img
      sha256 A8891194EE35023CB6BDAE7F22C2ABEF983735F841262D8EA574AF507187E44C

## 1. What to do next, in order

### Step 1 - restore Android (or flash the final image)          [5 min]

The phone is on the test-loop image.  Either:

  * back to Android:
        hold Power ~15 s (full power cycle - EUD keeps the USB port otherwise)
        Vol-Down + Power -> fastboot
        fastboot flash boot E:\edk2-samurai-out\backup\boot_stock_RMX1931.img
        fastboot reboot
  * or flash the final image (same commands, different file):
        fastboot flash boot E:\edk2-samurai-out\boot-samurai-eudcom.img

Host side needs the COM port to exist first:
        E:\eud-host\eudtool.exe com-up          (CTL: enable COM + VBUS attach)
        E:\eud-host\comlog.exe COM14 600 E:\eud-host\eud-com.log

### Step 2 - make EudSerialPortLib non-blocking  (MAIN next task; concrete plan in section 12)

File: Platform/Realme/sm8150/Library/EudSerialPortLib/EudSerialPortLib.c

Why: SerialPortWrite() currently performs the MMIO frame writes inline with
delays (200 us per byte, 2 ms per frame).  That is fine for a few lines, but
when the platform DEBUG level was raised globally the sheer number of DEBUG
calls made the boot crash in DxeCore/CpuDxe (see the crash section below).
The SerialPortLib must never block or touch uncertain MMIO from an arbitrary
DXE context.

Proposed design:
  1. SerialPortWrite() only appends bytes to a small ring buffer in normal RAM
     (no MMIO, no delays).  Drop data when the buffer is full (count drops).
  2. Register a periodic event (or hook the existing BDS wait callback /
     a platform timer) that drains the ring buffer into the EUD COM FIFO in
     6-byte frames with the known-good timing.
  3. Keep the CSR_EUD_EN gate check, but only in the drain path (BDS time,
     where the EUD block is known to be accessible).
  4. Expose a "drops" counter somewhere readable (a CTL scratch register or an
     on-screen line) so lost logs are visible.

Acceptance: set gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x800B05C7
(full DEBUG) in samurai.dsc, boot the phone, and comlog.exe must show the full
DEBUG stream while the phone still reaches the boot menu.

### Step 3 - or: raise DEBUG per module instead of globally (short path)

If Step 2 is not wanted yet, INFO-level logs can be enabled for individual
modules by overriding gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel inside
that component block in the DSC (component <PcdsFixedAtBuild>), instead of
setting it globally.  Keep the global value at the platform default
(0x80000000, ERROR only).

### Step 4 - SWD/JTAG + OpenOCD (optional, unexplored)

CTL gives registers, COM gives text; SWD/JTAG would give halt/breakpoints/
arbitrary memory access (and lets us read a RAM log ring buffer).
State: sending CTLOUT_SET 0x645 (SWD payload) + VBUS attach did NOT make the
9504 SWD device appear on this unit.  Next things to try:
  * verify the SWD payload/bits against ctl_eud.h CTL_PAYLOAD_SWDON;
  * check whether the target DAP must be clocked/reset first;
  * linux-msm/openocd on Linux (WSL + usbipd, or a native Linux host) with
        ./configure --enable-eud --disable-linuxgpiod
    then ./src/openocd -f tcl/interface/eud.cfg -f tcl/target/qualcomm/<target>.cfg

### Step 5 - use the new log channel to close the remaining firmware TODOs

Now that logs can reach the PC, revisit:
  * samurai-specific DSDT (currently borrowed from cepheus);
  * Shell has no alphabetic input (only three side buttons) - startup.nsh;
  * no persistent UEFI variables / no on-device log buffer;
  * a RAM log ring buffer that OpenOCD or the EUD COM drain can read.

## 2. Verified hardware facts (do not re-derive)

EUD enable (same writes the kernel driver does; no secure-eud on this unit):
    +0x1014 = 1      (CSR_EUD_EN)
    +0x0024 = 0x1C   (INT1_EN_MASK: VBUS|CHGR|SAFE_MODE)
Readback shows the low byte replicated into all four lanes: writing 1 reads
back 0x01010101.  Never gate logic on these readback values.

Host CTL node (Windows, already working):
    \\.\Qualcomm EUD Control Device 9501\DEBUG      (no "(0003)" suffix)
    open + WriteFile one opcode byte, ReadFile the response:
        0x01 EUD_VERSION_READ -> 4 bytes (00 00 05 00)
        0x02 DEVICE_ID_READ   -> 4 bytes (A1 28 BC 62 = 0x62BC28A1)
        0x03 EUD_STATUS_READ  -> 4 bytes (04 00 00 00)
        0x07 CTLOUT_SET / 0x08 CTLOUT_CLR: 5 bytes (opcode + LE u32), NO response
    Reading after 0x07/0x08 blocks forever - write only, or use overlapped I/O.

EUD COM bring-up (host side, verified):
    CTLOUT_CLR 0x00000000
    CTLOUT_SET 0x00000020     # COM_PERIPH_EN
    CTLOUT_SET 0x00001000     # VBUS_ATTACH
    CTLOUT_SET 0x00002000     # VBUS_INT
    wait ~100-200 ms
    CTLOUT_CLR 0x00002000
Then USB\VID_05C6&PID_9505 enumerates.  Without the VBUS attach it shows up as
VID_0000&PID_0002 (descriptor request failed).

EUD COM wire format (verified):
    [ID=0x90][LEN][DATA...]
      TX_ID  0x088E0000 <- 0x90 (UART_ID from drivers/soc/qcom/eud.c)
      TX_LEN 0x088E0004 <- payload length of this frame
      TX_DAT 0x088E0008 <- payload byte
A whole string written in one go is truncated by the TX FIFO after about seven
payload bytes.  Six-byte frames with 200 us between bytes and 2 ms between
frames are known good.  The host must reassemble frames.

Windows driver for 9505 (installed here, see EUD.md for the full recipe):
    package: QUD.WIN.1.1 installer 10057.4 -> qcser.inf 2.1.3.5
             (qcser.cat + qcusbser.sys, both WHQL-signed)
    note: the INF expects the binary under serial\amd64\, recreate that layout
    installed as: oem102.inf -> "Qualcomm EUD Port 9505 (COM14)"

## 3. Repo state

    master = 996c9a2  samurai: DEBUG over EUD COM via EudSerialPortLib
                        (hardware verified)
             5b7196e  samurai: EUD verified on hardware; document Windows CTL
                        path, COM 9505 bring-up and driver
             11a52b2  docs: fix the offline-copy section in BINARIES.md
    fork remote: https://github.com/hmhmdcy/edk2-realme-x2-pro (push with
                 git push fork master - plain "git push" goes to upstream!)

New/changed in 996c9a2:
    Platform/Realme/sm8150/Library/EudSerialPortLib/{EudSerialPortLib.c,.inf}
    Platform/Realme/sm8150/samurai.dsc      (SerialPortLib scoped overrides)
    Platform/RenegadePkg/Library/PlatformBootManagerLib/PlatformBm.c
                                            (EUD enable + COM marker)
    Platform/Realme/sm8150/EUD.md

SerialPortLib scoping in samurai.dsc (important, do not widen casually):
    DXE_DRIVER / DXE_RUNTIME_DRIVER / UEFI_DRIVER / UEFI_APPLICATION -> EudSerialPortLib
    PrePI / PEI / SEC and DXE_CORE keep FrameBufferSerialPortLib

## 4. Tools and paths

| What | Where |
|---|---|
| EDK2 build tree (WSL) | /home/cy122/edk2-samurai/repo |
| Build script / log | /home/cy122/build-eudcom.sh -> build-eudcom.log |
| Images / backups (Windows) | E:\edk2-samurai-out\ |
| Stock boot (back to Android) | E:\edk2-samurai-out\backup\boot_stock_RMX1931.img |
| EUD host tools | E:\eud-host\ (eudtool, comtool, comrecv, comlog) |
| MSYS2 / UCRT64 toolchain | E:\msys64 |
| quic/eud clone + libeud.dll | E:\eud-host\quic-eud |
| QUD driver package / unpacked | E:\eud-host\qud_10057.4.zip, qud_cab\ |
| platform-tools | C:\Users\cy122\Downloads\platform-tools\platform-tools |
| adb serial | 62bc28a1 |

## 5. Pitfalls (each one already cost a hardware cycle)

1. Readback gating: TX_ID readback came back 0x99999999 (low byte 0x99 =
   0x90 | status bits).  An early version returned early on mismatch and sent
   zero bytes.  Never gate on EUD register readback.
2. One big COM write is truncated after ~7 payload bytes - chunk it.
3. Full DEBUG + DXE_CORE override crashed the boot:
       ReplaceTableEntry: splitting block entry with MMU disabled
       Synchronous Exception at ArmCpuDxe.dll+0x34B8
       ELR 0x13FE0F4B8, LR 0x13FE0F518, ESR 0x02000000, stack corrupted
   Keep PcdDebugPrintErrorLevel at the platform default (0x80000000) and do
   not override SerialPortLib for DXE_CORE.  Fix = Step 2 or Step 3 above.
4. SM8150_UEFI.fd is compressed (FVMAIN_COMPACT): verifying a string with
   grep/strings on the .fd gives false negatives.  Check the uncompressed
   FVMAIN.Fv or the module .obj instead.
5. The submodule files must be committed in the submodule repo, not just the
   parent (this is why the blobs "would not upload" earlier).
6. While EUD is enabled the USB port is gone (no fastboot / no UMS) until a
   full power cycle.  A warm reboot can keep EUD on.

## 6. Safety

* Only ever flash the boot partition.
* Keep E:\edk2-samurai-out\backup\boot_stock_RMX1931.img - it is the only way
  back to Android.
* The "USB Attached SCSI (UAS) Storage" boot option exposes the phone raw UFS
  LUNs.  Never let Windows initialise, partition or format them.
* If the phone hangs with no USB at all, hold Power 15-30 s, then
  Vol-Down + Power into fastboot and reflash a known-good image.

## 7. Open questions

* Does the EUD COM drain need to be faster once full DEBUG is on?  (Step 2)
* Why did EUD SWD 9504 not enumerate after CTLOUT_SET 0x645 + attach?
* Can the log channel survive the UEFI -> OS handoff (useful for Linux boot
  debugging), and what does the Android kernel's ttyEUD see at that point?﻿
---

## 8. Linux boot path and persistent variables - decision (2026-10-07)

Both items are OFF the firmware critical path.  Community practice and the
reasoning are recorded here so this does not get re-analysed every session.

### What the firmware already provides

* Disk stack is in the FV: DiskIoDxe, PartitionDxe, EnhancedFatDxe,
  FvSimpleFileSystem (Apriori.fdf.inc:109-124), so UEFI can read FAT partitions
  and load an EFI application from \EFI\BOOT\BOOTAA64.EFI.
* UFS through the vendor UFSDxe (Shell map/blk shows all six LUNs).
* The platform already runs a Linux kernel as a UEFI application
  (LinuxSimpleMassStorage, MODULE_TYPE = UEFI_APPLICATION).
* The mainline DTB is handed to Linux through the EFI configuration table
  (FdtBlob/<device>/); FdtBlob_compat/<device>.dtb is the vendor DTB appended
  to the boot image so ABL can build the runtime DTB.

### How other phone ports do it (references)

* Renegade / edk2-msm: SimpleInit is only a boot manager - the OS is loaded by
  GRUB or Windows Boot Manager as an EFI application.  Boot menu settings live
  in a config file on a partition (e.g. simpleinit.static.uefi.cfg on the logfs
  partition), NOT in UEFI variables.
    https://renegade-project.tech/en/config/bootmenu
    https://github.com/edk2-porting/edk2-msm
    https://github.com/edk2-porting/renegade-project.org/blob/master/en/multiboot.md
* postmarketOS dual boot on SDM845-class phones: repartition with TWRP/sgdisk,
  create an ESP (set N esp on), pmbootstrap install --split, then boot through
  Renegade UEFI + GRUB.
    https://wiki.postmarketos.org/wiki/Dual_Booting
    https://gist.github.com/raihan2000/70dd18a4022cab8f3411e5665fea5902
* Phones with an SD card slot can boot entirely from SD with no GPT changes;
  the X2 Pro has no card slot, so that escape hatch does not exist here.

### Decision

* initrd / distro boot: NOT implemented in firmware, on purpose.  initrd and
  DTB handoff are the OS loader's job (GRUB publishes LINUX_EFI_INITRD_MEDIA_GUID
  and passes the DTB via devicetree or the EFI config table).  The firmware
  prerequisite - loading an EFI application from a FAT partition - already works.
* Persistent UEFI variables: NOT implemented; accepted as optional.  Variables
  stay emulated (PcdEmuVariableNvModeEnable=TRUE, QcomCommonDsc.inc:92) and are
  lost on reboot.  This only matters for Windows/WoA installers; for the Boot
  Manager / Shell / UFS / EUD-debug goals it is irrelevant.
* Do NOT repartition the phone just to tick the checklist.  If a distro is ever
  wanted, a full GPT backup plus a verified EDL/9008 rescue path must come first.

### If someone wants it later (deferred plan)

1. Back up the GPT (sgdisk --backup) and the partition headers; confirm an
   EDL/9008 rescue path.
2. Shrink userdata with TWRP and create a FAT32 ESP (512 MB - 1 GB), optionally
   a Linux rootfs partition.  Never touch modem / persist / op1 / op2 / super.
3. Put grubaa64.efi as EFI/BOOT/BOOTAA64.EFI plus kernel, initrd, DTB and
   grub.cfg on the ESP:

       menuentry "Linux" {
         devicetree /samurai.dtb
         linux     /kernel.efi console=tty0 root=PARTUUID=<rootfs> rw
         initrd    /initrd.img
       }

   SimpleInit will discover it; if not, register a boot option in PlatformBm.c
   the same way the UAS entry is registered.
4. Minimal proof without a distro: put kernel.efi + initrd.img + startup.nsh on
   the ESP and run it from the Shell (the Shell has no letter input, so
   startup.nsh is mandatory):

       fs0:\kernel.efi console=tty0 initrdfile=fs0:\initrd.img

   (older kernels accept initrd= instead of initrdfile=)
5. A file-backed variable store already exists in the tree if ever needed:
   Common/edk2/OvmfPkg/Library/NvVarsFileLib (OVMF model: keep emulated mode,
   read \NvVars early, save it at ExitBootServices).  Not needed now.

## 9. Port checklist status (2026-10-07)

| Item | Status | Note |
|---|---|---|
| Stable boot | ✅ | PEI -> DXE -> BDS -> Boot Manager -> EFI Shell, verified on hardware |
| Memory | ✅ | 8 GiB profile: -DHAS_MLVM + ABL-patched runtime DTB |
| GOP / display | ✅ | framebuffer text console 1080x2400; optional DisplayDxe not enabled |
| Buttons | ✅ | Vol-Up / Vol-Down / Power (factory ButtonsDxe + OppoProject + ResetRuntimeDxe) |
| Select / load Linux | 🟡 | delegated: SimpleInit + GRUB.  Firmware can load EFI apps; no distro installed |
| DTB passed | ✅ | mainline DTB via EFI configuration table; vendor DTB appended for ABL |
| initrd passed | 🟡 | delegated to GRUB; firmware side intentionally not implemented |
| UFS | ✅ | six LUNs, GPT, Shell map/blk; raw LUNs via the UAS boot option |
| USB for debugging | ✅ | EUD CTL + EUD COM + DEBUG over EUD (host qcser driver needed); SWD/JTAG not yet |
| Persistent variables | ❌ | not implemented, optional; only needed for Windows/WoA |
| Windows on Arm | ❌ | DSDT still borrowed from cepheus |﻿
---

## 10. Linux porting paths and when a partition change is really needed (2026-10-07)

A first Linux bring-up on this phone does NOT require touching the partition
table.  Do not repartition unless one of the cases in the last table applies.

### Paths that need NO GPT change

1. Android boot model, mainline kernel + built-in initramfs (recommended first
   step for a Linux port):
   - the repo already has the pieces: configs/devices/samurai.conf,
     tools/mkbootimg.py (header v1 + gzip payload + appended DTB) and the
     mainline DTB at Platform/Realme/sm8150/FdtBlob/samurai/*.dtb;
   - replace the UEFI FD payload with the Linux kernel + initramfs, build a
     boot.img, then:  fastboot flash boot boot-linux-bringup.img
   - the system runs from RAM (tmpfs); display / USB / UFS / buttons can be
     validated; going back to Android is just flashing the stock boot image.
2. EDK2/UEFI model, EFI-stub kernel embedded in the firmware as a UEFI
   application:
   - the platform already does exactly this with LinuxSimpleMassStorage
     (MODULE_TYPE = UEFI_APPLICATION, built-in initramfs, launched from the FV);
   - a bring-up kernel can be embedded the same way - no FAT partition and no
     GPT change; not suitable for a persistent distro.
3. Persistent rootfs without a GPT change: format userdata (ext4/f2fs) and use
   it as the rootfs.  Data is lost, but the partition table is untouched and
   Android can be restored at any time.

### Paths that DO need a GPT change

| Goal | Why |
|---|---|
| Android + Linux dual boot | must shrink userdata and create a second partition |
| Persistent distro while keeping Android data | same |
| EDK2/UEFI + GRUB distro | UEFI only reads FAT, so an ESP must exist |
| Windows on Arm | ESP + NTFS, same as the WoA community guides |

### Two distinctions that keep getting confused

* mkfs of an existing partition is NOT repartitioning.  Formatting userdata
  keeps the GPT intact; sgdisk/parted rewrite the GPT and are the real risk.
* Repartitioning itself needs neither EDL nor auth.  The community does it
  from TWRP with parted/gdisk on /dev/block/sda; userdata is the last
  partition, so the other partition offsets do not move.  EDL is only the
  rescue path for a hard brick (no fastboot, no recovery).

### Rules for the partition-touching cases (from the WoA community)

* partition names must not contain spaces and must not be empty - ABL fails
  otherwise; fix with parted, never with Windows diskpart/diskmgmt;
* back up the GPT and the partition headers before touching anything;
* keep QCN/EFS backed up - a full EDL flash erases IMEI.

## 11. EDL (9008) resources for RMX1931, and the auth question (2026-10-07)

The earlier assumption "realme has no public EDL package" was wrong - resources
exist (third-party mirrors, verify hashes and scan before use):

* firehose programmer (ELF/MBN) for RMX1931/SM8150:
    https://filewale.com/folders/rmx1931-realme-x2-pro-1/16100
* QFIL XML full firmware packages (rawprogram/patch XML + images):
    RMX1931EX-11-C.36-210310-XML-FIRMWARE-QFIL.rar (5.1 GB)
    RMX1931-11-F.10-210425-XML-FIRMWARE-QFIL.rar (3.8 GB)
    https://azrom.net/rom-realme-x2-pro-rmx1931-all-file-repair-firmware/
* tools / guides:
    https://github.com/salokrwhite/OplusEdlTool   (open source, OFP/OPS, backups)
    https://github.com/AdaUnlocked/OnePlus-9008-JiuZhuan-Guide
    https://github.com/kxob/OnePlus-9008-Unbrick-Guide
    ROM2box (XDA), "no auth" MSM Download Tool for RMX1931 (romprovider)
* Chinese 9008 line-flash packages:
    https://yun.daxiaamu.com/Realme_Roms/ (realme X2 Pro RMX1931 page)
* already on this machine:
    E:\RMX1931_11_OTA_1340_all_2QCxQYdkxpql.ozip          (3.19 GB, CN full OTA)
    E:\系统rom\RMX1931_11_OTA_1330_all_19781_downgrade.ozip (3.19 GB, downgrade)
    EDL reference scripts from the OnePlus 7T mainline work:
      E:\Realme X2 Pro移植主线Linux\sources\oneplus-reference\hotdog-linux-bringup\scripts\
      restore-boot-b-from-edl-firehose.sh, watch-edl-dump-critical.sh

Auth reality - do not rely on "no auth" being permanent:

* There is no real auth bypass.  "No auth" means leaked signed firehose files
  (devprg*.mbn plus digest/signature) reused by community tools.  It covers
  older models/firmware such as RMX1931, but OPPO has changed the scheme on
  newer firmware (the OnePlus 13 / Ace5 update went back to service-only auth,
  with no downgrade package).
* Consequence: do NOT update the firmware and do NOT re-lock the bootloader,
  otherwise the leaked files may stop working.
* A firehose file alone is not enough.  Four things are needed: a matching
  signed programmer (plus digest/signature if the device enforces auth), a
  matching firmware package (rawprogram/patch XML, or OFP/OPS), a tool that
  speaks the OPLUS protocol, and correct partition definitions for this exact
  model.  Plus a QCN/EFS backup because a full EDL flash erases IMEI.
* Safe rehearsal (zero risk): get into 9008, let the tool detect the device and
  load the firehose, then stop before flashing.  Only after that, and after the
  no-auth recovery path (fastboot images + QCN/EFS + ozip) is in place, should
  a GPT change even be considered.﻿
---

## 12. Final image verified, why boot logs are still missed, and the two fixes (2026-10-07 01:0x)

### Verification of the final image

* Image: boot-samurai-eudcom.img
  sha256 A8891194EE35023CB6BDAE7F22C2ABEF983735F841262D8EA574AF507187E44C
  flashed via fastboot, booted to the UEFI boot menu: display, UFS, all three
  side buttons normal.
* EUD control channel while running the final image:
      0x01 -> 00 00 05 00
      0x02 -> A1 28 BC 62
      0x03 -> 04 00 00 00
* EUD COM: "Qualcomm EUD Port 9505 (COM14)" Status OK.
* comlog.exe COM14 60 -> 0 bytes captured.

### Why 0 bytes (a timing gap, not a bug)

    firmware: BDS enables EUD, then immediately emits the single marker line
    host:     sees the 9501 only after the EUD hub enumerates, then runs
              eudtool com-up, which is what sets COM_PERIPH_EN + VBUS_ATTACH,
              so COM14 appears about 1-2 s later

The marker is written before the COM channel exists and is dropped; the BDS
boot menu is idle afterwards, so nothing else arrives.  The earlier 30-second
test loop was captured precisely because it was still sending while the host
brought the port up.

### Consequence for the log channel design

Every DEBUG line emitted before the host runs com-up is lost - that includes
all of PEI/DXE and the start of BDS, i.e. the most interesting boot logs.
Two complementary fixes:

1. Firmware enables the COM peripheral itself (small, nice-to-have)

   In the BDS EUD block, after CSR_EUD_EN, also write the CTL_OUT bits
   directly instead of waiting for the host:
       CTL_OUT_1 register = 0x088E0074
       set bit5  (COM_PERIPH_EN) and bit12 (VBUS_ATTACH)
   Those are the same bits eudtool com-up sets through the CTL USB channel.
   The EUD COM device then exists before the first log line and the host only
   has to open the port.  Verify the write semantics on hardware (the register
   behaves like a set/clear register; the host uses CTLOUT_SET/CLR commands).
   This alone does not help if the host is slow to open the port - which is
   what fix 2 solves.

2. Non-blocking SerialPortLib with a ring buffer (the real fix)

   * SerialPortWrite() only appends bytes to a RAM ring buffer: no MMIO, no
     delays, no gBS dependency; count the dropped bytes when the buffer is full;
   * a periodic event (or the BDS wait callback / a platform timer) drains the
     ring buffer into the EUD COM TX FIFO in 6-byte frames with the known-good
     timing (200 us per byte, 2 ms per frame);
   * the drain only runs once CSR_EUD_EN is set, and - with fix 1 - once the
     firmware has enabled COM;
   * expose the drop counter (an on-screen line or a CTL scratch register).

   With both fixes in place, DEBUG from DXE onwards is buffered and replayed as
   soon as the host is ready, which also removes the need for the
   PcdDebugPrintErrorLevel workaround and its crash risk (section 5, pitfall 3).

### Suggested order for the next session

1. Final image is flashed and verified (this section) - nothing to redo.
2. Implement fix 2 (ring buffer + drain) in EudSerialPortLib; that is the main
   remaining task and it unblocks full DEBUG logging.
3. Optional: fix 1 (firmware-side COM enable) to shorten the gap further.
4. Re-test with comlog.exe and PcdDebugPrintErrorLevel set to 0x800B05C7,
   keeping the SerialPortLib scoping unchanged (never DXE_CORE).