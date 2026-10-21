# 当前检查点：419（逐帧IQ失ACK恢复及ERROR缓冲出队修复）

读WORKING-BOUNDARIES.md、reference/kernel419/README.md。完整目标active。已开灯。418归档archive/NEXT-SESSION-through418-2026-10-21.md；不要扩大已通过TMC矩阵。

## 419当前证据

维护内核samurai-ipe-error-buffer419 commit07d2ca735f88649587c0e89802febff6dbf2b443干净，父417f0b6ea869e3e748e6c1ccfe06865ac8d02c3ef3a。仅适配器device_work：七项逐帧所有权都释放时不queue_error，ERROR缓冲可DQBUF；任一未释放继续poison/保引用。全局fatal与395两微秒复位脉冲/readback/双IPE freshACK后退役顺序保留。

24项ASanUBSan实际worker+vb2模型通过；生产in-tree W1/Werror无诊断。private419生产核心qcom-camss-icp-a5-core-intree-r1.ko 419848B SHA63131c5719526ca796955f4d833380a12c36c62557ccf539e85bd58c0f070632（同417），适配器camss-icp-a5-m2m-intree-r1.ko 132400B SHA46f91cc8dd024626f05a276e63dd8384bb6a056d15bf441c7d44a91ab4c2e06f。**临时吞ACK核心425344B SHAe27ad5242e374140b6bc2a308ba020b612f7c300c4b5ee71e9e6e414346991a6禁止部署为生产**。

复用418实库，两个wrapper各先非零LA暖帧。A提交有效LTM+Gamma，testcore只吞一次完整成功ACK，超时约5.1秒；IQ8944B+wholeparcel548864B保留到停机/双freshACK后退役，失败输出不当成功交付。旧idle上下文保持fatal；关闭最后旧上下文才清fatal。新wrapper恢复LA1024全部460800字节等406参考。各变体3success/3failed，无cancel；导出FD仍在时ownerrefs8正常，client退出后0。

旧适配器r1与新419适配器r2各故障一次，两次总计；有实际驱动变化才重复。r2被fatal拒绝的新wrapper失败回调0.00666163秒，旧r1看门狗日志约3.006532秒；计时边界不同不算严格倍数。wrapper watchdog日志从3变1。物理停机失败仅模型覆盖，未向硬件注入。

**r2原始runtime-validation.state.passed=false必须保留**：worker用printk与uptime数值比较，四条预期错误被错分unexpected；client passed，failure/cleanup_failure null，正式恢复true。fault-validation.json严格按唯一drop→reset→IQ保留→双ACK3,3→retirement→PMrelease→新SYS_INIT顺序验证，恰好核心[-110]适配器[-110,-5,-5]且无其它fault，原unexpected恰等这4条。实验判定passed，原报告仍false；不为修报告再注入。未来模板改dmesg锚点，未重启旧事务。

419-r1worker8177/r2worker9088、client/collector均终态，root /var/lib/samurai/k419-typed-ack-r1..r2。当前正式core395/adapter393/CAMSS389、r30/r25已恢复，四摄各12=48app/48IPE，extra0，失败/取消0，starts/stops4。ICP/CAMSS双CCI suspended，17clk0/9railsdisabled-users0，CPU/IRQ/PM/图像/映射释放。PW9335/WP9340 uid10000各一，owner_refs53桌面句柄。guard394不变；taint512源417-r2已修WARN，保留历史不清标记。没有419重启。Image363 release7.3.0-rc6-rmx1931-samurai-k363+、DT389/logdump365/SGownerFW未改。

## 418候选通道

候选libcamera=/mnt/samurai-full282/libcamera418-request-iq/src/libcamera-v0.7.2，基于391r30；0041-camss-ipe-request.patch四文件零fuzz复现/源hash核对，库SHA55721a2340f3f71f6aadba4e0ba8ade380901ab3774a9961c4eb847c68d9d303。尚未打包/永久装，IPA算法/接口/签名不变。池用标准allocateRequests/V4L2controls/U8固定6008packet，OUTPUT带request，CAPTURE普通。input/output/request三方完成才归还job；Queued finish避V4L2Request信号栈内销毁pool，serial拒旧通知。无参数显式零旁路；旧驱动显式非零返回ENOTSUP。STREAMOFF失败先close/join再释放FD，保IFE SOF元数据。

418有37模型/6完成顺序，实库16非零诊断全有效像素等406，4wrapper取消=2kernelcancel另2未成job；pipeline81request完成（四摄48/dual6/isolated27），RAW-only6不启IPE；候选99job97done2cancel。**自动IPA生成参数仍全零旁路**，非零只诊断。418r1测试逻辑plane布局失败在imageDMA前，修探针单连续plane后r2通过，生产未变。

UAPI CID USER_BASE+1240本地下游非上游分配；6008包v1/size/knownflags/reserved-padding0或全零旁路，colour104/gamma3072/LTM2800；仅worker s_ctrl，EXECUTE_ON_WRITE，imageimport前copy/check/setup。417缺buf_out_validate警告已修ANY→NONE拒隔行，不用r2旧适配器。

## 接续

优先把419生产模块+418用户空间通道打包收敛，然后接IPA prepare/result、407..416原厂算法和真实曝光/增益/统计/输入域。history只最终图像成功commit、失败discard，Media Request完成不等于成功。IFE已有CC/Gamma，不未经证明再叠原厂RGB曲线；补实际缺的LA/mask/weights/scalars/inverseGamma与非零LTM/LCE实机。基础AE/AWB/IFE已存在。

全scope读reference/kernel363/REMAINING-CAMERA-SCOPE.md：现四摄GW1/IMX319/S5K3M5/IMX471基础取流通过；第五2MP/OV02A1B身份未定，共享PHY2/MCLK2/reset12/GPIO29需正确mux，不能猜OV02A10。多模式/帧长/防频闪/持续AF/光学/几何/多摄同步、implicitfences/SSC/旋转未全复验。SoC/板级/主线/UAPI/驱动/用户空间区分。

原厂数学细节416及418归档：IPE input SP340非SP240；2760调校管理器非版本，cache node149a8.version1只设request1否则初始0，ptr3024；HDR88/92为槽1/0 time/sensitivity比，control2零。154TMC Execute两架构一致是合成统计不代表自动调校。darkY不clipanchor1、nohist BYTE1、平滑左值已更新、firstgain>=1024不夹unity；raw124/140身份未解，90次计算非帧，历史atten前/ADRC后待commit。406显式IP不要回退HAL DC/quarter gate，maskhalo/crop保留。405unknownDMA整parcel+images保引用。

每次WSL访问source/build/ext4先root storage284.mounted_build挂原32GiB，勿重建/格式化；source354/build在/mnt/samurai-full282。root PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原厂系数/二进制/图像/日志私存/mnt/e/edk2-samurai-out/kernel419与前序。公共仅作者代码/脱敏报告，mirror本地scoped commit护无关index，不push/PR。保护NV/OTP/备份/密钥/电池温控；未知事务先查。
