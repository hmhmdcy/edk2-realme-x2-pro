# Session 36：USB 描述符、旧 qcusbser 审查与待测对照

2026-10-09；详细结论见 `../../sessions/36-rx-usb-descriptors-and-legacy-qcusbser.md`。
此目录的 `.raw` 是手机 TX 的串口抓取，**没有收录 USB OUT 实测**。
`rx36-cmdline` 是未完成命令，不能当作运行中 cmdline 证据。

下一轮管理员先完成（仅 9505；执行前重查 busid，以下 6-5 为本轮值）：

```powershell
& 'C:\Program Files\usbipd-win\usbipd.exe' bind --busid 6-5
```

用户反馈成功后，在普通终端手动分步执行：

```powershell
& 'C:\Program Files\usbipd-win\usbipd.exe' list
& 'C:\Program Files\usbipd-win\usbipd.exe' attach --wsl Ubuntu --busid 6-5
wsl.exe -d Ubuntu -u root -- lsusb -v -d 05c6:9505
wsl.exe -d Ubuntu -u root -- modprobe usbmon
wsl.exe -d Ubuntu -u root -- python3 '/mnt/e/RealmeX2Pro edk2/linux-port/scripts/eud-usb-step.py' `
  --seconds 5 --out /mnt/e/edk2-samurai-out/rx36-usb-drain
```

上述工具未设备验证。核对无错误且描述符匹配后，单独用 `--hex '90 01 15'`
与 `--ack 'tty byte=15'` 验证安全清行，再开始一帧 ABC：

```powershell
wsl.exe -d Ubuntu -u root -- python3 '/mnt/e/RealmeX2Pro edk2/linux-port/scripts/eud-usb-step.py' `
  --hex '90 03 41 42 43' --repeat 5 --seconds 20 --ack 'byte[3/3]=' `
  --out /mnt/e/edk2-samurai-out/rx36-usb-ABC
```

不要把这些命令拼成无人值守循环。输出前缀必须全新，工具拒绝覆盖已有证据。
看 `.usbmon` 中对应的 Bo 提交和完成、`.events.jsonl` 的长度及回执、`.txt` 的
全部 payload。USBmon 记录 URB，不是物理总线包；超时/未受理不能计为有效失败。

进程正常退出、USB 资源关闭后再把设备交还 Windows：

```powershell
& 'C:\Program Files\usbipd-win\usbipd.exe' detach --busid 6-5
& 'C:\Program Files\usbipd-win\usbipd.exe' list
```

bind 的共享配置会保留；detach 结束当次转发，不会卸载 qcusbser。确认 COM14 正常
再开单步串口/临时终端。移除持久共享需管理员 `unbind --busid 6-5`。
遇到 hrdevmon 警告/attach 失败先停止，不自动 force、不重启主机、不动其他设备。
