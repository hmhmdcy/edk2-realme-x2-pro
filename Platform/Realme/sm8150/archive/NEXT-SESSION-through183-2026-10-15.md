# Realme X2 Pro 当前检查点

最后核对：2026-10-15，kernel183/logdump183已部署。活跃播放/录音中WCD STOP −ENOTCONN缺陷已修，原客户端自动恢复及左右匹配功放关闭对照通过；当前183两次s2idle及醒后原生/桌面左右回归通过。完整音频goal active：耳机实物、真实watchdog、跨启动/更长可靠性、音质/瞬态/保护仍开放。用户暂无耳机，不重复问。规则见[边界](WORKING-BOUNDARIES.md)。

## 当前部署与实机依据

| 项目 | 最后核对结果 |
| --- | --- |
| 组合 | kernel183/logdump183；boot/DTB172、software/modules132、Mesa149、UCM173保持，只刷logdump |
| 标识 | #183 SMP PREEMPT Oct15 00:20:49 CST；Image bfa72dd920c8376ceefc458fe7202a73ddb364b6727556471d70c8d0e7ade469；logdump e73754c7d327925acf031aed54e0e6d02069b7a112c32b187ac9bfb468da1358 |
| 初启动 | 新boot78.44秒，card/WCD0x411/MBHC/桌面自动出现，所列16项0，SD1与GPIO137/138/140、分区/NV通过 |
| 183修复 | NGD QMI消失先于report_absent；is_online检查设备/地址/传输，ASLEEP仍在线。slim_stream_abort仅离线释放本地ports，不发硬件命令，在线EBUSY；WCD正常清理与首真实错误保持，离线START拒绝ENOTCONN |
| 原客户端恢复 | 完整v2在双PCM RUNNING时一次合成MMU故障报告，原paplay/parecord自动重接，2旧name FD EIO，18项窗口故障0；约3.690秒观察两PCM再运行，未手工重绑或替换客户端 |
| 匹配声学 | v2原流左右相关0.9119/0.9312，同流实际功放关闭对照差20.48/40.37dB；沿用0.75/6dB/8dB门槛，无削顶、volume/mute及16控件恢复 |
| 当前PM | 空闲45/活跃90秒s2idle实际45.330/87.039秒，每例success+1/fail+0、RTC IRQ+1；2392/2210 PM callback end全err0，同boot无重绑，原双工客户端正常结束。不是deep STR或休眠无损音频证明 |
| 醒后回归 | 原生左右0.9809/0.9979、功放关闭差22.02/41.86dB；桌面0.9744/0.9967、同boot醒后原生off参考差20.72/40.84dB。均检出、无削顶，桌面后回归未另做独立off实验 |
| 最终1472.87秒 | 同183 boottaint0、ADSP running、单card/alsa-card和HiFi(Mic,Speaker)，PCM关、左23/23右22/22关闭静音且failed0，16控件恢复、五consumer各1、两map/一MCLK、cache-only=N、NGD suspended；NV/分区/770模块132核验 |
| 日志范围 | 当前ring从0秒且含#183 banner，所列20项全boot0；保留两次预期合成crash及首轮脚本失败。未列整机问题不被说成清零 |

依据：[183完整记录](reference/kernel183/README.md)、[182](reference/kernel182/README.md)、[181](reference/kernel181/README.md)、[171线路与人工双组听音](reference/kernel171/README.md)。其它硬件见[清单](linux-port/docs/HARDWARE-STATUS.md)。

## 源码、产物与回退依据

- WSL /home/cy122/pmos-samurai-kernel136/kernel tracked12。本轮六文件：SLIM core/stream/NGD/内部及公共header/WCD codec；[完整hash](reference/kernel183/source-validation.json)。MFD181/PDR180、MBHC172/machine175、15显示源163及缓存策略保持。新增两个导出API及内部controller回调，现有函数签名保持；不是声称所有ABI从未改变。
- 69实际函数host场景/六负对照、ASan/UBSan、四对象W=1/全编译/FAT回读通过；全编译仅既有eud未用函数警告。770模块仅两个既有build-id差异，runtime132保持。unsigned本地补丁用no-signoff风格检查，首次缺签名失败日志保留，不造签名。逐port已有disable/unprepare错误处理未扩大。
- 当前与回退私人镜像在E:/edk2-samurai-out/kernel183、181等；当前身份在手机k183-final和私人k183-all包。183 preflash属旧181，下一次切换新取身份。logdump181 56aa1c46…是本轮完整回退，仍有新发现的活跃流STOP问题；boot172 77e1a272…、DTB172 22c1f2ad…保持，BDS源164/固件172/FdtBlob129保持。
- 更早180 c5439e24…有config72/mask6，176 6e3ebbe7…有178 SSR/初启动缺陷，175有reset −110；172/171 SD1完整原件保持，164/168是SD0，不混入当前验收。
- UCM173由callaudiod负责端口并卸载Pulse自动切换模块，四设备/四profile；勿强制补载端口模块。旧软件/rootfs132更新可能覆盖UCM173/Mesa149。原132 UCM保存在私人173证据。

## 续作与已知风险

1. 本轮kernel181活跃双工crash：WCD STOP −107和ASoC3，原左编码未达旧native off参考、右通过；后续新原生四例左右通过且1373 mixer值相同。保留旧失败，没有推定幅度变化根因。183首轮驱动错误0，但amp-off脚本误要求逻辑muted1，实际GLOBAL0/AMP bit0=0/Powered0；修正硬件判据后独立v2通过。两份原件都保留。
2. 下一步补其它麦克风/用户路由、跨启动/更长稳定性、音乐/人声/瞬态/保护；实物耳机/耳麦/按钮仍待。真实DSP watchdog和所有SSR未验收。171人工滴声有效，当前不是完全不能播放，也不把编码音当作音质完成。
3. 178失败下界IRQ27720/config144/mask12/ASoC6/PDR2，初启PDR3/config8/mask1；180停启config72/mask6。181停启/182仅录音合成crash通过，不能覆盖本轮新增181活跃双工失败。183通过不改历史。
4. 180 F1无RX回执仍Linux，重绑EUD wait11未恢复、原因未定。Linux RESTART2在180/181/183成功：新身份、完整停机/冻结、按本树CSR_EUD_EN关闭EUD和单次bootloader请求，再看实际fastboot。183前置JSON捕获。一次SCP尾部中断保留半件，确认quiesce未开始后重取SHA通过，未重复切换。
5. 182原字段recovery_latency_seconds=7.927包含后续播放/等待，派生摘要更名、原件保留。180录音错标签176已依据boot-ID/#180 guard更正派生标签，原包保留。176重绑、177两短s2idle属于历史各自组合。
6. 蓝牙只扫描、不连接，振动不加脉冲；保护NV/校准/私人数据、电池保护边界。Wi-Fi/USB/蓝牙等独立问题按硬件清单保留，音频所列20项0不是整机全清。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
