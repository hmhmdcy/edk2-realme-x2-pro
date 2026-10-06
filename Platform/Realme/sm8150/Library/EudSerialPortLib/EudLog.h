/** @file
  Shared layout of the EUD log ring buffer used by the realme X2 Pro (samurai).

  The firmware cannot send DEBUG() output to a host PC until the host has run
  "eudtool com-up", which is what makes the EUD COM port appear.  Everything
  printed before that (all of PEI, DXE and the start of BDS) would be lost, so
  this ring buffer holds it until a host attaches.

  The ring lives at a fixed physical address inside a memory region that the
  platform memory map already reserves under the name "EUD Log" (it used to be
  called "RSRV2"; nothing in the tree ever referenced that region).  Because
  the address is fixed, each of the about 160 modules that link SerialPortLib
  writes to the same ring without sharing any library state, and one single
  consumer (Platform/Realme/sm8150/EudLogDxe) replays it to the host.

    producer: Platform/Realme/sm8150/Library/EudSerialPortLib/EudSerialPortLib.c
    consumer: Platform/Realme/sm8150/EudLogDxe/EudLogDxe.c

  SPDX-License-Identifier: BSD-2-Clause-Patent
**/

#ifndef EUD_LOG_H_
#define EUD_LOG_H_

//
// Must match the "EUD Log" entry in
// Silicon/Qualcomm/sm8150/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c
//
#define EUD_LOG_BASE     0x9FFE3000U
#define EUD_LOG_SIZE     0x00014000U
#define EUD_LOG_MAGIC    0x474F4C45U  /* ELOG */
#define EUD_LOG_VERSION  0x00010000U

//
// Head and Tail count the bytes ever written and ever drained.  They are not
// wrapped indices, so the used space is simply Head - Tail.
//
// The scalar fields are volatile because producer and consumer are different
// modules touching the same physical memory.
//
typedef struct {
  volatile UINT32  Magic;
  volatile UINT32  Version;
  volatile UINT32  Size;
  volatile UINT32  Head;
  volatile UINT32  Tail;
  volatile UINT32  Drops;
  volatile UINT32  DropEvents;
  volatile UINT32  Pad;
  UINT32           Data[1];
} EUD_LOG_HEADER;

#define EUD_LOG_DATA_OFFSET  ((UINT32)OFFSET_OF (EUD_LOG_HEADER, Data))
#define EUD_LOG_DATA_SIZE    (EUD_LOG_SIZE - EUD_LOG_DATA_OFFSET)

#endif
