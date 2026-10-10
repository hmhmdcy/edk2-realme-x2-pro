# Session handover - realme X2 Pro (samurai) EDK2/UEFI

> Updated 2026-10-10 (Asia/Shanghai).  Sections 0-7 below are the living part:
> current state, next steps, repo state, tools, pitfalls, safety, open questions.
> The history (former sections 8-30) now lives in exactly one file per section -
> see the index at the end of this file.  Read DOCS-INDEX.md for the whole map.
> Companion documents: DOCS-INDEX.md, README.md, EUD.md, BINARIES.md,
> linux-port/README.md.

## 0. TL;DR - where the project stands (2026-10-10, session88 Wi-Fi build and handover)

session88继续Wi-Fi适配；充电阶段保持收尾，显示与充电未解决项保留待办。
手机仍#86，boot ID=32bf2d8f-8dde-47dc-9b88-e87db9e95198；3984.69秒taint0。
当前网络接口只有lo/usb0，Wi-Fi未上线；显示超时2/下溢0，display on0/count=0。
真实显示故障快照摘要与86/87一致；本轮没有清空/重武装、开关屏、重启或分区写入。
宿主Wi-Fi依赖内核#89编译完成，27项配置变化；QRTR/QMI/GLINK/PAS/SYSMON/PD和ath10k SNOC内建。
保留全部此前源码修复/模式、14个initramfs文件/308链接及原CPIO；本轮源码仅MPSS DTS增量。
#89候选MPSS节点okay、同机modem.mdt路径，但PAS auto_boot=false；Wi-Fi节点仍disabled。
33项本机MPSS分段固件只读归档/哈希通过，ELF可重定位范围160MiB正好适合既有保留区。
本机msm/modem/wlan_pd、实例180与当前主线PD mapper对应；35项Wi-Fi固件沿用81/87校验。
静态AArch64 qrtr-lookup/tqftpserv-ro构建完成；真实翻译/WRQ函数本地测试拒绝写、越界和符号链接。
测试使用本地文件与socket桩，未验证实际QRTR服务；工具/固件尚未安装，MPSS尚未启动。
关键发现：实际Linux DT来自EDK2内嵌DTB，单改logdump FAT中的DTB不能激活MPSS。
EDK2内嵌DTB未改，boot固件未构建，#89尚未打包/部署；chip/board ID及扫描/连接/流量均未知。
Image-wifi sha=02fbe7e5d20cc2a0f5b55e08511ee9a1a39d2c47516079569fe8dc2368360ea0。
完整构建/固件/测试/现场/边界见sessions/88-wifi-dependency-build-and-read-only-firmware-service.md。

## 1. What to do next, in order

1. 先读sessions/88、reference/kernel88与kernel88私人目录；再读87依赖、81固件/供电、79和68实际DT路径。
   宿主#89已经构建，先核对Image/config/DTB/CPIO哈希和保留审计，不重复运行拒绝覆盖的构建脚本。
   #89含87显示timer候选和86 MP观测修正，均未实机验收；不把构建通过当硬件通过。
2. 下一步构建实际boot固件：备份EDK2内嵌DTB/FV/boot，采用#89 DTB，审查语义仅MPSS两个属性变化。
   实际入口为Platform/Realme/sm8150/FdtBlob/samurai/sm8150-realme-samurai.dtb；兼容DTB保持。
   参考79/68的FV/模块/BootShim/Android头/版本差异验证；不要复用旧会话的固定守卫。
   当前EDK2仓库HEAD=a9e7e86；本次文档提交后固件版本字符串可能变化，应以实际构建HEAD重新核对。
   生成私有boot及logdump候选，#89 Image/DTB放入原FAT，检查容量、来源和全部保留项。
3. 刷写前重新确认手机boot ID、保存完整dmesg/display snapshot/trace/DRM状态，并备份当前#86 boot/logdump。
   用新会话新守卫核对PARTNAME/大小/序列/UFS型号/哈希；逐项检查原生命令退出码，F1后finally释放。
   仅已授权boot/logdump，保留Android/数据/GPT；kernel86/flash-final.ps1停止保护保持，不重放旧OUT。
   #89启动后先验证/proc/device-tree实际MPSS节点、remoteproc offline、QRTR与USB/EUD/触摸/电量计。
