# EUD (Embedded USB Debug) on the realme X2 Pro

EUD is a debug hub built into almost every Qualcomm SoC since ~2018. When it is
enabled it hijacks the USB port and exposes a small USB hub (VID `0x05C6`) with
debug devices that `linux-msm/openocd` can drive - i.e. JTAG/SWD over the normal
USB cable, no disassembly, no UART wiring.

## Device facts (verified on this unit)

| Item | Value |
|---|---|
| Device tree node | `qcom,msm-eud@88e0000`, compatible `qcom,msm-eud` |
| Base / size | `0x088E0000` / `0x2000` (inside the `PERIPH_SS` MMIO region) |
| Interrupt | GIC SPI 492 (`<0 0x1EC 4>`) |
| Kernel driver | `eud`, built into the phone's kernel, bound to `88e0000.qcom,msm-eud` |
| Kernel enable knob | `/sys/module/eud/parameters/enable` (mode 0, root only), default `0` |
| Fuses | **not** disabled - EUD works on this retail unit |

## Enabling it from Android (verified 2026-10-06)

```sh
adb shell
su
echo 1 > /sys/module/eud/parameters/enable
```

The host PC then shows:

```
Qualcomm EUD Control Device 9501   USB\VID_05C6&PID_9501
USB hub                            USB\VID_05C6&PID_9500
```

Side effects: EUD takes over the USB port, so adb / fastboot / USB mass storage
stop working. A **full power cycle** (hold Power ~15 s) is required to get normal
USB back - a warm reboot can leave EUD enabled, and then fastboot is unreachable.

## Register writes (what the kernel does)

From the msm `drivers/soc/qcom/eud.c` - the same code path the phone runs:

```c
writel(BIT(0),                eud_base + 0x1014);  /* EUD_REG_CSR_EUD_EN            */
writel(BIT2 | BIT3 | BIT4,    eud_base + 0x0024);  /* INT1_EN_MASK: VBUS|CHGR|SAFE_MODE */
```

This SoC's DT node has no `qcom,secure-eud-en`, so no secure-world (SCM) call is
involved: plain non-secure MMIO is enough. That is exactly why EDK2 can do it too.

## Status inside the EDK2 port

Implemented, guarded by `-DSAMURAI_ENABLE_EUD` (set in `samurai.dsc`): in
`PlatformBm.c` -> `PlatformBootManagerAfterConsole` (BDS) the firmware writes the
two registers ten times, 200 ms apart, and prints to the framebuffer console:

```
[SAMURAI-EUD] CSR_EUD_EN=0x00000001 INT1_EN_MASK=0x0000001c
```

**Built, not yet flashed/verified on hardware** (2026-10-06 16:36):

    E:\edk2-samurai-out\boot-samurai-eudtest.img
    sha256 a2819fbafe2e2eb4774fcdd22c4cb7ac2c1d718b463e30c8638835575e8b1ce8

## Using it: OpenOCD on the host

```sh
git clone https://github.com/linux-msm/openocd
cd openocd && git submodule update --init
./bootstrap
./configure --enable-eud --disable-linuxgpiod
make -j"$(nproc)"
./src/openocd -d -f tcl/interface/eud.cfg -f tcl/target/qualcomm/<target>.cfg
```

Upstream OpenOCD is also getting an `adapter/eud` (SWD-over-EUD) implementation.

Notes for this machine (Windows + WSL):

* WSL needs access to the USB device: `winget install usbipd-win`, then
  `usbipd bind --busid <id>` (admin) and `usbipd attach --wsl --busid <id>`.
* WSL currently lacks `autoconf`, `automake`, `libtool`, `pkg-config` and
  `libusb-1.0-dev`, and there is no sudo - use the project's
  `apt-get download` + `dpkg-deb -x` trick to install them under `~/.local`.
* A native Linux host needs far less setup.

## Caveats

* While EUD is enabled the USB port is unavailable (no fastboot / UMS) until the
  next power cycle.
* On SoCs where EUD is fused off, or where the mode manager is secure-only, the
  writes silently do nothing. Not the case on this device.
* EUD grants full JTAG/SWD access (halt, breakpoints, arbitrary memory access).
  Treat it as a debug tool - do not leave it enabled on a device that holds
  sensitive data.
* EUD is independent of the framebuffer console: the DEBUG log keeps working.