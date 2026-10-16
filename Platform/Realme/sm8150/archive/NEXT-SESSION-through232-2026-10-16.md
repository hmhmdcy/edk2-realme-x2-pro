# Realme X2 Pro 当前检查点

2026-10-16，231审计已关闭、232后摄候选已构建，尚未部署。用户要求搁置前摄纯色物体测试、加快其它适配。完整goal active。[232](reference/kernel232/README.md)、[231](reference/kernel231/README.md)、[230归档](archive/NEXT-SESSION-through230-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 手机仍是boot230。运输reference/kernel232/host.py沿用严格USB邻居/原公钥；guard /var/lib/samurai/k230-runtime/boot-id-private.txt。先前启动及230-baseline guard均失效。私人232/current-work-private.json为下一动作指针。无活动切换/构建/捕获，未安装232模块、未刷写/重启。
- 最新232原生检查：taint0、全部模块taint空，WARN/Oops/GPU/DSP fatal/BT重组五类0；三DSP running、SensorProxy三Has真，Wi-Fi connected、chrony Normal。944包数据库/772ko和786相关文件、boot/logdump、程序配置/NV/persist均保持。旧Q已绑定，新reset provider尚不存在。
- boot219镜像156f0370…/100663296B、Image183 bfa72dd9…、logdump183 e73754c7…、DTB a214fd6b…。FastRPC运行/默认均2abde0ea…/50192B/intreeY，ref1。230真实额外ADSP open→2/close→1、五SSC流67/44/9/10/1正常disable、活动seat0 Wayland UID10000三Claim/Release通过；新模块PM/SSR/精度未验收。
- 相机e49dab26…IMX471/29536B与fae1ed40…CAMSS/777360B、libcamera99990.7.2-r13/config0.1.0-r8保持。设备/CCI/CAMSS suspended、前摄双轨关/users0、图案0、fullres=N。CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认2M/4M，16MP实验关闭。
- 229白天RAW/RGB及32帧RGB有效、非全零、有通道差异；小端RGB888内存BGR已核对。曝光/gain仍调整，不称AE收敛或颜色准确。223暗场不是同曝光对照。用户无纯色物品，已明确延期已知颜色参照测试；不再次追问。仅RAM统计、不保存场景照片/不加照明的要求保持。
- GPS0/Signalsfalse/rate30，watch空闲、UTC自动准备、data worker0。231/232无新搜星/注入。226四轮零CNR/168h XTRA是旧启动证据。MM191 b350c55b…保持，State−1/原因2/Power1；用户无SIM，真实业务待有卡，GNSS不依赖SIM。BT关闭/无连接，phase5未修。

## 源码、产物与回退依据

- canonical /home/cy122/pmos-samurai-kernel136/kernel仍为after228：FastRPC f378afed…已整合，16798符号/772顺序和Image/DTB/配置保持。相机canonical仍旧216 IMX/旧CAMSS，不刷其整体输出。232临时树内编译后源/对象/全局元数据均恢复。当前完整FastRPC源锁在linux-port/ssc/kernel；SSR/DMA排空仍开放。
- FastRPC原189回退88553112…在设备k228-baseline及私人227/228，外建7ca5在k228-intree-stage/私人227；当前树内2abde在私人228。回退须新鲜身份/无活动FD，不用旧guard。相机r13回退r11/config-r6见私人224/225事务；SDK源恢复、r13缓存路径和旧构建器符号数风险见230归档。
- 231：TFTP645/RMTFS172行，16快照/36原生成员逐项核对。原厂只读vendor/persist已卸载；shared是persist独立命名空间，mdtime缺失，不能映射固件mdtime。实际207 RRQ源码对拒绝打开统一发error1（源码推导，无抓包），改errno没有RF修复依据。固件mdtime12B：两次rsize0无DATA、两次12B载荷、两次seek12空EOF；不称六次完整读。RMTFS11数字回复成功、六COW源载入。原厂ruleset/mcfg.tmp也缺失，未补造。未改服务/程序/NV，不宣称GNSS根因；无安全热排空机制，日志安静不能授权推断无在途写。
- 232实际源在reference/kernel232：独占P/Q reset provider、MFD reset backend、持久P→Q/provider链接、UNBINDING门控、P身份及失败清理。参数experimental_p_address_only默认false/0444，未开时P释放前拒绝；开启仅身份且无dummy/regmap/IRQ/MFD children。产品P disabled，实验P enabled，625个显式DT引用核对，未知VIN未填。
- 两个真实树内W=1模块零诊断，匹配当前ABI，私人232/module-build：MFD f633467f…/20520B、provider2223f337…/9744B；源bd6c578e…/b0e46fad…。97例实际函数ASan/UBSan及三个删除防护的负对照通过，不能替代原生解绑/物理读回。SPMI输出读取可能是缓存。
- 私人232/boot-partition-k232-pmic-identity.img已完成打包，45f398f2…/100663296B，实验DTB7e8345ae…。仅固件内嵌DTB改变，全部固件代码及当前Image183/logdump183、头部/ramdisk/兼容DTB/尾部保持，固件原有生成输出亦恢复。回退boot219 156f0370…；当前默认MFD d1ff82c0…/14336B仍未替换。232原生预检13成员归档已逐项核对。最后完整镜像230为8435文件/HEAD5c80582，231/232镜像以私人232最终收据为准。

## 续作与已知风险

下一步直接推进232候选的受控暂存/切换及原生P身份验证，不重跑已通过整套矩阵。重新核对当前身份、当前MFD加载note/默认及模块树，保留旧MFD、boot219和配置，再安装两个模块/depmod、模块加载前options qcom_pm8008 experimental_p_address_only=1。不能热换仍有children的MFD；受控清理后只刷已核对的boot。全部操作手机串行，三路只读研究授权保持。

新启动核对参数实际生效、P身份0x0100匹配、无P MFD children/新增regulator，Q前后状态/前摄回归、taint和fault；再测P→Q及provider解绑/重绑/失败收尾。P解除复位不等于所有物理rails关闭，未知VIN和四路后摄出图仍未完成；契约见232/RESET-CONTRACT。

GNSS仍无正CNR/TRACK/fix，室内窗边、无无遮挡户外/同机Android基线；不从clk prepare0判定XO关，不照抄Hotdog suspend watchdog补丁当零CNR修复，不重做已过online/精度/辅助负对照。前摄真实CFA/几何/白平衡/光学延迟/GUI/性能开放；GPU ISP211 CMA黑帧/unmap349 WARN未修。

FastRPC invoke/put_work/DMA/SSR/reclaim−22及新模块PM/传感器精度、BT phase5只扫描、Wi-Fi/USB PM和大块截断、音频/耳机缺失、充电保护、指纹/NFC实卡、rootfs132可复现整合与构建缓存等见[完整清单](linux-port/docs/HARDWARE-STATUS.md)。不能把局部通过当全goal完成。
