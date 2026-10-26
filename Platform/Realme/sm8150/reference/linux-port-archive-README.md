# Archived linux-port support trees

These trees were moved out of the active `linux-port` area on 2026-10-26:

- `linux-port-scripts/`: one-off build, synchronization, push and validation
  helpers tied to the original developer machine.
- `linux-port-packages/`: historical APKBUILD snapshots. The maintained
  userspace recipes now live in `hmhmdcy/realme-x2-pro-pmaports`.
- `linux-port-camera/`: camera deployment locks and experimental package
  snapshots. The maintained kernel source lives in
  `hmhmdcy/realme-x2-pro-linux`.
- `linux-port-uefi-rx-probe/`: an experimental UEFI RX probe.

They are retained for traceability, not as portable build entry points.
`Platform/Realme/sm8150/tools/check-portable-tree.py` deliberately excludes
this directory when checking the active device tree.
