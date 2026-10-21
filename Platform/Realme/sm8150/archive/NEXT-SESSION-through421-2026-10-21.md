# 当前检查点：421（真实观测/最终回执及统计发布重入修复）

读WORKING-BOUNDARIES.md、reference/kernel421/README.md。完整多摄/ISP目标active；用户已开灯。420归档archive/NEXT-SESSION-through420-2026-10-21.md。不要重跑已完成事务/算法矩阵。

## 421候选（未永久安装）

候选/mnt/samurai-full282/libcamera421-frame-history/src/libcamera-v0.7.2，基于已部署420r31。4文件0042补丁零fuzz复现。新增IPE观测拥有1024BHIST副本、同SOF曝光ns/物理增益、原始行/码/source、IFErevision、可用lux/exposureIndex和Gamma override标记。统计DMA可复用，不持旧buffer指针。Statistics携token/摘要到pipeline，最终tryComplete在图像/RAW配对后反馈success；RAW-only不提交，缺统计不造token。最大64pending，epoch/token单调，晚到旧成功superseded不回退，stop清pending。

**这是观测历史，不是TMC/LTM数学状态；自动IPE非零参数仍旁路。** 不能把Gamma override标记当传递域证明，不能把单曝光观测造为HDR双槽或DRC/darkGain/raw124/140。数学候选还要绑定计算所依赖的history版本/重叠请求/失败依赖，不能直接宣称成功commit数学已完成。

私有IPA接口2（YAML/内核UAPI未改），库/IPA/生成proxy配套构建/签名通过。最新r3 librarySHA9fb54db05e713f165dd00a203fa3c0e509f0a56ab1f3d7986a80afb60ae16597；IPAced9de9043e095314a7e3662f5bf56e26e6f88e356bbd6f3ce9312d67528e9f2，proxy15ec5035df641782ec189d088d36768525896e868a21ea39020f5f2f89bd4973。不要只换单个新IPA2组件。22history+12实际aggregate+11实际stats/queue函数ASanUBSan共45项，native实测默认/强制隔离；**原生in-process IPA未测**。

## 重入问题及实机

r1 worker12693/root /var/lib/samurai/k421-history-r1：四摄48+dual6+isolated27=81IPE，RAW-only六对不启IPE且6观测全discard；正式前摄再12。主摄12图像仅10观测配对/commit，13prepare/3abort。SOF1/2明明有观测却fallback：statsProcessed先erasepending，调用queueIspUpdate→同步prepareParameters，等待期间递归处理相机事件，histogram尚未发布，completeMissing错误判缺。旧函数模型重现counterexample。

修复先发布/认领统计再同步IPA调参；返回后检查running/epoch；queueIspUpdate也防停流后使用已释放paramsbuffer。r2 worker13575/root ...k421-history-r2只复测受影响主摄/隔离路径，不重跑其它物理摄/RAW：主摄12/12观测配对及commit、无metadata fallback；隔离29图像/29观测，28有配对回执（27commit/1晚到旧sof superseded），1未认领观测abort。应用28份有统计曝光/增益与同SOF记录匹配；**应用SOF7确实没有BHIST，metadata恢复且无token/回执，不计为匹配**。正式前摄再12。

r2首次离线checker错误假设每图像都有BHIST，KeyError7保留hardware-r2-first-check-validation；修checker明确计无统计并核对无commit，未修改原worker或为修报告重拍。r1/r2 worker/client/collector全终态、rawpayload/日志保留。源准备几次文本空白断言失败均仅主机；r2第一次launch缺staging-r2报告在发命令前退出，补保存报告后才launch。不能重启旧事务。

## 正式设备保持420

已装五libcamera运行包99990.7.2-r31+config/stack0.1.0-r26；419生产core/adapter。421仅临时库/IPA/proxy环境，未改正式文件/个体配置/加载notes、未卸模块/刷写/重启。当前239direct=原420的93+421新146（81+41候选及24正式），failed/cancel/firsterror0、starts/stops17。PW13618/WP13621 uid10000各一，owner_refs53桌面CAMSS句柄。ICP/CAMSS双CCI suspended，17clk0/9railsdisabled-users0，CPU/IRQ/PM/map/import释放，新fault/dump0。历史417WARN taint512保留；guard394=/var/lib/samurai/k394-recovered/boot-id-private.txt保持。

维护内核source354 branch samurai-ipe-error-buffer419 commit07d2ca735f88649587c0e89802febff6dbf2b443干净。core419848B SHA63131c5719526ca796955f4d833380a12c36c62557ccf539e85bd58c0f070632，adapter132400B SHA46f91cc8dd024626f05a276e63dd8384bb6a056d15bf441c7d44a91ab4c2e06f。Image363 release7.3.0-rc6-rmx1931-samurai-k363+、DT389/CAMSS389/logdump365/SGownerFW未动。**e27吞ACK测试核心不能当生产**。保护394重启/ramoops和3952us脉冲/readback/双freshACK后退役修复；419原worker混时钟false与严格有序verifier成功分开保留，不重复注入。

## 接续主线

直接在421真实观测/回执位置接407..416原厂数值及本路径所需LA/mask/weights/scalars/inverseGamma，确认IFE/IPE域，防重复已有CC/Gamma。区分缺统计的明确沿用/旁路与“有统计却被重入提前完成”；后者候选已修，正式r31尚未收录。匹配IPA2库/模块/proxy后续统一集成，当前421未打包。不把全部观测/模型通过当完整画质或数学状态已完成。

全scope reference/kernel363/REMAINING-CAMERA-SCOPE.md：GW1主/IMX319广角/S5K3M5长焦/IMX471前基础取流；第五2MP身份/mux未完（vendor OV02A1B不足证明，PHY2/MCLK2/reset12/GPIO29共享前摄不能猜OV02A10）；多模式/帧长/防频闪、连续AF/光学/几何/同步、implicitfences/SSC/旋转未全复验。SoC/板级/主线/驱动/用户空间分层。

原厂数学416及420归档：IPE input SP340非SP240，2760调校管理器非版本，cache149a8.version1才设request1否则初始0/ptr3024；HDR88/92槽1/0 time/sensitivity比，control2零。154TMC两架构一致仅合成统计。darkY不clipanchor1/nohistBYTE1/平滑左值已更新/firstgain>=1024不夹unity；raw124/140未解，90次计算非帧，历史atten前ADRC后待数学commit。406显式IP位勿回退HAL DC/quarter gate；405unknownDMA整parcel+images保引用。

每次WSL源码/build/ext4访问先root storage284.mounted_build挂原32GiB，不重建格式化。root PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原厂系数/ELF/图像/完整日志私存/mnt/e/edk2-samurai-out/kernel421及前序；公共只作者代码/脱敏报告，本地scoped mirror提交护无关index、不push/PR。保护NV/OTP/备份/密钥/电池温控；未知事务先查；按改动测试，不默认全量扫描/重复下载。
