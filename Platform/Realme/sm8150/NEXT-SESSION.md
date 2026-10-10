# 下一阶段交接：电池/充电与剩余硬件（session76研究，session75硬件基线）

先读sessions/76-charging-source-and-safety-review.md及reference/kernel76/README.md。
本轮仅只读研究：本机原厂BQ28Z610与MP2650配置已核对，相关OPPO/OnePlus及主线
来源已固定提交；主线电量计可先行，MP2650/PM8150b-SMB5不能套其它驱动。
下一步先审查并接入&i2c15/0x55上的只读电量计，保持NVM更新关闭、不解封。
原厂MP2650 probe会复位/启用充电/关闭安全计时器，不可直接绑定探测；看门狗超时
恢复默认模式也不保证充电关闭。其他安全边界及本机温区差异见session76。

当前#76：A640/GMU已启用，本机签名固件加载和Turnip真实渲染通过，
累计39096次交替红/绿三角形渲染、4096像素读回及fence校验成功。
用户照片及纯白测试曾确认静止彩色噪点；关闭EOT单独无效，补齐原厂非连续DSI时钟并
清除继承的controller/PHY强制时钟位后，用户确认全白及重新启动后的首次彩条正常。
最终两次#76启动完整日志无DSI worker错误、SMMU context fault或Oops，taint0；
混合GPU/显示回归共12次显示关闭/开启通过。当前boot_id=af922f36-bacd-481d-a5c5-21c8e3fada65。
DTB只有GPU/GMU status及板级ZAP路径三处语义变化；EUD、触摸、RPMh、init/SSH身份保留。
仅部署boot一次/logdump七次，Android/全部数据/GPT保留；专有固件及密钥不入Git。
下一项电池/充电、无线/音频等；冷断电、90Hz、休眠、全部GPU频点压力仍未验收。

先读sessions/75-a640-render-and-sofef03f-clock-fix.md与reference/kernel75/README.md。
实际#76源码与配置、DTB/FW、FAT Image/CPIO及分区回读均已核对；0011/0012补丁对
session74基线精确应用复现当前源码，checkpatch零错误/警告。GPU-SUDO没有启用。
GMU固件v2.0.261；本机a630_sqe.fw/a640_gmu.bin/完整签名a640_zap.mbn仅本地，
七固件预检及MDT可重定位4KiB LOAD适配8KiB carveout，真实渲染已验证认证路径。
CPU framebuffer正常但物理噪点，证明截图/CRC不是屏幕验收。EOT-only失败；最后
非连续时钟+清继承位在纯白和fresh-boot彩条通过。不要再改DSC PPS/时钟频率来猜测。
#75诊断版早期有147条DSI worker消息，首次电源循环后结束；最终#76两次日志均为零。
#69 drain超时导致旧private-object二次释放，F1后shutdown阻塞，曾用sysrq b恢复fastboot；
之后cleanup和对应INTF复位修复。#71只构建未刷；一次EOT部署F1回执未捕获，采用单次
OUT完成+独立fastboot枚举验证，日志没有伪造回执。其余最终F1均有回执/枚举。

SSH/SCP工具在reference/kernel72；地址169.254.42.1，私钥/known_hosts仅本地kernel72。
真实内核/home/cy122/x2pro-linux/linux、initramfs/home/cy122/x2pro-linux/initramfs，
实际Git /home/cy122/edk2-samurai/repo；Windows镜像不是Git。保持REFGEN内建/defer60秒。
EUD重启先com-up，早期verbose输出需排完才发原生命令；COM和USB接口单owner/finally释放。
专有blob/完整Image/logdump/CPIO/SSH身份不发布。只boot/logdump写入且PARTNAME核对，
本机boot=/dev/sde11、logdump=/dev/sde32；不要猜DSP或其它分区。保留Android/数据/GPT。
最终boot sha43ddcba2444e1672cd95205f6984c761eaeb59c83162cffdffb371c50a29c37b，
logdump sha607fc6b4b0caba8ca5c7ea6677fd8259c81a216f91b2d6de7603e3f56d9881d0。
回退GPU关闭基线使用本地kernel75/boot-before.img与logdump-before.img，见final-validation。
全硬件目标仍active；下一轮从只读电量计和真实日志推进，不按注册数量验收。
