#!/usr/bin/env python3
"""Verify a built samurai boot image against its firmware inputs."""

from __future__ import annotations

import hashlib
import struct
import sys
import zlib
from pathlib import Path

DEVICE_ROOT = Path(__file__).resolve().parents[1]
REPO_ROOT = DEVICE_ROOT.parents[2]
BOOT_IMAGE = REPO_ROOT / "boot-samurai.img"
BOOT_SHIM = REPO_ROOT / "tools/BootShim/BootShim.bin"
FIRMWARE = REPO_ROOT / "workspace/Build/samurai/RELEASE_GCC5/FV/SM8150_UEFI.fd"
COMPAT_DTB = DEVICE_ROOT / "FdtBlob_compat/samurai.dtb"


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def fail(message: str) -> None:
    print(f"FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> int:
    for path in (BOOT_IMAGE, BOOT_SHIM, FIRMWARE, COMPAT_DTB):
        if not path.is_file():
            fail(f"missing build input: {path}")

    image = BOOT_IMAGE.read_bytes()
    if len(image) < 2048:
        fail("boot image is shorter than its first page")

    (
        magic,
        kernel_size,
        kernel_addr,
        ramdisk_size,
        ramdisk_addr,
        second_size,
        second_addr,
        tags_addr,
        page_size,
    ) = struct.unpack_from("<8sIIIIIIII", image, 0)

    if magic != b"ANDROID!":
        fail(f"unexpected boot image magic: {magic!r}")
    if page_size not in (2048, 4096, 8192):
        fail(f"unsupported boot image page size: {page_size}")
    if (kernel_addr, ramdisk_addr, tags_addr) != (0x10000000, 0x10000000, 0x10000000):
        fail("kernel, ramdisk and tags load addresses do not match the samurai layout")
    if ramdisk_size not in (0, 1):
        fail("samurai boot image unexpectedly contains a userspace ramdisk")
    if second_size:
        fail("samurai boot image unexpectedly contains a second stage")
    if page_size + kernel_size > len(image):
        fail("boot header kernel size extends beyond the image")

    payload = image[page_size : page_size + kernel_size]
    ramdisk_start = (page_size + kernel_size + page_size - 1) & -page_size
    if ramdisk_size == 1 and image[ramdisk_start : ramdisk_start + 1] != b"\n":
        fail("the one-byte placeholder ramdisk is not the expected newline")
    compat_dtb = COMPAT_DTB.read_bytes()
    if compat_dtb[:4] != b"\xd0\x0d\xfe\xed":
        fail("compat DTB does not start with the FDT magic")
    if payload[-len(compat_dtb) :] != compat_dtb:
        fail("compat DTB is not appended byte-for-byte to the boot payload")

    try:
        embedded = zlib.decompress(payload[: -len(compat_dtb)], 16 + zlib.MAX_WBITS)
    except zlib.error as error:
        fail(f"boot kernel is not a valid gzip stream: {error}")

    expected = BOOT_SHIM.read_bytes() + FIRMWARE.read_bytes()
    if embedded != expected:
        fail("decompressed boot payload is not BootShim.bin + SM8150_UEFI.fd")

    print(f"boot image: {len(image)} bytes, kernel payload: {len(payload)} bytes")
    print(f"firmware:   {len(FIRMWARE.read_bytes())} bytes")
    print(f"BootShim:   {len(BOOT_SHIM.read_bytes())} bytes")
    print(f"compat DTB: {len(compat_dtb)} bytes")
    print(f"boot sha256: {digest(image)}")
    print("RESULT: Android header, gzip payload, FD and appended DTB all match")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
