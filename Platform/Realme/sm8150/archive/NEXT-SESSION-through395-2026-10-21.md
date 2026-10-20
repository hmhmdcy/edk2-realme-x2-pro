# 当前检查点：395（A5强制复位顺序修复已部署，目标active）

先读WORKING-BOUNDARIES.md、reference/kernel395/README.md。旧394交接归档archive/NEXT-SESSION-through394-2026-10-21.md。完整多摄/骁龙ISP目标继续，关灯黑场/噪点不单独判故障，照明相关光学校准后做。

## 已实现及实际证据

395只修改SoC核心强制停机：保留assert，等待与冷启动一致的2us，deassert后读回A5 enable/wake均清零，之后才IPE复位、DMA退映射和PM释放。deassert/读回/IPE失败仍保留资源；重试先处理遗留reset再访问CSR。22个实际停机模型ASan/UBSan、正常/测试ARM64 W1/Werror、7个实际ACK解析器模型通过。保持393局部REJECTED语义及未知完成所有权，adapter API/ABI不变。

一次真实成功帧ACK丢失实机通过：两个session各预热1帧，约5.104476秒原超时-110；pending/request_map及输入输出引用保留。A5 reset pulse/CPU清零在前，IPE新ACK3,3后引用仍各1，之后DMA aliases retired、PM release0。超时任务-110、同伴-5，第三上下文被fatal拒绝；旧消费者全关闭后fatal清除，新上下文像素通过。故障epoch jobs6/completed3/direct3/failed3/first_error-110/cancel0，无重启、watchdog/protocol0。测试核心已卸载，正式无测试宏/参数。此证据不代表所有物理硬件错误恢复。

第一次完整事务k395-ack-loss-r1/worker7618仍FAILED：故障部分已通过，但正常GW1底层完成13/应用交付12触发错误的严格计数断言，自动恢复393。四颗应用均12/bus错误0，第一次正常底层共49；不得改写整笔成功。异步Gst appsink有在途帧，后续按提交=完成=direct且至少覆盖交付、core帧数及session关闭、错误/取消0检查。原失败保留，没重复ACK注入。

第二次k395-normal-install-r2/worker8282仅正常核心安装和回归，已terminal/pass/installed。四摄各12、恰好48direct，starts/stops4、失败/取消/first_error0，无LD/调校覆盖，fixture恢复。当前计数48与故障6/3及第一次正常49分epoch，不相加。两次worker/client/collector均结束；第一次collector无新dump，第二次未运行collector。

## 当前源、设备、回退

source354分支samurai-a5-reset-pulse395，HEAD3a793050772b5e23d22ce9a82dc8ba23000dddb0，干净、正常源无测试宏。访问source/build先reference/kernel284/storage.py::mounted_build()；现有32GiB ext4 backing不可格式化/重建。正式core354864B，SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88，磁盘/加载note匹配。adapter393仍ff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1，qcom-camss复合模块389仍24fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。

无新启动/刷写，host395委托host394，guard仍/var/lib/samurai/k394-recovered/boot-id-private.txt，原USB密钥/known_hosts。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot389/logdump365、DT389静态7SID/5IOVA、SG owner API/helper、FW、libcamera99990.7.2-r30/config-stack0.1.0-r25及四私有Preview配置保持。用户空间源libcamera391-ipe-r30-built。不重做无关模块/包全量核验。

CPU/IRQ/PM/backing/map/import全回收，ICP/CAMSS/双CCI suspended，17clks0、9rails disabled/users0、taint0。PW8440/WP8443各一uid10000；owner_refs53是桌面普通CAMSS句柄，m2m users0/fatalfalse。正常验证窗口无新fault。旧SSC间歇故障/旋转未全面复验，不宣称修复。

两个395事务各自backup/normal393-core.ko已读回e22253916088e58a221c1948f025c44c939c819310c7d3f67106053dd39502f6。393旧pair/389、391旧r29/r24七包、390平台/boot366回退保留。不要重启已有state的部署脚本。394失败和206061B ramoops未删除；395状态文件/目录改fsync并落盘，普通日志不承诺绝对持久化。

## 来源及接续，不缩减目标

395复用原厂固件/HAL协议逆向及Realme GPL9668fcdc6ec15be7a10d66f7b93c347829e0fdb6。394已审hfi和ICP manager，395从本地仓库取cam_soc_util补六个资源退出函数；所查链无直接reset_control，不推断整个OEM。原394保持块reset后重启的精确物理机制未证明；395同类错误完整返回是实机事实。

继续相关底层错误恢复缺口，再原厂Gamma/LTM/CCM完整IQ及reference/kernel363/REMAINING-CAMERA-SCOPE.md全部：第五2MP身份/mux、多模式、动态帧长/防频闪、几何/多摄同步、连续AF/光学画质。仍1:1 NV12/NV21 IQ旁路，异步implicit-fence发布未证明。保留373/375/376/379启动ACK、381未知DMA/reset、388 DMA-only SG禁sg_page/sg_phys、自有IOMMU别名、377/378失败及383 Unicorn MEM_READ/ThumbIT审计。

private=/mnt/e/edk2-samurai-out/kernel395及前序；FW/HAL/OEM源码/ASM/CDM/全日志/图像/个体数据不公开。公共mirror=/home/cy122/edk2-samurai/repo/Platform/Realme/sm8150，仅本地提交、不push/PR、保留其它改动。
