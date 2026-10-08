# EUD RX side: registers, framing and the console driver

> Split out of EUD.md on 2026-10-08; verbatim from there.  The TX side and the firmware
> log ring are in EUD.md.

---

## RX side: registers, framing and the console driver (2026-10-08)

Earlier sections describe the transmit direction.  This one is the receive
direction, measured on this unit.

Registers inside the 0x2000 window (every readback replicates the low byte into
the four lanes, so mask with 0xff):

| offset | meaning |
|---|---|
| 0x0c | RX_ID - latch holding the id of the last message the host wrote |
| 0x10 | RX_LEN - latch holding that message's length |
| 0x14 | RX_DAT - FIFO read port: every read pops one payload byte |
| 0x40 | INT_STATUS_0 - 0x00 idle, 0x02 while RX data is pending |
| 0x44 | INT_STATUS_1 - 0x06 idle, 0x07 while RX data is pending (BIT(0)) |
| 0x20 | INT0_EN_MASK - reads 0; writing 0xff reads back 0x1f (five bits) |
| 0x60 | reads 0x0b0b0b0b, undocumented |

Protocol: the host writes [id][len][payload...] as one transfer; the device
reads id from 0x0c, len from 0x10 and then reads 0x14 `len` times for the
payload.  Unframed writes are dropped by the device entirely.  The status bits
are not reliable enough to gate on (they can read idle while data is pending),
so new data is detected by watching the 0x0c/0x10 latch pair change.

Ids used by this port: 0x82 = tty input (the payload goes to /dev/ttyEUD0),
0x81 = command channel (payload[0] is the command code: 0x01 ping, 0x02 register
dump, 0x03 status).  0x90 is the id the device uses when it transmits.

The kernel driver is drivers/tty/serial/eud.c: a uart driver ("ttyEUD") with a
workqueue transmit path paced at 200 us per register write and 2 ms per frame, a
20 ms RX poll, and a console that registers only when the command line contains
"console=eud" - otherwise the early console is a second writer on the same seven
entry FIFO and the two interleave byte by byte.

Caveat: reading 0x14 too eagerly wedges the EUD COM block.  The console goes
silent (the 9501 control device and the COM port stay up) until a full power
cycle.  Only read it once a complete payload is certain.
