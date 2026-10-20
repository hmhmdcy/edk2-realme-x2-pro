# 当前检查点：397（逐帧CC硬件固定矩阵通过，正式仍395，目标active）

先读WORKING-BOUNDARIES.md、reference/kernel397/README.md。396交接归档archive/NEXT-SESSION-through396-2026-10-21.md。完整多摄/ISP继续，关灯黑场/噪点不单独判故障，照明相关校准后做。

## 本轮实际进展和颜色域边界

397新增camss_a5_ipe_run_colour_status类型化同步接口；锁内复制/验证量化矩阵、整数偏移、Q因子，MAP前非法值局部拒绝。旧job/frame/session布局和接口保持，旧调用NULL仍旁路。IQ2584后2592空数组、2624单项post数组、2656固定44B命令，总2700，均在原4096B IQ页中，沿用请求映射/未知完成保留/复位回收。帧头40base、48postoffset32。不接受任意外来CDM或寄存器包。

39个实际transfer/DMA用例ASan/UBSan通过，含旧/CC接口及MAP/FRAME/UNMAP错误保留；实际C完整2700区域1121组/3026700B与原HAL命令+固件布局零差，2730非法/短缓冲无写入，host+QEMU AArch64通过。12组合由完整原FW CONFIG_IO/帧准备消费，软件模型停enqueue前。

一次实机root=/var/lib/samurai/k397-colour-r1，worker10439，collector10536。候选core+临时固定模式adapter只私有加载，磁盘正式文件未动。四模式相同640x480 NV12输入各1帧：旁路Y与输入一致；单位矩阵全460800B等于旁路；零矩阵全460800B归零；半幅矩阵307200个Y精确除2，UV相对旁路向下除2有5280B高1，其余相同，原因未隔离。CRC主机重算一致、尾canary/时间戳/序号/输入未改通过，4direct/错误0。实际CC程序已影响像素，不只是ACK。

不能直接应用原厂RGB矩阵：当前NV12输入输出只启CC、两侧颜色转换仍关闭，正确RGB处理域未建立。零矩阵连UV归零是观察，不证明RGB链路正确。优先原HAL核实pre-LTM color transform、post-LTM chroma enhancement等转换/范围/顺序；再非对角元素/有符号偏移、标准媒体请求/libcamera及351触发树。当前无稳定V4L2参数接口，不把临时test_cc_mode当产品API。

## 源码、构建和正式部署

source354 branch samurai-ipe-frame-colour397，HEAD6a6451dd1fa14534e5c805d8ca8e9a588b42016d，干净；父39646fdb7c96b04825dc1802f8280685a4c4e709615。仅4源文件，free/unknown completion/quiesce/stop函数体不变。访问source/build先reference/kernel284/storage.py::mounted_build()；现有32GiB ext4不可格式化/重建。

正常397 core ARM64 in-tree W1/Werror诊断0，370160B/SHA2a2aa6b57050cd4fda82fa849bff6924061b6b3600287a0541c3664846f254e6。临时adapter122160B/SHAa56989f098212ccca4ba084b5c6aee80d8ec04970aee431660bb3cbc030d0e01，宏只提供0旁路/1单位/2零/3半幅；核心与正常构建逐字节同。前两次adapter构建缺帮助模块目标导致modpost未解符号，第二次因准备未终态过早启动仍旧列表；第三次完整目标成功。标准帮助模块只为符号构建，未安装。临时源和共享构建输出/配置恢复，所有构建终态，失败记录保留。

实机后已卸候选、恢复正常395/393。默认r30四摄imx471/imx319/s5k3m5/s5kgw1各12，恰好48direct/starts-stops4/错误-取消0，无LD/调校覆盖，fixture恢复。临时4、恢复48及实验前48三个epoch分开。worker/client/collector全部终态，无新dump/timeout/fault，未重启/刷写/永久安装。不要重启已有state的runtime脚本。

正式core395354864B/SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88；adapter393 ff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1；CAMSS38924fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。磁盘/加载note、四个私有配置保持，test_cc_mode及test_drop_frame_ack均无。源码397未永久部署。

host397委托396/395/394，guard仍/var/lib/samurai/k394-recovered/boot-id-private.txt，原USB密钥/known_hosts。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot389/logdump365、DT389静态7SID/5IOVA、SG owner API/helper、原FW、r30/r25保持。用户源libcamera391-ipe-r30-built。不重复无关全量核验。

最终CPU/IRQ/PM/backing/map/import释放，ICP/CAMSS/双CCI suspended，17clks0、9rails disabled/users0、taint0。PW10681/WP10684各一uid10000；owner_refs53是桌面普通CAMSS句柄，m2m users0/fatalfalse。SSC/旋转未全面复验，不称旧间歇故障修复。

## 保留证据与接续

396完整原HAL CC量化/固定CDM1121组、矩阵signed12/offsetsigned13、Q(7+shift)、GBR行列顺序及FW路由可复用；原厂737叶只私存351，所选前摄非单位矩阵不能挪IFE代替。397已解决同页程序所有权和固定矩阵实像素，接下来先解决上面的颜色域组合，再全Gamma/LTM/CCM，不跳到默认启用。

395reset pulse2us/deassert/CPU读回、IPE新ACK后再DMA/PM释放，双会话真实丢ACK恢复无重启；394旧块reset后重启的精确物理机制未证明，失败和206061B ramoops保持。395首事务因GW1底层13/应用12严格计数断言失败并回退，第二次正常48通过，均保留。两个395root的normal393-core.ko备份e22253916088e58a221c1948f025c44c939c819310c7d3f67106053dd39502f6，393旧pair/391旧r29-r24七包/390平台-boot366回退保持。

完整reference/kernel363/REMAINING-CAMERA-SCOPE.md继续：第五2MP身份/mux、多模式、动态帧长/防频闪、几何/多摄同步、连续AF/光学。产品默认仍1:1 NV12/NV21 IQ旁路，异步implicit-fence发布未证明。保留388 DMA-only SG禁sg_page/sg_phys、自有IOMMU别名、381未知DMA/reset、383 Unicorn MEM_READ破坏ThumbIT/SP审计。

private=/mnt/e/edk2-samurai-out/kernel397及前序；FW/HAL/OEM源/ASM/CDM/全日志/图像/个体数据不公开。公共mirror=/home/cy122/edk2-samurai/repo/Platform/Realme/sm8150，仅本地提交、不push/PR、保留其它改动。
