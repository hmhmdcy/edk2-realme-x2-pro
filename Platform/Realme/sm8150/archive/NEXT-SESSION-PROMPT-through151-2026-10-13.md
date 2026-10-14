# 下一会话短提示词

继续Realme X2 Pro Linux适配，先读NEXT-SESSION.md、linux-port/docs/HARDWARE-STATUS.md和WORKING-BOUNDARIES.md。当前内核#147/software132加已部署Mesa149本地库；已复现GLES/Vulkan CCU故障修复成功，151同boot收尾新增fault0、taint0、桌面保持，无测试/临时GPU追踪/core。150无Mesa补丁候选未部署，存在功能降级与MSRTSS未测风险，不替换现有方案。

下一阶段优先显示接管/DSI生命周期，然后充电控制保护、音频首次DMA问题；实体camera、完整传感器、蜂窝业务、GNSS fix、指纹/NFC读卡/振动物理确认及跨硬件休眠长稳仍开放。原生触摸、Wi-Fi、蓝牙扫描和USB已有基础能力。Mesa升级与旧rootfs132会覆盖本地修复，后续构建需携带0015补丁。包数据库与149摘要不同，936包/Mesa26.2.4-r1及修复库保持，原因待核对。当前源码目录kernel136实际为147；切换前核对设备状态，保护分区/NV/电池边界，不复用旧收据。
