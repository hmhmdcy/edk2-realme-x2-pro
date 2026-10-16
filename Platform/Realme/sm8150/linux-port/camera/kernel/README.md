# IMX471内核补丁链

依次保留215的测试图案16位写与216的模拟增益上限修复，219新增原厂4MP/实验16MP模式、固件链路频率过滤及像素阵列时序修复。新增两补丁在保存的216源/板级树上独立重放，结果与实际部署源码逐字一致。[锁](source-lock.json)、[重放收据](../../../reference/kernel219/kernel-patch-integration-validation.json)。

旧模式实际行长5120；三模式阵列速率387.2/326.4/约578.133MHz经活动寄存器和各120帧时间戳核对。保持PLL表，显式写旧模式行长，修正PIXEL_RATE元数据。16MP仍须模块实验参数，默认关闭，真实颜色/标准CFA/几何未验收。

本目录保存补丁与指纹，不代表宿主canonical源/DTB已更新；其仍为216源和旧canonical板级树。部署boot219及模块e49与旧输出分别核对，禁止把旧canonical DTB当当前部署树刷写。Image183保持，后置四摄/未知供电父网与完整rootfs整合继续开放。

223新增独立的0005 CAMSS补丁：只在SM8150/VFE170发布标准FRAME_SYNC，给缓冲保存真实SOF号，缺标记返回错误。fae1模块与r8已配套部署，160帧临时试验逐帧对应独立事件流。完成时间戳保持EOF，未校准物理曝光延迟；canonical CAMSS仍原始源，完整内核/rootfs整合待办。[锁内camss条目](source-lock.json)、[223证据](../../../reference/kernel223/README.md)。
