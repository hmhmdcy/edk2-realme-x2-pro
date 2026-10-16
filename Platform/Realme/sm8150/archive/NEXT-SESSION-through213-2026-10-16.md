# Realme X2 Pro 当前检查点

2026-10-16，阶段213：关灯后RAW暗噪声与CPU ISP首帧bug已分开验证，helper/属性及一行查找表修复的隔离候选通过固定输入对照。当前仍为212启动，系统libcamera/包数据库未替换，未刷写/重启；下一步保留原包功能完成构建、打包和部署。完整外设goal active。[213证据](reference/kernel213/README.md)、[212验收](reference/kernel212/README.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前运输reference/kernel213/host.py，guard为/var/lib/samurai/k213-baseline/boot-id-private.txt。传输故障前验证仍为212启动、taint/fault0、三个DSP running；独立两候选、RAW暗噪声及固定白输入通过，系统相机库/包数据库未替换，无新切换。212/211所有marker已闭环，不可重放。
- 当前boot211 c3bf043f…/DTB6f9f5b0f…；Image183 bfa72dd9…/logdump183 e73754c7…保持。IMX471模块a28dd67a…，CCI f9c9272a…/PM8008 d1ff82c0…/CAMSS82cbc052…/BT185保持；模块树772ko/786文件。TFTP207 b3bb82b9…/wifi854c9a8c…/MCFG helperd4c62be6…/MM191/helper421/init54/SSC9a1保持。
- IMX471/PM8008静态自动绑定，media0为23实体，sensor有独立TITAN_TOP域。前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/200MHz、CSIPHY2。PMIC源码&i2c4为0x890000，运行i2c-1不等于源码&i2c1。210两轮6帧1928×1088 RAW10及211独立sensor PM/裁剪接口修复保持。
- heap自动加载/权限跨启动通过，通用堆root/video0660、FastRPC专用池root0600。/etc/libcamera/configuration.yaml选择CPU，目录0755/文件0644。212首轮目录0700导致配置不可读/CMA不足，原失败保留；修正后默认配置6帧中首帧黑/后5帧非全黑、无新增fault。没有借环境变量隐藏配置问题。
- 212健康样本及96份归档已验证，213取流后健康也通过：GPS0/Signalsfalse/rate30、BT关闭、UTC第8次准备成功/chrony Normal、NV/产品保持。后续传输故障及最新复查失败见下文，不能用旧健康样本冒充当前状态。

213暗场RAW10经DMA同步、排除行填充后，均值63.949～63.983、标准差0.442～0.476、相邻帧34.6%～36.3%像素变化，非全零/冻结。CSID全1正对照6帧每像素1023；旧候选首帧RGB0、后5帧254，一行修复后6帧均254。所有图案/链路/控制已恢复，最终3DSP running、相机电源/时钟释放、taint/五fault0，NV/产品保持。隔离候选未安装，RGB暗场全零不直接判bug。

## 源码、产物与回退依据

- 内核/home/cy122/pmos-samurai-kernel136/kernel。211只改IMX471源码、板级DTS、sensor binding三文件，212/213无kernel源码变更。其余33份已保存改动保持，25 tracked/11 untracked未暂存。配置fbde3690…、16798符号/order772、Image183及旧canonical DTB22c1…保持；旧canonical不能刷作当前树。[211源码核对](reference/kernel211/source-final-validation.json)。
- 私人211保留source-before、原模块/14元数据、190文件原生归档；当前镜像为boot-partition-k211-sensor-domain.img。回退私人210/boot-partition-k210-front.img，哈希89242ade…；正常回退需新身份核对，不使用旧marker。完整kernel/camera APK及新rootfs尚未整合。
- 211旧boot清理的两次MCLK WARN及恢复证据保留，随后新boot独立PM已验证供电域修复。211 GPU ISP又出现CMA不足、全黑帧及IOMMU unmap告警（保存环形日志可见349条/taint512），与MCLK问题不同，仍未修复。212 CPU默认路径干净，不把旧GPU问题改写成通过。
- 207 TFTP回绕已修，原厂MCFG173文件8,807,671B自动RAM复制/mdtime可读，mcfg.tmp仍0B；PDC1平台/25软件活动无pending为207证据，没有选择/激活和NV写入。radio/Mesa打包债保持。

## 续作与已知风险

用户最新明确房间关灯，后续按暗场判断。必须先对DMA buffer执行READ START/END同步，再用去除stride填充的RAW10直方图/噪声方差、Bayer分通道及帧间变化区分正常暗噪声与全零数据；RGB黑位扣除后全零本身不能证明bug。首帧ISP验收应加已知非黑合成RAW或sensor内部图案对照；原始场景仍私下保存。

213证据回收时USB第三个1MiB块截断，随后小SSH也超时；原密钥Wi-Fi曾两次核验同一213 guard、taint0，但后续SSH亦有间歇超时。host.py已按私人selected-transport-private.json选择Wi-Fi；下一阶段需读取这个选择并做新鲜guard核对，不能只复制旧USB endpoint。手机归档227文件仍待完整回收，主机只有截断副本；Windows/原生Wi-Fi读回及最后完整健康复查未响应。此前相机/三DSP完整健康样本在传输故障之前，两次Wi-Fi guard样本仅证明当时同boot/taint0。任何设备变更前先恢复新鲜连接；不要盲目重启或复位。回收状态见[213归档报告](reference/kernel213/final-evidence-archive-validation.json)，USB/Wi-Fi稳定性未修。

前摄下一步整合libcamera0.7.2原六补丁与linux-port/camera/libcamera/的三补丁，保留原auto/virtual pipeline、其它IPA/代理、工具、tuning和签名依赖，完成可复现包/部署后验默认客户端。当前三pipeline隔离构建不能直接充当完整系统包。helper增益范围1～4.57143，像元修正1µm，延迟仍空；传感器TPG的0x0600/0601位宽疑点未修。再验控制延迟、tuning、曝光色彩方向及拍照应用；GPU路径需单独修CMA预算/黑帧/IOMMU释放。五摄分别验收：前摄完整16MP未完成，后置6400万主摄/1300万长焦/800万超广角/200万人像四路未接入；未知四路PLDO输入、其它模式、冷启/长稳保持开放。不能用非全黑RGB统计证明图像质量。

GNSS真实fix/正CNR仍未解决。用户已确认手机室内窗边，无无遮挡户外验收；209较小UTC误差输入未改善约6秒报告周期，候选未部署。208 ADC变化不能证明RF正常，不重复同一UTC/CNR实验。NTP延迟、GeoClue晚到Signals、原厂初始化/RF/LNA、精度冷启/SSR开放。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。

保留完整目标：蜂窝真实SIM注册/数据/通话/SMS，传感器精度/FastRPC共享池与SSR/SSC首次204退出，BT phase5，Wi-Fi/USB PM，充电闭环及其它外设，radio/Mesa可复现APK和新rootfs均未完成。[全硬件清单](linux-port/docs/HARDWARE-STATUS.md)。
