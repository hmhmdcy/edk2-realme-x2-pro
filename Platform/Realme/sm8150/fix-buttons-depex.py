#!/usr/bin/env python3
"""Add the OPPO project-protocol GUID to the factory ButtonsDxe DEPEX.

The factory realme/OPPO ButtonsDxe looks up the OPPO project protocol
(903C579D-EBDE-19E0-39A7-43B95FA73F91, installed by OppoProject.efi) with
LocateProtocol() at run time, but that dependency is *not* in its DEPEX.
If the DXE dispatcher happens to dispatch ButtonsDxe before OppoProject,
the lookup fails, ButtonsDxe returns EFI_NOT_FOUND and is unloaded, and
*no* side button works at all.

Adding the GUID to the DEPEX makes the dispatcher guarantee the ordering.

Usage:  python3 fix-buttons-depex.py [path/to/ButtonsDxe.depex]
"""
import io, struct, sys

OPPO_PROJECT_GUID = '903C579D-EBDE-19E0-39A7-43B95FA73F91'
PUSH, AND, END = 0x02, 0x03, 0x08
DEFAULT = 'Platform/EFI_Binaries/Drivers/Devices/samurai/ButtonsDxe/ButtonsDxe.depex'


def guid_bytes(s):
    p = s.split('-')
    return (struct.pack('<IHH', int(p[0], 16), int(p[1], 16), int(p[2], 16))
            + bytes.fromhex(p[3]) + bytes.fromhex(p[4]))


def main(path):
    d = io.open(path, 'rb').read()
    guids, i = [], 0
    while i < len(d):
        op = d[i]; i += 1
        if op == PUSH:
            guids.append(d[i:i + 16]); i += 16
        elif op == AND:
            pass
        elif op == END:
            break
        else:
            raise SystemExit('unsupported depex opcode 0x%02X at offset %d' % (op, i - 1))
    want = guid_bytes(OPPO_PROJECT_GUID)
    if want in guids:
        print('already patched: %s' % path)
        return 0
    guids.append(want)
    out = (b''.join(bytes([PUSH]) + g for g in guids)
           + bytes([AND]) * (len(guids) - 1) + bytes([END]))
    io.open(path, 'wb').write(out)
    print('patched %s: %d bytes, %d PUSH, %d AND' % (path, len(out), len(guids), len(guids) - 1))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else DEFAULT))
