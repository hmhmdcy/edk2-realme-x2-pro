# 当前检查点：437（主摄 AWB 稳态及连续锁定通过）

完整多摄/ISP目标active。先读WORKING-BOUNDARIES、reference/kernel437/README。436已恢复原厂BLS，消除主摄大面积雾/亮环的主要配置遗漏；437修复AWB元数据：等待GTM回执不重算AWB的帧原来被无条件设locked0。新AppliedAwbStatus绑定有效收敛对应的实际量化WB增益+SOF；相同WB等待帧保持、增益改变不沿用、旧SOF不追认；缺BG/无已知参数/禁用或重配置/重启清除。缺配对统计的frameMetadata回退仍false。原AWB算法筛选/增益/速度/tolerance.015/三次稳定判据不变。

## 实际状态与候选

437 r1复用436模块无AF/无策略切换，240实拍/237math：63locked但最长1连续，62次同WB的未计算帧掉锁。不是整个240帧不收敛；436 AF205帧只有16次有效区域AWB计算，多数时间扫描暂停AWB。r2新模块普通50帧47math、隔离52帧49math，两路各连续8locked而结束（240/20s仅上限），每路5个未重算且相同实际WB的锁定帧。合计102实拍96math+6bootstrap；typed GTM实际ACK/cookie/gen→immutable TMC→同SOF FULL/PD10→成功history及上一成功lux全部审计。两bank/ordinary vs isolated进程区分通过。

新用户源 /mnt/samurai-full282/libcamera437-awb-history/src/libcamera-v0.7.2，build1/IPA5；仅camss.cpp+awb_status.h两文件改动，0049以436为base零fuzz/offset字节重放。IPA8117008B/a4c0b7e6765504ccc440f1332bf84e8a0ea7a8ec35c38b0a9354d5aab8ae587e；签名3d2eea586a17ba5c3816f25acdba72bdff8740a9fdcedb4209008aa57ed08e57；库50923736B/af3bc105448c2d04407362992aa1682b6504956ded26a57d568544470f799c51、proxy1674864B/093df5faa73b42b741e2b61d862fefc292fcf7ced2ccfb6f6f9389f70b182dcf与436相同。匹配新模块和签名，不混旧模块。

原厂修正主摄profile仍b4b6daa2d8039963a9c07a6a09b27e87a293a0b102644a1f0ca3e89648f4c40b；436原Sunny IFEBLS两根10区交叉核对960U14→3840U16及2175/2048 normalization。LSC/GTM/TMC/LTM/PD10/色彩/Gamma未改；原manual/v2flags1和非零GTM份额保留，只已支持TMC11 model2，非完整OEM tone分支。

内核未改，source354 HEAD9bc07e6339128ae8d3525c7d5c9bca5d0fbc46f3/samurai-vfe175-gtm-reopen434，434 CAMSS3edb28d1/core d391fa24/m2m e6828a0c。正式仍420/419、Image363/DT389，临时实验均恢复，不是已经永久安装437。r1/r2 worker/client全部终态，模块/服务/资源恢复，无newfault taint0。

## 检查与未完成范围

实际ARM64 IPA模块合成BG+延迟GTM ACK验证保持、缺BG清除/重收敛、重启复位；同测试器加载原436真实模块在SOF5等待帧复现locked0反例。实际状态头另核增益变化、旧SOF、不合法/未收敛/非有限/复位；legacy factory/bypass/profile/GTM成功历史契约通过。源码哈希/原算法与profile不变、两文件patch重放通过。固定数据/原厂系数/像素/完整日志仅private kernel437。

两路末端CCT估计4772/4759K只是参考模型输出；锁定证明稳态，不是绝对色准。下一步扩大广角/长焦原厂GTMTMCLTM与真实PD10自动链路，前摄保持其原厂禁用/旁路语义，再其它尺寸/视频和正式颜色/平场/噪声/锐度。426已恢复四摄DS4模块/模式及56次查询，431 inspect-gtm已定位四摄GTM原件；复用原厂mode selector，不能直接套主摄参数。第五2MP、个体光学、多摄几何同步等363完整范围保持。

## 环境和安全边界

每次WSL source/build/ext4先root调用284/storage.py mounted_build原32GiB E盘，禁止格式化重建。SDK临时bind串行使用，不能同时跑两个sdk_candidate。437 storage在新源存在后自动指向437，否则仅历史baseline436；当前已是437。host继承436→429新guard，USB SSH正常。不猜MMIO，不恢复429越界诊断；DC仍RT2→kind0→bank0 coarse clear/write、FULL read，未逐字节dump SRAM，a7scratch不是统计。

437开始mirror HEAD bae4f75c941658dcc4cb21a152970b2c5f5f49b5，435/436公共文件已在此恢复并提交，不能信早期d21fac6a。继续public_module导出、scoped本地commit，保留无关index/worktree/untracked、不push。原件与私有数据仅E:/edk2-samurai-out。C/WSL过期对象清理已完成，当前空间以实际df/PSDrive为准。
