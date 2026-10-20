接手Realme X2 Pro Linux适配。先读NEXT-SESSION.md、WORKING-BOUNDARIES.md、reference/kernel249/README.md和linux-port/docs/HARDWARE-STATUS.md。

本轮249是PC离线pmaports打包/复现，未连接或刷写手机；物理手机当前系统未知。pmaports默认samurai-userspace已按6个功能主题整理并推送，公开源码构建、882包离线rootfs和升级模拟通过。与248历史958包和旧实机验收严格区分。GNSS旧goal仍暂停，零CNR根因未解决。

用户要求内核/rootfs跟随上游，补丁纯净，不混过渡产物。先读pmaports的samurai/MAINTENANCE.md和REPRODUCIBILITY.md；内核120文件差异仍含OF fixture/overlay/trace及235/237 lab相机供电依赖，不能称已纯化。应在新候选上将电源/reset/静态DTS正式化，逐功能整理，构建与实机回归后再固定发布；保留原分支和回退。

沿用240交接及248私人备份依据，但接触手机前重新核身份、OS及当前进程，旧boot-id guard不能沿用。原内核/旧SDK/备份与本地未提交生成DTB保持。249构建卷可重挂，不能重新格式化。遵守WORKING-BOUNDARIES，完成后更新检查点和专题证据。
