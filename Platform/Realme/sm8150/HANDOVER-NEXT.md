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
* Current host frames use id 0x90. [90][01][char] types real payload into the
  shell; sending i, d, then newline returned `uid=0 gid=0`. Older 0x81/0x82
  header-only shortcuts are historical and are not the current protocol.
* The RX payload register is 0x14 (a FIFO read port); 0x0c/0x10 are latches
  holding the last message's header, and `EUD_INT_RX` = BIT(0) of INT_STATUS_1
  (0x44) is the payload-available gate.  The downstream Qualcomm driver was
  found while searching, and its receive function reads the id latch first,
  filters on `UART_ID`, then reads `len` bytes from 0x14 (RX-CONSOLE.md).
* The RX command channel WORKS.  id 0x90 (= the upstream UART_ID, confirmed in
  two kernel/msm mirrors) is accepted; the length field carries the command, and
  `[90][02]` makes Linux reboot straight into fastboot - verified on hardware,
  no key presses.  That closes the hands-free flywheel (FLYWHEEL.md).
* Session 32 ran the original probe: it returned 90 90. Removing printk before
  RX_DAT exposes the real first payload byte (ABC -> 41, DEFG -> 44), and
  [90][01][char] now reaches tty with real echo. Do not skip two header bytes.
  Multi-byte advancement remains unresolved: burst reads repeat the first byte,
  a buffered one-byte-per-poll probe returns 41 90 90. See RX-CONSOLE.md and
  sessions/32-rx-printk-interference.md for the initial evidence. Session 33 adds
  whole-frame TX exclusion, verified Device-nGnRnE mapping, data-before-header
  and host-path tests; none produced consecutive payload. RX pending does not
  always clear on the first read. Production debug gating is possible, but no
  evidence establishes a COM single-byte restriction.

## 1. What to do next, in order

Process rule agreed on 2026-10-08: when an experiment has failed two or three
times in a row, STOP and search for an existing implementation or document
before spending another hardware cycle. The downstream `drivers/soc/qcom/eud.c`
and QUIC host library established the register layout and framing; multi-byte
RX on this unit is still open.

1. Use the temporary terminal to continue driver bring-up now:
   `E:\eud-host\eud-terminal.cmd -Reconnect` (guide: linux-port/docs/EUD-TERMINAL.md).
   It queues ASCII input as single-byte frames with receipt/retry and decodes
   multi-byte TX output; it does not require another kernel flash. Native RX
   investigation should not hold up all Linux port work.
   Remaining multi-byte RX investigation is recorded in session 33. The original
   probe and the single-character fix are done: RX_DAT must be read before any
   printk; [90][01][char] reaches tty. The offset-2 hypothesis is unsupported.
   a. Keep len 3..14 as bounded diagnostics, buffer before printing and do not
      inject repeated/stale probe bytes into tty. Length 3 is not recovery.
   b. Obtain USB OUT evidence or a controlled host-path comparison, then actual
      SM8150 RX completion/advance and clock documentation. TX exclusion,
      200 us/2 ms/20 ms pacing, readb, nGnRnE and changed header ordering have
      already failed; do not repeat them unchanged. Installed qcusbser is older
      than the public WDF source. SWD restrictions do not establish COM gating.
   c. Only then wire more commands (recovery / EDL) into the length table.
   Reminders that still hold: start the host capture BEFORE the kernel boots so
   the device TX FIFO never backs up, and a silent EUD does not mean a crashed
   kernel - try a full power cycle first.  Host writes are only staged about 1
   time in 3, so send every command 3-5 times.
2. Latest kernel artifact: `logdump-rx33-console.img`, with the single-character
   RX fix, header/first-data lock, actual mapbase and bounded multi-byte probe;
   older baseline `logdump-tty6.img` remains available. Current state and hashes
   are in session 33. Only logdump was flashed this session. Back to Android with
   `cd E:\edk2-samurai-out; .\flash-and-test-rx.ps1 -RestoreAndroid`.
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

    master = 38bf2b8  docs: mark raw EUD captures as binary fixtures
             79b0f9d  eud: protect RX header access and record FIFO investigations
             f9b6f8a  eud: fix single-character RX and record hardware probe evidence
             649c90d  linux-port: mirror the Linux side of the port into the repo
             2184dc1  docs: anchor the Repo state count to the tip the block names
             6658232  docs: regenerate the whole Repo state block, no stale duplicate
             4903417  docs: generate the handover Repo state block from git, and check it
             47121ad  linux-port: make the push retry in sync-docs-to-repo.sh actually retry
             b1657b2  docs: refresh the handover - current repo state and the real open questions

    59 commits ahead of upstream origin/master, as of the tip named above;
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
* Multi-byte RX: id 0x90 and the first payload byte are verified. Pre-read printk
  changes the result to 0x90; the underlying hardware mechanism and subsequent
  byte advancement remain unproven. Current probes gate only the message start,
  collect at most len bytes and print afterward; they never feed unverified
  multi-byte data to tty (RX-CONSOLE.md, sessions 32/33). Whole-frame TX
  exclusion still fails; production COM gating remains an unproven hypothesis.

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

Rules that keep this file from growing again:

* The living sections stay here; never append a session log to this file.
* A new session writes one file - `sessions/NN-<topic>.md`, or
  `linux-port/docs/NN-<topic>.md` for the Linux side - and adds one row above.
* One fact, one file; mirrors point at the source and never carry their own copy.

The complete pre-split text is kept verbatim in `archive/HANDOVER-NEXT-full-2026-10-08.md`.
