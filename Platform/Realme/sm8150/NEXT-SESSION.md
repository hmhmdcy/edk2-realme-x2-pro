# 当前检查点：384（原生bypass完整条带已实机通过，目标active）

先读WORKING-BOUNDARIES.md、reference/kernel384/README.md。383完整交接归档archive/NEXT-SESSION-through383-2026-10-20.md；更早的382/381/380交接保留。用户告知现场将关灯：后续采集按低照度解释，黑画面/噪点本身不能作为链路故障；用完成状态/日志/元数据判断。光照相关校准后续做，不阻塞其它适配。

## 当前维护源和已验证路径

源/mnt/samurai-full282/source354，branch samurai-a5-ipe-native384，HEAD5a0df37d3e9c8971d55186e468b38b424c8387dc，父383a9f823f210344ab551e4859b4889358916345fbb；干净，close-current确认源码与验证提案一致。camss_a5_ipe_bypass_size + encode_bypass_striping完整生成bypass条带，接入run，job移除striping/striping_bytes；test_frame不再request_firmware条带文件。IQ仍由382函数生成4默认值。仅全帧1:1、IQ关闭、8位线性NV12/NV21、匹配输入输出尺寸/UV顺序、端口8/9、core1/2，偶数宽高128..8192，有效偶数stride/slice。运行层每幅图仍限64MiB，8192²只有离线几何证据。

复用383分区，ceil(W/328)向core数倍数取整，右到左边界floor(W*i/n)对齐2、fetchhalo4。生成pass纵向、裁剪、FE/WE、LTM网格/相位、径向坐标和估算工作量；未复制原厂blob或padding。LTM原函数1557c8..15583c：Xgrid=ceil(max(W,320)/12)，Ygrid=ceil(max(H,240)/9)，倒数65536/grid；初版忘min导致小尺寸差分，已修正。径向x=first-W/2，y=-H/2，r²=x²+y²；工作量fetchWidth*H。

实际C体ASAN/UBSAN 40组与原HAL条带经原FW准备的整512KiB CDM和32Bjob相同；另6组NV21/高8192、每组无填充/有填充IO12组完整FW比较，共46几何/52准备条件。完整HAL算法互补dirtyseed canonical基于383方法，原FW几何/CDM不做桩。384/engine384.py扩展NV21与padding，默认不使用MEM_READ观察。仍停220a2硬件enqueue前，无模型engine/pixelDMA声明。

transfer24组故障注入，保留381DMA/PM uncertain retain和A5停机+IRQjoin+两IPE CDM/TOP新resetACK再unmap/free。in-tree k363 W1/-Werror无诊断：core317008B SHAb429dc7b37fb22d9a5628a90eb3e27b780e4df3da568750f815ac7ae09a3b56d，test99712B SHA64141f53e861b10039cd7b334d73811a1fc90ef81fe1f926b35fcae42d7ffde7。未永久安装。

## 本轮实机与当前状态

guard仍/var/lib/samurai/k378-recovered/boot-id-private.txt，host384委托383→382→381→380→379→378，严格原USBkey/known_hosts。唯一/var/lib/samurai/k384-boot-r1 worker14251和collector均terminal/passed/exited，不重用。payload只有core.ko/test.ko/firmware.elf/worker/collector/decoder，无外部stripe或IQ。预检电量100%温24.3°C，taint0CAMSSsuspended。

INIT/PING、RT/非RT双handle/configscratch48/48、RT一帧640×480、FRAME40/ACK72、图像MAP/UNMAP、双destroy、PC/WFI/cooperativestop、三BO/PM全部释放。CMD158/MSG173words，16消息/17IRQ/1debug，wd/protocol0、新相关fault0。未触发失败snapshot，不把snapshot_saved=false当失败。所有exec session已等终态。

实际460800字节输出与382原厂条带实机输出逐字节全等；Y307200字节等于输入，UV143040/153600等于输入、MAE0.203125，色度阶跃处滤波差仍存在，不能说全平面identity/完整IQ校准。CRCinput3426410711/output3085177422，输出SHA182eb4be96df1d710c90ea4b9a5262f522110078b96ae425baac65a596fd84e5。私存384/collected-r1/ipe-output-private.nv12，baseline382同目录。同一张合成图，不依赖光照，不重采四摄。

