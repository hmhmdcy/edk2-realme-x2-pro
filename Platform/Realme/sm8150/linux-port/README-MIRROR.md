# linux-port (mirror)

This is a read-only mirror of the Windows working copy at
`E:\RealmeX2Pro edk2\linux-port\` (see HANDOVER-NEXT.md section 19.7: the Linux
side of this port used to live only on one disk, with no git history at all).

It holds everything that is small and reproducible:

    README.md        port status and how to build/flash
    docs/            section 18-21 companions, old-project verification, EDK2 embed
    dts/             sm8150-samurai.dts (the mainline device tree source)
    patches/         0001 EUD earlycon, 0002 samurai DTS
    scripts/         build/flash/verify helpers (incl. comlog2.cpp)
    refs/19781/      files cherry-picked from the Android downstream tree
    initramfs/       the diagnostic init script
    eud_earlycon.c   the earlycon driver source (also in patches/0001)

Deliberately NOT mirrored: `artifacts/` (incl. the 30 MB kernel Image) and the
full kernel tree (`~/x2pro-linux/linux`, a Linux v7.3-rc6 checkout whose only
local commits are exactly the two patches in `patches/`).

To recreate the kernel side from scratch:

    tar xf linux-7.3-rc6.tar.gz && cd linux
    git am /path/to/linux-port/patches/0001-*.patch
    git am /path/to/linux-port/patches/0002-*.patch
    make -s ARCH=arm64 qcom/sm8150-samurai.dtb     # -> artifacts/sm8150-samurai.dtb
    bash linux-port/scripts/build-image.sh         # -> the kernel Image
