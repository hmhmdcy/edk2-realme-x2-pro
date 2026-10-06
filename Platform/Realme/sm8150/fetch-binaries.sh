#!/usr/bin/env bash
#
# Fetch and install the firmware blobs required by the realme X2 Pro port.
# They are Qualcomm/OPPO firmware and are NOT part of this repository
# (they belong in the Platform/EFI_Binaries submodule).
#
# Run from the repository root:   ./Platform/Realme/sm8150/fetch-binaries.sh
#
set -euo pipefail

FW="https://raw.githubusercontent.com/Project-Aloha/UEFIFirmwareBackup/main/realme-rmx1931/Binaries/QcomPkg/Drivers"
MU="https://raw.githubusercontent.com/Project-Aloha/mu_aloha_platforms/main/Platforms/SurfaceDuo1Pkg/Device/realme-rmx2086/Binaries/QcomPkg/Drivers"
DEST="Platform/EFI_Binaries/Drivers/Devices/samurai"

fetch() {
  local url="$1" out="$2" i
  mkdir -p "$(dirname "$out")"
  for i in 1 2 3 4; do
    if curl -fsSL --retry 3 --retry-delay 2 --max-time 60 "$url" -o "$out"; then
      printf '  ok   %-52s %8s bytes\n' "${out#$DEST/}" "$(stat -c%s "$out")"
      return 0
    fi
    sleep 2
  done
  printf '  FAIL %s\n' "$url" >&2
  return 1
}

echo "==> stock realme X2 Pro (realme-rmx1931) DXE blobs"
fetch "$FW/DALSYSDxe/DALSYSDxe.efi"             "$DEST/DALSys/DALSys.efi"
fetch "$FW/DALSYSDxe/DALSYSDxe.depex"           "$DEST/DALSys/DALSys.depex"
fetch "$FW/UsbPwrCtrlDxe/UsbPwrCtrlDxe.efi"     "$DEST/UsbPwrCtrlDxe/UsbPwrCtrlDxe.efi"
fetch "$FW/UsbPwrCtrlDxe/UsbPwrCtrlDxe.depex"   "$DEST/UsbPwrCtrlDxe/UsbPwrCtrlDxe.depex"
fetch "$FW/TLMMDxe/TLMMDxe.efi"                 "$DEST/TLMMDxe/TLMMDxe.efi"
fetch "$FW/TLMMDxe/TLMMDxe.depex"               "$DEST/TLMMDxe/TLMMDxe.depex"
fetch "$FW/ResetRuntimeDxe/ResetRuntimeDxe.efi"   "$DEST/ResetRuntimeDxe/ResetRuntimeDxe.efi"
fetch "$FW/ResetRuntimeDxe/ResetRuntimeDxe.depex" "$DEST/ResetRuntimeDxe/ResetRuntimeDxe.depex"
fetch "$FW/ButtonsDxe/ButtonsDxe.efi"           "$DEST/ButtonsDxe/ButtonsDxe.efi"
fetch "$FW/ButtonsDxe/ButtonsDxe.depex"         "$DEST/ButtonsDxe/ButtonsDxe.depex"

echo "==> OPPO project protocol provider (OcdtDxe), SM8150 build"
fetch "$MU/OcdtDxe/OppoProject.efi"   "$DEST/OcdtDxe/OppoProject.efi"
fetch "$MU/OcdtDxe/OppoProject.depex" "$DEST/OcdtDxe/OppoProject.depex"

echo "==> patching ButtonsDxe DEPEX"
python3 "$(dirname "$0")/fix-buttons-depex.py" "$DEST/ButtonsDxe/ButtonsDxe.depex"

echo
echo "Done.  Build with:  ./build.sh -d samurai --toolchain GCC5"
