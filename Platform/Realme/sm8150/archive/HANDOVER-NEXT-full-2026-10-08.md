# Session handover - realme X2 Pro (samurai) EDK2/UEFI

> Updated 2026-10-08 (Asia/Shanghai) at the end of the session that turned the
> EUD COM port into a real console and command channel.  Sections 29 and 30 are
> the current state; sections 2-28 are the earlier, still valid detail.
> Companion documents:
>   Platform/Realme/sm8150/EUD.md      (EUD registers, CTL/COM protocol, drivers)
>   Platform/Realme/sm8150/BINARIES.md (firmware blobs and where they come from)
>   Platform/Realme/sm8150/README.md   (status of the port as a product)

## 0. TL;DR - where the project stands (2026-10-08 evening)

Boots and runs:

* EDK2/UEFI boots on hardware; all three side buttons work; UFS and the GPT are
  enumerated; USB mass storage mode works; the UEFI menu boots the mainline
  Linux kernel from the FAT inside the logdump partition.
* Mainline Linux (7.3-rc6) reaches userspace and stays there, with an
  interactive shell in the initramfs.

EUD - the only console this board has - all verified on hardware today:

* Single-writer, fully paced log channel.  The early console is retired as soon
  as our real console registers ("printk: legacy bootconsole [eud0] disabled"),
  every register write is paced (200 us) and every frame spaced (2 ms), and a
  210 s capture reassembles with 0 resyncs and no dropped frames.
* /dev/ttyEUD0 exists (a real uart driver, "ttyEUD"), its TX path works end to
  end, and /dev/console is bound to it.
* The firmware command line was rebuilt to
  "earlycon=eud,mmio,0x88e0000 console=tty0 console=eud ..." with keep_bootcon
  removed.
* RX command channel [0x81][cmd] works (ping, register dump, status), and
  [0x82][char] types into the shell on /dev/ttyEUD0.
* The RX payload register was found: 0x14 is the FIFO read port while 0x0c/0x10
  are latches (section 29.1).
* Known problem: the first payload implementation reads 0x14 too eagerly and
  wedges the EUD COM block - the console goes silent until a full power cycle.
  Reading 0x14 must happen only when a complete payload is certain.

## 1. What to do next, in order

1. Choose the phone state you want:
     * last verified-good kernel:  fastboot flash logdump logdump-tty6.img
       (clean console, /dev/ttyEUD0, header command channel)
     * back to Android:            .\flash-and-test-rx.ps1 -RestoreAndroid
2. Make the RX payload read safe (section 29.5): read 0x14 exactly `len` times,
   only when the header latch changed, with `len` validated to 1..16, and never
   touch 0x14 otherwise.  Typing over EUD then becomes a reliable interactive
   shell - the goal "control it like adb, without Android".
3. PON reboot-mode plus the two DT mode lines plus a reboot2 helper, so
   "reboot bootloader / recovery / EDL" can be commanded over EUD.  Together
   with the verified `fastboot flash logdump` (1.8 s) that closes the hands-free
   flywheel (sections 28.4 and 28.6).
4. Then the real port work: panel SOFEF03F_M, touch S3706, WCN3990, charger,
   sensors, and the device-tree clean-ups in section 27.4 goal 2.
5. Optional: a samurai DSDT for Windows, a startup.nsh for the EFI shell, a
   persistent UEFI variable store, and the ESP + GRUB end state.

Every hardware step needs a full power cycle first: hold Power ~15 s (EUD keeps
the USB port until then, and a wedged EUD block only clears that way), then
Vol-Down + Power for fastboot.  Never flash anything but boot and logdump; see
section 6 for the safety rules.

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
---

## 13. EUD log ring buffer implemented (2026-10-07 02:0x)

The main task from section 12 (fix 2) is DONE in code and builds clean.  It is
NOT flashed yet.

New image (built, not flashed):
    E:\edk2-samurai-out\boot-samurai-eudlog.img
    sha256 d2fce824f9e3ac0495b85c4775f5448a917ebec4e8deeb8150d9ab55de46ae72
    (plus SM8150_UEFI-samurai-eudlog.fd)

Changed in ~/edk2-samurai/repo (all uncommitted):

    Platform/Realme/sm8150/Library/EudSerialPortLib/EudLog.h            new
    Platform/Realme/sm8150/Library/EudSerialPortLib/EudSerialPortLib.c  rewritten: producer only, no MMIO, no delays
    Platform/Realme/sm8150/Library/EudSerialPortLib/EudSerialPortLib.inf  SynchronizationLib in, IoLib/TimerLib out
    Platform/Realme/sm8150/EudLogDxe/EudLogDxe.c                        new (single drainer)
    Platform/Realme/sm8150/EudLogDxe/EudLogDxe.inf                      new
    Platform/Realme/sm8150/samurai.dsc                                  [Components.common] entry
    Platform/Realme/sm8150/samurai.fdf.inc                              INF entry
    Silicon/Qualcomm/sm8150/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c
                                "RSRV2" renamed to "EUD Log" (address and size unchanged)
    Platform/Realme/sm8150/EUD.md                                       new section

Why the section 12 design had to change: EudSerialPortLib is linked into 162 of
the 177 built modules (verified from the .map files), so a library-static ring
buffer would exist 162 times and no single drainer could see all of them.  The
ring is therefore at a fixed address shared by every copy.

Why RSRV2 and not Log Buffer: realme own uefiplat.cfg (in
uefifw/realme-rmx1931/Binaries/RawFiles) contains no RSRV1/2/3 at all; the vendor
map simply leaves 0x9FFD0000 up to 0x9FFF7000 empty and the port filled that hole
with reference names from other SoCs.  "Log Buffer" by contrast is a real vendor
region (RtData, and the stock XBL references it), so overwriting it would destroy
the vendor boot log.

Build verification (no hardware involved):
  * EudSerialPortLib.obj undefined symbols: InterlockedCompareExchange32 and
    MemoryFence only; zero references to 0x088E0000 (the blocking path is gone).
  * EudLogDxe disassembly contains both movk #0x9ffe (ring) and #0x88e0000 (EUD).
  * FVMAIN.Fv: "RSRV2" 0 occurrences, "EUD Log" 1, 0x9FFE3000 1, EudLogDxe FFS
    file present (GUID 2E6C5B41-9A73-4C0E-8B27-1F5D3A6E9C04).

Still to do next session:
  1. flash and verify on hardware: look for the "[EUD-LOG] host COM attach seen"
     line, then the full DEBUG stream, and check the Drops counter.
  2. measure the replay rate and tune (see the follow-ups in EUD.md).
  3. optional fix 1 (firmware side COM enable) is still not done; it would remove
     the dependence on the CTL_OUT gate.
---

## 14. EUD log ring: 真机验证通过（2026-10-07 02:45）

镜像 `E:\edk2-samurai-out\boot-samurai-eudlog2.img`
sha256 `cf2364723022b2491bf763d5359547fc6226518829c119539b2d5153ec0e71a8`，已刷机验证：

- 重启后约 **3.5 秒** EUD CTL 9501 出现（BDS 里开 EUD）
- `eudtool com-up` → `Qualcomm EUD Port 9505 (COM14)` 立即就绪
- `comlog.exe COM14 30` → **12523 字节 / 1571 帧 / 12 遍完整回放**
- 日志里含**主机 attach 之前**产生的早期 DXE 行
  （`SimpleFbDxe: Retrieve MIPI FrameBuffer parameters from PCD`）——以前必丢的内容，现在拿到了
- 无 overflow（ERROR 级别下 80KB 环远远够）

**中途发现的设计缺陷（第一版 eudlog 镜像）**：排空驱动原本门控在 `CTL_OUT_1` 的读回，
并设 15 秒兜底。实测该读回不可靠，且兜底在"人手动敲 com-up"之前就触发了，
于是缓冲被推进真空、主机抓到 0 字节（当时屏幕上的
`[EUD-LOG] no host attach seen, replaying anyway` 就是这条路径）。

**修正**：去掉门控与兜底，改成**循环回放** —— 每遍把消费指针回卷到环内最旧字节、
整卷重发，遍间停 2 秒；EUD 就绪后维持 120 秒，之后转为只转发新数据（避免长时间占用回调）。
主机在任何时刻 attach 都能拿到完整一份，且不再需要猜测主机状态。

**后续可做**：

1. 每遍加一个分隔标记行，便于阅读（现在是 12 份副本叠在一起）。
2. 若把 `PcdDebugPrintErrorLevel` 开到全量 DEBUG，环会填满，按当前 ~1.2KB/s 每遍约 68 秒 ——
   循环仍保证完整，但回调占用会偏高，建议先做流控优化（TX 状态轮询 / 加大帧长）再开。
3. **首次抓取已经暴露出一个以前看不见的真固件错误**：
   `ERROR: C40000002:V03051003/V03051002 I0 6D33944A-EC75-4855-A54D-809C75241F6C 9FFCF718`
   （BdsDxe 的 GUID，每遍出现 9-11 次）—— 值得下一步查。
---

## 15. 全量 DEBUG 打通 + 崩溃真因修正（2026-10-07 03:20）

**镜像** `E:\edk2-samurai-out\boot-samurai-eudlog5.img`
sha256 `5a0aab582df3f1382b6b7cae6fd58568930a50b2a80dd5ab3013c265d8837d82`，真机验证通过。

### 崩溃真因（推翻了交接文档的判断）

`ArmCpuDxe + 0x34B8` 反汇编后是 **`ldp x19, x20, [sp, #16]`** —— 即
**ArmMmuLib 的 `ReplaceTableEntry()` 收尾弹栈**，是**栈访问 fault**，**不是**串口/EUD 写。

- 那条 "splitting block entry with MMU disabled" 是同一分支打印的，
  所以它的文本才会留在栈上 —— **症状而非原因**；
- 旧版写 EUD MMIO、新版写 RAM 环形缓冲，都崩在**同一条指令**（所以偏移完全一致）；
- 真正的问题是：更新"活动块映射"时（关 MMU 做 break-before-make），
  **栈所在页会变得不可访问**，紧接着的弹栈就 fault；
- 全量 DEBUG 才触发，是因为它改变了内存属性更新的数量/时机，某次更新覆盖了栈区
  （`SP=0x9FFCF5E0`，落在 "UEFI Stack" 0x9FFB0000–0x9FFD0000）。

**修复**：删掉该分支里的 `DEBUG()`（原则：绝不在"即将关 MMU"的路径上做日志输出），
见 `Common/edk2/ArmPkg/Library/ArmMmuLib/AArch64/ArmMmuLibCore.c`。
改后全量 DEBUG（`PcdDebugPrintErrorLevel=0x800B05C7`，加在 `samurai.dsc`）**4 秒进 BDS**。

### 验收数据

- `comlog COM14 90` → **138501 字节 / 2099 行 / 12 遍**
- 每遍 `10214 byte(s) in 8510 ms` → **约 1.2 KB/s**
- **无 overflow**：整份启动日志仅约 10KB，80KB 环绰绰有余
- 日志覆盖：DXE 启动 → BDS → 启动项转储 → SimpleInit → 变量驱动 → CPU 频率驱动

### 附带收获：两个以前看不见的真 bug

1. `SetCPUFreqDxeMain: CPU 1 Now running at -1875767296 Hz`（CPU 2 同样）—— **负值/垃圾频率**
2. `Failed to get the maximum performance level for CPU 4, Status: Protocol Error` +
   `This CPU may not exist on current platform` —— 8 核平台只配置了 CPU 0–3

### 之前那个 BdsDxe 错误，被这份日志直接证实了

启动项转储显示自动枚举出 **8 个不可引导项**：
`UEFI Misc Device 1–6`（六个 UFS LUN）+ `UEFI Non-Block Boot Device 1–2`。
BDS 逐个尝试加载失败 → 正是
`EFI_SW_DXE_BS_EC_BOOT_OPTION_LOAD_ERROR (V03051002)` 约 7 次 +
`BOOT_OPTION_FAILED (V03051003)` 1 次。**属良性噪音，但确实是每次开机报 9 次错误的来源。**

### 待提交（仓库当前未提交改动）

- `Platform/Realme/sm8150/EudLogDxe/EudLogDxe.c`（循环回放 + 每遍标记/统计 + 时间预算）
- `Platform/Realme/sm8150/samurai.dsc`（全量 DEBUG PCD）
- `Common/edk2/ArmPkg/Library/ArmMmuLib/AArch64/ArmMmuLibCore.c`（移除危险 DEBUG）
- 以及 EUD 环形缓冲相关的全部文件（EudSerialPortLib 重写、EudLog.h、内存表改名）
---

## 16. 提交、噪音消除、bug 定位（2026-10-07 03:30）

### 已提交（master，5+1 个提交，尚未 push 到 fork）

```
04da4b4 samurai: EUD COM log ring + cyclic replay drainer
1da715f samurai: do not auto-enumerate every device as a boot option
2d26a5a SetCPUFreqDxe: print UINT32 frequencies unsigned and keep going
a3b70b8 samurai: ship the ArmMmuLib full-DEBUG fix as a patch
18e965b docs: EUD log ring verification, ArmMmuLib root cause, boot option noise
(+ 后续一个 docs 补丁说明提交)
```

