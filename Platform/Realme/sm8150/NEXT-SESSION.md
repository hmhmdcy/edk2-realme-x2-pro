# 当前检查点：379（两路 IPE IO 配置实机通过；图像数据面未接，目标 active）

2026-10-20。先读 WORKING-BOUNDARIES.md、reference/kernel379/README.md。优先复用固定仓库和原厂提取证据，按 SoC、板级、主线框架、驱动、用户空间区分修改。不要将会话配置成功视作图像处理或校准完成。

## 当前设备与源码

当前是378失败后恢复的启动，guard `/var/lib/samurai/k378-recovered/boot-id-private.txt`，用reference/kernel379/host.py（委托378的动态恢复guard），strict原密钥USB/known_hosts保持。377与378都自动重启；379没有重启，379-boot-r1 worker3830与collector均结束，finished/terminal/passed。失败事务保留，不重跑377/378。

实际Image363／7.3.0-rc6-rmx1931-samurai-k363+、boot366嵌入DT365、libcamera五包r29、config/stack r24及362四份私有Preview保持。原厂曝光/手动频闪、IFE Gamma、unit WB/CCT与动态LSC/CCM保留。静态ICP disabled，候选未永久安装。378恢复核对boot/logdump原始读回，379无刷写，无NV/OTP/工厂校准写入。

维护源 `/mnt/samurai-full282/source354`，分支samurai-a5-ack-status379，commit6b8e3b1a28ff9ea60391045b03b746499d1d9400；父3783347022f42202b9823b6945c6878189d3d64527d、3777ccaf8db4690cbedba43d44d065ccd93c119b30b。实际Image源码ba61a62293e0f6bc5838c06f2e85e033e3d702a8，静态DT源码e217016006e609333a715c10f2f3e442dc4da95f未变。379 core SHAfb98ea6014318d46816505daf45a12e3fc9a364aff24561003b0c66c21d4d2a1、test SHAae29dd03d9fc69b368a47ec0a4db056b6bd018dd3d633c0e45810eea348cec62，in-treeY/W1/Werror无诊断。

访问ext4前先调用reference/kernel284/storage.py::mounted_build()，返回/mnt/samurai-full282/build，source354在旁；WSL退出会卸载，不重建/格式化镜像。libcamera源 /mnt/samurai-full282/libcamera362-serialized-built/src/libcamera-v0.7.2；SDK /home/cy122/x2pro-linux/libcamera214-root，work bind串行。

## 本轮实际能力与现存降级

379 RT(type2)create→MAP→CONFIG_IO→UNMAP→非RT(type3)create→MAP→CONFIG_IO→UNMAP→逆序destroy→PC/WFI→cooperative stop→全释放/卸载通过，两个handle同时存在。实际scratch各48字节，13msgs/14IRQ/1debug，watchdog/protocol0；CMD读写120words、MSG133words按实际长度精确吻合，剩余会话/CPU/IRQ/backing/PM/mapping均0。证据379/boot-runtime-validation.json、io-runtime-validation.json。image_frames仍0。

同启动379新采四摄各12帧640×480，主摄隔离IPA27帧/5阶段/GammaACK，无新增故障/taint0。17个ICP/BPS/IPE时钟enable0、9相机电源disabled/users0、CAMSS/双CCI休眠，临时core/test/DT/固件/worker无残留。四摄与ICP证据均新生成，不能继续写“复用375同启动”。

378恢复启动时SSC自动启动出现旧FastRPC attach EPERM/daemon exit4模式，清理后SLPI offline、SensorProxy stopped、桌面未自动启动。379保存上下文，按实际状态临时nodeps启动greetd，依赖配置未改；桌面PW/WP/phoc/phosh各一进程已恢复。没有盲目重新attach共享池，没有重启整机。自动旋转/SSC尚不可用，不能把whole_platform_healthy写true。见379/ssc-failure-validation.json、desktop-restore-validation.json、final-state-validation.json；final-state passed仅相机/ICP收尾。

## 原厂ABI与必须保留的底层修正

372异常现场解码、373 reset/wake后编程并读回HFI参数、375 PC/WFI/CONTROL关闭确认后避免额外全局ICP/AHB块复位、376双token与IRQ join/错误锁存修正均保留，细节见376/README与旧NEXT对应文档。失败/未知/未清CPU使能仍强制复位；复位失败保留CPU/DMA/PM。旧强制复位后重启的具体总线/看门狗机制未直接测定。

