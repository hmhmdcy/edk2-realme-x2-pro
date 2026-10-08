# Session handover - realme X2 Pro (samurai) EDK2/UEFI

> Updated 2026-10-08 (Asia/Shanghai).  Sections 0-7 below are the living part:
> current state, next steps, repo state, tools, pitfalls, safety, open questions.
> The history (former sections 8-30) now lives in exactly one file per section -
> see the index at the end of this file.  Read DOCS-INDEX.md for the whole map.
> Companion documents: DOCS-INDEX.md, README.md, EUD.md, BINARIES.md,
> linux-port/README.md.

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
  are latches (`sessions/29-eud-console-tty-command-channel.md`, 29.1).
* Known problem: the first payload implementation reads 0x14 too eagerly and
  wedges the EUD COM block - the console goes silent until a full power cycle.
  Reading 0x14 must happen only when a complete payload is certain.

## 1. What to do next, in order

1. Choose the phone state you want:
     * last verified-good kernel:  fastboot flash logdump logdump-tty6.img
       (clean console, /dev/ttyEUD0, header command channel)
     * back to Android:            .\flash-and-test-rx.ps1 -RestoreAndroid
2. Make the RX payload read safe (`sessions/29-eud-console-tty-command-channel.md`, 29.5): read 0x14 exactly `len` times,
   only when the header latch changed, with `len` validated to 1..16, and never
   touch 0x14 otherwise.  Typing over EUD then becomes a reliable interactive
   shell - the goal "control it like adb, without Android".
3. PON reboot-mode plus the two DT mode lines plus a reboot2 helper, so
   "reboot bootloader / recovery / EDL" can be commanded over EUD.  Together
   with the verified `fastboot flash logdump` (1.8 s) that closes the hands-free
   flywheel (`sessions/28-flywheel.md`, 28.4/28.6).
4. Then the real port work: panel SOFEF03F_M, touch S3706, WCN3990, charger,
   sensors, and the device-tree clean-ups in `sessions/27-userspace-and-shortcuts.md`, 27.4 goal 2.
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

    master = 4903417  docs: generate the handover Repo state block from git, and check it
             47121ad  linux-port: make the push retry in sync-docs-to-repo.sh actually retry
             b1657b2  docs: refresh the handover - current repo state and the real open questions
             721d2f2  docs: drop the stale DIAG-CAPTURE.md from the mirror
             15f7303  docs: split EUD.md and DIAG-CAPTURE.md into single-topic files
             7ccb70e  samurai: track the disabled boot-layout include
             f201abf  linux-port: NN-<topic> doc names, an index, and guards against re-adding sections
             2789b41  docs: split the 109 KB handover into a slim entry plus one file per section
             2d0e68e  docs: index the documentation; keep the two 2026-10-06 records in the repo

    53 commits ahead of upstream origin/master; all of them are on the fork.

    fork remote: https://github.com/hmhmdcy/edk2-realme-x2-pro
                 push with:  git push fork master
                 (a plain git push goes to upstream edk2-porting/edk2-msm - never do that)

Documentation layout (2026-10-08; the full map is DOCS-INDEX.md):
    HANDOVER-NEXT.md               this file: sections 0-7 + the history index
    DOCS-INDEX.md                  documentation map, sync commands, maintenance rules
    reference/DECISIONS.md         former sections 8-11
    sessions/NN-<topic>.md         former sections 12-18, 29, 30 (+ two 2026-10-06 records)
    linux-port/docs/NN-<topic>.md  former sections 19-28, see its 00-INDEX.md
    archive/HANDOVER-NEXT-full-2026-10-08.md   the pre-split text, verbatim
    EUD.md, SWD-JTAG.md, RX-CONSOLE.md, BINARIES.md, README.md

Editing happens in E:\RealmeX2Pro edk2 (Windows); publish with:
    linux-port/scripts/sync-docs-to-repo.sh    top-level docs + health check + push
    linux-port/scripts/mirror-linux-port.sh    the linux-port/ mirror
docs-health-check.sh must print RESULT: clean before anything is pushed.

SerialPortLib scoping in samurai.dsc (important, do not widen casually):
    DXE_DRIVER / DXE_RUNTIME_DRIVER / UEFI_DRIVER / UEFI_APPLICATION -> EudSerialPortLib
    PrePI / PEI / SEC and DXE_CORE keep FrameBufferSerialPortLib

