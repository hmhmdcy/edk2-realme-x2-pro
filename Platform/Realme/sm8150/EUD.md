# EUD (Embedded USB Debug) on the realme X2 Pro

EUD is a debug hub built into almost every Qualcomm SoC since ~2018. When it is
enabled it hijacks the USB port and exposes a small USB hub (VID 0x05C6) with
debug devices the host can drive: CTL (control), JTAG, SWD, TRACE and COM.
The CTL channel alone is enough to enable/attach the other peripherals.

## Device facts (verified on this unit)

| Item | Value |
|---|---|
| Device tree node | qcom,msm-eud@88e0000, compatible qcom,msm-eud |
| Base / size | 0x088E0000 / 0x2000 (inside PERIPH_SS) |
| Interrupt | GIC SPI 492 |
| Kernel driver | eud, bound to 88e0000.qcom,msm-eud |
| Kernel enable knob | /sys/module/eud/parameters/enable (root only), default 0 |
| Fuses | not disabled - EUD works on this retail unit |

## Enable from Android (verified 2026-10-06)

    adb shell
    su
    echo 1 > /sys/module/eud/parameters/enable

The host then sees a Qualcomm hub (VID_05C6&PID_9500) plus the EUD control
device (VID_05C6&PID_9501). EUD takes over the port: adb / fastboot / USB mass
storage stop working. A full power cycle (hold Power ~15 s) restores normal USB;
a warm reboot can keep EUD on and hide fastboot.

## Register writes (what the kernel does)

    writel(BIT(0),             eud_base + 0x1014);  /* EUD_REG_CSR_EUD_EN */
    writel(BIT2 | BIT3 | BIT4, eud_base + 0x0024);  /* INT1_EN_MASK */

This node has no qcom,secure-eud-en, so plain non-secure MMIO is enough - which
is exactly why EDK2 can do the same.

## EDK2 firmware enable (VERIFIED on hardware 2026-10-06)

Implemented in PlatformBm.c under #ifdef SAMURAI_ENABLE_EUD (set in
samurai.dsc). In PlatformBootManagerAfterConsole the firmware writes the two
registers ten times, 200 ms apart, and prints to the framebuffer console:

    [SAMURAI-EUD] CSR_EUD_EN=0x00000001 INT1_EN_MASK=0x0000001c

Test image: E:\edk2-samurai-out\boot-samurai-eudtest.img
sha256 a2819fbafe2e2eb4774fcdd22c4cb7ac2c1d718b463e30c8638835575e8b1ce8
(= release3 + EUD; release3 already carried the three-button fix.)

Host-side result after flashing and rebooting (2026-10-06 17:19):

    9500 hub + 9501 control device appear immediately
    eudtool probe -> opcode 0x01 => 00 00 05 00
                     opcode 0x02 => A1 28 BC 62
                     opcode 0x03 => 04 00 00 00

Do not try to verify this by grepping the boot image: SM8150_UEFI.fd contains a
compressed FVMAIN_COMPACT, so the marker is not visible. Check the uncompressed
build products instead:

    Build/samurai/RELEASE_GCC5/FV/FVMAIN.Fv      (strings -el | grep SAMURAI-EUD)
    Build/samurai/RELEASE_GCC5/AARCH64/Platform/RenegadePkg/Library/
        PlatformBootManagerLib/PlatformBootManagerLib/OUTPUT/PlatformBm.obj

## Host access from Windows (verified; no Zadig, no usbipd, no WSL)

The Qualcomm QDSS driver that is already installed on this PC (qdbusb.sys via
oem58.inf) binds the EUD control device and creates a DOS device name:

    QueryDosDeviceA(NULL, ...)  ->  "Qualcomm EUD Control Device 9501"

Open it at:

    \\.\Qualcomm EUD Control Device 9501\DEBUG

There is no "(0003)" instance suffix on this unit - the "(NNNN)" names quoted in
older Qualcomm documents do not exist here, and brute-forcing them fails with
ERROR_PATH_NOT_FOUND.

### CTL protocol

One request = one opcode byte plus an optional little-endian payload; the
response is read from the same handle. Opcodes (ctl_eud.h):

| Opcode | Name | Send bytes | Recv bytes |
|---|---|---|---|
| 0x01 | EUD_VERSION_READ | 1 | 4 |
| 0x02 | DEVICE_ID_READ | 1 | 4 |
| 0x03 | EUD_STATUS_READ | 1 | 4 |
| 0x07 | CTLOUT_SET | 5 (opcode + LE u32 mask) | 0 |
| 0x08 | CTLOUT_CLR | 5 | 0 |

CTLOUT bit positions: bit2 SWD_PERIPH_EN, bit3 TRACE_PERIPH_EN,
bit4 JTAG_PERIPH_EN, bit5 COM_PERIPH_EN, bit12 VBUS_ATTACH, bit13 VBUS_INT.

