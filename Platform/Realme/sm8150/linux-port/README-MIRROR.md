# linux-port historical source index

This directory preserves the early Linux port sources and the sections 19-28
companion notes. Maintained kernel, userspace and firmware sources now live in
the canonical repositories:

- firmware: <https://github.com/hmhmdcy/realme-x2-pro-edk2>
- kernel: <https://github.com/hmhmdcy/realme-x2-pro-linux>
- userspace packages: <https://github.com/hmhmdcy/realme-x2-pro-pmaports>

The active source archive contains:

    README.md        port status and how to build/flash
    docs/            NN-<topic>.md companions for handover sections 19-28,
                     plus the Android DTS reference / EDK2 embed / old-project notes
    dts/             sm8150-samurai.dts (the mainline device tree source)
    patches/         0001 EUD earlycon, 0002 samurai DTS, 0003 EUD real console
    refs/19781/      files cherry-picked from the Android downstream tree
    initramfs/       the diagnostic init script
    eud_earlycon.c   the earlycon driver source (also in patches/0001)
    eud.c            the real-console driver source (also in patches/0003)

Historical one-off build/sync helpers and package or camera snapshots are under
[`../reference`](../reference/linux-port-archive-README.md). They are retained
for traceability and are excluded from the active-tree portability check.

The old standalone Linux v7.3-rc6 workflow in this directory is historical; it
does not identify the current deployed kernel, modules or rootfs. For a
reproducible image, use the canonical kernel repository together with the
source identity recorded in [`../NEXT-SESSION.md`](../NEXT-SESSION.md), then
keep the resulting `Image`, `sm8150-samurai.dtb`, modules and rootfs tied to the
same source and configuration revision.