The per-commit detail that used to be listed here (EudSerialPortLib, the samurai.dsc
overrides, PlatformBm.c, EUD.md) is in git log and in sessions/15-17.


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
   not override SerialPortLib for DXE_CORE.  The root cause and the real fix
   (no DEBUG print in the ArmMmuLib MMU-off path) are in sessions/15.
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

* Can the log channel survive the UEFI -> OS handoff (useful for Linux boot
  debugging), and what does the Android kernel ttyEUD see at that point?
* The RX payload read stays dangerous until step 2 of section 1 lands: 0x14 may
  only be read exactly len times, once the header latch has changed, or the EUD
  block wedges until a full power cycle (sessions/29-..., 29.5).

Answered since; kept here so nobody re-opens them:

* EUD COM drain speed with full DEBUG on: fine now - paced writes, and a 210 s
  capture reassembles with 0 resyncs (sessions/15, sessions/16).
* Why EUD SWD 9504 did not enumerate after CTLOUT_SET 0x645 + attach: the
  transport works, the AP DAP is unreachable on this retail unit (APPS_DBGEN_DISABLE
  fuse + signed APDP debug policy) - see SWD-JTAG.md and Mnemon document 06827d0c.


---


## History index (the former sections 8-30)

Old references such as "section 26" or "HANDOVER-NEXT.md 19.7" still resolve
through this table.  Nothing is duplicated: the file in the third column is
the only copy.

| old section | what | file |
|---|---|---|
| 8 | Linux boot path and persistent variables - decision | `reference/DECISIONS.md` |
| 9 | Port checklist status | `reference/DECISIONS.md` |
| 10 | Linux porting paths; when a GPT change is really needed | `reference/DECISIONS.md` |
| 11 | EDL (9008) resources for RMX1931; the auth question | `reference/DECISIONS.md` |
| 12 | Final image verified, why boot logs were still missed, two fixes | `sessions/12-final-image-and-log-gap.md` |
| 13 | EUD log ring buffer implemented | `sessions/13-eud-log-ring-implemented.md` |
| 14 | EUD log ring: verified on hardware | `sessions/14-eud-log-ring-verified.md` |
| 15 | Full DEBUG works; the real cause of the +0x34B8 crash | `sessions/15-full-debug-and-crash-root-cause.md` |
| 16 | Commits, boot-option noise removed, SetCPUFreqDxe bug | `sessions/16-commits-noise-and-cpufreq-bug.md` |
| 17 | Submodule solved with plan A (fork + branch) | `sessions/17-submodule-solution-a.md` |
| 18 | Mainline Linux: the kernel goes into the firmware volume | `sessions/18-mainline-kernel-in-firmware.md` |
| 19 | Kernel command line in the boot option LoadOptions | `linux-port/docs/19-loadoptions.md` |
| 20 | Mainline Linux boots on hardware; kernel moved to the FAT | `linux-port/docs/20-linux-boot.md` |
| 21 | EUD log garbling: kernel-side FIFO overflow | `linux-port/docs/21-eud-framing.md` |
| 22 | Kernel side into GitHub: fork from upstream | `linux-port/docs/22-kernel-upstream.md` |
| 23 | Kernel side: fetch and branches done, push blocked | `linux-port/docs/23-upstream-push.md` |
| 24 | samurai-bringup pushed to GitHub | `linux-port/docs/24-push-done.md` |
| 25 | EUD real console + firmware cmdline/DTB update | `linux-port/docs/25-eud-console.md` |
| 26 | Real-hardware review: console works, two culprits, panic loop | `linux-port/docs/26-real-machine-review.md` |
| 27 | Userspace reached; console to /dev/kmsg; shortcuts vs goals | `linux-port/docs/27-userspace-and-shortcuts.md` |
| 28 | Button-free fastboot and the hands-off flywheel | `linux-port/docs/28-flywheel.md` |
| 29 | EUD COM console, tty and command channel | `sessions/29-eud-console-tty-command-channel.md` |
| 30 | Current artifacts and how to drive the phone | `sessions/30-artifacts-and-workflow.md` |

Rules that keep this file from growing again:

* The living sections stay here; never append a session log to this file.
* A new session writes one file - `sessions/NN-<topic>.md`, or
  `linux-port/docs/NN-<topic>.md` for the Linux side - and adds one row above.
* One fact, one file; mirrors point at the source and never carry their own copy.

The complete pre-split text is kept verbatim in `archive/HANDOVER-NEXT-full-2026-10-08.md`.
