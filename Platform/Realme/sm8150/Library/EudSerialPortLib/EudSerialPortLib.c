/** @file
  EUD (Embedded USB Debug) COM SerialPortLib for the realme X2 Pro (samurai).

  Writes DEBUG()/SerialPortWrite() output into the EUD COM TX FIFO.  The host
  reads it on "Qualcomm EUD Port 9505 (COMx)" and must reassemble the
  [ID][LEN][DATA] frames.

  Register map taken from the stock kernel driver drivers/soc/qcom/eud.c:
    +0x0000 TX_ID  = 0x90 (UART_ID)
    +0x0004 TX_LEN = payload length of this frame (6 bytes is known-good)
    +0x0008 TX_DAT = payload byte

  Notes learned on hardware (2026-10-06):
    * the EUD register block replicates the low byte into all four lanes on
      reads (writing 1 reads back 0x01010101); never gate on readback values;
    * one big write is truncated by the TX FIFO after ~7 payload bytes, so the
      data must be split into small frames;
    * only transmit once the firmware set CSR_EUD_EN (0x1014) low byte to 1.

  SPDX-License-Identifier: BSD-2-Clause-Patent
**/

#include <Base.h>
#include <Library/BaseLib.h>
#include <Library/SerialPortLib.h>
#include <Library/IoLib.h>
#include <Library/TimerLib.h>

#define EUD_BASE             0x088E0000U
#define EUD_REG_CSR_EUD_EN   0x1014U
#define EUD_REG_COM_TX_ID    0x0000U
#define EUD_REG_COM_TX_LEN   0x0004U
#define EUD_REG_COM_TX_DAT   0x0008U
#define EUD_COM_UART_ID      0x90U
#define EUD_COM_CHUNK        6U
#define EUD_COM_BYTE_DELAY   200U      /* microseconds between payload bytes */
#define EUD_COM_FRAME_DELAY  2000U     /* microseconds between frames */

STATIC BOOLEAN  mEudComActive = FALSE;
STATIC UINTN    mEudComGateSkip = 0;

STATIC
BOOLEAN
EudComIsEnabled (
  VOID
  )
{
  return (BOOLEAN)((MmioRead32 (EUD_BASE + EUD_REG_CSR_EUD_EN) & 0xFFU) == 1U);
}

/**
  Initialize the serial device hardware.  Nothing to do here; the EUD block is
  enabled later by the platform (BDS).  SerialPortWrite() re-checks the gate.
**/
RETURN_STATUS
EFIAPI
SerialPortInitialize (
  VOID
  )
{
  mEudComActive = EudComIsEnabled ();
  return RETURN_SUCCESS;
}

/**
  Write data to the EUD COM TX FIFO as a sequence of [ID][LEN][DATA] frames.
**/
UINTN
EFIAPI
SerialPortWrite (
  IN UINT8  *Buffer,
  IN UINTN  NumberOfBytes
  )
{
  UINTN  Index;
  UINTN  Chunk;
  UINTN  Byte;

  if ((Buffer == NULL) || (NumberOfBytes == 0)) {
    return 0;
  }

  if (!mEudComActive) {
    //
    // Avoid hammering the EUD register before BDS enables it: only re-check
    // the gate every 256 write calls.
    //
    if ((mEudComGateSkip++ & 0xFFU) != 0) {
      return NumberOfBytes;
    }

    mEudComActive = EudComIsEnabled ();
    if (!mEudComActive) {
      return NumberOfBytes;
    }
  }

  for (Index = 0; Index < NumberOfBytes; Index += EUD_COM_CHUNK) {
    Chunk = NumberOfBytes - Index;
    if (Chunk > EUD_COM_CHUNK) {
      Chunk = EUD_COM_CHUNK;
    }

    MmioWrite32 (EUD_BASE + EUD_REG_COM_TX_ID, EUD_COM_UART_ID);
    MmioWrite32 (EUD_BASE + EUD_REG_COM_TX_LEN, (UINT32)Chunk);
    for (Byte = 0; Byte < Chunk; Byte++) {
      MmioWrite32 (EUD_BASE + EUD_REG_COM_TX_DAT, (UINT32)Buffer[Index + Byte]);
      MicroSecondDelay (EUD_COM_BYTE_DELAY);
    }

    MicroSecondDelay (EUD_COM_FRAME_DELAY);
  }

  return NumberOfBytes;
}

UINTN
EFIAPI
SerialPortRead (
  OUT UINT8  *Buffer,
  IN  UINTN  NumberOfBytes
  )
{
  return 0;
}

BOOLEAN
EFIAPI
SerialPortPoll (
  VOID
  )
{
  return FALSE;
}

RETURN_STATUS
EFIAPI
SerialPortSetControl (
  IN UINT32  Control
  )
{
  return RETURN_UNSUPPORTED;
}

RETURN_STATUS
EFIAPI
SerialPortGetControl (
  OUT UINT32  *Control
  )
{
  return RETURN_UNSUPPORTED;
}

RETURN_STATUS
EFIAPI
SerialPortSetAttributes (
  IN OUT UINT64              *BaudRate,
  IN OUT UINT32              *ReceiveFifoDepth,
  IN OUT UINT32              *Timeout,
  IN OUT EFI_PARITY_TYPE     *Parity,
  IN OUT UINT8               *DataBits,
  IN OUT EFI_STOP_BITS_TYPE  *StopBits
  )
{
  return RETURN_UNSUPPORTED;
}
