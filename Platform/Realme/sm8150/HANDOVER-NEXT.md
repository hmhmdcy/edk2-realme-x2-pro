# Session handover - realme X2 Pro (samurai) EDK2/UEFI

> Updated 2026-10-09 (Asia/Shanghai).  Sections 0-7 below are the living part:
> current state, next steps, repo state, tools, pitfalls, safety, open questions.
> The history (former sections 8-30) now lives in exactly one file per section -
> see the index at the end of this file.  Read DOCS-INDEX.md for the whole map.
> Companion documents: DOCS-INDEX.md, README.md, EUD.md, BINARIES.md,
> linux-port/README.md.

## 0. TL;DR - where the project stands (2026-10-09)

Boots and runs:

* EDK2/UEFI boots on hardware; all three side buttons work; UFS and the GPT are
  enumerated; USB mass storage mode works; the UEFI menu boots the mainline
  Linux kernel from the FAT inside the logdump partition.
* Mainline Linux (7.3-rc6) reaches userspace and stays there, with an
  interactive shell in the initramfs.

Final session-41 phone state: logdump-rx41-native-ordered-tty.img retained;
TOP_CFG=0x11, original zero, Linux shell booted. The last bounded retry obtained
a fresh Ctrl-U on its second OUT. COM14 closed/disposed; 6-5 Shared, not Attached.
Some native commands have no captured response; use the compatible terminal.

Current next-session handoff: sessions/42-native-terminal-next-session-handoff.md.
The repeated-first-byte payload fault has a verified fix, using complete native
frames rather than host-side single-byte splitting. The remaining terminal
faults are not established as newly introduced: their cause and relationship to
the earlier failure are still unknown. The last phone state above is a session-41
snapshot, not a live check made during the session-42 documentation update.

EUD native multi-byte RX now has a verified method (session 41):

* Stock RMX1931 SM8150 DAL maps SOUTH SWMAN at 0x088ee000. The matching
  vendor USB driver defines TOP_CFG +0x10, one read/write wait state 0x11.
  A read-only UEFI snapshot measured zero; setting 0x088ee010 to 0x11 with
  matching readback makes the unchanged RX39 burst loop advance correctly.
* Two UEFI boots each accepted ABC=41 42 43 and DEFG=44 45 46 47, then restored
  zero before Linux. Linux independently accepted two ABC and three DEFG
  probes, and a full 14-byte payload. Only low COM field bytes are interpreted;
  upper lanes need not replicate after the FIFO starts advancing.
* The Linux driver sets/verifies the wait state, buffers the complete frame
  under the TX lock before logging, and restores the original configuration
  on F1/remove. Native multi-byte X=ok\n executed in the shell and a later
  single-byte terminal command read back ok. Some correctly received commands
  had no captured response; the session distinguishes execution from TX output.
* Length 1 and 3..14 carry tty input; length 2 remains the header-only F1
  command [90][02]. Never send a two-character tty frame. The existing
  temporary terminal still uses single-byte frames and remains compatible.
* Host OUT acceptance is still intermittent and needs device receipts plus
  bounded retry. Empty captures are inconclusive. 0 stray does not prove
  lossless TX. Do not repeat the old 0-wait DAT/latency/flag guesses unchanged.
* Only logdump was flashed in session 41. Firmware boot, DTB, actual working
  initramfs, existing kernel changes and backups are preserved. COM owners
  always close/dispose in finally. Current artifact/state and raw verification
  are in sessions/41-rx-ahb2phy-wait-state-fix.md and reference/rx41.

## 1. What to do next, in order

Process rule agreed on 2026-10-08: when an experiment has failed two or three
times in a row, STOP and search for an existing implementation or document
before spending another hardware cycle. The downstream `drivers/soc/qcom/eud.c`
and QUIC host library established the register layout and framing; session 41
verified native payload advancement with the SM8150 AHB2PHY wait state.

**Native FIFO advancement has a working method; read session 41 first.**
Sessions 35-40 remain the history of excluded paths and source limits. The new
SM8150 map plus actual zero/0x11 readbacks supplied evidence missing from the
older SDM845 register table. No PHY/clock reset, filter change or force bind.

