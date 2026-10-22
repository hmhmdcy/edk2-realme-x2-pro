# 当前检查点：436（恢复原厂 BLS，主摄完整 tone 实拍和 AF 通过）

完整多摄/ISP目标active。先读WORKING-BOUNDARIES、reference/kernel436/README。436保存同SOF FULL/真实PD10/实际6008B IPE包/成片，固定输入硬件回放两次原厂输出相同且等于实时成片；LTM off不能消除上游径向分布，LSC off对照减弱。定位到324内部图案用的BLS0/normalization1实验配置被继承进435。恢复本机Sunny GW1原厂IFE BLS后，大面积暗心/亮环/雾感明显减轻，LSC/GTM/TMC/LTM均保留。

## 当前候选与证据

用户候选 /mnt/samurai-full282/libcamera436-tone-domain/src/libcamera-v0.7.2，build1/IPA5。libcamera50923736B/af3bc105448c2d04407362992aa1682b6504956ded26a57d568544470f799c51；IPA8100224B/510529147d0489b58b62945e9a135ab031cb7cb2853f60589b5d5bd98af4f60c；proxy1674864B/093df5faa73b42b741e2b61d862fefc292fcf7ced2ccfb6f6f9389f70b182dcf。IPA/签名/proxy与435逐字相同。只增加可选只读同帧保存，0048补丁两文件以435为base，零fuzz/offset逐字重放。

内核未改，source354 HEAD9bc07e6339128ae8d3525c7d5c9bca5d0fbc46f3/samurai-vfe175-gtm-reopen434。434 CAMSS3edb28d1…/core d391fa24…/m2m e6828a0c…；正式仍420/419、Image363/DT389，未永久安装。

436原厂BLS：复用324 Sunny原件59238df7…，有界类型解码+原厂ParameterParser独立XML，两IFE根Default/Sensor.9共10区域全960U14/四阈值0，BPS990未混用。转换U16减量3840、Q11归一化2175/2048，只恢复这两项；原LSC/GTM/TMC/LTM/Gamma/色彩/PD10字段不变。私有factory-s5kgw1 profile b4b6daa2d8039963a9c07a6a09b27e87a293a0b102644a1f0ca3e89648f4c40b。export-profile.py是当前导出，stage-runtime默认修正配置；复现旧r1/r3要--uncorrected-baseline。原准备/parser脚本有一次性目录前置，不盲重放。

r1原配置24帧/21math；r2固定输入5回放（stock/noLTM/colour/bypass/stock）；r3只LSC关闭24/21；r4恢复BLS并保留所有原模块24/21；r5同修正配置+已有424 AF采集器205/202，Focused。总277实拍/265math+12bootstrap、另5回放。修正配置合计229帧/223math+6bootstrap；硬件恢复全部passed，newfaults0/taint0，全部worker/client终态。

逐帧审计核对 actual GTM cookie/generation→immutable TMC→同SOF FULL/PD10→IPE最终成功math history，上一lux来自成功历史。r1/r4/r5 SOF12 token13/revision10，GTM5/gen5来源stats9；r3SOF12 token9/rev3，GTM3来源stats3，允许未消费PD10与SOF间隔。各流两个GTM bank。bootstrap不冒算math。IPE库/IPA5/proxy必须匹配；435入口锁与同步frameProcessed、PD10占有/顺序和控制等ACK不阻断统计的修复不变。

## 尚未验收与下一步

205帧AWB全程locked0；AF期间前景变化，不能把FoM变化全当作镜头改善。末帧可辨物体且颜色显著改善，但仍不算绝对色准/平场/噪声/清晰度验收。下一步先查AWB稳态、统计/有效增益/触发语义与残余偏色，继续原厂数据及实拍；随后其它摄像头、尺寸/视频、完整legacy/manual/v2/HDR tone。第五2MP、个体光学、多摄几何同步等363完整范围保持。

435完整自动tone链路和数学检查继承，支持TMC11 model2，原manual/v2 flags1与非零GTM份额保留；不是所有OEM分支完整移植。DC仍RT2→kind0→bank0，coarse DC写/clear、FULL IP读；430/431原厂遍次和因果消费证据沿用，未逐字节导出SRAM。a7scratch不是统计，429越界诊断禁止恢复/不猜MMIO。

## 工作环境

每次WSL source/build/ext4先root调用284/storage.py mounted_build原32GiB E盘，禁止格式化重建；SDK临时bind，用完卸载。436 host继承429新guard，USB SSH正常，私有原件/系数/全日志/像素仅E:/edk2-samurai-out/kernel436。2026-10-22清理旧中间对象约9.5GiB+Windows uv缓存，C可用约11.8GiB，WSL已恢复读写。镜像仓库实际HEAD在436开始时为efd01b4c且435对象缺失，不能信此前d21fac6a记忆；保留所有无关修改，通过public_module恢复435和436并scoped本地提交，不push。