**重要约束**：`Common/edk2` 子模块只有 `origin = tianocore/edk2`，**没有 fork**。
若在其中 commit，父仓库记录的指针在上游不存在 → `clone --recursive` 不可复现
（与交接文档里"二进制传不上 GitHub"是同一个坑）。因此 ArmMmuLib 修复以补丁形式随父仓库发布：

```
git -C Common/edk2 apply Platform/Realme/sm8150/patches/armmmulib-no-debug-in-mmu-off-path.patch
```

工作区里该子模块改动保持未提交（本地构建需要它）；如需真正入库，需要先 fork edk2 并加 remote。

### 启动项噪音：已消除

`PlatformBm.c` 里的 `EfiBootManagerRefreshAllBootOption()` 已注释掉（附完整说明与恢复方法）。
它曾为 6 个 UFS LUN + 2 个 FS-only 设备自动建启动项，BDS 逐个尝试加载失败 →
每次开机 9 条 `BOOT_OPTION_LOAD_ERROR/FAILED`。菜单项改为只显示显式注册的
（UiApp / SimpleInit / UEFI Shell / UAS Storage），其他可从 Shell 启动。

### bug 定位与修复：SetCPUFreqDxe（源码就在本仓库）

`Platform/RenegadePkg/Drivers/SetCPUFreqDxe/SetCPUFreqDxe.c`

1. **显示 bug**：`perfLevel`/`frequencyHz` 声明为 `UINT32` 却用 `%d` 打印 →
   2419200000 Hz（2.4192GHz，Silver）显示成 `-1875767296`，
   2956800000 Hz（2.9568GHz，Gold+）显示成 `-1338167296`。**频率本身是对的。** 已改 `%u`。
2. **真 bug**：循环 `for (i = 0; i < 9; i++)`（假设 4+4 CPU + L3），
   而 `GetMaxPerfLevel` 失败时**直接 `return`** → 本机 index 4 返回 Protocol Error 后
   整个循环中止，**Gold/Gold+ 核（4–7）从未被设置频率**。已改为 `continue` + 跳过记录。

### 记忆

- **Mnemon 后端在本机不可用**（`spawn mnemon ENOENT`，未安装 CLI）→ 记忆空间创建失败，
  无法写入 Mnemon 空间。若要启用：安装 Mnemon Windows 版并把 `mnemon.exe` 加入 PATH。
- 已改用 **host 的运行时 MEMORY.md**：新增一条 2026-10-07 摘要（3 条，6850/10240 字节），
  记录 EUD 环、三条硬教训、崩溃真因、噪音来源、SetCPUFreqDxe 缺陷、Linux 侧 earlycon 现状。

### 新镜像（待真机验证）

```
E:\edk2-samurai-out\boot-samurai-eudlog6.img
sha256 060efe010b5a1b6a54d52927fbafcd4980bd16a51a623426d749f26fb51dbe25
```

包含：EUD 环全量 DEBUG + 启动项噪音消除 + SetCPUFreqDxe 修复 + ArmMmuLib 补丁（已应用）。
验证要点：① 启动更快、日志里不再有那 9 条 BOOT_OPTION 错误、启动项只剩 4 个；
② `SetCPUFreqDxeMain` 频率为正数，且 CPU 4–8 不再因 index 4 失败而中断。
---

## 17. 子模块已按方案 A 解决（2026-10-07 03:45）

ArmMmuLib 修复**不再需要手工打补丁**：

- 已用 `gh` 建好 fork `hmhmdcy/edk2`（fork of tianocore/edk2）
- 子模块本地提交 `60dbefd0`「ArmMmuLib: do not print from the live block split path」
- 已推到分支 **`samurai-armmmulib`**（远端校验：`refs/heads/samurai-armmmulib` = 60dbefd0）
- `.gitmodules` 的 `Common/edk2` 已改为 `url = https://github.com/hmhmdcy/edk2.git` +
  `branch = samurai-armmmulib`（与 `Platform/EFI_Binaries` 指向 `hmhmdcy/edk2-msm-binary` 同一套做法）
- 父仓库提交 `c10cf90` 固定新指针，**已推到 fork/master**

于是 `git clone --recursive https://github.com/hmhmdcy/edk2-realme-x2-pro` 直接得到带修复的树，
零手工步骤。补丁 `Platform/Realme/sm8150/patches/armmmulib-no-debug-in-mmu-off-path.patch` 保留，
供"使用上游 submodule URL"的人兜底。

**后续维护**：若把 edk2 子模块 rebase 到更新的上游版本，需把这一行删除重放到新版本，再推同名分支
（`git -C Common/edk2 push fork HEAD:refs/heads/samurai-armmmulib`），最后在父仓库更新指针。

**网络注意**：本机 GitHub 访问走代理、**时好时坏**（`GnuTLS handshake failed` /
`connection reset` / `via 127.0.0.1`）；push 经常要重试 2–3 次才能成功，
且 `git ls-remote` 成功并不代表 push 一定成功。`gh` 在 WSL 与 Windows 均已登录（hmhmdcy）。

### 已推送的提交（fork/master = c10cf90）

```
c10cf90 Common/edk2: pin the submodule to the fork carrying the ArmMmuLib fix
f756f44 docs: note how to apply the ArmMmuLib patch
18e965b docs: EUD log ring verification, ArmMmuLib root cause, boot option noise
a3b70b8 samurai: ship the ArmMmuLib full-DEBUG fix as a patch
2d26a5a SetCPUFreqDxe: print UINT32 frequencies unsigned and keep going
1da715f samurai: do not auto-enumerate every device as a boot option
04da4b4 samurai: EUD COM log ring + cyclic replay drainer
```

---

## 18. 主线 Linux：内核已进固件，等真机验证（2026-10-07 14:3x）

### 18.0 TL;DR

固件里**第一次有了能用的主线 Linux 内核，和这台机器自己的设备树**。
之前 `FdtBlob/samurai/sm8150-realme-samurai.dtb` 其实是小米 9（cepheus）的设备树，
而固件里除了别人编的 pmOS 6.1 内核外没有任何可启动的内核。

现在刷 `E:\edk2-samurai-out\boot-samurai-linux.img`，UEFI 菜单里会多出
**"Linux (mainline samurai)"**，选中后内核经 EUD earlycon 打日志（同时 simpledrm
把日志打到手机屏）。**这一步尚未上真机**——下一个会话第一件事就是它。

### 18.1 本会话（Linux 主线）做了什么

工作区 `E:\RealmeX2Pro edk2\linux-port`；WSL 源码树 `~/x2pro-linux/linux`
（Linux v7.3-rc6 `a90ee4305c4a`，无 remote，本地两个提交）。

1. **EUD earlycon**（提交 `e4858b30a`，补丁 `linux-port/patches/0001-*.patch`）：
   `drivers/tty/serial/eud_earlycon.c`，命令行 `earlycon=eud,mmio,0x88e0000`。
   **本会话修掉一个会直接崩机的 bug**：earlycon 框架对 `mmio` 形式只映射 64 字节
   （即 FIFO 所在那一页），而 `CSR_EUD_EN` 在 `+0x1014`，属于**下一页**——照原样写会
   缺页，内核还没输出就死。改为自己 `ioremap(mapbase + 0x1014, 4)` 再写；映射失败
   也不影响 console 注册。
2. **samurai 主线设备树**（提交 `0450fd895`，源 `linux-port/dts/sm8150-samurai.dts`）：
   以 `sm8150-mtp.dts` 为底（本机原厂基础 DTB 本身就是 MTP 派生），按实机重写
   21 个 reserved-memory、音量键（`pm8150_gpios` 6/7、`bias-disable`、
   `power-source = <1>`）、UFS 供电（保持 MTP 的 `vreg_s4a_1p8`）；GPU/WiFi/四个
   remoteproc/uart2/pon_resin 保持 `disabled`。`make dtbs` 通过，DTB
   `1c760ec9cf74389c246e1b64a032c52910f6437dab29772371a506ead5d67b81`（94,623 B）。
   `/memory` 故意保持 `0x80000000 + 0`：Android 链由 ABL 修补，EDK2/EFI 链的 RAM
   来自 EFI memory map（已核对 `drivers/firmware/efi/efi-init.c`）。
3. **旧工程核实**（报告 `linux-port/docs/OLD-PROJECT-VERIFICATION.md`）：
   它的补丁可复现（重编 DTB 与产物同哈希 `f0c3a820…`），但 **3 处勿抄**：
   UFS `vccq2` 是 `&vreg_s4a_1p8`（S4A）不是 L7A；音量键 pin 是 `bias-disable` +
   `power-source = <1>`；ramoops 不要 `devinfo-size`（主线不解析）。其文档只记了
   4 轮主线盲刷，实际是 6 轮（1-4/7/8），第 8 轮完全没有结果文件。
4. **诊断内核 Image**（`linux-port/scripts/build-image.sh`）：以旧工程
   `bringup.config` 为配置基线（补上它缺的 `CONFIG_EFI` / `EFI_STUB` /
   `EFI_ARMSTUB_DTB_LOADER`），另开 EFI GOP 帧缓冲控制台（`SYSFB_SIMPLEFB` +
   `DRM_SIMPLEDRM` + `FRAMEBUFFER_CONSOLE`，日志同时上屏）、`SERIAL_EUD_EARLYCON=y`、
   `PSTORE_RAM=y`，内置 busybox 诊断 initramfs。`Image` 30,116,352 B，
   sha256 `3d5665ab…`，`kernelrelease = 7.3.0-rc6-rmx1931-samurai+`。
5. **内核进固件 + 换掉错误 DTB**（EDK2 提交 `47c3efb`，说明
   `linux-port/docs/EDK2-KERNEL-EMBED.md`）：
   - `FdtBlob/samurai/sm8150-realme-samurai.dtb` → 新的 samurai DTB；
   - 新增 `Platform/Realme/sm8150/LinuxKernel/{Image,SamuraiLinuxKernel.inf}`
     （`UEFI_APPLICATION`，GUID `7a3c1e42-9d55-4c8b-b621-0f8a442e913d`，写法照抄
     `LinuxSimpleMassStorage.inf`），`samurai.fdf.inc` 加 `INF` 行；
   - `PlatformBm.c` 在 `#ifdef SAMURAI_LINUX_KERNEL` 下注册启动项
     `"Linux (mainline samurai)"`，`samurai.dsc` 打开该宏；
   - **FD 从 7 MiB 涨到 20 MiB**（`configs/sm8150.conf` 的 `FD_SIZE=0x01400000`、
     `sm8150.fdf` 的 `NumBlocks=0x1400` 和 FD 区域 `0x01400000`），原因是内核
     压缩后约 11.7 MB，塞不进 7 MiB。
6. **离线逐字节验证**：FD = 20,971,520 B；boot.img 解出的 BootShim+FD 与之完全一致；
   FV 里内核 FFS 的 PE32 载荷与 `Image` **sha256 相同**；未压缩 `FVMAIN.Fv` 中
   `realme,samurai` 出现 1 次、`xiaomi,cepheus` **0 次**、`rmx1931-samurai` 7 次。

### 18.2 产物

| 文件 | 大小 | sha256 |
|---|---|---|
| `E:\edk2-samurai-out\boot-samurai-linux.img` | 15,185,920 | `0d1ec54656fed0550a90ac8453918a8d589d93ed890914959ffba31f2b0a3439` |
| `E:\edk2-samurai-out\SM8150_UEFI-samurai-linux.fd` | 20,971,520 | `f6a0664d6d4ce402c668fdd46fef9d49bd8e3bbabe901e55fb550c7843d58f4b` |
| `E:\edk2-samurai-out\Image-rmx1931-samurai` | 30,116,352 | `3d5665abcf53b1b97ee5b2c32b4aaaee45265a4c45af99463b4d3c2b35427ba3` |
| 回滚用 | — | `backup\boot_stock_RMX1931.img`（`dfe18875…`） |

EDK2 提交：`47c3efb`（内核进固件）+ `0ccd325`（本文档），**已 push 到 fork
`hmhmdcy/edk2-realme-x2-pro` 的 master**。内核补丁在 `linux-port/patches/`，
设备树源在 `linux-port/dts/`。

⚠️ **复现注意**：`Platform/Realme/sm8150/LinuxKernel/Image` 是构建产物，**没有进
git**（30 MB）。全新 clone 后必须先把它放回去——`E:\edk2-samurai-out\Image-rmx1931-samurai`
或 `linux-port\artifacts\Image-rmx1931-samurai`（sha256 `3d5665ab…`），或自己按
`linux-port/scripts/build-image.sh` 重编——否则 `./build.sh -d samurai --toolchain GCC5`
会因为 INF 找不到 `Image` 而直接失败。

### 18.3 下一步（按顺序）

**A. 真机验证（最高优先；手机接上就能做）**

