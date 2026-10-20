继续多摄／骁龙ISP校准目标（active、未完成）。读NEXT-SESSION.md、WORKING-BOUNDARIES.md及reference/kernel305/README.md。

USB NCM／原密钥SSH恢复，但启动ID变化；仍#298、taint0。用305/host.py和新guard k305-geometry-r2，不沿用303/304旧guard。当前298 Image加305长焦单模块，SHA d1a85e75b9344423097c8189ed65a0320abcb3f7ba3d5fdac34e3c8758f056c9；其余777模块／961包／50相机载荷保持。最新树camera305-sensor-kernel，samurai-geometry305／18b0a5a753e9363594f682049bf131169488c644，原298树保持。

长焦标准几何与libcamera属性通过。产品四摄18段272帧，再补中断／重开76帧，图和资源恢复，taint/fault0。仍RAW＋CPU ISP，303候选未安装。305 R2回退、R3安装／采集均终态，勿重放。

SDK work/libcamera299-inline仍303源码；上一启动硬件AE只验证低照度上限，目标亮度收敛待验。304 EEPROM解码不是完整校验，未应用个体值。继续原厂长焦调校、独立硬件profile和延迟实测，补RGB统计／AWB、多摄／模式、正式IQ，保持分层。旧GPU、modem、SSC问题仍开放。
