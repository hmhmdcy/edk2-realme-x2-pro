# Session handover - realme X2 Pro (samurai) EDK2/UEFI

> Written 2026-10-06 16:4x (Asia/Shanghai) at the end of the session that fixed
> the side buttons and trialled EUD.

## TL;DR

* The port boots on hardware and **all three side buttons work** now:
  Volume-Up (`SCAN_UP`), Volume-Down (`SCAN_DOWN`), Power.
* Working image: `boot-samurai-release3.img`
  `sha256 c9feb0cab6abb66b4f3722f041449034d908c15bbf9a95b7903e394026360cde`
* **EUD (JTAG over the USB port) works on this retail unit** when enabled from
  Android. The EDK2-side enable is written and built
  (`boot-samurai-eudtest.img`, `sha256 a2819fba...`) but **has not been flashed
  or verified yet** - that is the next thing to do.
* The phone is currently running **Android** (stock boot image was restored).
* GitHub: `hmhmdcy/edk2-realme-x2-pro`, branch `master`.

## What changed in this session

| File | Change |
|---|---|
| `Platform/Realme/sm8150/samurai.fdf.inc` | factory `ButtonsDxe` + `OppoProject` + `ResetRuntimeDxe` + `TLMMDxe` |
| `Platform/Realme/sm8150/samurai.dsc` | `-DSAMURAI_ENABLE_EUD` appended to `GCC:*_*_AARCH64_CC_FLAGS` |
| `Platform/RenegadePkg/.../PlatformBm.c` | `#include <Library/IoLib.h>` + `#ifdef SAMURAI_ENABLE_EUD` block (~25 lines) |
| `tools/tools_def.txt` | `-std=gnu17` appended to `GCC_AARCH64_CC_FLAGS` (host GCC 15) |
| `Platform/Realme/sm8150/BINARIES.md` | new: where every firmware blob comes from |
| `Platform/Realme/sm8150/fetch-binaries.sh` | new: downloads all blobs + applies the DEPEX patch |
| `Platform/Realme/sm8150/fix-buttons-depex.py` | new: idempotent DEPEX patch |
| `Platform/Realme/sm8150/EUD.md` | new: EUD reference |
| `Platform/Realme/sm8150/README.md`, root `README.md` | updated (buttons fixed, EUD) |

The vendor firmware blobs now ship with the fork: `Platform/EFI_Binaries`
points at `hmhmdcy/edk2-msm-binary` branch `samurai-blobs` (commit `2420ecf`), so
`git clone --recursive https://github.com/hmhmdcy/edk2-realme-x2-pro.git`
produces a tree that builds as-is. `fetch-binaries.sh` remains as a fallback and
`E:\edk2-samurai-out\samurai-binaries.zip` is a local copy.

## Verified facts worth keeping

1. **The factory `ButtonsDxe` is the only one with a correct key map for this
   board** (Volume-Down is wired to a GPIO, not the PMIC PON real-time IRQ), but
   it is not self-contained. At run time it also needs
   * `EFI_QCOM_TLMM_PROTOCOL` (`TLMMDxe`),
   * the **OPPO project protocol** `903C579D-EBDE-19E0-39A7-43B95FA73F91`,
     installed by `OcdtDxe/OppoProject.efi`,
   * the **reset-reason protocol** `A022155A-4828-4535-A499-11F15240B91B`,
     installed by `ResetRuntimeDxe.efi`,
   * and it reads the SMEM project entry (`Project:19781`) to select the key map.
   If anything is missing the driver returns `EFI_NOT_FOUND`, gets unloaded, and
   **no** side button works.
2. `ButtonsDxe` locates the OPPO project protocol only at run time and it is not
   in its DEPEX, so `fix-buttons-depex.py` adds `903C579D` to the DEPEX -
   otherwise the dispatcher can start `ButtonsDxe` before `OppoProject` and the
   lookup fails intermittently-looking.
