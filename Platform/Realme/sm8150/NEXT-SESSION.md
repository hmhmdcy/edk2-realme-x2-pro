# 下一阶段：Wi-Fi实际固件部署与服务验证（session88）

session88继续Wi-Fi适配；充电阶段保持收尾，显示与充电未解决项保留待办。
手机仍#86，boot ID=32bf2d8f-8dde-47dc-9b88-e87db9e95198；3984.69秒taint0。
当前网络接口只有lo/usb0，Wi-Fi未上线；显示超时2/下溢0，display on0/count=0。
真实显示故障快照摘要与86/87一致；本轮没有清空/重武装、开关屏、重启或分区写入。
宿主Wi-Fi依赖内核#89编译完成，27项配置变化；QRTR/QMI/GLINK/PAS/SYSMON/PD和ath10k SNOC内建。
保留全部此前源码修复/模式、14个initramfs文件/308链接及原CPIO；本轮源码仅MPSS DTS增量。
#89候选MPSS节点okay、同机modem.mdt路径，但PAS auto_boot=false；Wi-Fi节点仍disabled。
33项本机MPSS分段固件只读归档/哈希通过，ELF可重定位范围160MiB正好适合既有保留区。
本机msm/modem/wlan_pd、实例180与当前主线PD mapper对应；35项Wi-Fi固件沿用81/87校验。
静态AArch64 qrtr-lookup/tqftpserv-ro构建完成；真实翻译/WRQ函数本地测试拒绝写、越界和符号链接。
测试使用本地文件与socket桩，未验证实际QRTR服务；工具/固件尚未安装，MPSS尚未启动。
关键发现：实际Linux DT来自EDK2内嵌DTB，单改logdump FAT中的DTB不能激活MPSS。
EDK2内嵌DTB未改，boot固件未构建，#89尚未打包/部署；chip/board ID及扫描/连接/流量均未知。
Image-wifi sha=02fbe7e5d20cc2a0f5b55e08511ee9a1a39d2c47516079569fe8dc2368360ea0。
完整构建/固件/测试/现场/边界见sessions/88-wifi-dependency-build-and-read-only-firmware-service.md。

1. 先读sessions/88、reference/kernel88与kernel88私人目录；再读87依赖、81固件/供电、79和68实际DT路径。
   宿主#89已经构建，先核对Image/config/DTB/CPIO哈希和保留审计，不重复运行拒绝覆盖的构建脚本。
   #89含87显示timer候选和86 MP观测修正，均未实机验收；不把构建通过当硬件通过。
2. 下一步构建实际boot固件：备份EDK2内嵌DTB/FV/boot，采用#89 DTB，审查语义仅MPSS两个属性变化。
   实际入口为Platform/Realme/sm8150/FdtBlob/samurai/sm8150-realme-samurai.dtb；兼容DTB保持。
   参考79/68的FV/模块/BootShim/Android头/版本差异验证；不要复用旧会话的固定守卫。
   当前EDK2仓库HEAD=a9e7e86；本次文档提交后固件版本字符串可能变化，应以实际构建HEAD重新核对。
   生成私有boot及logdump候选，#89 Image/DTB放入原FAT，检查容量、来源和全部保留项。
3. 刷写前重新确认手机boot ID、保存完整dmesg/display snapshot/trace/DRM状态，并备份当前#86 boot/logdump。
   用新会话新守卫核对PARTNAME/大小/序列/UFS型号/哈希；逐项检查原生命令退出码，F1后finally释放。
   仅已授权boot/logdump，保留Android/数据/GPT；kernel86/flash-final.ps1停止保护保持，不重放旧OUT。
   #89启动后先验证/proc/device-tree实际MPSS节点、remoteproc offline、QRTR与USB/EUD/触摸/电量计。
4. 固件/工具仅临时RAM目录部署并核对哈希，配置SAMURAI_TFTP_FIRMWARE_ROOT；不提供可写存储服务。
   重新审查显式MPSS启动条件，观察WLFW/PD/TFTP和运行时故障，再取实际chip/board ID选择精确板数据。
   PAS auto_boot=false，Wi-Fi仍disabled；不任挑35个bdwlan之一，不混用他机mdsp，不启动未审阅rmtfs/NV服务。
   接着接入Wi-Fi节点、无线接口、扫描/连接及实际流量；这些步骤当前都尚未通过。
5. 充电和显示保留待办；继续全硬件目标，Wi-Fi之后再蓝牙/音频等，避免重复消耗在充电状态查询上。

Linux源码/home/cy122/x2pro-linux/linux；initramfs/home/cy122/x2pro-linux/initramfs。
私有产物E:/edk2-samurai-out/kernel88；公开只发布增量源码/patch/摘要/证据/doc到fork/master。
完整固件/源码/配置/生成头/镜像/可执行工具/身份留私有目录；历史85/86/87封存不改。
EUD TOP_CFG0x11、整帧/RX53/F1/两终端保持；既有com-up只恢复COM/VBUS，不写CHGR。
充电不写配置/解封/NVM/OTP/FET/OTG/GPIO/MCU，不跑OEM charger probe，不读0051/0053/0072或REG14，不用I2C_FORCE。
最新已采分区摘要见88提取记录与86；部署前必须重新读并核对，不能以旧摘要代替新守卫。
