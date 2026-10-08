# linux-port/docs - index

> Mirror of `E:\RealmeX2Pro edk2\linux-port\docs\`.  Naming: `NN-<topic>.md`, where
> NN is the HANDOVER-NEXT section the file came from.  The handover itself is an
> index since 2026-10-08 and holds no section bodies any more.

| file | what |
|---|---|
| `19-loadoptions.md` | kernel command line in the boot option LoadOptions (UTF-16, not ASCII) |
| `20-linux-boot.md` | mainline Linux boots on hardware; the kernel moves to the logdump FAT |
| `21-eud-framing.md` | EUD log garbling: kernel-side FIFO overflow, and comlog2 |
| `22-kernel-upstream.md` | kernel side into GitHub: fork, branches, scripts |
| `23-upstream-push.md` | fetch and branches done, push blocked, what to check first |
| `24-push-done.md` | samurai-bringup pushed; two wrong guesses corrected |
| `25-eud-console.md` | EUD real console + firmware cmdline/DTB update, acceptance criteria |
| `26-real-machine-review.md` | real-hardware review: console works, two culprits, panic loop |
| `27-userspace-and-shortcuts.md` | userspace reached; console to /dev/kmsg; shortcuts vs goals |
| `28-flywheel.md` | button-free fastboot, EUD COM RX, verified fastboot write path |
| `EUD-TERMINAL.md` | temporary interactive host terminal; one-byte RX frames with ACK/retry, decoded TX and logs |
| `ANDROID-DT-REFERENCE.md` | where the Android downstream DTS lives and what was cherry-picked |
| `EDK2-KERNEL-EMBED.md` | how the kernel is embedded in the firmware volume |
| `OLD-PROJECT-VERIFICATION.md` | the earlier (2026-10-05) project: what is reusable, what is wrong |

Rules: one section, one file; never append a section back into the handover.
`scripts/sync-docs-to-repo.sh` mirrors the top-level documents, and
`scripts/mirror-linux-port.sh` this directory, into the repository.