```powershell
# 1) 先备好 EUD 日志通道：重启后约 3.5 s 出现 9501，那时执行
E:\eud-host\eudtool.exe com-up
E:\eud-host\comlog.exe COM14 600 E:\eud-host\samurai-linux.log
# 2) 刷入并重启
fastboot flash boot E:\edk2-samurai-out\boot-samurai-linux.img
fastboot reboot
# 3) 屏幕出现 UEFI 菜单后：音量键选 "Linux (mainline samurai)"，电源键确认
```

验收：`samurai-linux.log` 里出现 `Booting Linux on physical CPU`、8 核、内存、
UFS、initramfs 横幅；屏幕上同时能看到内核日志。

回滚：EUD 开着时 USB 被占用，**先长按电源 15 s 彻底断电**，再 音量下+电源 进
fastboot，`fastboot flash boot E:\edk2-samurai-out\backup\boot_stock_RMX1931.img`。

**B. 如果没输出，按这三个分支排查**

1. 菜单里根本没有 "Linux (mainline samurai)" → 确认 `INF` 真的编进去了
   （grep `workspace/Build/samurai/RELEASE_GCC5/FV/FVMAIN.inf`）以及
   `-DSAMURAI_LINUX_KERNEL` 生效。
2. 选了之后立刻黑屏/回菜单，EUD 里什么都没有 → 最可能是内核没拿到 DTB/命令行
   （console 与 earlycon 都来自 DTB 的 `chosen/bootargs`）。加固：给
   `PlatformRegisterFvBootOption` 增加一个可选命令行参数，把
   `earlycon=eud,mmio,0x88e0000 console=tty0 loglevel=7` 作为 LoadOptions 传进去
   （EFI stub 会用 EFI 命令行覆盖 DTB 的 bootargs，两者内容一致，无副作用）。
3. 连 UEFI 菜单都起不来 → 第一嫌疑是 FD 7 → 20 MiB 的改动。回退：把
   `configs/sm8150.conf`、`Platform/Qualcomm/sm8150/sm8150.fdf` 三个尺寸改回
   `0x700000`，或先把内核精简（非必需驱动改模块）再重编。

**C. 起来之后**

- 用 `linux-port/refs/19781/`（Android 源）继续做：面板 SOFEF03F_M（806 行 init
  序列已存）、触控 S3706（`i2c17`/`i2c@c80000` 地址 0x20、IRQ TLMM 122、reset
  TLMM 54、2.8 V `pm8150_l17`、1.8 V 使能 `pm8150l_gpios 5`）、WCN3990、充电、
  传感器；
- 决定 30 MB `Image` 怎么管：建议放二进制子模块或用脚本生成，**不要提交进父仓**；
- 把 EDK2 提交 push 到 `hmhmdcy/edk2-realme-x2-pro`（网络不稳，通常要重试 2-3 次）。

### 18.4 不要重新推导的事实

- `PcdDefaultDtPref` 默认 **TRUE**（`EmbeddedPkg.dec`，本平台没有覆盖成 FALSE）
  → `DtPlatformDxe` 选 DT 分支，把 `FdtBlob/samurai` 通过
  `InstallConfigurationTable(gFdtTableGuid, …)` 装进 EFI 配置表；arm64 EFI stub
  从配置表取 DTB、从 `chosen/bootargs` 取命令行。
- 实机 `/memory` 三段：`0x80000000 + 0x3BB00000`、`0x1_80000000 + 0x1_00000000`、
  `0xC0000000 + 0xC0000000`；EDK2 `Mem8G` 表里 `0xC0300000 + 0x7FD00000` 是 `Conv`
  → FD 在 `0xCE000000` 扩到 20 MiB 仍在映射范围内。
- earlycon 框架给外设只映射 64 字节（一页）；**跨页寄存器必须自己 ioremap**。
- Android 设备树源码就在本机：下游克隆
  `E:\Realme X2 Pro移植主线Linux\sources\realme-downstream.git` →
  `arch/arm64/boot/dts/19781/`（`19781` = 本机 `oppo,dtsi_no`），关键文件已复制到
  `linux-port/refs/19781/`；可用性评估见 `linux-port/docs/ANDROID-DT-REFERENCE.md`。
  仓库本身无需联网即可 `git ls-tree` / `cat-file` 读取。
- 旧工程 3 处错误与 6 轮盲刷记录见 §18.1 第 3 点与核实报告。

### 18.5 本会话新增文档索引

| 文档 | 内容 |
|---|---|
| `linux-port/README.md` | Linux 主线进度总览 + 真机测试步骤 |
| `linux-port/docs/EDK2-KERNEL-EMBED.md` | 第 2 步改动清单、DTB 链路证据、风险 |
| `linux-port/docs/OLD-PROJECT-VERIFICATION.md` | 旧工程核实：可复现、3 处错误、轮次漏记 |
| `linux-port/docs/ANDROID-DT-REFERENCE.md` | Android 设备树可用性与映射表、坑 |
| `linux-port/scripts/*.sh` | 可复跑脚本（编 Image、装内核进固件、核实旧工程、抓实机真值） |
---

## 19. 内核命令行进了 boot option 的 LoadOptions（2026-10-07 14:4x）

### 19.0 TL;DR

内核命令行现在**同时**存在于两个地方：设备树的 `/chosen/bootargs`（原来就有）和
"Linux (mainline samurai)" 这个 boot option 的 **LoadOptions**（本次新增）。两者逐字
相同，正常路径下行为不变；设备树万一没带上 bootargs，内核仍然拿得到 `console=` 和
`earlycon=`，不会变成"选了启动项、黑屏、EUD 里 0 字节"。

新产物（**尚未上真机**——手机当前没有连接：adb 无设备，Windows 上也没有 VID_05C6）：

| 文件 | 大小 | sha256 |
|---|---|---|
| `E:\edk2-samurai-out\boot-samurai-linux-cmdline.img` | 15,185,920 | `b9fb2064e10f9fa8b77c04c5e5062ac1ba6362051a2390e1d4783b3c01900619` |
| `E:\edk2-samurai-out\SM8150_UEFI-samurai-linux-cmdline.fd` | 20,971,520 | `b02b55a1c8fd6bb6295fa559af99e3a3bdd22381ac8af0ac52c7d3861f3eb4ad` |

EDK2 提交 `c2a3697`，已 push 到 fork `hmhmdcy/edk2-realme-x2-pro` 的 master。

### 19.1 为什么这不是"顺手加固"，而是必修

`update_fdt()`（`drivers/firmware/efi/libstub/fdt.c`）里只有一句：

    if (cmdline_ptr != NULL && strlen(cmdline_ptr) > 0)
            fdt_setprop(fdt, node, "bootargs", cmdline_ptr, strlen(cmdline_ptr) + 1);

即 **EFI 命令行非空时，它整段替换设备树的 `/chosen/bootargs`**。而修改前
`PlatformRegisterFvBootOption()` 根本没有 OptionalData → LoadOptions 恒为空 →
内核 100% 依赖设备树的 bootargs。这就是单点故障：设备树这一环出任何问题（DTB 没装上、
`chosen` 被裁掉），`console=tty0` 和 `earlycon=eud,mmio,0x88e0000` 会一起消失，现象与
§18.3 B.2 描述的一模一样。现在这条备胎补上了，`console=` / `earlycon=` 不再只有
一个来源。

### 19.2 必须记住的坑：LoadOptions 是 UTF-16，不是 ASCII

libstub 的 `efi_convert_cmdline()` 把 LoadOptions 当 **UTF-16** 读（`efi_char16_t *`，
最后用 `snprintf(..., "%.*ls", ...)` 转成 ASCII）。按 ASCII 塞进去的后果是：

- 每两个 ASCII 字节被当成一个 UTF-16 码元 → 解出一串乱码；
- 这段乱码**非空**，于是按 19.1 的逻辑**覆盖**掉设备树里本来正确的 bootargs；
- 正好亲手制造出它要防的那个故障（黑屏、EUD 无输出）。

所以 `PlatformBm.c` 里用 `STATIC CHAR16 mSamuraiLinuxCmdLine[] = L"…"`，不是 `CHAR8`。
`verify-cmdline-firmware.py` 专门有一条检查："FVMAIN 里唯一的 ASCII 副本必须落在设备树
内部"——代码侧只允许出现 UTF-16。

### 19.3 改了什么

`Platform/RenegadePkg/Library/PlatformBootManagerLib/PlatformBm.c`：

- `PlatformRegisterFvBootOption()` 增加第 4 个参数 `CHAR16 *CommandLine OPTIONAL`；
  非空时 `OptionalDataSize = (StrLen(CommandLine) + 1) * sizeof(CHAR16)`，作为
  `EfiBootManagerInitializeLoadOption()` 的 OptionalData。BDS 会原样把它当
  `LoadOptions` 传给 `LoadImage()`，`EfiBootManagerInitializeLoadOption()` 自己会复制
  一份缓冲区，所以传静态数组是安全的；
- 新增 `STATIC CHAR16 mSamuraiLinuxCmdLine[]`，内容与设备树 bootargs 逐字相同：
  `earlycon=eud,mmio,0x88e0000 console=tty0 loglevel=7 ignore_loglevel panic=15`
  `clk_ignore_unused pd_ignore_unused regulator_ignore_unused`；
- 其余 4 个调用点（SimpleInit / Shell / UAS / SwitchSlots）补 `NULL`，行为不变。

### 19.4 离线验证（全部通过）

脚本 `linux-port/scripts/verify-cmdline-firmware.py`，直接读构建树，可重跑：

- FD = `0x1400000`（20 MiB），带 FV 头 `_FVH`；sha256 与改动前不同（`f6a0664d…` → `b02b55a1…`）；
- 未压缩 `FVMAIN.Fv` 里有 UTF-16 命令行（offset 16231800）和 UTF-16 的
  `Linux (mainline samurai)` 启动项描述；
- 全文唯一的 ASCII 命令行副本在 offset 32279672，落在 mainline 设备树内部
  （`d0 0d fe ed` @ 32279380，totalsize 94623）→ 代码侧确实只有 UTF-16；
- `realme,samurai` 在、`xiaomi,cepheus` 不在；
- `boot-samurai.img` 解出的 BootShim+FD 与构建目录的 FD **逐字节相同**；
- 尾部追加的是 `FdtBlob_compat/samurai.dtb` 本身（450,826 B，逐字节比对）。

### 19.5 本会话新增脚本

| 脚本 | 用途 |
|---|---|
| `linux-port/scripts/patch-bootmanager-cmdline.py` | 幂等地打 §19.3 那个 PlatformBm.c 改动 |
| `linux-port/scripts/build-cmdline-firmware.sh` | WSL 里重编 samurai 固件（后台 + 日志） |
| `linux-port/scripts/verify-cmdline-firmware.py` | §19.4 的全部检查 |
| `linux-port/scripts/archive-cmdline-firmware.sh` | 归档产物到 `E:\edk2-samurai-out\` 并提交 |

### 19.6 下一步：仍然只有真机验证

手机接上后刷的是 **`boot-samurai-linux-cmdline.img`**（不是 §18 里的
`boot-samurai-linux.img`），其余步骤与 §18.3 A 完全相同：

```powershell
# 1) 刷入并重启，手机会先起 UEFI
fastboot flash boot E:\edk2-samurai-out\boot-samurai-linux-cmdline.img
fastboot reboot

# 2) 重启后约 3.5 s 出现 9501 控制设备；这步必须赶在内核打第一行之前
E:\eud-host\eudtool.exe com-up
E:\eud-host\comlog.exe COM14 600 E:\eud-host\samurai-linux.log

