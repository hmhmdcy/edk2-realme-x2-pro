# Realme X2 Pro 当前检查点

2026-10-16，230：真正树内FastRPC2abde已受控新启动加载，taint0，五SSC/保活/桌面Claim再验通过，无刷写。229白天前摄确认颜色信息，未保存场景。完整goal active。[230](reference/kernel230/README.md)、[229](reference/kernel229/README.md)、[上一交接](archive/NEXT-SESSION-through229-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前运输reference/kernel230/host.py，严格USB新邻居/原公钥。guard /var/lib/samurai/k230-runtime/boot-id-private.txt；所有先前启动guard及230-baseline均已失效。私人230/current-work-private.json保留操作状态。新启动自动三DSP running、Wi-Fi connected、chrony Normal，当前无活动切换/构建/捕获。
- boot219镜像156f0370…、Image183 bfa72dd9…/logdump183 e73754c7…/DTB a214fd6b…保持，本轮没有刷写。IMX471 e49dab26…/29536B、CAMSS fae1ed40…/777360B，772ko/786模块相关文件与228暂存清单一致，其它785项及944包数据库、程序/配置/NV/persist均核对保持。
- FastRPC运行与默认均2abde0ea…/50192B/intree=Y，loaded-note匹配、taint0，全部模块taint空、五类fault0。当前refcount1，真实额外ADSP open→2/close→1；清理停daemon后也实测ref0。外建7ca5/O4096是旧228启动证据，原189是FD1/ref0，不能混写当前。
- 230自动SSC真实加速度70/光线10条readiness，三Has真；五流67/44/9/10/1均干净disable。实际active seat0 Wayland UID10000三Claim/Release通过，子进程核验自身session、原daemon身份及Polkit策略保持。新模块PM/SSR/物理精度尚未验收。
- 相机全栈99990.7.2-r13/config0.1.0-r8，CPU/system ISP；通用堆root/video0660+uaccess、FastRPC池root0600。设备/CCI/CAMSS suspended，前摄双轨disabled/users0，图案0、unprocessed_fullres=N。重载WP须现取argv/env。
- 229白天4MP RAW/RGB各6帧及32帧RGB均有效非全零。RAW63–1018/std约37；末帧R/G/B71.11/72.45/70.69，12.86%像素通道差≥12，clip0.074%。小端RGB888内存BGR顺序已核对。曝光33192µs/gain1→1.573仍调整；不称AE收敛/颜色准确。仅RAM统计、无场景文件/外部照明，全部格式/图/控制恢复。230未重拍。
- IMX471 CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认2M/4M，16MP实验N。225手动控制/元数据来源/生命周期修复保持。夜间223 RAW62–133/std2.66不是同曝光对照。
- 当前GPS0/Signalsfalse/rate30，watch空闲/data workers0、UTC自动准备；230无手工搜星/辅助注入/有效期重测。226零CNR四轮和168h XTRA均是旧启动证据。MM191 b350c55b…保持，State−1/原因2/Power1；用户无SIM，真实业务待有卡，GNSS不依赖SIM。BT关/无连接，本启动重组0不等于phase5修复。

## 源码、产物与回退依据

- canonical /home/cy122/pmos-samurai-kernel136/kernel的FastRPC已在228正式整合f378afed…，树内.c/.o/.ko更新，after依据私人228/canonical-after-private.json，本轮保持。16798符号/772顺序、Image/DTB/配置及其它输入保留。相机canonical仍216 IMX/旧CAMSS，不刷其旧整体输出；相机当前源锁camera/kernel/0005及223。
- 完整GPL源码、相对189的补丁和当前运行/默认锁在linux-port/ssc/kernel。真实树内目标W=1/modpost通过，intree=Y且未伪造宏；树内2abde与外建7ca5的19540字节.text一致。227十一例原函数ASan/UBSan与负对照通过，189 freezer保留；这些不等于SSR/DMA排空。
- 原189回退88553112…/50240B在设备k228-baseline/fastrpc-original-private.ko及私人227/228/canonical-fastrpc-before；外建7ca5在k228-intree-stage及私人227，树内2abde在私人228/fastrpc228-intree-private.ko。回退须核验当前身份，不能用旧guard强制卸载有FD的驱动。
- 相机r13/r8、20补丁/13包；SDK原work/libcamera225四项恢复。r13缓存libcamera225-r13-built/src/libcamera-v0.7.2；229仅新编统计客户端。旧186/189构建器符号数过期，勿重放。r13回退r11/config-r6见私人224/camera-forward-repo-r11及225事务，只模拟通过，勿混旧r8/82c。
- 230清理先后因生成num_users=4096和旧显示taint0断言失败，均发生于对应卸载/模式切换前；原脚本、worker及失败保留。核验明确阶段后仅继续余下步骤，最终r3终止0。冻结前上传路径/散列/身份再核对；一次Linux→bootloader和fresh fastboot→Linux，无flash。末USB回执缺失由fresh fastboot及新Linux身份闭合，未重发。
- 私人228原生119成员、229数值日志30成员、230原生116成员均逐项核对，含失败/新启动/原生测试，归档指纹不公开。最后229只拷贝镜像8394文件/HEAD5c80582，diff check0、无暂存/提交/推送；230镜像以私人230最终收据为准。

## 续作与已知风险

树内加载验收已完成。继续GNSS已有TFTP/RMTFS错误与RF/资源时间线，或后摄P/Q依赖实现；不无端重复已过矩阵。GNSS仍无正CNR/TRACK/fix，室内窗边，无无遮挡户外/同机Android基线；不从clk prepare0推断XO物理关，不抄Hotdog suspend watchdog修复当零CNR修复，不重做191/201 online、209精度及226 HIGH/注入负对照。

后置四摄仍未出图；先解决PM8008 P/Q显式依赖、早期P reset/gpio-hog所有权，未知PLDO VIN不猜供电。IMX319 OF/资源/runtime PM候选、GW1 CPHY、3M5缺GPIO按OEM no-op及未知人像型号见227/PM8008-DEPENDENCY。

前摄真实CFA/几何/方向/白平衡/标定、光学2/1帧延迟/GUI/实时性能仍开放；统计通道均值接近不当颜色校准，16MP保持实验。GPU ISP211 CMA黑帧/unmap349 WARN未修。

三路只读研究授权保持，手机串行。FastRPC invoke/put_work/DMA/SSR及reclaim−22、新模块PM/传感器运动精度；BT phase5只扫描；Wi-Fi/USB PM与大块截断；音频音质/耳机缺失；充电保护、指纹/NFC实卡、rootfs132可复现整合和交叉构建/缓存迁移等继续按[完整清单](linux-port/docs/HARDWARE-STATUS.md)推进，不能把局部通过当全goal完成。