4. 固件/工具仅临时RAM目录部署并核对哈希，配置SAMURAI_TFTP_FIRMWARE_ROOT；不提供可写存储服务。
   重新审查显式MPSS启动条件，观察WLFW/PD/TFTP和运行时故障，再取实际chip/board ID选择精确板数据。
   PAS auto_boot=false，Wi-Fi仍disabled；不任挑35个bdwlan之一，不混用他机mdsp，不启动未审阅rmtfs/NV服务。
   接着接入Wi-Fi节点、无线接口、扫描/连接及实际流量；这些步骤当前都尚未通过。
5. 充电和显示保留待办；继续全硬件目标，Wi-Fi之后再蓝牙/音频等，避免重复消耗在充电状态查询上。

Linux源码/home/cy122/x2pro-linux/linux；initramfs/home/cy122/x2pro-linux/initramfs。
私有产物E:/edk2-samurai-out/kernel88；公开只发布增量源码/patch/摘要/证据/doc到fork/master。
完整固件/源码/配置/生成头/镜像/可执行工具/身份留私有目录；历史85/86/87封存不改。
EUD TOP_CFG0x11、整帧/RX53/F1/两终端保持；既有com-up只恢复COM/VBUS，不写CHGR。
充电不写配置/解封/NVM/OTP/FET/OTG/GPIO/MCU，不跑OEM charger probe，不读0051/0053/0072或REG14，不用I2C_FORCE。
最新已采分区摘要见88提取记录与86；部署前必须重新读并核对，不能以旧摘要代替新守卫。

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

    master = a9e7e86  samurai: close charging stage and prioritize Wi-Fi prerequisites
             b3e3f11  samurai: observe MP2650 input and preserve real display timeout
             60e5b9f  samurai: verify OEM chemistry and short-IC observations
             3e308c0  samurai: deploy boot display traces and timeout snapshots
             7c53c0b  samurai: compare Android R and cyborg charging sources
             1d1bc31  samurai: audit charge policy units and Android backup provenance
             2f82b23  samurai: verify stock cell reads and record gauge identity difference
             ce1352f  samurai: enable bounded MP2650 observations and record current settings
             3dd07f4  samurai: record first-boot controls and event-checked page flips
             efeba61  samurai: enable BQ28Z610 monitoring and record display regression
             136157b  samurai: audit charging sources and safety boundaries
             89ab2a5  samurai: normalize session75 evidence file modes
             c2564b6  samurai: validate A640 rendering and fix SOFEF03F DSI clock mode
             20a1d60  samurai: quiesce SM8150 boot display before IOMMU handoff
             523d195  samurai: enable native SOFEF03F DSC display and record hardware tests
             bd23aaa  samurai: enable automatic USB NCM and public-key SSH
             964362e  samurai: enable native S3706 touch and record hardware handover
             0819bd5  samurai: audit PM8009 resource scope and native touch prerequisites
             218812b  samurai: audit USB gadget state and EUD coordination

    118 commits ahead of upstream origin/master, as of the tip named above;
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
| Android rollback boot (custom kernel) | E:\edk2-samurai-out\backup\boot_stock_RMX1931.img |
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
6. F1 explicitly releases EUD before restarting to bootloader. This is verified
   on this handset. EUD being enumerated does not establish that ordinary Linux
   USB must be exclusive; the actual gadget/role path is still untested.

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

* How should USB OTG, suspend/resume and long-term stability be enabled and verified?
  CDC NCM/SSH/SCP with Windows UsbNcm and EUD coexistence now work; USB3 remains unverified.
* Does the new touch input retain correct physical contact count, orientation,
  edge accuracy and suspend/resume behavior? Basic recorded input now works.
* What board-native panel/DSI/DSC, GPU firmware and power descriptions are
  needed to replace the inherited framebuffer with accelerated native display?
* How can a full persistent rootfs be provided while preserving Android and all
  data? The current logdump FAT only has about34.35MiB free; userdata FBE/ICE
  access and a safe large layout have not been established.
* CPU high-frequency load, battery/charging and the remaining functional groups
  still need board-specific implementation and acceptance; see HARDWARE-STATUS.

