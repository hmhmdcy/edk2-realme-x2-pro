历史快照：阶段151收尾更新前的文档，仅保留历史证据；当前状态以NEXT-SESSION.md及linux-port/docs/HARDWARE-STATUS.md为准。

# 下一会话短提示词

当前以 NEXT-SESSION.md 和 sessions/149-vulkan-ccu-alignment-fix-and-deployment.md 为准：#147/software132 加已部署 Mesa149 本地库补丁，当前可复现 A640 Vulkan CCU 故障已修复。185 次像素读回零差异、36 次 Settings 面板打开及 PM/稀疏/旧地址重放/并发通过，部署后新增 fault0、taint0、物理桌面保持。普通 Mesa 包更新可能覆盖本地库，旧 rootfs132 镜像不含更新；公开源码补丁在 linux-port/patches/0015-mesa-turnip-a640-vm-bind-iova-alignment.patch，原库/回退材料在手机 k149-deployment 与私有主机 kernel149 目录。整机其它待办保持。以下为阶段147历史提示。

继续Realme X2 Pro postmarketOS适配，当前规则见WORKING-BOUNDARIES.md。最新手机#147/software132，仅刷logdump；A640旧式VM/GLES GMEM迟发CCU fault已用64KiB IOVA对齐修复，20次像素验证+6次持续绘制和退出35–90秒观察全部无fault，taint0，显示/警告/DMA错误计数0。详见NEXT-SESSION.md及sessions/147-a640-gmem-alignment-fix.md。

源码/Image仍在WSL kernel136目录，实际版本147。147补丁和报告在reference/kernel147；私有产物、启动身份、刷写与原始RD/core在E:/edk2-samurai-out/kernel147。再次切换先查当前状态，不复用146身份与旧收据。Vulkan用户管理VM_BIND、其他GPU型号未验收；显示启动偶发问题、音频、充电等整机待办保持。