3. `6231E399-...` is a **generic** sm8150 `ButtonsDxe` protocol (every sm8150
   ButtonsDxe has it) - it is *not* the OPPO project protocol. An earlier
   analysis wrongly blamed it.
4. EUD: base `0x088E0000`; enable = write `1` to `+0x1014` and `0x1C` to
   `+0x0024`. Android: `su -c 'echo 1 > /sys/module/eud/parameters/enable'`
   makes the PC see `VID_05C6&PID_9500` (hub) and `PID_9501` (control device).
   EUD hijacks the USB port - **full power cycle** (hold Power ~15 s) to restore;
   a warm reboot can leave EUD enabled and hide fastboot.
5. edk2 `DEBUG()` strings survive in the RELEASE build (they appear as ASCII in
   the FV), but `Print(L"...")` is the convenient way to get a marker that is
   both verifiable with `grep` and visible on the framebuffer.
6. The build is incremental: after touching `BuildOptions` in the DSC, always
   confirm the compiled artefact really contains the new code (grep the FV)
   before flashing.

## Next steps, in order

1. **Flash and verify the EDK2-side EUD enable** (`boot-samurai-eudtest.img`):
   * power the phone **fully off** (hold Power ~15 s) first - a warm reboot can
     keep EUD on, and then fastboot is unreachable;
   * `fastboot flash boot E:\edk2-samurai-out\boot-samurai-eudtest.img`, boot;
   * expect on screen:
     `[SAMURAI-EUD] CSR_EUD_EN=0x00000001 INT1_EN_MASK=0x0000001c`
     and on the PC: `VID_05C6&PID_9500` + `PID_9501`;
   * recover with another full power cycle.
   * If nothing appears, the USB PHY probably is not up at BDS yet - move the
     writes later (a BDS callback inside the boot-manager menu, or an event that
     retries for longer).
2. **Stand up the host debugger** (`EUD.md`): `usbipd-win` + build
   `linux-msm/openocd` inside WSL, or use a native Linux machine.
3. **Comfort features** (none of them blocking):
   * `startup.nsh` on a FAT partition (the Shell cannot be typed into - only
     three keys exist);
   * samurai-specific DSDT for Windows;
   * `USE_DISPLAYDXE` + factory panel XML;
   * a RAM log ring buffer written by the firmware, so the full DEBUG log can be
     read over OpenOCD (or via pstore) instead of photographing the screen.
4. ~~Binary distribution~~ **done**: the submodule fork
   (`hmhmdcy/edk2-msm-binary` @ `samurai-blobs`) now carries the blobs, so
   `git clone --recursive` is self-contained. A GitHub Release asset is still an
   option if a downloadable bundle is wanted.

## Useful paths

| What | Where |
|---|---|
| EDK2 build tree (WSL) | `~/edk2-samurai/repo` |
| Build logs | `~/edk2-samurai/build-*.log` |
| Images / backups (Windows) | `E:\edk2-samurai-out\` |
| Stock boot (restores Android) | `E:\edk2-samurai-out\backup\boot_stock_RMX1931.img` (`dfe18875...`) |
| Device blobs (local copy) | `E:\edk2-samurai-out\samurai-binaries.zip` |
| Platform tools | `C:\Users\cy122\Downloads\platform-tools\platform-tools` |
| Vendor firmware dumps (WSL) | `~/uefifw/realme-rmx1931/Binaries/` |
| mu_aloha_platforms clone | `~/mu-aloha` (source of `OppoProject.efi`) |

## Safety

* Only ever flash the `boot` partition.
* Keep the stock boot image; it is the way back to Android.
* The `USB Attached SCSI (UAS) Storage` boot option exposes the phone's **raw
  UFS LUNs** to the host; never let the host OS initialise, repartition or format
  them.
* EUD disables fastboot/UMS while it is on; always recover with a full power
  cycle, not a warm reboot.