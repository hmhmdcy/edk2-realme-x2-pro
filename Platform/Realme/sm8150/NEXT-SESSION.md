# 下一会话交接：继续硬件实现（2026-10-10，session71结束）

手机现在运行主线Linux **#61**，boot_id是
`a31c1158-fbca-4515-83ac-1a3b40ee808e`，taint=0。COM14交回Windows，
usbipd为Shared、未Attached，9501/9500/9505三节点OK，没有已知连接owner。
这是本轮结束时的记录；下一会话从实时枚举和新Linux回执接续。

## 本轮取得的进展

触摸已经从“没有总线/驱动/设备树”推进到真机基本输入可用：内建GENI I²C、GPI
DMA、RMI4/F12；增加本机I²C17、供电和引脚描述，并补齐RMI I²C可选复位GPIO。
按Realme 19781原厂接线实现，没有套其它手机的电压/引脚。芯片实际报告
**Synaptics S3706A，fw3078696**，F01/F12绑定，输入节点是`/dev/input/event2`。

用户实际点按、滑动后，手机保存306744字节/12781个输入事件，压缩导出SHA/CRC/
长度均通过。970个SYN_REPORT，241个contact全部释放，223个有移动，按下/抬起
各69次；坐标在1080×2400内，多点通路有数据。最多记录5触点，但尚未严格核对
物理手指数、边缘/方向/精度、休眠唤醒和长期稳定性，不能称为全面触摸验收。

初始54413字节和操作后66932字节完整dmesg都已校验。操作后没有新panic/Oops/
WARN回溯或触摸I²C错误；三CPU policy最高频率1785600/2419200/2956800、27个
温度读数、六个UFS盘与`a600000.usb` UDC仍在。旧RPMh读回-95、PM8009无资源、
QMP/aux_bridge等warning依旧，影响边界见session70/71，未删除节点静音。

屏幕仍是诊断控制台。它用UEFI遗留帧缓冲/simpledrm显示，触摸不会滚动现有画面，
也没有桌面GUI；原生面板、GPU尚未接入。Android及全部数据仍保留。

## 下一步最有价值的实作

优先普通USB网络/SSH，使日志和文件传输不再完全依赖会丢帧的EUD。现有HS PHY、
DWC3和UDC已绑定，但configfs gadget为空；还没配置普通USB函数，也没有真实流量
验收。实际glue是`dwc3-qcom-legacy`，它在peripheral模式设置VBUS override；
EUD tty缺少VBUS通知转发，但尚未证明这就是USB不可用的原因，更没证明Linux
必定与EUD互斥。下一会话应补齐必要的gadget/内建函数并实际连通电脑，而不是再
做一轮同样的只读审查。核实真实结果后再决定具体内核修复。

然后推进本机SOFEF03F原生面板/DSI/DSC与GPU，再电池/充电、无线和音频。
按功能分组，除本轮触摸基础通路外，仍有13类待接入或验收；详见
[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。这些并非13个已确诊的坏驱动，
多数需要板级配置、固件及数据流验收。完整postmarketOS尚未安装，当前logdump
FAT只有约34.91MiB空闲，不能据此认定有足够的持久rootfs分区。

## 可直接使用的代码、证据与回退

- 当前记录：[session71](sessions/71-native-s3706-touch-bringup.md)，
  [校验证据](reference/kernel71/README.md)，[HANDOVER-NEXT](HANDOVER-NEXT.md)。
- 实际内核：`/home/cy122/x2pro-linux/linux`；实际initramfs：
  `/home/cy122/x2pro-linux/initramfs`。当前源码增量已在这里生效，Image是#61。
- 发布仓库：`/home/cy122/edk2-samurai/repo`；Windows文档镜像：
  `E:\RealmeX2Pro edk2`。0007/0008补丁、DTS和kernel71-builtins.config在linux-port。
- 构建/部署记录：`E:\edk2-samurai-out\kernel71`。手机内还有
  `/tmp/K71L`初始日志、`/tmp/K71T`输入事件、`/tmp/K71Z`后续日志；本机/tmp会随
  手机重启消失，但压缩副本和哈希已经保存在reference/kernel71。
- 当前boot-k71-touch.img为6680576字节；logdump-k71-touch.img为64MiB；完整
  哈希见session71/flash-validation.json。只有boot/logdump写过一次。
- 即刻成对回退：`E:\edk2-samurai-out\kernel68\boot-k68-opp.img`和
  `E:\edk2-samurai-out\logdump-k67-usb.img`。boot回退已从手机分区前缀读取、校验
  匹配；原F1固件、RX48/RX53回退仍保留。

这轮Windows一次F1无回执、fastboot未枚举；随后既有WSL工具一次F1有新回执并
独立确认fastboot后完成部署。早期启动阶段一次Windows终端未同步，数据命令
没有发；等用户态就绪后正常读取。失败抓取均保留，不能当内核崩溃或填字证据。
原生终端多份导出成功不代表EUD已无损，仍以手机保存副本校验结果为准。

执行范围用一句话承接：保留Android/全部数据，部署仅boot/logdump，保留既有
EUD/RX53/F1/终端和真实init，连接单owner并finally释放，改动只推fork/master。
不再展开历史EUD reset/延时/掩码或Windows驱动实验，重点继续交付硬件实现。