1. Read sessions 41 and 42 before further terminal experiments. First verify
   live device enumeration, serial ownership and a fresh bounded device receipt.
   Use the verified wait-state plus whole-frame RX method. The remaining
   questions are missing frame receipts and missing visible command responses;
   neither the failing layer nor whether these are old or introduced faults
   has been established. Trace complete RX -> tty/line discipline -> shell ->
   TX -> host capture; inspect the actual initramfs/BusyBox terminal behavior.
   Compare one variable at a time and classify each result by evidence stage
   (session 42), without treating empty captures as proof of USB rejection.
   Preserve the receipt/retry boundary and reserved length-2 F1 protocol.
   Continue Linux port work with the existing compatible terminal:
   E:\eud-host\eud-terminal.cmd -Reconnect (linux-port/docs/EUD-TERMINAL.md).
   For native frames use the bounded eud-step helper and fresh capture names;
   RetryJitterMs is optional, not proof of reliable delivery.
2. Session 41 builds logdump-rx41-native-ordered-tty.img; its verification and
   final live-device state are recorded in the session. Rollback remains the
   unchanged logdump-rx33-console.img (SHA256 d5a36aa2...). Do not run the old
   build-image.sh: it would replace the actual working initramfs with a stale
   mirror. Build incrementally from the current WSL source and package only
   the new FAT Image, keeping the DTB byte-identical.
3. DONE 2026-10-08 evening: PON reboot-mode plus the two DT mode lines are in and
   verified.  `[90][02]` on the EUD command channel reboots Linux straight into
   fastboot with no key presses, and no reboot2 helper was needed (the driver is
   built in, so it calls kernel_restart("bootloader") directly).  The hands-free
   flywheel is closed - FLYWHEEL.md, sessions/31-flywheel-f1-verified.md.
4. Continue the port work with that terminal: panel SOFEF03F_M, touch S3706, WCN3990, charger,
   sensors, and the device-tree clean-ups
   (`sessions/27-userspace-and-shortcuts.md`, 27.4 goal 2).
5. Optional: a samurai DSDT for Windows, a startup.nsh for the EFI shell, a
   persistent UEFI variable store, and the ESP + GRUB end state.

Normal iterations use [90][02] -> fastboot, flash logdump, then reboot. A full
power cycle is a fallback for a wedged EUD block (hold Power ~15 s, then
Vol-Down + Power for fastboot). Never flash anything but boot and logdump; see
section 6 for the safety rules.

## 2. Verified hardware facts (do not re-derive)

EUD enable (same writes the kernel driver does; no secure-eud on this unit):
    +0x1014 = 1      (CSR_EUD_EN)
    +0x0024 = 0x1C   (INT1_EN_MASK: VBUS|CHGR|SAFE_MODE)
Readback shows the low byte replicated into all four lanes: writing 1 reads
back 0x01010101. Interpret EUD fields through the low-byte mask, not unmasked
32-bit equality. AHB2PHY TOP_CFG is a separate bridge register; its 0x11
configuration readback is explicitly verified by the session-41 method.

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

    master = eff092d  eud: verify native SM8150 RX with AHB2PHY wait state
             2708b47  eud: audit complete register map and stock SM8150 firmware
             89236ea  eud: record tight arrival polling failure and verified baseline recovery
             3bfecb7  docs: normalize RX38 evidence text and retain original hashes
             703469c  eud: record pre-Linux RX failure and USB boundary comparisons
             9d01126  eud: audit native RX sources and PHY lifecycle
             ed31013  docs: normalize RX evidence manifests
             0915f34  eud: confirm native RX failure without qcusbser
             e606a99  eud: audit legacy qcusbser and prepare USB OUT comparison

    70 commits ahead of upstream origin/master, as of the tip named above;
    all of them are on the fork.

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
6. While EUD is enabled it owns the USB port. The verified [90][02] handler
   disables EUD before restarting to bootloader; an ordinary warm reboot can
   leave EUD on and hide fastboot. Use the flywheel first, full power cycle as
   a fallback.