close-current：taint0、CAMSS/双CCI休眠、9railsdisabled/users0、ICP模块及临时FW无残留、静态ICPdisabled；worker17相关clkenable0。普通四摄仍381每摄12帧640，主摄隔离IPA27帧5阶段/GammaACK1证据。用户空间/DT/Image未改：Image363/7.3.0-rc6-rmx1931-samurai-k363+，boot366 DT365，r29五libcamera包/r24config-stack，362四私有Preview保留。Image源码ba61a62293e0f6bc5838c06f2e85e033e3d702a8，DT源码e217016006e609333a715c10f2f3e442dc4da95f。SSC旧EPERM/daemon4、SLPIoffline/SensorProxystopped未修，不宣称全平台健康；379desktop恢复保持。

## 接下来

原生路径已去掉外部条带依赖。先扩实际尺寸/端口/双核/连续帧，再V4L2m2m/libcamera，适配原厂Gamma/LTM/CCM等完整IQ；禁止把bypass当全目标完成。第5个2MP身份未知（OV02A1B库名不是ID、front共享PHY2/MCLK2/reset12、GPIO29mux未解）、多模式、动态帧时长/自动频闪、光学/几何/同步/连续AF等仍按363/REMAINING-CAMERA-SCOPE.md。目标active，不设预算、未pause。

## 必须保留的资源与历史修正

临时组合SID2222/0、2080/20、20a0/20、2100/20、2120/20、20c0/0、2140/0，mask不交CAMSS；images20000000+08000000仅IOVA名字空间，各image64MiB；parcel07800000≤1MiB在既有shared内，config07600000/4KiB。出错或未知完成retain BO/PM；两IPE CDMresetf/TOP3新ACK且清除成功才free，失败留待明确retry。373先reset/wake后HFI参数program/readback；375正常PC/WFI/CPUoff避免额外全局BCR；376两token、IRQjoin、错误锁存；379MAP/UNMAP ACK44只headerstatus有效、尾12未初始化忽略；CONFIGACK56scratch36/DESTROYACK48/FRAMEACK72。377/378失败自动重启审计保留，内部原因未测，不能改称成功或重复旧事务。372ABTSP+58/arch_coredump_ptr修正及EUD377retired保持。

Unicorn2.1.4全局MEM_READ观察破坏ThumbIT/SP，383最小复现与无钩子对照保留，只用限定观察且对整CDM/job与无观察一致后采信；384常规模型无读钩子。原HALCPUwrite mask不含provider uc.mem_write，不当初始化mask。模型配置寄存器10705，非本轮新实机读值。

ext4访问前reference/kernel284/storage.py::mounted_build()取得/mnt/samurai-full282/build和source354，不格式化/重建镜像。libcamera源/mnt/samurai-full282/libcamera362-serialized-built/src/libcamera-v0.7.2，SDK/home/cy122/x2pro-linux/libcamera214-root，bind串行。exec有session必须同handle终态后再依赖操作。

原HAL281/camera.qcom.so-private SHAe2b1b9b6379507052464d9f9573c2a5a1b1cf37c43947b53645ddc8948a70dde，350debugELF只有符号，objdump原HAL。原FW352/CAMERA_ICP.elf-private SHAa22bc8adbb4ae97e4f8d728eecb1fd19c1bf866250b0bb7e668951c41c159e63，armv7 asm370，objdump-marmv7。Unicorn/home/cy122/x2pro-linux/private-k329-venv/bin/python。fixedGPL9668fcdc6ec15be7a10d66f7b93c347829e0fdb6、CamxChi9f17f1b568626b393e785b369c5dc94543774d7a，partialclone禁止全树gitgrep导致lazyfetch，原型ebd1e440443121d18f730ab2aeea5586a754f36f不完整。383维护者stats/paramsRFC仍draft无本机条带算法，不采用新UAPI。所有rawFW/HAL/asm/CDM/图像/完整日志/校准/auth仅/mnt/e/edk2-samurai-out/kernelNNN。公共mirror/home/cy122/edk2-samurai/repo仅Platform/Realme/sm8150，本地commit不push/PR，保护无关修改与staged。

boot366 SHAc3e4e9c85d80c8ec37605cd522cf716525ae5ebe4fa801342dbf7586c292d924，logdump365 SHAaca01bc2c91928f1a6a6690f62d14db014351ec5049e5684590b40c3c93de8da，旧rollback保留。
