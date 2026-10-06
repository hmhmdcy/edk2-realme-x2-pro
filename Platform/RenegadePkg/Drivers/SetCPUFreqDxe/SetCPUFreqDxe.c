#include <Library/PcdLib.h>
#include <Library/DebugLib.h>
#include <Library/UefiDriverEntryPoint.h>
#include <Library/UefiBootServicesTableLib.h>

#include <Protocol/EFIClock.h>

STATIC EFI_HANDLE Handle = NULL;

EFI_STATUS
EFIAPI
SetCPUFreqDxeMain (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_STATUS             Status                       = EFI_SUCCESS;
  EFI_CLOCK_PROTOCOL    *pClockProtocol               = NULL;
  UINT32                 perfLevel                    = 0;
  UINT32                 frequencyHz                  = 0;

  Status = gBS->LocateProtocol (
     &gEfiClockProtocolGuid,
     NULL,
     (VOID **)&pClockProtocol
     );

  if (EFI_ERROR (Status)) {
    DEBUG ((EFI_D_INFO, "%a: Failed to locate protocol\n", __FUNCTION__));
    return Status;
  }

  DEBUG ((EFI_D_INFO, "\n\n\n\n\n\n\n\n\n\n\n\n\n"));

  //
  // Assume 4 cpu + 4 cpu + L3 cache.
  //
  // Not every index has a performance level on every SoC variant: this device
  // reports Protocol Error for index 4.  A failure used to abort the whole loop,
  // which left the Gold and Gold+ cores (indices 4-7) at their default level.
  // Skip the index and keep going instead.
  //
  for (int i = 0; i < 9; i++) {
    Status = pClockProtocol->GetMaxPerfLevel (pClockProtocol, i, &perfLevel);

    if (EFI_ERROR (Status)) {
      DEBUG ((EFI_D_INFO, "%a: no max perfLevel for CPU %d (Status: %r), skipped\n", __FUNCTION__, i, Status));
      continue;
    }

    //
    // Helps to set proper freq in PrePi.  perfLevel and frequencyHz are UINT32,
    // so they must be printed unsigned: 2419200000 Hz used to show up as
    // -1875767296 Hz when %d was used.
    //
    DEBUG ((EFI_D_INFO, "CPU %d has max perfLevel of %u\n", i, perfLevel));
    Status = pClockProtocol->SetCpuPerfLevel (pClockProtocol, i, perfLevel, &frequencyHz);

    if (EFI_ERROR (Status)) {
      DEBUG ((EFI_D_INFO, "%a: Failed to set the maximum performance level for CPU %d, Status: %r\n", __FUNCTION__, i, Status));
      continue;
    }

    DEBUG ((EFI_D_INFO, "%a: CPU %d Now running at %u Hz\n", __FUNCTION__, i, frequencyHz));
  }

  return EFI_SUCCESS;
}
