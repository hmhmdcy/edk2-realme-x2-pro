继续多摄像头／骁龙ISP校准目标（active、未完成）。先读NEXT-SESSION.md、WORKING-BOUNDARIES.md和reference/kernel303/README.md。

303仅主机：AE候选AArch64 Werror、真实DSO和线程proxy各720帧合成模型通过；QEMU clone3 ENOSYS，独立worker未启动，不能记为隔离IPC通过。序列化另测通过。手机未连接，当前boot未复核；最后已验证#298，产品RAW＋CPU ISP，候选未安装。

SDK work/libcamera299-inline现为303，使用303/build-candidate.py，勿重放302/299源码安装器。已测302源码和可运行包保全。接回设备核当前身份和资源后先做303联合曝光增益恒EV实测：launch-capture.py joint r1 isolated、poll终态、analyse-joint.py r1。不要重放旧终态运行。只有实测passed才启动AE。若复现分写锁存问题，在IMX319驱动层修正；不往SoC/DT或应用硬编码模组策略。

之后补真机隔离／变光收敛／错误恢复、RGB统计与AWB、多摄多模式、EEPROM校验和正式暗场／色彩／阴影。旧GPU、modem watchdog、SSC EPERM仍开放。