The EUD console reaches Linux userspace and F1 returns to independently
enumerated fastboot. Native RX advancement and RX53 console/IRQ are verified;
intermittent TX loss remains documented in session65. The deferred EUD/Windows
driver work is background evidence, not the next hardware implementation task.
Historical SWD/JTAG evidence and its unresolved AP DAP response stay in SWD-JTAG.md.

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
| 43 | Correct RX41 missing-output claims from unchanged raw evidence; actual BusyBox/tty/TX audit, repaired-config USB comparison and final live state | `sessions/43-native-terminal-evidence-audit.md` |
| 44 | RX counters narrow failed native inputs to no observed pending; retained native output/F1, source review and qualified fuse/policy evidence | `sessions/44-rx-receipt-counters.md` |
| 45 | Persistent RX mask before arrival remains insufficient; exact native 14-byte output/F1, restored RX44 baseline, fuse-claim correction | `sessions/45-rx-mask-before-arrival.md` |
| 46 | Real IRQ reception and absent notification for a failed Windows command; exact outputs/F1, libusb comparison and host ETW instrument | `sessions/46-rx-irq-and-host-trace-boundary.md` |
| 47 | Continuous native terminal/startup sync, reopen losses and ETW endpoint resets; real TX text loss, measured watchdog fallback and F1 | `sessions/47-native-terminal-session-boundary.md` |
| 48 | Bounded IRQ grace and CRC-protected issued-TX journal; 512 frames matched, wait branches unexercised, compatibility/F1/reboot preserved | `sessions/48-irq-grace-and-tx-journal.md` |
| 49 | Complete virtual USB IN/raw comparison, seven offline audits and real partial cancellation retained; unchanged kernel, physical stability still open | `sessions/49-usb-in-and-partial-timeout-audit.md` |
| 50 | Current connection normal; Windows receive observation and exact installed-driver buffer/status audit, 287 overlapping TX frames match; no old fault reproduced | `sessions/50-windows-receive-and-driver-buffer-audit.md` |
| 51 | Busy-console native receipt failure and one issued 4-byte console frame absent from raw; 511/512 direct cross-owner matches, unchanged image | `sessions/51-console-overlap-and-issued-frame-loss.md` |
| 52 | Same-owner busy-console RX loss with complete OUT/IN; continuous IN improves requeue gap and TX match in one contrast, RX remains unresolved | `sessions/52-same-owner-usb-overlap-and-continuous-in.md` |
| 53 | Console-boundary whole-frame RX succeeds on USB/Windows, compatibility/F1/reboot preserved; final issued four-byte TX prefix still lost | `sessions/53-console-boundary-rx-service.md` |
| 54 | Nine manual console RX overlaps and console F1 pass on unchanged candidate; six credited empties, exact Windows worker/GET_STATS audit, TX gap still open | `sessions/54-console-rx-regression-and-host-counter-audit.md` |
| 55 | Reproduced seq7376 TX gap before Windows accepted-buffer count; first startup receipt still missing, unchanged candidate | `sessions/55-windows-perf-counter-and-reproduced-tx-gap.md` |
| 56 | Repair/measurement synthesis, exact pre-buffer/reset/padding boundaries and focused new sources; read-only, no stability fix | `sessions/56-source-boundaries-and-focused-research.md` |
| 57 | Built-in pre-buffer logger measured; 9550 driver/counter/raw bytes and 512 journal matches, restored configuration; old faults untriggered | `sessions/57-driver-raw-logging-boundary.md` |
| 70 | Verified cmd-db/full dmesg, unused PM8009 resource warning lowered to P3, native touch prerequisites and rootfs capacity audited | `sessions/70-pm8009-resource-and-touch-prerequisites.md` |
| 76 | Charging sources, own archived DT differences, BQ28Z610 mainline path and MP2650 safety boundaries; read-only, hardware unchanged | `sessions/76-charging-source-and-safety-review.md` |
| 77 | Live BQ28Z610 gauge, two boots/45 samples, boot-only deployment; fresh-boot DSI underflow remains open | `sessions/77-bq28z610-live-gauge-and-display-regression.md` |

Rules that keep this file from growing again:

* The living sections stay here; never append a session log to this file.
* A new session writes one file - `sessions/NN-<topic>.md`, or
  `linux-port/docs/NN-<topic>.md` for the Linux side - and adds one row above.
* One fact, one file; mirrors point at the source and never carry their own copy.

The complete pre-split text is kept verbatim in `archive/HANDOVER-NEXT-full-2026-10-08.md`.