优先已有352固定CAMSS原型ebd1e440443121d18f730ab2aeea5586a754f36f、Realme GPL9668fcdc6ec15be7a10d66f7b93c347829e0fdb6（352/oem与355/oem/cam_icp_hw_mgr.c），CamxChi9f17f1b568626b393e785b369c5dc94543774d7a（350/sources/camxipenode.cpp与377/sources/camxipenode.h私存）。原型不完整且async多一字段，不能直接套本机。CamxChi的ipe_data.h外部依赖未取得，优先本机HAL实际指令。

本机HAL camera.qcom.so-private在kernel281，SHAe2b1b9b6379507052464d9f9573c2a5a1b1cf37c43947b53645ddc8948a70dde，debugELF/符号在350；原始SetConfigIOData0x2e4b88..0x2e4f00完整执行18例，确认image_desc84、format20、Y stride52/height56、UV stride60/height64、uvSwap24。payload1216（旧GPL头文件848不适用），maxBatch1192、尾userArg1208。自写encoder12组14592字节与原HAL完整输出相同，13invalid不改输出。

create命令28/ACK32，destroy44/实际ACK48，CONFIG_IO间接命令40/ACK56、scratch在reply36；MAP/UNMAP直接命令56/ACK44。MAP/UNMAP **只有header状态有效，12字节tail是未初始化分配器内容**，不得再读作payload错误；CONFIG_IO与DESTROY仍检查有效payload状态。379原厂指令模型改用dirty allocator，旧parser反例失败，新parser与40会话/25owner场景通过ASAN/UBSAN。

377配置槽07420000落入固件debug映射：debug存储100KiB但原始HFI_QueueGetQHdr建立07403000起1MiB映射，原始重叠检查复现首次MAP拒绝；实际377未记录精确HFI错误码。378移至07600000实机MAP/CONFIG成功，却误读UNMAP尾，二次UNMAP被拒绝，强制清理后自动重启。377/378各自attempt-audit-validation.json严格只取最新窗口，worker未落终态，不冒充正常清理成功。

## 下一步直接工作

进入IPE frame处理所需的图像/命令/IQ/striping/CDM布局、DMA所有权与完成通知；控制配置已有真实硬件证据，无需重复同一握手/配置来回扫描。核对原厂GPL管理器buffer patch、acquire/config/frame流程和HALSetup/striping路径，按固定文件取源，禁止partial clone全树git grep导致海量lazyfetch。

A5当前SID2222只证明控制CPU映射，IPE/BPS引擎SID、上下文/共享域不能等同。图像缓冲走内核DMA/IOMMU和明确寿命/缓存/错误回滚，不能抢CAMSS现有stream，不能用户空间MMIO。命令别名07600000/4KiB已避开固件队列映射，处于既有shared保留窗口；没有新板级DT保留区。确认引擎帧完成与输出后再接libcamera m2m及Gamma/LTM/CCM。

第五2MP身份仍未知，OV02A1B库名不算识别；共享front PHY2/MCLK2/reset12与GPIO29 mux待解。更多模式、动态帧时长、自动防频闪、光学/几何/同步/连续AF等见363/REMAINING-CAMERA-SCOPE.md。延期纯色/遮光可后做，整体goal active。

## 私存、工具与回退

公共Git /home/cy122/edk2-samurai/repo，范围Platform/Realme/sm8150；根目录不是Git。原厂ELF kernel352/CAMERA_ICP.elf-private，3630392bytes SHAa22bc8adbb4ae97e4f8d728eecb1fd19c1bf866250b0bb7e668951c41c159e63。完整汇编370/firmware-armv7-private.asm，objdump -m armv7；Unicorn /home/cy122/x2pro-linux/private-k329-venv/bin/python。377/378失败pstore与379成功日志/模型/模块均私存kernel对应目录。raw固件、回包、异常、校准、密钥不进公共Git。

boot366 SHAc3e4e9c85d80c8ec37605cd522cf716525ae5ebe4fa801342dbf7586c292d924；logdump365 SHAaca01bc2c91928f1a6a6690f62d14db014351ec5049e5684590b40c3c93de8da。旧boot276+logdump363、旧k298模块/logdump与362回退包均保留。未请求push/PR，仅本地提交。