IMPORTANT: CTLOUT_SET / CTLOUT_CLR return no data. Reading after them blocks
forever on a synchronous handle; write only, or use overlapped I/O with a
timeout.

### Bringing up the COM peripheral (verified)

    CTLOUT_CLR 0x00000000
    CTLOUT_SET 0x00000020   # COM_PERIPH_EN
    CTLOUT_SET 0x00001000   # VBUS_ATTACH
    CTLOUT_SET 0x00002000   # VBUS_INT
    sleep ~100-200 ms
    CTLOUT_CLR 0x00002000   # clear VBUS_INT

Result: the hub then reports USB\VID_05C6&PID_9505. Without the VBUS attach step
it only reported USB\VID_0000&PID_0002 ("device descriptor request failed"), so
the attach step is required.

### Known gap: no Windows driver for 9505

After the sequence above the 9505 device enumerates correctly
(HardwareIds USB\VID_05C6&PID_9505&REV_0100, compatible Class_FF) but has
ProblemCode = 28 ("the drivers for this device are not installed"), empty Class
and no COM port.

Reason: Qualcomm's own C:\Windows\INF\oem69.inf has the 9505 entry commented
out:

    ;%QcomDevice9505%   = QportInstall00, USB\VID_05C6&PID_9505
    QcomDevice9505      = "Qualcomm EUD Port 9505"

The public qualcomm/qcom-usb-userspace-drivers repo has no INF for 9505 and no
signed catalog either (only qcusbfilter.sys), so the serial driver cannot simply
be installed from there.

Options for getting EUD COM data to the host:

    A. Bind WinUSB to 9505 (Zadig, admin once), then read it with libusb.
       quic/eud's libeud.dll is already built on this machine (see below).
    B. usbipd bind 9505 -> attach to WSL, then use linux-msm/openocd or the
       Linux build of quic/eud.
    C. Supply a signed serial INF for VID_05C6&PID_9505 (qcusbser).

SWD (9504) and JTAG (9503) are listed, not commented out, in oem58.inf, but
CTLOUT_SET 0x645 (SWD payload) + attach did not make 9504 appear on this unit.

## Host tools built for this project (Windows)

Everything lives in E:\eud-host\ :

| File | What it does |
|---|---|
| eudtool.exe / eudtool.cpp | probe / attach / detach / com-up / com-off / raw / list |
| eudraw.exe / eudraw.cpp | first raw opcode test (0x01 / 0x02 / 0x03) |
| dosdev.exe / dosdev.cpp | enumerate DOS device names via QueryDosDevice |
| opentest.exe / opentest.cpp | CreateFile variant matrix for the CTL node |
| quic-eud/ | quic/eud clone, libeud.dll built with MSYS2 UCRT64 |
| eud-probe.exe | probe linked against libeud.dll (the library uses libusb on
  Windows, so it cannot see the device while qdbusb is bound - use eudtool) |

MSYS2 lives at E:\msys64 (UCRT64 environment). Rebuild eudtool with:

    export MSYSTEM=UCRT64
    E:\msys64\usr\bin\bash.exe --login
    cd /e/eud-host && g++ -o eudtool.exe eudtool.cpp

Typical use with the phone already in EUD mode:

    E:\eud-host\eudtool.exe probe
    E:\eud-host\eudtool.exe com-up

## OpenOCD (host debugger, still the plan for JTAG/SWD)

    git clone https://github.com/linux-msm/openocd
    cd openocd && git submodule update --init
    ./bootstrap
    ./configure --enable-eud --disable-linuxgpiod
    make -j"$(nproc)"
    ./src/openocd -d -f tcl/interface/eud.cfg -f tcl/target/qualcomm/<target>.cfg

On this Windows machine prefer the native CTL path above for enable/attach and
use OpenOCD only once a JTAG/SWD device is reachable (WSL + usbipd, or a native
Linux host).

## Caveats

* While EUD is enabled the USB port is unavailable (no fastboot / UMS) until the
  next power cycle.
* EUD grants full JTAG/SWD access (halt, breakpoints, arbitrary memory access).
  Treat it as a debug tool, do not leave it enabled on a device with sensitive
  data.
* On fused-off SoCs, or where the mode manager is secure-only, the writes
  silently do nothing. Not this unit.

## Windows COM driver for 9505 (installed 2026-10-06)

