# 当前检查点：420（逐帧IQ生产通道已正式安装）

读WORKING-BOUNDARIES.md、reference/kernel420/README.md。完整多摄/骁龙ISP目标active；已开灯。419全文归档archive/NEXT-SESSION-through419-2026-10-21.md；不再反复扩大已通过算法矩阵。

## 正式设备

已安装五个libcamera运行包99990.7.2-r31与config/stack0.1.0-r26、419生产core+adapter。13包构建/签名核对，6IPA签名匹配包内核心，6IPA二进制与r30相同；原40补丁/全功能子包/IPA接口保留，新增0041请求补丁。公共配置payload不变，精确依赖pin更新；/etc四份个体配置未变，原厂表不进公共包。

候选源码/mnt/samurai-full282/libcamera420-request-r31/src/libcamera-v0.7.2复制418已验证源，四文件hash相同，复用418零fuzz及37模型/16非零实像素证据。包内strip核心SHAd8c841d28f65bd1746e240beea71af33b83087f511e6359ba75099ea09c0b05b，不混418未strip实验库55721…。linux-port/packages两配方与源锁已更新。

420一次事务root /var/lib/samurai/k420-install-r1，worker10893/client/collector终态且passed。停止消费者→owner/DMA释放→原子替换2模块/depmod/重载→七包精确离线升级→测试→重启原用户服务。正式磁盘文件与loaded notes一致，测试参数无。旧r30/r25七包/签名索引/world/repo/395核心393适配器备份保留，本轮没有执行回退。勿重启已完成事务或重新stage旧root。准备阶段两次只读查询错误已修，无状态切换。

生产93jobs=93done/direct，failed/cancel/firsterror0，starts/stops7：四摄各12=48；主RAW+NV12六（原IFE SOF匹配）；RAW-only六对无IPE；独立进程IPA27/五control阶段/GammaACK1；普通用户PipeWire四节点/广角12。四摄/dual/isolated日志均requests=1；WirePlumber实际映射系统库。GammaACK为IFE，**自动IPE参数仍全零旁路**，不称自动原厂画质。

最终PW11073/WP11076 uid10000单例，owner_refs53为桌面CAMSS句柄。ICP/CAMSS双CCI suspended、17clk0/9railsdisabled-users0，CPU/IRQ/PM/backing/map/import释放；新fault/dump0、watchdog/protocol0。guard394=/var/lib/samurai/k394-recovered/boot-id-private.txt不变，本轮无重启。taint512源417-r2已修WARN，保留不清标记，不声称taint0。

## 内核和恢复依据

source354 branch samurai-ipe-error-buffer419 commit07d2ca735f88649587c0e89802febff6dbf2b443干净，420未改代码。生产core419848B SHA63131c5719526ca796955f4d833380a12c36c62557ccf539e85bd58c0f070632；adapter132400B SHA46f91cc8dd024626f05a276e63dd8384bb6a056d15bf441c7d44a91ab4c2e06f。**e27ad524…吞ACK临时核心绝不能当生产**。Image363 release7.3.0-rc6-rmx1931-samurai-k363+、DT389/CAMSS389/logdump365/SGownerFW保持。SoC/板级/主线/UAPI/驱动/用户空间分层描述。

419 ERROR缓冲修复：七项逐帧所有权均释放才不queue_error，便于DQBUFFER返回已知ERROR；未知DMA继续poison及保引用，全局fatal不删。24实际worker/vb2模型、W1/Werror构建、真实typed LTM+Gamma成功ACK被吞一次/变体通过。约5.1秒reset，IQ8944B/parcel548864B保留到双freshACK3,3后退役；恢复460800字节等406参考。blocked失败回调6.7ms。物理停机失败仅模型覆盖，本轮未重复故障注入。

419原始r2 worker报告state.passed=false必须保留：混printk/uptime误把4条预期错误归unexpected。严格fault-validation按唯一drop→reset→retirement→下一SYS_INIT边界，恰一核心-110与适配器[-110,-5,-5]，无其它fault；client通过/正式恢复。原报告不改，不为修报告重做实验。保护394丢ACK重启/ramoops及395两微秒复位/readback/freshACK后释放修复。

## 下一步（主线工作）

接IPA prepare/result、407..416原厂数学与真实曝光/增益/统计/输入域，生成非零LTM/LCE；history只最终图像processed(success)提交，失败discard。Media Request完成不等于图像成功。IFE已有CC/Gamma，未经域证明不再次叠原厂RGB曲线。补实际缺的LA/mask/weights/scalars/inverseGamma，优先主摄再复用四摄；基础AE/AWB/IFE调校已存在。当前通道已部署，不再把打包或失ACK验证当未完成主线。

完整scope读reference/kernel363/REMAINING-CAMERA-SCOPE.md：四摄GW1主/IMX319广角/S5K3M5长焦/IMX471前基础可用不等于原厂画质；第五2MP身份未定，vendor OV02A1B不足以证明，PHY2/MCLK2/reset12/GPIO29与前共享需正确mux，不能猜OV02A10。多模式/帧长/防频闪、连续AF/光学/几何/多摄同步、implicitfences/SSC/旋转未全复验。

原厂数学细节416及419归档：IPE input SP340非SP240；2760调校管理器非版本；cache149a8.version1才设request1，否则初始0/ptr3024。HDR88/92槽1/0 time/sensitivity比，control2零。154TMC两架构一致仅合成统计。darkY不clipanchor1/nohistBYTE1/原地左值已更新/firstgain>=1024不夹unity；raw124/140身份未解、90次计算非帧、历史atten前ADRC后待commit。406显式IP位勿回退HAL DC/quarter gate，maskhalo/crop保留；405unknownDMA整parcel+images保引用。

## 环境

每次WSL访问source/build/ext4先root storage284.mounted_build挂原32GiB，勿重建/格式化；source354/build在/mnt/samurai-full282。root PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原厂系数/夹具/ELF/图像/完整日志仅/mnt/e/edk2-samurai-out/kernel420及前序。公共仅作者代码/脱敏报告，mirror本地scoped commit护无关index，不push/PR。保护NV/OTP/个体备份/密钥/电池温控；未知事务先查。按改动验证、复用未变结果，不默认全量扫描/固定次数/重复下载。