7. Trial and error instead of looking it up.  The EUD RX protocol took many
   hardware cycles of guessing (burst reads, status gating, header-change
   gating) before a search found the answer in the downstream Qualcomm driver:
   `EUD_INT_RX` = BIT(0) of INT_STATUS_1, the id latch is read first and
   filtered against `UART_ID`, then the payload comes out of 0x14.  Rule agreed
   with the user on 2026-10-08: after two or three failed experiments, stop and
   search for an existing implementation, driver or document first.  A useful
   technique for source that fetch tools cannot open is a quoted-string probe
   with Exa, e.g. `"static void eud_uart_rx(struct eud_chip *chip)"`, which
   returns a snippet from the middle of the file.

## 6. Safety

* Only flash boot (firmware changes) and logdump (the FAT-contained kernel).
* Keep E:\edk2-samurai-out\backup\boot_stock_RMX1931.img - it is the only way
  back to Android.
* The "USB Attached SCSI (UAS) Storage" boot option exposes the phone raw UFS
  LUNs.  Never let Windows initialise, partition or format them.
* If the phone hangs with no USB at all, hold Power 15-30 s, then
  Vol-Down + Power into fastboot and reflash a known-good image.

## 7. Open questions

* Can the log channel survive the UEFI -> OS handoff (useful for Linux boot
  debugging), and what does the Android kernel ttyEUD see at that point?
* Which layer causes intermittent whole OUT frames without a receipt, and
  how can TX responses be checked for exact continuity? Do not conflate this
  with the now-verified AHB2PHY FIFO advancement method (session 41).
* Why do some correctly read and tty-inserted native commands have no captured
  response? Audit tty/line discipline, actual BusyBox shell and TX/host capture
  before assigning a root cause or calling this a newly introduced fault.
* Move the SM8150 shared bridge configuration to appropriate platform/DT
  resource management before generalizing the board-specific driver.

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
| 31 | Flywheel F1: EUD command channel reboots Linux into fastboot; payload probe still open | `sessions/31-flywheel-f1-verified.md` |
| 32 | RX probe 90 90; pre-read printk interferes; single-character input fixed; multi-byte advancement open | `sessions/32-rx-printk-interference.md` |
| 33 | RX access, host/upstream audits and production-policy evidence; multi-byte advancement still open | `sessions/33-rx-access-and-production-policy.md` |
| 34 | Temporary host terminal; multi-byte TX, single-byte RX bridge, tty/console and keyboard verification | `sessions/34-temporary-eud-terminal.md` |
| 35 | Next-session RX handoff: retained state, excluded paths, new evidence needed and short prompt | `sessions/35-rx-next-session-handoff.md` |
| 36 | Actual USB descriptors, legacy qcusbser/SM8150 audit; accepted libusb/WSL ABC and DEFG still fail | `sessions/36-rx-usb-descriptors-and-legacy-qcusbser.md` |
| 37 | Native RX source search: actual OEM bugs, QUIC overload correction, PHY v9 lifecycle candidate | `sessions/37-rx-source-search-and-phy-lifecycle.md` |
| 38 | Pre-Linux UEFI still repeats first byte; accepted legal max-packet/ZLP and reset comparisons fail; baseline restored | `sessions/38-rx-pre-linux-and-usb-boundaries.md` |
| 39 | Tight pre-Linux arrival polling still AAA/DDDD; bounded recovery, baseline/native receipt restored; HWIO source limits | `sessions/39-rx-tight-arrival-poll.md` |
| 40 | Complete older EUD register map and stock SM8150 static audit; no RX advance spec/fix; fresh baseline single-byte receipt | `sessions/40-rx-register-map-and-stock-firmware-audit.md` |
| 41 | SM8150 AHB2PHY wait-state native RX method; UEFI/Linux complete payloads and tty execution | `sessions/41-rx-ahb2phy-wait-state-fix.md` |
| 42 | Native terminal handoff: verified payload fix, unresolved receipt/response faults, next checks and short prompt; docs only | `sessions/42-native-terminal-next-session-handoff.md` |

Rules that keep this file from growing again:

* The living sections stay here; never append a session log to this file.
* A new session writes one file - `sessions/NN-<topic>.md`, or
  `linux-port/docs/NN-<topic>.md` for the Linux side - and adds one row above.
* One fact, one file; mirrors point at the source and never carry their own copy.

The complete pre-split text is kept verbatim in `archive/HANDOVER-NEXT-full-2026-10-08.md`.
