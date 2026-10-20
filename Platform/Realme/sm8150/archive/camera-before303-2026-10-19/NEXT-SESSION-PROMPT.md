接手Realme X2 Pro Linux适配。先读NEXT-SESSION.md、WORKING-BOUNDARIES.md、reference/kernel278/README.md、277/276与硬件清单。

完整active目标继续：多个摄像头及骁龙ISP，按SoC/板级/公共驱动/用户空间收敛。现机仍boot276/Image183、776模块/961包；278七包升级libcamera r24/config-r19，PW/SPA/Gst r3。标准单次Auto AF、触发/取消/重触发/停流和自动曝光下AF已实机通过，应用不做搜索/镜头写；FocusFoM随帧按值传递，镜头串号回执与稳定/曝光/读出守卫已接通。四摄232帧回归通过。配对测量AF约9–12秒，连续AF、距离/画质标定、GUI录像及Spectra仍未完成。

运输reference/kernel278/host.py仍用276guard，服务身份k278-services-verified-private.json。内核分支samurai-cci-io276/0d692761未推送、统一最新内核/rootfs未部署。继续AF加速与更多场景/连续模式/距离标定、应用标准控制接入，并推进VFE170公共PIX/统计/IPA、四摄GUI录像与画质。物理旋转待重测，旧273 EPERM根因/GPU/modem watchdog开放。先核实际状态，不重放已终态工作；普通相机测试已有授权，不将完整目标缩成单次AF。
