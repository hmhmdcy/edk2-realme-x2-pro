# 当前检查点：371（持有窗口仍在probe返回前重启，恢复验证通过，目标active）

2026-10-20。读WORKING-BOUNDARIES.md及reference/kernel371/README.md。上轮370的离线改动已实际尝试，新证据改变下一步；不是等待或连续无进展。完整多摄／ISP目标仍active。

## 当前设备

当前guard `/var/lib/samurai/k371-recovered/boot-id-private.txt`；用reference/kernel371/host.py。USB NCM已恢复，strict原密钥／known_hosts保持，private371/current-transport-private.json选择USB。369旧Wi-Fi guard已失效，不可再用旧guard发写操作。没有活动构建或实验worker。

实际Image363／7.3.0-rc6-rmx1931-samurai-k363+，778模块；boot366嵌入DT365，libcamera五包r29、config/stack r24、四份私有Preview默认362。已映射原厂曝光／手动防频闪、IFE Gamma及既有个体WB/CCT、动态LSC／CCM保留。未永久安装ICP模块，静态ICP仍disabled。

371恢复后四颗传感器各12帧GStreamer硬件采集，主摄隔离IPA另28帧／5阶段／Gamma ACK通过，故障增量0。SSC、SensorProxy、greetd、Phoc/Phosh和adsp/slpi/modem健康，无额外正常重启。终态十个相机模块loaded note匹配磁盘，CAMSS/双CCI休眠、九相机电源disabled/users0，PW/WP各一uid10000、taint0，无ICP模块／临时固件／动态节点／worker。证据371/camera-runtime-validation.json、final-state-validation.json。不能外推完整光学校准。

## 最近A5真实证据

368原厂SendSfrMessage348字节实际指令11路径确认响应3属于故障；cache/log/format/power为桩，不是整RTOS。369取回568字节标准dump：3、fw01000100、队列索引和IRQ/WD/protocol计数0、SFR空，随后重启无清理终态。原始dump私存369，不能把它冒充371的数据。

370原厂vmm_preinit/program_section_entries实际指令只对L1 memset设桩：代码／异常字段／页表／CSR样本恒等映射，共享／SFR／堆需动态VMM。请求等待块4例确认=1后写01000100版本，369/371已读此版本，推断通过等待点。原始data/prefetch abort4例确认FAR/FSR/type偏移1099a0/1099a4/1099a8、type3/1；CP15值合成且core-save桩，尚无本机异常解码。完整页表／反汇编只私存。

370分开quiesce和stop，start失败保留RAM／映射／PM，临时test显式hold_start_failure=1且CPU/IRQ关、复位成功、映射完整时才failed-held。371核心仅增加DMA开始／完成、PM释放三个日志，test产物与370完全相同。新独立collector和worker夹具通过，两个in-tree k363 W1/Werror模块无诊断。

371实际只启动一次：事务 /var/lib/samurai/k371-boot-r1，worker8617，collector先ready。CPU release后2.502ms响应3／fw01000100／expired0，随后块复位断言完成。没有DMA阶段或PM释放日志、没有worker cleanup状态、没有probe返回的held结果。旧worker/collector均已不在；新启动确认，旧state仍terminal=false/load-boot-test，未改写。仅ready和空日志落盘，没有标准dump／固件异常页，不等于dump未发布。精确复位原因未知，末尾没有modem watchdog，不套用366标签。

持有语义避免了失败路径主动DMA/PM释放仍无法得到窗口，现有证据不能只把重启归因DMA/PM调用，也不证明实际DMA静止。末尾4条fw_devlink 0x180日志经过actual Image363同一core.c核对及LKML代理链接讨论，不能仅凭该日志判定UAF或复位根因；没有改框架或关闭fw_devlink。

新启动boot366/logdump365读回正确，临时firmware与原厂和事务副本hash相同后删除；原件和旧事务完整保留。没有主机复位、刷写、NV/OTP/个体校准写入。新启动未读取旧DDR异常页。

## 下一步

不要再次依赖371用户空间held窗口。先设计在CPU/块复位之前、仍拥有固件映射时完成有界内核现场复制，并将必要字段／代码校验摘要经已工作的printk/ramoops保全；只复制到普通RAM devcoredump仍可能来不及被用户空间持久化。通用SoC核心按已验证加载布局保存范围，原厂特有偏移留在临时诊断工具或明确版本约束的解析中，不散入板级／正常用户空间。继续对照原厂错误停机和MMU／共享区访问，不能延长超时或允许3发SYS_INIT。

371没有再读取重启后保留RAM。369所查5MiB/1280页全reserved/mapcount0只排除普通Linux页分配，不能证明TZ/A5权限；356已保存的匹配原厂19781 pil_camera_mem物理9ab00000/5MiB正确，不重启partial clone大目录git grep。

## 源码与回退

维护源/mnt/samurai-full282/source354，samurai-a5-held-snapshot371／f41d5f828e047b57c61a0e1a3b4dcde3fca96671；父370 e79613d477deee2a55726cc2e05c7789057395ba。实际Image仍ba61a62293e0f6bc5838c06f2e85e033e3d702a8，DT e217016006e609333a715c10f2f3e442dc4da95f。libcamera /mnt/samurai-full282/libcamera362-serialized-built/src/libcamera-v0.7.2，正式r29/r24未改。进入ext4先storage284.mounted_build()；WSL会停止后卸载，不能假设路径仍挂载。SDK bind串行。

公共Git /home/cy122/edk2-samurai/repo/Platform/Realme/sm8150。私存E:/edk2-samurai-out/kernel371有原事务／ramoops／恢复／新模块；原厂ELF在kernel352，3,630,392字节 SHA a22bc8adbb4ae97e4f8d728eecb1fd19c1bf866250b0bb7e668951c41c159e63。arm-linux-gnueabi-objdump -m armv7；Unicorn私有venv在/home/cy122/x2pro-linux/private-k329-venv。固件、原始内存、SFR、完整日志、校准和密钥只私存。

boot366 SHA c3e4e9c85d80c8ec37605cd522cf716525ae5ebe4fa801342dbf7586c292d924，logdump365 aca01bc2c91928f1a6a6690f62d14db014351ec5049e5684590b40c3c93de8da。boot276+logdump363可回退DT；旧k298模块/logdump和362事务r27/r22+338模块+344私有配置组合回退保留。未动工厂备份。

## 全目标剩余

完整HFI SYS_INIT/PING/PC_ACK、IPE图像会话/IO/IQ和后级Gamma/LTM/CCM未完成。已确认三后摄+前摄，另有官方2MP人像，vendor OV02A1B只有库名；原厂19781 cam-sensor@4与前摄共享PHY2/MCLK2/reset12，GPIO29选择待解，不加冲突节点或等同OV02A10。完整范围见363/REMAINING-CAMERA-SCOPE.md。

动态FrameDurationLimits、自动防频闪、其它模式、绝对颜色/黑电平/阴影、几何/多摄同步、连续AF均开放；用户延期纯色/遮光可后做。不要把已有四摄采集或诊断模型当完整适配完成。