# 3) 屏幕出现 UEFI 菜单后：音量键选 "Linux (mainline samurai)"，电源键确认
#    或者用 §19.8 的 flash-and-capture-linux.ps1，它自己处理这个时隙
```

本轮之所以没做：手机没有连接（`adb devices` 为空，Windows 上没有 `VID_05C6`）。
`boot-samurai-linux.img`（`0d1ec546…`）保持原样未删，两个都能刷，新的是超集。

### 19.7 没做但该记一笔：linux-port 还没进版本库

`E:\RealmeX2Pro edk2\linux-port\` 里的内核补丁、设备树源、脚本和文档目前**只在
Windows 上**，本地没有 git 仓库；WSL 的 `~/x2pro-linux/linux` 也没有 remote（只有
两个本地提交 + `~/x2pro-linux/patches/` 里的 format-patch 产物）。EDK2 仓库这边只有
`HANDOVER-NEXT.md` / `README.md` 里的引用，`linux-port/...` 这个路径在没有那份工作区
的机器上是断的。

建议（下一次做）：把 `linux-port/{README.md,docs,patches,dts,scripts,refs}` 这几个小
目录（合计约 300 KB，不含 30 MB 的 `Image` 和 `artifacts/`）镜像进
`Platform/Realme/sm8150/linux-port/`，保持引用路径可解。本轮没动，因为它会改变仓库
结构，先留给人确认。


### 19.8 真机测试脚本（写好但没跑过）

`E:\eud-host\flash-and-capture-linux.ps1`：刷 `boot-samurai-linux-cmdline.img` →
轮询 `VID_05C6&PID_9501` → 一出现就 `eudtool.exe com-up` → 等 9505 的 `(COMxx)`
枚举出来 → 用这个端口号跑 `comlog.exe`，最后自动打印日志开头与
`Booting Linux on physical CPU` 之类的标记；找不到设备时给出明确的分支提示。

它解决的正是 §12 里那个"时隙"：EUD 只在固件走到 BDS 之后才出现，而 comlog 必须在
内核打第一行之前就已经在跑，靠人手掐表很容易又拿到 0 字节。

**本轮只做了冒烟测试**（没有手机，走的是 "No fastboot device" 那条分支：报错信息、
镜像哈希都正常）。第一次真机跑请盯着屏幕，别盲信脚本；手动版本仍是 §18.3 A / §19.6。

---

## 20. 主线 Linux 真机启动成功：内核改放 FAT 分区（2026-10-07 16:0x）

### 20.0 TL;DR

**这台 realme X2 Pro 第一次真正跑起了主线 Linux。** EUD 上抓到了

```
Linux version ...  Machine model: Realme ...
earlycon ... 0x88e0000
efi: SMBIOS=... MEM...
OF: reserved memory: memory@85700000 ... 0xb7e00000 (ramoops) ... cma ...
PSCI v1.1 ... Zone ... Detected CPU ... init: SLUB ... RCU ... GIC ... IPIs
```

关键改变：**内核不再放进固件卷**，而是放在 `logdump` 分区（64 MiB，FAT16）；固件在打开 EUD 之后直接启动它。

### 20.1 为什么必须搬出来：两个硬根因

1. **FFS 文件装不下 30 MB 内核。** `EFI_FFS_FILE_HEADER.Size` 只有 3 字节（最大 16 MiB），`GenFfs` 把
   `0x1CB8A62` 截成了 `0x00CB8A62`——FVMAIN 里的内核文件结构是坏的，PE32 section 头同理。
2. **未压缩 FVMAIN 撑爆 PrePi 内存池。** 加了内核后 FVMAIN 从约 32 MB 涨到 **62.5 MB**，而
   `PcdUefiMemPoolSize=0x04230000`（66.2 MiB），`PrePiLib` 的 `InternalAllocatePages` 是**从池顶往下分配**的，
   解压 FVMAIN 占掉 94%，DXE 核加载失败。RELEASE 构建里 `ASSERT` 是空操作，于是**静默挂死在
   `LoadDxeCoreFromFv In`**（屏幕最后一行）。
   → FD 从 20 MiB 改回 7 MiB、FVMAIN 回到 31 MB 后，PEI/DXE/BDS 全部正常。

### 20.2 内核放在哪：`logdump`

这台机的分区表（从 9008 包的 GPT 和实机 live GPT 双向核对，两者一致）：

| 分区 | 索引 | 起始 LBA | 大小 | 类型 GUID | unique GUID |
|---|---|---|---|---|---|
| `modem` | 4 | 0xC86 | 0x10000 (256 MiB) | 标准高通 | 934CA8ED-C69D-9755-BA9A-6C9411CDC27F |
| `logfs` | 30 | 0x31570 | 0x800 (8 MiB) | BC0330EB-... | 09969439-057F-289A-5729-CE302330C1CA |
| **`logdump`** | 32 | 0x31F70 | 0x4000 (**64 MiB**) | 5AF80809-AABB-4943-9168-CDFC38742598 | 6458791A-5CBF-649C-B221-7A804460E308 |

选它的安全依据（全部逐项验证过）：

- **内容全是 0**（抽 0 / 4 KiB / 32 MiB 三处），没有任何数据可丢；
- 工厂 9008 包 `rawprogram*.xml` 里 `logdump` **没有 filename**，`patch*.xml` 只改 GPT 里 `userdata` 的
  last LBA，**出厂流程根本不写它**；
- 实机 `fstab` / SELinux 里 `logdump` **只作为块设备标签**出现，ROM 既不挂载也不格式化它；
- LineageOS 在 Nokia msm8998 / 小米 beryllium / 一加 sdm845-common 上直接把 `logdump` 改成了 `/metadata`，
  提交信息明说"生产机上该分区无用"——**复用有先例**；
- **不动 GPT**：只写分区内容，名字/大小/类型 GUID/偏移全不变；
- 上机前做了完整备份：`E:\edk2-samurai-out\backup\{logdump_stock.bin (64 MiB, md5 E97EA65C…),
  gpt_lun0_live.bin, gpt_lun4_live.bin}`。

格式化与写入（安卓 root 下）：

```sh
newfs_msdos -F 16 -c 1 -S 4096 -L KERNEL /dev/block/by-name/logdump   # 必须 4096，UFS 逻辑扇区是 4K
mount -t vfat -o rw /dev/block/by-name/logdump /mnt/kernel
cp /sdcard/Image /mnt/kernel/Image            # 30,116,352 B, sha256 3d5665ab…
cp /sdcard/samurai.dtb /mnt/kernel/samurai.dtb
umount /mnt/kernel
```

文件名用 `Image` / `samurai.dtb`（都是 8.3 兼容），不依赖 VFAT 长文件名支持。

### 20.3 固件怎么找到并启动它

`PlatformBm.c`（EDK2 提交见下）：

- `SamuraiRegisterKernelBootOption()` 枚举**所有** `EFI_SIMPLE_FILE_SYSTEM_PROTOCOL`，找根目录下的
  `\Image`；**必须校验文件内容以 `MZ` 开头**（PE 签名）才认，否则跳过；
- 用 `FileDevicePath()` 生成设备路径，`EfiBootManagerInitializeLoadOption()` 注册成
  `Linux (mainline samurai)`，OptionalData 就是内核命令行（UTF-16）；
- **注册完立刻 `EfiBootManagerBoot(&NewOption)`**，放在 `PlatformBootManagerAfterConsole()` 的最后、
  EUD 打开之后，绕开整个 boot order。
- `samurai.fdf.inc` 里删掉 `INF …SamuraiLinuxKernel.inf`；`LinuxKernel/SamuraiLinuxKernel.inf` 顶部加了
  "DO NOT ADD THIS BACK" 警告。

两个踩到的坑（都已修）：

1. **`modem` 分区被固件的 FAT 驱动误判成 FAT 卷**，而且"里面"也有个 `\Image`。只检查"文件能打开"就会选它，
   BDS 去那里读 PE 失败 → `BdsDxe` 报致命错误（`ERROR: C40000002… I0 6D33944A-…`，`6D33944A` 就是
   `MdeModulePkg/Universal/BdsDxe/BdsDxe.inf`）→ 复位。**必须校验 `MZ`。**
2. **SimpleInit 会复位**：这台机的 boot manager 是 SimpleInit，它的内置条目 `Continue Boot` 是
   `BOOT_EXIT`（`boot.c:40`），也就是"退出 SimpleInit 让固件继续"；之后 BDS 继续走却撞上上面那个坏设备路径，
   于是每 ~10 秒复位一轮。所以固件改成**直接启动内核**，不再把控制权交给它。

### 20.4 日志通道：EUD

- 固件在 BDS 开 EUD（`SAMURAI_ENABLE_EUD`），主机 `E:\eud-host\eudtool.exe com-up` 让 9505 变成
  `COM14`，再 `comlog.exe COM14 600 <log>` 录制。
- **`earlycon` 是 boot console，真 console 注册后会被注销**，所以最初只录到 1.2 秒的日志就断了。
  cmdline 里加 **`keep_bootcon`** 后 boot console 不再注销，EUD 就能拿到整个启动过程的日志
  （代价：EUD 是分小帧轮询发送，日志多时启动会变慢）。
- comlog 的帧重组不完美，日志会花；真正干净的做法是把 `eud_earlycon.c` 升级成**真正的 console 驱动**
  （注册 `struct console`，`console=eud`），下游 4.14 的 `drivers/soc/qcom/eud.c`（`ttyEUD`）就是这套思路。
- 兜底：DTB 里有 `ramoops@0xb7e00000`（4 MB），内核 panic 后进安卓
  `su -c cat /sys/fs/pstore/console-ramoops` 可以读到上次的日志。

### 20.5 产物与脚本

| 文件 | 说明 |
|---|---|
| `E:\edk2-samurai-out\boot-samurai-linux-console.img` | 加 `keep_bootcon`，sha256 `e461a8a2…`（本轮最新） |
| `E:\edk2-samurai-out\boot-samurai-linux-mz.img` | 首次真机跑起内核的那版，sha256 `aed239e3…` |
| `E:\edk2-samurai-out\boot-samurai-linux-fs.img` | 只注册启动项、不自动启动，sha256 `35fd18ee…` |
| `linux-port\scripts\move-kernel-out-of-fv.py` | 把内核移出 FV + 改 FD 尺寸 |
| `linux-port\scripts\boot-kernel-directly.py` | 在 AfterConsole 末尾直接启动内核 |
| `linux-port\scripts\require-pe-magic.py` | 加 `MZ` 校验，修掉 modem 误选 |
| `linux-port\scripts\verify-kernel-on-fs.py` | 离线校验（扫描器字符串、内核已移出、FD 尺寸） |

### 20.6 下一步

1. 读完整日志（`E:\eud-host\samurai-console.log`），看内核跑到哪里、卡在什么驱动；
2. 把 `eud_earlycon.c` 升级成真正的 console 驱动（`console=eud`），日志就能在 cmdline 里切换、不必每次重刷固件；
3. 然后按 §18.3 C 继续：面板 SOFEF03F_M、触控 S3706、WCN3990、充电、传感器。
---

## 21. EUD 日志乱码的真因：内核侧 FIFO 溢出，不是主机重组（2026-10-07 16:0x）

### 21.1 现象

`keep_bootcon` 之后 EUD 能拿到整个启动过程的日志，但文字是花的，像这样：

```
[15:56:23.808]  32-bix51df8ux ver+ (cy1inux-gubuntus for .00000 lack odel: [    0e ]---ic_iorules l.00000ID: 0 tainte[    0Realme[    0[    0[    0prot+00] sp [
```

一开始怀疑是主机侧 comlog 的帧重组有问题。**查过之后：主机侧确实该修，但乱码的真因在内核侧。**

### 21.2 真因：一帧往 TX FIFO 里塞 8 个值，而 FIFO 只有约 7 个字节深

`drivers/tty/serial/eud_earlycon.c` 的 `eud_write()`：

```c
#define EUD_COM_CHUNK 6u
...
writel_relaxed(EUD_COM_UART_ID, base + EUD_REG_COM_TX_ID);   /* 值 1 */
writel_relaxed(chunk,             base + EUD_REG_COM_TX_LEN); /* 值 2 */
for (i = 0; i < 6; i++)
        writel_relaxed(s[i],      base + EUD_REG_COM_TX_DAT); /* 值 3..8 */
eud_wait_tx(base);                                            /* 只在整帧写完后才等 */
```

每个寄存器写 = 主机侧看到的 1 个字节（`0x90`, `LEN`, 数据…），所以**一帧共 8 个字节**。
而这块硬件的 TX FIFO 只有约 7 个字节深——交接文档 §2 早就记过："A whole string written in one go is
truncated by the TX FIFO after about seven payload bytes."

**后果**：每帧最后 1~2 个字节被硬件丢掉 → 下一帧的 `0x90` 被当成上一帧的数据 →
**帧边界从这一刻起永久错位**，之后所有内容都是错位拼接出来的。
**主机侧再怎么重组也救不回来**，因为边界信息已经在硬件里丢了。

（这也是为什么 EDK2 那条路径当初要用"6 字节帧 + 200 µs/字节 + 2 ms/帧"的节奏——它靠**延时**而不是流控来避免溢出。内核 earlycon 里没有校准好的定时器，不能用 `udelay`，所以必须改成**逐字节流控**。）

### 21.3 内核侧修法（下次重编内核时一起改）

两个改动：

1. **每个寄存器写之前都等 TX ready**，而不是整帧写完才等；
2. **每帧缩到 4 个数据字节**（ID + LEN + 4 = 6 个值），稳在 FIFO 深度以内。

```c
#define EUD_COM_CHUNK 4u        /* ID + LEN + 4 = 6 writes, under the FIFO depth */

static void eud_putreg(void __iomem *base, unsigned int off, unsigned int v)
{
        eud_wait_tx(base);      /* INT_STATUS_1 BIT(1), same bit as the vendor eud_tx_empty */
        writel_relaxed(v, base + off);
}

static void eud_write(struct console *con, const char *s, unsigned int n)
{
        ...
        while (n) {
                unsigned int chunk = min(n, EUD_COM_CHUNK);

                eud_putreg(base, EUD_REG_COM_TX_ID, EUD_COM_UART_ID);
                eud_putreg(base, EUD_REG_COM_TX_LEN, chunk);
                for (i = 0; i < chunk; i++)
                        eud_putreg(base, EUD_REG_COM_TX_DAT, s[i]);

                s += chunk;
                n -= chunk;
        }
}
```

`eud_wait_tx()` 里有 `EUD_TX_POLL_LIMIT` 上限，所以即使状态位读错也不会挂死启动。

### 21.4 主机侧：`comlog2`

老 `comlog.exe`（`comlog.cpp`）除了不能处理错位，本身还有几个问题，所以写了个 `comlog2.cpp`：

| 问题 | comlog2 的做法 |
|---|---|
| 启动时往串口写了 10 个字节（`WriteFile(p1/p2)`），污染流 | 只读，不写 |
| 帧边界错位后无法恢复 | `LEN == 0 \|\| LEN > 64` 即判定错位，立刻重新扫 `0x90`，并统计次数 |
| 看不到真实字节流 | **额外把原始字节流完整写成 `<log>.raw`** |
| 每 50 ms 才读一次，容易丢 | 连续读（`ReadIntervalTimeout = MAXDWORD`） |

编译（**必须在 MSYS2 环境里跑**，直接调 `g++.exe` 会因为它找不到 `cc1plus` 而**静默退出 1**）：

```sh
# 方式一
E:\msys64\msys2_shell.cmd -ucrt64 -defterm -no-start -here -c "cd /e/eud-host && g++ -O2 -o comlog2.exe comlog2.cpp"
# 方式二：开 MSYS2 UCRT64 终端
cd /e/eud-host && g++ -O2 -o comlog2.exe comlog2.cpp
```

用法与老的一样：

```
comlog2.exe COM14 600 E:\eud-host\out.log      # 同时写出 out.log.raw
```

### 21.5 怎么验证

1. 用 comlog2 抓一次，检查 `out.log.raw`：统计"数据字节数少于 LEN 的帧"有多少——这个数字就是 FIFO 溢出的频率；
2. 内核侧按 §21.3 改完再抓一次：`.raw` 里应该每帧完整、`0x90` 只出现在帧首，乱码消失。

### 21.6 后续（顺带记下）

- 把 `eud_earlycon.c` 升级成**真正的 console 驱动**（注册 `struct console`，支持 `console=eud`），
  这样日志通道不再依赖 `keep_bootcon`，也不会每次为日志参数重刷固件；下游 4.14 的
  `drivers/soc/qcom/eud.c`（`ttyEUD`）是参考实现。
- 上述内核改动应走正式的 `format-patch`，放进 `linux-port/patches/`（当前内核树在
  `~/x2pro-linux/linux`，已有两个提交：`e4858b30a` earlycon、`0450fd895` DTS）。
---

## 22. 内核侧进入 GitHub：从上游 fork（2026-10-07 16:2x）

### 22.0 TL;DR

内核源码的来源是**官方 tarball**（不是 git clone），本地只有"整棵树一次性导入"的 squashed baseline + 我们两个补丁，
**没有任何上游对象**，所以本地树不能直接推（会变成 335 MB 的全新历史）。

正解是**从上游 fork**：`torvalds/linux` → `hmhmdcy/linux`。因为 GitHub 的 fork 网络共享对象，
把两个补丁落到上游 tag 上之后，push 只需要传增量（几百 KB）。

上游对齐情况（已核实）：

```
$ git ls-remote --tags https://github.com/torvalds/linux.git 'v7.3-rc6*'
4eeccbed21e50c19f97be9d325511f3de6343f2d        refs/tags/v7.3-rc6
a90ee4305c4a5df72c11b31dacfdc76e00fcf78a        refs/tags/v7.3-rc6^{}   ← 与 baseline 记录一致 ✓
```

### 22.1 内核侧的现状

| 位置 | 内容 |
|---|---|
| `~/x2pro-linux/linux-7.3-rc6.tar.gz` | 源码 tarball（源头） |
| `~/x2pro-linux/linux` | 解包后 `git init`；3 个提交；**无 remote** |
| `b0630f810` | `baseline: Linux v7.3-rc6 pristine (upstream a90ee4305c4a)`（squashed 导入） |
| `e4858b30a` | `tty: serial: add Qualcomm EUD COM early console` |
| `0450fd895` | `arm64: dts: qcom: add realme samurai (X2 Pro) bring-up description` |
| `.git` | 346 MB（单 pack 335 MiB，101,683 objects） |
| `~/x2pro-linux/patches/` | 上面两个提交的 `format-patch` 产物 |
| EDK2 仓库 `linux-port/` | 2026-10-07 镜像（提交 `42a3923`，656 KB / 83 文件） |

### 22.2 新的上游工作区

```
~/x2pro-linux/upstream/          新建（不要动 ~/x2pro-linux/linux）
  origin → https://github.com/hmhmdcy/linux.git      （推送目标，fork）
  up     → https://github.com/torvalds/linux.git     （拉取源，上游）
  正在 git fetch --depth=1 up refs/tags/v7.3-rc6     （约 1.2 GB）
```

**目标结构**：`samurai-bringup` 分支 = 真正的 `v7.3-rc6` + 我们的两个提交，
这样 `git log` / `git blame` / `git format-patch` / 社区复现全都正常。

### 22.3 后续命令（fetch 跑完后执行）

```bash
cd ~/x2pro-linux/upstream
git rev-parse refs/tags/v7.3-rc6          # 应为 a90ee4305c4a5df72c11b31dacfdc76e00fcf78a

git checkout -b samurai-bringup refs/tags/v7.3-rc6
git am "/mnt/e/RealmeX2Pro edk2/linux-port/patches/0001-tty-serial-add-Qualcomm-EUD-COM-early-console.patch"
git am "/mnt/e/RealmeX2Pro edk2/linux-port/patches/0002-arm64-dts-qcom-add-realme-samurai-X2-Pro-bring-up-description.patch"
git log --oneline -3

git push -u origin samurai-bringup        # 增量几百 KB
timeout 60 git ls-remote origin samurai-bringup
```

`git am` 能干净应用的原因是：本地 baseline 的 tree 与上游 tag 的 tree **内容完全一致**（只差一个父提交）。

### 22.4 本轮新增脚本（`linux-port/scripts/`）

| 脚本 | 用途 | 是否幂等 |
|---|---|---|
| `mirror-linux-port.sh` | 把 `E:\RealmeX2Pro edk2\linux-port\{README,docs,dts,patches,scripts,refs,initramfs,eud_earlycon.c}` 镜像进 EDK2 仓库并提交推送 | 是 |
| `fork-linux.sh` | 查上游 tag / commit，用 GitHub API 建 fork，等 fork 就绪 | 是 |
| `fetch-upstream-bg.sh` | 配置 `origin`(fork) + `up`(上游) 两个远端，后台 `--depth=1` 拉 v7.3-rc6 | 是（会重拉） |

### 22.5 已知的坑

1. **fork 不广播上游 tag**：对 `hmhmdcy/linux` 执行 `git fetch refs/tags/v7.3-rc6` 会报
   `couldn't find remote ref`，**必须从 `torvalds/linux` 拉**（对象同一个网络，不影响后续推送到 fork）。
2. **`git fetch` 不支持断点续传**：中途断了要重头拉 1.2 GB，所以 WSL 必须一直开着直到拉完。
   被中断就直接重跑 `fetch-upstream-bg.sh`。
3. **GitHub 代理时通时断**：`http.proxy = http://127.0.0.1:7890`，会出现
   `Failed to connect to github.com port 443 via 127.0.0.1` / `Connection reset by peer`；
   所有网络脚本都要写成可重跑、带重试的形式（`push-fork.sh` 就是这么做的）。
4. **浅克隆 push 的风险**：从 `--depth=1` 的克隆 push 到自己的 fork 通常可以（浅边界提交在 fork 网络里已存在）；
   若报 `shallow update not allowed`，改成不带 `--depth`、只带 `--filter=blob:none` 重新拉。
5. **脚本自身的 bug（已修）**：早期版本只在 `.git` 不存在时才 `git remote add`，导致
   `.git` 已存在时 `git fetch up ...` 报"仓库不存在"。现在改成 `git remote get-url ... || git remote add ...`。

### 22.6 安全：那个 PAT 必须轮换

调试时 `~/.git-credentials` 里的 **classic PAT 被明文打印到了会话记录里**（135 字节的文件里其实有**两条** GitHub 凭据，
一条 `user:token@`、一条裸 `token@`）。它带 `repo` 权限的话等于账号下所有仓库的完整读写权。

**待办：GitHub → Settings → Developer settings → PAT → Revoke 旧 token，新建只勾 `public_repo` 的即可，
然后直接写进 `~/.git-credentials`（不要贴到任何对话里）。**
---

## 23. 内核侧上 GitHub：完成 fetch 与分支，卡在 push（2026-10-07 16:3x）

### 23.0 TL;DR

**最重要的一条经验：WSL 里访问 GitHub 必须绕过 Windows 那个代理。**

```
$ git -c http.proxy= -c https.proxy= ls-remote up HEAD      # 直连
602042bf29f6efde39cfb5fdd9289bf4854bc0c5        HEAD        rc=0   ✓

$ git ls-remote up HEAD                                      # 走代理(127.0.0.1:7890)
fatal: unable to access 'https://github.com/torvalds/linux.git/':
       GnuTLS, handshake failed: The TLS connection was non-properly terminated.   ✗
```

关掉代理后，**1.2 GB 的 v7.3-rc6 只用了 39 秒**就拉完（之前走代理半小时都下不完，每次都在 20~30 秒被 reset 掉）：

```
$ git config --local http.proxy "" && git config --local https.proxy ""
$ git fetch --depth=1 up refs/tags/v7.3-rc6:refs/tags/v7.3-rc6
From https://github.com/torvalds/linux
 * [new tag]             v7.3-rc6   -> v7.3-rc6        (16:28:57 → 16:29:36)
```

**结论：以后 WSL 里所有 GitHub 操作（clone/fetch/push）都在仓库里设 `http.proxy ""`、`https.proxy ""`。**

### 23.1 已完成

`~/x2pro-linux/upstream`（fork 的工作区）：

```
a89e94cd5  arm64: dts: qcom: add realme samurai (X2 Pro) bring-up description
9c9adca57  tty: serial: add Qualcomm EUD COM early console
a90ee4305  Linux 7.3-rc6        (grafted, tag: v7.3-rc6)   ← 真正的上游提交
```

改动文件核对无误：

| 提交 | 文件 |
|---|---|
| `9c9adca57` | `drivers/tty/serial/Kconfig`、`Makefile`、`eud_earlycon.c`（新增 100 行） |
| `a89e94cd5` | `Documentation/devicetree/bindings/arm/qcom.yaml`、`vendor-prefixes.yaml`、`arch/arm64/boot/dts/qcom/Makefile`、`sm8150-samurai.dts`（293 行）、`eud_earlycon.c`（+27/-） |

**内核侧从此是标准的「upstream + 2 个提交」结构**，`git log` / `git blame` / `git format-patch` 全部正常。

### 23.2 还没做：`git push`

`git push -u origin samurai-bringup` 输出为空，`git ls-remote origin samurai-bringup` 也查不到
→ **分支还没上到 GitHub**。没有足够时间查，最可能的原因是：

- 这是 `--depth=1` 的浅克隆（`git log` 里标着 `(grafted)`）。GitHub 对浅仓库推上来的分支有两种反应：
  报 `shallow update not allowed`，或者把整棵树当增量传（1 GB 级，被 150 秒超时掐掉，所以什么都没打印）。

**下一条命令（给足时间，看它到底报什么）：**

```bash
cd /home/cy122/x2pro-linux/upstream
timeout 600 git push -u origin samurai-bringup
timeout 60  git ls-remote origin samurai-bringup
```

对照处理：

| 报什么 | 怎么办 |
|---|---|
| `shallow update not allowed` | `git fetch --unshallow up`（约 5 GB；直连很快）后重推 |
| 一直传、很慢 | 让它传完（fork 网络里已有对象，理论只该传几百 KB） |
| TLS / 连接错 | 确认 `git config --local http.proxy ""` 还在（§23.0） |
| `empty ident name` | `git config user.name cy122; git config user.email cy122@localhost`（本轮踩过，`git am` 前必须设） |

成功标志：`git ls-remote origin samurai-bringup` 返回 `a89e94cd5…refs/heads/samurai-bringup`。

### 23.3 本轮确认的几个事实（别重复推导）

1. **上游对齐**：`v7.3-rc6` tag 对象 `4eeccbed21e50c19f97be9d325511f3de6343f2d`，peeled commit
   `a90ee4305c4a5df72c11b31dacfdc76e00fcf78a`（作者/提交者 Linus Torvalds
   `<torvalds@linux-foundation.org>`，2026-10-04T20:45:25Z，message 只有一行 `Linux 7.3-rc6`），
   parent `7704c4c5bb127673b4f0ead839919db573559e38`。
2. **我们本地 baseline 的 tree 与上游不同**：本地 `b66cfc195852b68d92a99eb9db0b947b429e275f`，
   上游 `18cdff87967594810218424b52c69529757a6a78`（大概是解包 tarball 时丢了可执行位之类）。
   → 所以"用 GitHub API 拿元数据、本地合成那个上游 commit"这条捷径**走不通**；只能用 `git am` 打到真提交上。
3. **fork 不广播上游 tag**：对 `hmhmdcy/linux` 执行 `git fetch refs/tags/v7.3-rc6` 会报
   `couldn't find remote ref`，**必须从 `torvalds/linux` 拉**（对象同一个网络，不影响推回 fork）。
4. **`git fetch` 不能断点续传**：断了要从头来；所以之前"后台 + 多次重试"的方案注定失败，
   而"绕过代理直连"能在一次 39 秒内解决。

### 23.4 本轮新增脚本（`linux-port/scripts/`）

| 脚本 | 用途 |
|---|---|
| `probe-upstream.sh` | 对比"直连 vs 代理"连通性；从 GitHub API 取上游 commit 元数据；对比本地/上游 tree |
| `fetch-noproxy.sh` | 仓库级关闭代理 + `--depth=1` 拉 v7.3-rc6（本轮成功的那条） |
| `finish-upstream.sh` | 设 git 身份 + `git am` 两个补丁 + push + 远端确认 |

### 23.5 待办清单

1. `git push -u origin samurai-bringup`（§23.2）；
2. 成功后把 `samurai-bringup` 链接补进 §22/本节；
3. **Revoke 那个泄露的 classic PAT**，新建只勾 `public_repo` 的，直接写进 `~/.git-credentials`（别贴到对话里）；
4. 回到主线任务：§21 的内核 EUD 改动（逐字节流控 + chunk 4）→ 然后 §20.6 的面板/触控。

---

## 24. `samurai-bringup` 已推上 GitHub（2026-10-07 16:46）

### 24.0 TL;DR

§23.5 第 1 条已完成，不用再试：

```
$ cd ~/x2pro-linux/upstream
$ timeout 1800 git push -u origin samurai-bringup
remote: Create a pull request for 'samurai-bringup' on GitHub by visiting:
remote:      https://github.com/hmhmdcy/linux/pull/new/samurai-bringup
To https://github.com/hmhmdcy/linux.git
 * [new branch]          samurai-bringup -> samurai-bringup
branch 'samurai-bringup' set up to track 'origin/samurai-bringup'.
PUSH_RC=0  end 16:46:06            # start 16:41:42，约 4 分 24 秒

$ git ls-remote origin samurai-bringup
a89e94cd558ca171b35a622087f8998839925eee        refs/heads/samurai-bringup   ✓
```

- 分支：https://github.com/hmhmdcy/linux/tree/samurai-bringup
- 开 PR：https://github.com/hmhmdcy/linux/pull/new/samurai-bringup

### 24.1 纠正 §23.2 的两条猜测（都是实测结果）

| §23.2 的猜测 | 实测 |
|---|---|
| 浅克隆会被拒：`shallow update not allowed` | **没有**。GitHub 接受 `--depth=1` 仓库推上来的新分支 |
| 增量只有几百 KB（fork 网络里已有对象） | **不是**。整份快照 pack 都传了（本地 285 MiB），约 4.5 分钟 |

原因：**fork 不广告上游 tag**（§22.5 第 1 条），协商时对端只报自己的 master/其他分支，
Git 看不出服务器已经有 `a90ee4305`，于是把 `--depth=1` 的那一份快照整包上传。

> 教训：**"从上游 fork 就能免费共享对象"只在被广告的引用能到达 base commit 时才成立。**
> 下次要传内核分支，先 `git ls-remote origin | grep -c refs/tags` 看一眼 tag 有没有被广告。

### 24.2 两个操作坑（这次踩到并解决）

1. **`nohup … &` 起的后台 push 活不过 WSL distro 回收。**
   第一次 16:39 起的后台 push，16:41 再去看时 distro 已被回收：进程没了、
   `/tmp/push.log` 整个消失，只在 `.git/objects/pack/` 留下 `tmp_pack_*` 垃圾。
   正确做法是**让一个前台 `wsl.exe` 附着到 push 结束**（PowerShell）：

   ```powershell
   Start-Process wsl.exe `
     -ArgumentList '--','bash','/mnt/e/edk2-samurai-out/push-branch.sh' `
     -RedirectStandardOutput 'E:\edk2-samurai-out\push.log' `
     -RedirectStandardError  'E:\edk2-samurai-out\push.err' -WindowStyle Hidden
   ```

   脚本本体已收进 `scripts/push-branch.sh`（关代理 → push → `ls-remote` 验证，可重复跑）。
2. 残留的 `tmp_pack_*` 不影响 push，但会让 `git count-objects` 报 `garbage found`；
   随手 `rm -f .git/objects/pack/tmp_pack_*` 即可。

### 24.3 待办清单（§23.5 更新后）

| # | 事项 | 状态 |
|---|---|---|
| 1 | `git push -u origin samurai-bringup` | ✅ 完成，`a89e94cd5`（2026-10-07 16:46） |
| 2 | 把分支链接补进交接文档 | ✅ 本节 §24.0 |
| 3 | **Revoke 泄露的 classic PAT**，新建只勾 `public_repo` 的、直接写进 `~/.git-credentials` | ⬜ 需要人在 GitHub 网页上操作 |
| 4 | §21 的内核 EUD 改动（逐字节流控 + `EUD_COM_CHUNK 4`）→ 重编内核 → 真机验证 | ⬜ 下一件主线任务 |
| 5 | §20.6：面板 SOFEF03F_M、触控 S3706、WCN3990、充电、传感器 | ⬜ 主线继续 |

---

## 25. EUD 真 console 落地 + 固件 cmdline/DTB 更新，等待真机验证（2026-10-07 18:1x）

### 25.0 产物（都已离线校验）

| 文件 | 大小 | sha256 | 用途 |
|---|---|---|---|
| `E:\edk2-samurai-out\boot-samurai-eudconsole.img` | 6,682,624 | `ea4a8f4e…` | 刷 boot 分区 |
| `E:\edk2-samurai-out\Image-rmx1931-samurai` | 30,116,352 | `fb1a6d6a…` | 放进 logdump FAT 的 `\Image` |
| `E:\edk2-samurai-out\samurai.dtb` | 94,739 | `68001bab…` | 可选，`\samurai.dtb` |
| 回滚-固件 | 6,680,576 | — | `boot-samurai-linux-console.img`（16:01，带 keep_bootcon） |
| 回滚-安卓 | 100,663,296 | `dfe18875…` | `backup\boot_stock_RMX1931.img` |

### 25.1 这次改了什么

1. **新驱动** `drivers/tty/serial/eud.c`（console-only，commit `e42788eaf`）：nbcon 三件套
   （`write_atomic` 有界会丢、`write_thread` 可睡眠、`device_lock` 用 `uart_port_lock_irqsave`）、
   帧长 4（6 entries ≤ FIFO ~7）、`dropped_bytes` sysfs。配套 `SERIAL_EUD_CONSOLE` Kconfig/Makefile、
   DTS 节点 `serial@88e0000`（`qcom,sm8150-eud-com`，2/2 cells）。
2. **earlycon 修 bug**：`EUD_COM_CHUNK` `6u` → `4u`，注释改写。
   §21.3 原来建议的「每个寄存器写之前都等 TX ready」是过度设计：`INT_STATUS_1` BIT(1) 是
   `eud_tx_empty`（整条 FIFO 排空），逐寄存器等会让每字节都等一次完整排空、慢 6 倍；
   真正的修法是**帧长 ≤ 深度**且**只在空闲时开始一帧、绝不中途停**。
3. **固件 cmdline**（`PlatformBm.c:62`）：加 `console=eud`（**放最后** = preferred → `CON_CONSDEV` →
   自动不重复回放 `CON_PRINTBUFFER`、自动注销 earlycon）、删掉 `keep_bootcon`。
4. **固件 FV 换新 DTB**：`FdtBlob/samurai/sm8150-realme-samurai.dtb` = 带 eud 节点的新版。

### 25.2 离线校验（在未压缩的 FVMAIN.Fv 上，不是 .fd）

```
cmdline: earlycon=eud,mmio,0x88e0000 console=tty0 console=eud loglevel=7 ignore_loglevel
         panic=15 clk_ignore_unused pd_ignore_unused regulator_ignore_unused
keep_bootcon 出现 0 次；console=eud 1 次；DTB 里 sm8150-eud-com 1 次
```

**坑（§19.2/§5 已记，这次又踩）**：`SM8150_UEFI.fd` 是 FVMAIN_COMPACT 压缩的，且 LoadOptions 是
**UTF-16**，所以对 .fd 直接 `grep console=eud`、`grep keep_bootcon` **一律假阴性（0）**。
要在 `workspace/Build/samurai/RELEASE_GCC5/FV/FVMAIN.Fv` 上用 `strings -el`（UTF-16LE）查。

### 25.3 刷机顺序（有坑，别搞反）

§20.3 的固件是**注册完立刻启动** FAT 上的 `\Image`，所以：

1. fastboot 刷 **stock boot** → 进安卓；
2. 安卓 root 下 `mount /dev/block/by-name/logdump`，把新 `Image`/`samurai.dtb` 拷进去；
3. fastboot 刷 `boot-samurai-eudconsole.img`；
4. PC 侧 `eudtool com-up` + `comlog2 COM14 600 <log>`。

反了（先刷新固件）会启动**旧内核**，白刷一轮。EUD 开着时 USB 被占、fastboot 消失 → 长按电源 15 s 彻底断电。

### 25.4 验收判据（很明确）

1. 日志出现 `console [eud0] enabled` → 真 console 注册成功；
2. 日志**延续到内核后期**（不再 ~1.2 s 处断掉）→ 真 console 接管（这次特意删了 `keep_bootcon`，
   没注册成功就会早期截断，一眼可辨）；
3. `.raw` 里「数据字节数少于 LEN 的帧」= 0 → 帧边界不再错乱。

### 25.5 未落地：`/dev/ttyEUD0`（下一步）

tty/uart 版代码已经写好但**没落盘**：`uart_driver`(`dev_name="ttyEUD"`) + `uart_ops`
+ `start_tx` 只 `schedule_work()`（无 TX 中断，持 port spinlock 排空会关中断几百 ms 并卡住 printk）
+ `PORT_EUD 124` + `.device = uart_console_device` / `.data = &eud_uart_driver`。

原因：本环境的 shell 对大段文本不稳（here-string 与数组两种写法、2.4–7 KB 共 5 次，都在同一处被截断）。
下次用「分片 ≤1 KB 追加」写入，再编译 → 出 `0004` patch。
注意：EUD COM 是 **TX-only**，`/dev/ttyEUD0` 写得通、读永远没数据，这不是 bug。

---

## 26. Real-hardware review: console works, two real culprits, panic loop (2026-10-07)

### 26.0 What happened

1. console=eud is verified on hardware: with keep_bootcon removed the log no
   longer stops at 1.2 s.
2. But the kernel never reached userspace; it has been a panic loop all along.
   Two independent causes:
   - RPMh read regression (new in 7.3): on SM8150 the AOSS never answers
     rpmh_read().  The request occupies an ACTIVE TCS and blocks every later
     write.  The first read was issued at 0.16 s and timed out exactly 10 s
     later (rpmh.c: RPMH_TIMEOUT_MS = msecs_to_jiffies(10000)).  The log shows
     "failed to read VOLTAGE ret = -110" plus rpmh_write WARNs and
     "dwc3 ... failed to get clocks" as secondary damage.
   - initramfs dead links: build-image.sh ran "busybox --install -s" with an
     absolute path, so all 305 applet symlinks in initramfs/bin point at
     /home/cy122/x2pro-linux/initramfs/bin/busybox.  Inside the initramfs they
     dangle, so /init (a #!/bin/sh script) cannot exec, and the kernel panics
     with "No working init found" -> panic=15 -> reboot loop.  The screen stuck
     on repeated firmware DXE dispatch output ("stuck at EDK2") is the symptom,
     not the cause.

### 26.1 Evidence from the two boots

Boot 1 (console=eud firmware + old Image):

    0.000-0.15 s   earlycon output (garbled head, then clean)
    0.15-10.2 s    hole: fbcon registered at 0.118 s and the kernel unregisters
                   all boot consoles automatically; our real console only
                   appears at device_initcall
    10.2 s         "console [eud0] enabled" and the log RESUMES - hard evidence
                   that console=eud works (without it nothing would follow)
    10.22 s        failed to read VOLTAGE ret = -110, rpmh_write WARN,
                   dwc3 -ETIMEDOUT
    78.86 s        random: crng init done (kernel still alive)
    next 5 min     0 bytes captured: it had already panicked and rebooted, and
                   the EUD CTL state resets on reboot (the host did not re-run
                   com-up)

Boot 2 (keep_bootcon firmware + RPMh patch): ret = -110 becomes ret = -95
(-EOPNOTSUPP, the read is never sent), the 10 s hole is gone, and then the
kernel panics with "No working init found".
### 26.2 Fix 1: RPMh read (drivers/soc/qcom/rpmh.c)

At the top of rpmh_read():

    if (rpmh_read_unsupported())
        return -EOPNOTSUPP;

where rpmh_read_unsupported() caches

    of_machine_is_compatible("qcom,sm8150") || of_machine_is_compatible("qcom,sc8180x")

once.  sm8150-samurai.dts carries "qcom,sm8150" in its compatible list, so the
check matches.  Same idea as the upstream "skip read commands on sm8150 and
sc8180x" thread.  It sits in rpmh_read() rather than in the regulator driver
because there are three call sites (qcom-rpmh-regulator.c:265/377/598) and the
TCS is an RPMh-level resource.

### 26.3 Fix 2: initramfs symlinks (the build-image.sh trap)

    ls -l initramfs/bin/sh
    sh -> /home/cy122/x2pro-linux/initramfs/bin/busybox      <- host absolute path
    find initramfs -type l -lname /home/* | wc -l
    305

build-image.sh calls "busybox --install -s" with an absolute directory, so all
305 applet symlinks point at the host tree.  The cpio keeps the target verbatim,
so inside the initramfs /bin/sh, /bin/ls, ... are dangling and the #!/bin/sh
/init cannot run.  Fix (now scripted): relink every non-busybox symlink in
initramfs/bin to the relative target "busybox", delete linux/usr/
initramfs_data.cpio* to force a rebuild, then make Image.  Verified: the Image
no longer contains /home/cy122/ and /bin/sh points at busybox.

### 26.4 Artifacts and state (2026-10-07 18:45)

    Image-rmx1931-samurai-rpmhfix    d25be955...  RPMh patch, verified in hardware (-95)
    Image-rmx1931-samurai-initfix    4a4463c3...  RPMh + initramfs fix, NOT yet in the FAT
    boot-samurai-eudconsole.img      ea4a8f4e...  console=eud, no keep_bootcon (production)
    boot-samurai-eudlogfull.img      7bc3d6e1...  keep_bootcon debug build (complete but slow)
    rollback: boot-samurai-linux-console.img (16:01), backup/boot_stock_RMX1931.img

Phone state at that moment: panic loop, screen showing firmware DEBUG output,
USB not enumerating at all (neither fastboot nor adb).  Recovery: hold Power
for 15 s, Vol-Down + Power into fastboot, flash stock boot, boot Android, write
Image-rmx1931-samurai-initfix into the logdump FAT, flash
boot-samurai-eudconsole.img.

### 26.5 TODO

1. Flash the initfix image and confirm "rmx1931-mainline initramfs reached
   userspace" appears on screen.
2. Emit the rpmh patch and the initramfs fix as linux-port/patches/0003, 0004.
3. Back to section 20.6: panel SOFEF03F_M, touch S3706, WCN3990, charger, sensors.

---

## 27. Userspace reached; console moved to /dev/kmsg; shortcuts vs proper goals (2026-10-08)

### 27.0 Where we are

* The kernel boots to userspace and stays there: "Run /init as init process",
  all six UFS LUNs enumerate, no "No working init found", no panic.  This is
  the first time the port gets past the kernel/initramfs handover at all.
* The initramfs banner and the diagnostic dump now reach EUD, but only
  partially: the dump floods the console (measured throughput ~3 KB/s), the
  captured stream breaks up, and the phone reboots shortly afterwards (cause
  not yet proven; panic=15 turns a panic into a reboot).
* Neither blocker was the port itself: (a) the 7.3 RPMh read regression,
  (b) the initramfs absolute symlinks.  Both are fixed.

### 27.1 What was fixed, in order

1. initramfs symlinks: build-image.sh ran "busybox --install -s" with an
   absolute directory, so all 305 applet links pointed at
   /home/cy122/x2pro-linux/initramfs/bin/busybox.  Inside the initramfs /bin/sh
   was dangling, /init could not exec, and the kernel panicked with
   "No working init found" -> panic=15 -> reboot loop.  Fixed by relinking to
   the relative target "busybox" and forcing a cpio rebuild
   (rm -f usr/initramfs_data.cpio*).
2. The kernel could not open an initial console ("Warning: unable to open an
   initial console.", the initramfs /dev is empty), so init's stdout went
   nowhere.  First attempt - redirect the script to /dev/console after mounting
   devtmpfs - still did not reach EUD, because opening /dev/console resolves
   through console_device() = the preferred console's .device callback, and the
   console-only driver has none, so the writes land on the VT (screen only).
   Second attempt (current): redirect to /dev/kmsg.  That goes through printk
   and therefore reaches every registered console, EUD included.  Banner
   confirmed in the EUD capture.
3. The RPMh read regression workaround (rpmh_read() returns -EOPNOTSUPP on
   qcom,sm8150 / qcom,sc8180x) is in and verified: the 10 s stall is gone and
   the log now shows "failed to read VOLTAGE ret = -95" instead of -110.

### 27.2 The reboot after the dump (open)

Not explained yet.  The last EUD bytes are at kernel time ~0.30 s, right after
the banner, and the tail looks like a crash dump cut into pieces by dropped
frames.  Candidates:

  (a) the flood of /dev/kmsg writes saturates printk/console and something in
      that path stalls or dies;
  (b) init exits (exec sleep 100000 fails, or the shell dies) ->
      "Attempted to kill init!" -> panic=15 -> reboot.

Next step: read /sys/fs/pstore/console-ramoops from Android.  The DTB already
carries ramoops@0xb7e00000 and PSTORE_CONSOLE is enabled, so the panic text
should be there in full - this is the one channel where we get an unbroken log.
### 27.3 Shortcuts taken to get information (temporary by definition)

Every row below exists only because we needed facts from a board that has no
UART.  None of them is the shape the port should keep.

| # | Shortcut | Why it exists | Proper replacement |
|---|---|---|---|
| S1 | initramfs writes its diagnostics to /dev/kmsg | our console has no tty, /dev/console writes never reach EUD | implement the tty layer (uart_driver + .device = uart_console_device): /dev/console and /dev/ttyEUD0 then work for userspace too |
| S2 | the whole diagnostic dump runs on every boot (iomem 40 lines, dmesg 30 lines, device lists) | collecting bring-up facts in one shot | opt-in only (cmdline flag or a file on the ESP); never unconditional |
| S3 | "exec sleep 100000" at the end of initramfs init | keep the box in userspace so the screen keeps its text | a real root filesystem and switch_root; the debug initramfs is a bring-up tool |
| S4 | rpmh_read() SoC quirk via of_machine_is_compatible | 7.3 RPMh read regression on sm8150/sc8180x | upstream's own proposal is the same skip; the cleaner form is a DT capability/quirk or an RSC version check |
| S5 | kernel Image + DTB stored in a FAT partition created inside the factory logdump partition | the kernel cannot fit in the FV (FFS 16 MiB limit; PrePi pool) | a real ESP (shrink userdata) + GRUB, i.e. the section 8 deferred plan |
| S6 | reading the previous panic through Android's pstore | the Linux bring-up has no shell | the initramfs can read /sys/fs/pstore itself and print the previous boot's panic; or OpenOCD |
| S7 | console=eud firmware carrying the command line in firmware code | the firmware is the only place we control the cmdline | the same command line, but as a documented boot option/chosen node with a reproducible build recipe |
| S8 | keep_bootcon (older builds, and boot-samurai-eudlogfull.img) | keep the early console alive to catch early logs | console=eud (done); the debug build stays debug-only |
| S9 | CONFIG_CMDLINE_FORCE experiment | test without flashing a new firmware | abandoned; .config reverted |
| S10 | kernel console pacing still consults INT_STATUS_1 when it reads back | it usually answers | the firmware side already learned this lesson: never trust INT_STATUS_1; use the proven fixed timing (200 us/byte, 2 ms/frame) or a real tty with flow control |
| S11 | panic=15, loglevel=7, ignore_loglevel in the cmdline | debug convenience | production defaults once the port is stable |
| S12 | local DT compatible qcom,sm8150-eud-com with no binding | bind the COM FIFO | an upstream binding, or reuse the qcom,eud node once the role-switch/SCM path is available on this unit |
| S13 | logdump repurposed at all | factory-unused, all-zero partition | keep it as the emergency/rescue area; user data belongs in a real partition scheme |

### 27.4 Proper goals (the standard shape of this work)

1. Console and tty.  A real console for the EUD COM FIFO, selected with
   console=eud, plus a real tty so userspace can write to /dev/console and
   /dev/ttyEUD0.  Pacing must not depend on readbacks that this block does not
   return reliably.  Replaces S1, S2, S10.
2. Device tree.  A reviewable samurai DTS with no borrowed MTP or vendor
   scaffolding: correct PMIC resources ("could not find RPMh address for
   resource ldof2" is a real mismatch), the missing supplies (vdd-hba-supply),
   interconnect paths for qcom-cpufreq-hw, and the temp-alarm dependencies.
3. USB.  Decide explicitly whether dwc3 coexists with EUD or is disabled while
   debugging; the end goal is a working USB gadget/UDC.
4. Boot chain.  ESP + GRUB (or SimpleInit BOOT_LINUX) with kernel, initrd and
   DTB, replacing S5; the firmware's job becomes "load an EFI application",
   nothing else.
5. Root filesystem.  A real distribution (postmarketOS/Debian) with a
   documented install path, replacing S3 and S6.
6. Logging.  Two channels with clear roles: pstore/ramoops for durable records
   across a crash, EUD COM for the live view.  Nothing debug-only on by default
   (S11).
7. Upstream.  The RPMh quirk (S4) and the EUD console with a proper binding
   (S12), plus commit messages that explain the hardware, and no bring-up
   scaffolding in the shipped configuration.

### 27.5 Order I would do it in

1. Read the panic from pstore (S6) and fix the reboot.
2. Trim the initramfs dump to the banner plus a handful of lines and throttle
   it (S2); make it opt-in.
3. Land the tty half of the EUD driver (S1, S10): that is already written and
   waiting in the un-landed eud.c.
4. Then the real work of section 20.6: panel SOFEF03F_M, touch S3706, WCN3990,
   charger, sensors - plus the DT items listed in goal 2.
5. Only after that: the ESP/GRUB/distro work (goals 4, 5), with a GPT backup
   and a verified 9008 rescue path in hand first.

---

## 28. Button-free fastboot and a hands-off flywheel: PON reboot-mode, EUD COM RX, fastboot flash logdump (2026-10-08)

### 28.0 Summary

Three findings, each verified in source or on hardware:

1. The phone can reboot into fastboot by itself.  The vendor DTB already carries the
   magic (mode-bootloader = <0x02> on the PMIC PON), mainline's qcom-pon.c speaks the
   generic reboot-mode framework, and only two DT lines are missing on this board.
2. The EUD COM channel is full duplex.  The official QUIC host library documents
   COM_RX_ID/LEN/DAT at 0x088E000C/0x10/0x14, i.e. host -> device.  This project only
   implemented the TX half, so "control the phone like adb" is a software task, not a
   hardware limit.
3. fastboot can write the logdump partition: "fastboot flash logdump" works and is
   byte-exact, 64 MiB in 1.8 s.  That removes the Android step from the iteration
   loop.

### 28.1 Button-free fastboot (PMIC PON reboot-mode)

Evidence:

* Vendor decompiled DT, linux-port/artifacts/sm8150-samurai.dts.decompiled:3917:

      pon@800 {
              compatible = "qcom,pm8998-pon";
              reg = <0x800>;
              mode-bootloader = <0x02>;
              mode-recovery   = <0x01>;
      };

  So the stock Android "reboot bootloader" writes 0x02 into the PMIC PON reason
  field and resets; ABL reads it and enters fastboot.  That is why every
  "adb reboot bootloader" in this project worked.

* mainline drivers/power/reset/qcom-pon.c matches qcom,pm8998-pon with
  GEN2_REASON_SHIFT, writes magic << reason_shift into the PON register and
  registers itself with the generic reboot-mode framework
  (devm_reboot_mode_register).  reboot-mode.c takes the magics from DT properties
  prefixed "mode-" (define PREFIX "mode-").

* .config already has POWER_RESET_QCOM_PON=y, POWER_RESET_MSM=y, REBOOT_MODE=y,
  POWER_RESET_SYSCON=y, SYSCON_REBOOT_MODE=y.

* mainline pm8150.dtsi's pon@800 has the right compatible and reg, but not the two
  mode- properties - that is the only missing piece.

Patch (two lines in sm8150-samurai.dts):

    &pon {
            mode-bootloader = <0x02>;
            mode-recovery   = <0x01>;
    };

Trigger: busybox's reboot cannot pass a reason string, so a ~15 line static helper
is needed:

    sync();
    syscall(SYS_reboot, LINUX_REBOOT_MAGIC1, LINUX_REBOOT_MAGIC2,
            LINUX_REBOOT_CMD_RESTART2, "bootloader");

Caveat: the magic is written by the reboot notifier at reset time, so the mode has
to be requested on the reboot that matters.  A panic reboot passes cmd = NULL and
therefore does NOT carry the bootloader reason; for that case the next boot's
initramfs should read pstore, notice the previous panic, and itself call
reboot2 bootloader.

### 28.2 EUD COM is full duplex (host -> device)

From the official QUIC library, E:\eud-host\quic-eud\com_api.cpp:127-132:

    HWIO_PERIPH_SS_EUD_COM_RX_ID_ADDR : 0x088E000C
    HWIO_PERIPH_SS_EUD_COM_RX_LEN_ADDR: 0x088E0010
    PERIPH_SS_EUD_COM_RX_DATA         : 0x088E0014

  TX (device -> host, what this project uses): 0x088E0000 / 0x04 / 0x08
  RX (host -> device, unimplemented here):     0x088E000C / 0x10 / 0x14

So a command channel is purely a software task:

* device side: poll RX_LEN, read RX_DAT, interpret a small command set
  (reboot2 bootloader / recovery / edl / heartbeat);
* host side: write to the COM port, or add an eudtool opcode;
* the same polling can be added to EDK2 with a timer event, so a PC can rescue a
  device that is stuck before BDS finishes - the situation seen twice today, when
  neither fastboot nor adb existed.

This is the "control it like adb" path.  It is cheaper and more useful than
SWD/JTAG for boot-mode control; SWD remains the only way to halt or single-step a
core, and on this unit the 9504 SWD endpoint has not been seen at all.
### 28.3 fastboot can write the logdump partition (verified)

Tests run on hardware:

| test | result |
|---|---|
| fastboot getvar partition-type:logdump | `raw` |
| fastboot getvar partition-size:logdump | `0x4000000` = 64 MiB |
| fastboot fetch logdump ... | not supported by this ABL |
| fastboot flash logdump logdump.img | OKAY, 64 MiB in 1.78 s |
| re-read with dd and compare sha256 | identical (`63e83d3e...` before and after) |

FAT layout of the template (parsed from the dump):

    FAT16 / label KERNEL / 4096 B per sector / 1 sector per cluster / 2 FATs
      \Image       30,116,352 B   start cluster 3
                   clusters 3..7355 contiguous, data offset 90112 (0x16000)
      \samurai.dtb     94,739 B   start cluster 7356

Because the Image size is always exactly 30,116,352 bytes and its cluster chain is
contiguous, an in-place update is a single contiguous write and touches neither the
FAT nor the directory entry:

    d = bytearray(open('logdump.img','rb').read())
    img = open(new_image,'rb').read()
    assert len(img) == 30116352
    d[90112:90112+30116352] = img
    open('logdump-new.img','wb').write(d)

Template kept at E:\edk2-samurai-out\logdump.img (sha256 63e83d3e...).

Side benefit: a corrupted logdump FAT is no longer a trip through Android - the
template can be flashed back in 1.8 s from fastboot.

### 28.4 The flywheel

    [PC]  edit code, make Image                                     ~2.5 min
    [PC]  python: patch logdump.img in place                        ~1 s
    [PC]  fastboot flash logdump (64 MiB)                          ~1.8 s
          fastboot flash boot, only when the firmware changed      ~0.3 s
    [phone] firmware -> Linux: dump logs, then reboot2 bootloader -> fastboot
    [PC]  capture daemon: waits for 9501, com-up, finds the COM port, records
          one log file per boot - no operator needed
    [PC]  new log -> panic/WARN extraction -> next fix

Prerequisites, in order:

1. DT: the two mode- lines (28.1).
2. initramfs: read the previous boot's pstore; if it shows a panic, go straight to
   fastboot; pet the hardware watchdog (CONFIG_QCOM_WDT=y) so a hang also resets;
   after the banner and diagnostics, call reboot2 bootloader.
3. PC side: the capture daemon above (the pieces exist: eudtool, comlog2).
4. PC side: the logdump patch script, landed in linux-port/scripts/.

### 28.5 Deltas to the shortcuts / proper-goals split (section 27.3, 27.4)

* S5 (kernel stored in a FAT inside logdump) is much less of a shortcut now: the
  fastboot write path is verified, the file offset and size are fixed, and a
  corrupted FAT is recoverable in 1.8 s.  It is still not the standard shape (goal
  4: ESP + GRUB), but it is no longer fragile.
* New item S14: reboot2 needs a static helper binary because busybox cannot pass a
  reboot reason.  The proper fix is a small tool in the image, or a future
  userspace that can call the reboot syscall properly.
* New proper goal (8): a host -> device command channel over EUD COM RX, wired into
  both the kernel driver and EDK2, so the PC can control boot modes and rescue a
  firmware that is stuck before BDS.  Replaces nothing; it makes S3/S6 unnecessary
  and gives the same convenience adb has, without Android.
* SWD/JTAG (section 4) stays where it was: the only tool for halt/step/memory, not
  for boot mode, and its endpoint has not appeared on this unit.

### 28.6 TODO, in order

1. Land the two DT lines and the reboot2 helper; rebuild the Image.
2. initramfs logic: previous-panic check via pstore, watchdog pet, reboot2 at the end.
3. PC capture daemon and the logdump patch script.
4. Then the flywheel runs unattended; use it to finish the real work of section 20.6.
5. Optional, later: the EUD COM RX command channel (kernel + EDK2), and the ESP/GRUB
   end state.
## 29. EUD COM console, tty and command channel (2026-10-08) - measured

### 29.1 What the hardware really does

Host to device framing, verified byte by byte on this unit:

    write  [id][len][payload...]   (one USB transfer, e.g. 81 05 "world")
    read   0x0c -> id     LATCH: the last message's id; re-reading does not pop
           0x10 -> len    LATCH: the last message's len
           0x14 -> payload FIFO: every read pops one payload byte, `len` times

Evidence: with the host writing [90][08]"PAYLOAD!" every 5 s, a probe that dumped
the window 0x0c..0x60 whenever the latches changed printed

    eud: C id=90 len=08 dat=50 window ... 14:50505050 ... 40:02020202 44:07070707
    eud: C id=90 len=08 dat=41 window ... 14:41414141 ...

0x50 is 'P' and 0x41 is 'A': the payload comes out of 0x14, one byte per read.
This also explains the earlier confusion - the header "changing with every
message" was the host's write updating a latch, not the driver draining a FIFO.

Other registers: INT_STATUS_0 (0x40) reads 0x00000000 when idle and 0x02020202
while data is pending; INT_STATUS_1 (0x44) goes 0x06060606 -> 0x07070707 (BIT(0));
neither is a reliable "data pending" flag (a phase that read only the status
registers while the host kept writing saw them constant).  INT1_EN_MASK reads
0x1c1c1c1c, INT0_EN_MASK 0, CSR_EUD_EN 0x01010101, 0x60 0x0b0b0b0b (undocumented).
Every readback replicates the low byte into all four lanes (0x81 -> 0x81818181).

Device to host (TX) is the same idea in reverse and was already known: one
register write is one FIFO entry, so the device writes [ID=0x90][len][data...]
and the host reassembles [0x90][len][data] frames.

### 29.2 Three bugs found on hardware (all fixed)

1. Two writers on one small FIFO.  The firmware boots with
   "earlycon=eud,... keep_bootcon", so the early console stays registered; an
   unconditional register_console() made every printk go out twice and the two
   writers interleaved byte by byte (every character arrived doubled).
   Fix: register the real console only when the command line asks for it, and
   drop keep_bootcon in the firmware command line.
2. No TX pacing.  eud_earlycon.c used INT_STATUS_1 BIT(1) as flow control, but
   that bit reads back stuck-at-set here, so frames went out at MMIO speed and
   whole frames were dropped (four bytes missing in the middle of a log line).
   Fix: fixed timing, 200 us per register write and 2 ms per frame, the numbers
   the EDK2 port had already measured on the same FIFO.
3. Short-lived writers lost their bytes.  "echo x > /dev/ttyEUD0" closes the port
   at once and ops->shutdown() cancelled the paced workqueue before it ran.
   Fix: drain the transmit kfifo synchronously in eud_shutdown().

### 29.3 The driver

Kernel side is drivers/tty/serial/eud.c (a copy lives in
E:\edk2-samurai-out\eud-v3-verified.c):

* a real uart driver, dev_name "ttyEUD", one port, custom type 124, TX through a
  workqueue with the pacing above;
* a 20 ms RX poll that follows the header latch and reads the payload from 0x14;
* struct console "eud" with .device = uart_console_device, registered only when
  the command line asks for it, so /dev/console binds to ttyEUD;
* command channel [0x81][len][payload]: payload[0] is the command code
  (0x01 ping, 0x02 register dump, 0x03 status);
* typing [0x82][len][payload]: the payload is fed to the tty with
  uart_insert_char(), so a shell on /dev/ttyEUD0 can be driven from the PC.

### 29.4 Verification runs (all on this phone)

* tty and console: the initramfs writes "[[TTYBANNER-OK]]" to /dev/ttyEUD0 and
  the host received exactly that string through the driver (not through printk).
  After the firmware change the boot log shows
  "printk: legacy console [eud0] enabled" followed by
  "printk: legacy bootconsole [eud0] disabled", and a typed
  "echo CONSOLEW >/dev/console" came back on EUD.
* command channel: [0x81][0x01] -> "eud: pong", [0x81][0x02] -> full register
  dump, [0x81][0x03] -> "eud: polls=... reports=... last_status=...",
  [0x81][0x07] -> "eud: unknown command 7".
* typing: "echo EUD2-OK", typed as one character per frame, was executed by the
  shell on /dev/ttyEUD0 and its output came back to the host.
* log quality: a 210 s capture reassembles with 0 resyncs (about 15k frames).

### 29.5 Still open

* Reading 0x14 blindly wedges the EUD COM block: the console goes silent while
  the EUD control device (9501) and COM14 stay up, and only a full power cycle
  brings it back.  The payload image did this right after the first host frames
  (see 29.6).  Next iteration: read 0x14 exactly `len` times, only once per
  header change, with `len` validated to 1..16, and never touch 0x14 otherwise.
* While the header-only protocol is in use, input characters can still be lost
  ([0x82][char] carries no payload); the payload protocol should remove that
  once the read is safe.
* The status bits are not trustworthy, so "data pending" is inferred from the
  header latch changing.

### 29.6 Note on the wedged state

After flashing logdump-payload.img the phone booted, the console streamed
normally to about kernel time 20 s, then the host wrote a few frames and the
console went silent.  A full power cycle restored it, so this is an EUD hardware
state rather than a kernel crash.  Do not conclude "the kernel is broken" before
trying a full power cycle.

## 30. Current artifacts and how to drive the phone

Images (E:\edk2-samurai-out):

* boot-samurai-console.img   EDK2 firmware whose command line carries
                             "console=tty0 console=eud" and no keep_bootcon
                             sha256 8351b782b090f16355fc8019c2701579217ecd581961da20db52a6f568890f52
* logdump-tty6.img           last verified-good kernel: clean console,
                             /dev/ttyEUD0, header command channel
* logdump-payload.img        payload protocol; wedges the EUD (section 29.5)
* logdump-regprobe2.img      the register-window probe that found 0x14
* Image-rmx1931-samurai-*    the kernel Images themselves
* boot_stock_RMX1931.img     Android boot backup, sha256 dfe18875..., byte
                             identical to the phone's boot partition

Host tools (E:\edk2-samurai-out):

* eud-parse.py            reassemble a capture ([0x90][len][data], with resync)
* patch-logdump.py        put an Image into the logdump FAT (about 1 s)
* flash-and-test-rx.ps1   flash boot + logdump, wait for EUD, capture;
                          -RestoreAndroid puts the Android boot image back
* eud-type.ps1            type a string into /dev/ttyEUD0
* eud-run.ps1, eud-run2.ps1  run a command with output verification and retry
* eud-cmd-test.ps1        exercise the [0x81] command channel
* eud-regprobe-host.ps1   write [0x90][0x08]"PAYLOAD!" every 5 s (the 0x14 hunt)
* comlog2.cpp            tight-loop reader used earlier in the project

Workflow for every cycle:

    hold Power ~15 s        full power cycle: EUD keeps the port otherwise and a
                            wedged EUD block only clears this way
    Vol-Down + Power        -> fastboot
    fastboot flash boot  boot-samurai-console.img    only when firmware changed
    fastboot flash logdump logdump-<version>.img     1.8 s
    fastboot reboot
    E:\eud-host\eudtool.exe com-up                   enable COM + VBUS attach
    then eud-type.ps1 / eud-cmd-test.ps1 / comlog2 and read the capture

Build trees:

* kernel:  ~/x2pro-linux/linux   (Linux 7.3-rc6, samurai DTS, eud.c,
           eud_earlycon.c).  make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
           Image, then patch-logdump.py.
* firmware: ~/edk2-samurai/repo  (build.sh -d samurai --toolchain GCC5),
           produces boot-samurai.img.

Repositories to push to when the work is settled: the EDK2 tree (hmhmdcy fork)
and the kernel branch created in sections 22-24.