The EUD COM device enumerates as USB\VID_05C6&PID_9505 but Windows has no
in-box driver, and Qualcomm's current INFs comment the EUD product IDs out
(qcom-usb-kernel-drivers RELEASES.md: "Remove EUD product IDs from INFs").
A working WHQL-signed package still ships inside the older QUD.WIN.1.1
installer 10057.4:

    source : https://mirrors.lolinet.com/software/windows/Qualcomm/QUD/
             qud.win.1.1_installer_10057.4.zip
    sha256 : 5ADE2447F8CA75CED0EE61C7B5641DB76CF6D1B8A85C423C1F1EC2D0ECEF2B9A
    inside : Setup.exe -> MSI -> Data1.cab -> qcser.inf (DriverVer 12/17/2018,
             2.1.3.5), qcser.cat, qcusbser.sys
    signing: qcser.cat and qcusbser.sys are Valid WHQL
             (CN=Microsoft Windows Hardware Compatibility Publisher)
    local  : E:\eud-host\qud_10057.4.zip and unpacked E:\eud-host\qud_cab\

qcser.inf carries the 9505 model line for every architecture:

    %QcomDevice9505% = QportInstall00, USB\VID_05C6&PID_9505

Install (admin). The INF expects the driver binary under serial\<arch>\, so if
you unpack the cab yourself you must recreate that layout first:

    mkdir E:\eud-host\qud_cab\serial\amd64
    copy E:\eud-host\qud_cab\qcusbser.sys E:\eud-host\qud_cab\serial\amd64\
    pnputil /add-driver "E:\eud-host\qud_cab\qcser.inf" /install
    pnputil /scan-devices

Result on this machine (2026-10-06 17:4x):

    published name : oem102.inf
    device         : USB\VID_05C6&PID_9505\8&5580DC5&0&5
    status         : OK, Class=Ports, service=qcusbser, problem=0
    friendly name  : Qualcomm EUD Port 9505 (COM14)
    open test      : COM14 opens at 115200; ReadByte times out (expected -
                     the firmware does not write COM output yet)

Notes:
* Only qcser.inf is needed. Do NOT install qdbusb.inf / qcfilter.inf from the
  same package - the working QDSS CTL binding (oem58.inf) must stay.
* The 9505 device must exist first: enable EUD, then run eudtool com-up.
* Full log chain: firmware writes the EUD COM TX FIFO, Windows reads COM14.

## Firmware side: EUD COM TX (next step)

The host side is now complete. What is still missing is on the target:

    TX_ID   0x088E0000   (execution environment id, APPS = 0x81)
    TX_LEN  0x088E0004
    TX_DATA 0x088E0008

Planned: a minimal TX-only write from the BDS EUD block (fixed string), then a
proper SerialPortLib so DEBUG() output goes out over COM14.

## EDK2 side: DEBUG over EUD COM (verified 2026-10-07)

EudSerialPortLib (Platform/Realme/sm8150/Library/EudSerialPortLib) implements
SerialPortLib by writing DEBUG() output into the EUD COM TX FIFO.

Wiring (samurai.dsc): SerialPortLib is overridden only for the module-type
scopes DXE_DRIVER, DXE_RUNTIME_DRIVER, UEFI_DRIVER and UEFI_APPLICATION.
PrePI/PEI/SEC and DXE_CORE keep FrameBufferSerialPortLib.  That matters:

  * PrePI/PEI run before the EUD block is enabled;
  * DxeCore owns the page tables and must not run extra MMIO/delay code early.

Frame format (verified on hardware):

    [ID=0x90][LEN][DATA...]

  * TX_ID   0x088E0000 <- 0x90 (UART_ID)
  * TX_LEN  0x088E0004 <- payload length of this frame
  * TX_DAT  0x088E0008 <- payload byte

A whole string written in one go is truncated by the TX FIFO after ~7 payload
bytes, so the library sends it in 6-byte frames (200 us between bytes, 2 ms
between frames).  The host must reassemble the frames.

Gate: SerialPortWrite() only transmits once CSR_EUD_EN (0x1014) low byte is 1,
i.e. after the BDS block enabled EUD.  It re-checks the gate every 256 calls so
the pre-BDS cost stays at zero.

Host-side capture (verified):

    E:\eud-host\eudtool.exe com-up
    E:\eud-host\comlog.exe COM14 600 E:\eud-host\eud-com.log

Result: "[SAMURAI-EUD-COM] SerialPortLib test 29" was reassembled from COM14,
proving EDK2 -> EUD COM 9505 -> qcusbser -> COMx -> host log.

### Crash lesson (2026-10-06, build with PcdDebugPrintErrorLevel=0x800B05C7)

Enabling full DEBUG globally while the library was also assigned to DXE_CORE
crashed the boot in DxeCore/CpuDxe:

    ReplaceTableEntry: splitting block entry with MMU disabled
    Synchronous Exception at ArmCpuDxe.dll+0x34B8
    (ELR 0x...F4B8, LR 0x...F518, ESR 0x02000000, stack corrupted)

Fix: keep the platform default PcdDebugPrintErrorLevel (0x80000000, ERROR only)
and never override SerialPortLib for DXE_CORE.  To get INFO-level logs later,
raise the level per module (component <PcdsFixedAtBuild>) rather than globally,
or make the library non-blocking (ring buffer drained by a timer event).
