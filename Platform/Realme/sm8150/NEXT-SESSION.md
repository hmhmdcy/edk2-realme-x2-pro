# 当前检查点：396（CCM编码／固件路由候选，正式仍395，目标active）

先读WORKING-BOUNDARIES.md、reference/kernel396/README.md。395交接归档archive/NEXT-SESSION-through395-2026-10-21.md。完整多摄／ISP目标继续，关灯黑场／噪点不单独判故障，照明相关光学校准后做。

## 本轮实质进展与边界

复用351原厂BIN完整CCM树、281本机HAL、352固件及固定CamxChi仓库。补搜公共CAMSS RFC／OPE参数讨论作接口参考，不能当SM8150固件ABI或完整可用驱动。396新增内部受限CC编码器，未接运行调用者／未安装，不开放任意用户CDM。候选只改Makefile和两个新文件，现有帧与adapter ABI保持。

实际完整HAL CC13CalculateSetting的OEM已插值输入路径、完整WriteRegRange执行：737原厂区域＋384合成／边界共1121组，49324B与自有C逐字节一致，246620原指令；仅CmdBuffer Begin／Commit存储桩，无数值／包编码桩。矩阵signed12、RGB行主序转GBR行列、Q(7+shift)，shift2bit；IPE偏移signed13。固定9寄存器、44B CDM、起始0x5e68。72非法输入无写入，ASan/UBSan；相同C交叉编译＋QEMU AArch641121/72通过。未执行该检查中的调校插值或完整Android图形处理。

HAL模块片段确认命令buffer索引4/post-LTM、IQ偏移2188开关；FW实际读取bit0写0x5e60。完整原厂striping和FW CONFIG_IO／帧准备覆盖三尺寸640/1920/4608、端口8/9、核心1/2共12组，CC启闭条带及BL容量相同、外部post数组链接一次、包完整。完整分发器确认帧头40程序数组base、48post相对偏移；数组头8B／每项24B，generic0、长度高word=(bytes-1)<<12；十个偏移重定位后base被清零。模型停于硬件enqueue入口，像素效果／最终CDM执行／fence及真实生命周期未验证。

首轮293合成用例差异来自测试夹具Q因子偏移错，修夹具后过，C未改；原输出私存r1。路由夹具最初地址越界和错误期待保留base的失败也记录，未改FW。详见colour-r1-validation及routing-attempt-validation。

## 源码、构建、正式部署分开

source354当前branch samurai-ipe-colour396、HEAD46fdb7c96b04825dc1802f8280685a4c4e709615，干净；父395源3a793050772b5e23d22ce9a82dc8ba23000dddb0。访问source/build先reference/kernel284/storage.py::mounted_build()；现有32GiB ext4不可格式化/重建。396仅编码器/header/Makefile，ARM64 in-tree W1/Werror诊断0，候选core360096B/SHA6652bbbc410d3d9c9e8b7a767608a67c6580c664ebb9d3de632e1af950a36c25，符号存在，构建终态，共享输出/配置恢复。未新增runtime调用者，未上机。

本轮只读核对手机仍正式core395354864B/SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88；adapter393 ff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1；CAMSS38924fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288，磁盘/加载note相符。396无安装/采集/重启/刷写/设备worker。

host396委托395/394，guard仍/var/lib/samurai/k394-recovered/boot-id-private.txt，原USB密钥/known_hosts。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot389/logdump365、DT389静态7SID/5IOVA、SG owner API/helper、原FW、libcamera r30/config-stack r25及四私有Preview配置保持。用户源libcamera391-ipe-r30-built。不重复无关全量核验。

同一module epoch jobs/completed/direct48、错误/取消/first_error0，CPU/IRQ/PM/backing/map/import回收、ICP/CAMSS/双CCI suspended、taint0。395最后17clks0/9rails disabled/users0及PW8440/WP8443单例uid10000证据沿用，396未全面复查SSC/旋转，不称旧间歇故障修复。

## 保留395故障恢复与回退

395强制reset pulse2us、deassert后读回A5 enable/wake清零，再IPE新ACK／DMA retirement／PMrelease。一次双会话真实ACK丢失完整恢复无重启，故障epoch6作业/3完成/3预期错误；最后旧消费者关闭后重开像素通过。22停机模型/7解析器模型通过，未知完成引用保留。394保持块reset后重启的精确物理根因未证明，失败和206061B ramoops保持。

395第一次事务worker7618的故障部分通过，正常GW1底层13/应用12触发不合理严格计数断言，整笔FAILED并自动恢复393。第二次k395-normal-install-r2/worker8282仅正常安装，四摄各12/48direct通过。三个计数epoch分别保留，全部worker/client/collector终态，不重启旧脚本。两个395root的normal393-core.ko备份e22253916088e58a221c1948f025c44c939c819310c7d3f67106053dd39502f6；393旧pair、391旧r29/r24七包、390平台/boot366回退保持。

## 下一步及完整范围

接受驱动管理的逐帧CC参数／program array／固定CDM区域，在提交前验证范围/重叠并纳入未知完成时DMA保留与复位回收；从标准媒体请求/参数路径输入量化矩阵，禁止任意外来寄存器包。用可预测合成图像验证实际CCM单位/非单位效果，再接351触发树与libcamera标准ColourCorrectionMatrix。396/probe-routing.py提供原厂条带及完整FW准备，check-routing.py提供完整dispatch重定位模型，可复用。

继续完整原厂Gamma/LTM/CCM及reference/kernel363/REMAINING-CAMERA-SCOPE.md全部：第五2MP身份/mux、多模式、动态帧长/防频闪、几何/多摄同步、连续AF/光学。默认仍1:1 NV12/NV21 IQ旁路，异步implicit-fence发布未证明。保留388 DMA-only SG禁sg_page/sg_phys、自有IOMMU别名、381未知DMA/reset及383 Unicorn MEM_READ破坏ThumbIT/SP审计。

private=/mnt/e/edk2-samurai-out/kernel396及前序；FW/HAL/OEM源/ASM/CDM/全日志/图像/个体数据不公开。公共mirror=/home/cy122/edk2-samurai/repo/Platform/Realme/sm8150，仅本地提交、不push/PR、保留其它改动。
