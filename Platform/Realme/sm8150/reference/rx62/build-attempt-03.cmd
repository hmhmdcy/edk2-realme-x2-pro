@echo off
call "F:\BuildEnv\SetupBuildEnv.cmd" amd64
if errorlevel 1 exit /b %errorlevel%
@echo off
"F:\Program Files\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\amd64\MSBuild.exe" "E:\edk2-samurai-out\rx61\source-pinned\qcom-usb-kernel-drivers-14b6fe1ee69cdd9182502629da9192156b9d206a\src\windows\wdfserial\qceudexp.vcxproj" /t:Build /nologo /m:1 /nr:false /v:minimal /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10.0.26100.0 /p:SignMode=Off /p:EnableTestSign=false /p:Inf2CatUseLocalTime=true /p:OutDir=E:\edk2-samurai-out\rx62\build-output\attempt-03\ /p:IntDir=E:\edk2-samurai-out\rx62\build-intermediate\attempt-03\ "/flp:LogFile=E:\edk2-samurai-out\rx62\build-attempt-03.log;Verbosity=normal;Encoding=UTF-8"
exit /b %errorlevel%
