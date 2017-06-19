@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo 请求管理员权限...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

rem 构造下载脚本

echo "正在下载hosts..."
echo Set Post = CreateObject("Msxml2.XMLHTTP") >>download.vbs
echo Set Shell = CreateObject("Wscript.Shell") >>download.vbs
echo Post.Open "GET","https://raw.githubusercontent.com/racaljk/hosts/master/hosts",0 >>download.vbs
echo Post.Send()>>download.vbs
echo Set aGet = CreateObject("ADODB.Stream") >>download.vbs
echo aGet.Mode = 3 >>download.vbs
echo aGet.Type = 1 >>download.vbs
echo aGet.Open()>>download.vbs
echo aGet.Write(Post.responseBody) >>download.vbs
echo aGet.SaveToFile "temp",2 >>download.vbs
echo wscript.sleep 1000 >>download.vbs
cscript download.vbs > nul
del download.vbs
echo "下载完成"

echo n|comp temp C:\Windows\System32\drivers\etc\hosts >nul 2>&1

if errorlevel 1 (
    echo "hosts有更新,正在替换hosts......"
    copy temp C:\Windows\System32\drivers\etc\hosts >nul
    echo "替换完成"
    ipconfig /flushdns >nul
    echo "重启网络完成"

) else (
    echo "hosts无更新"
)
del temp
echo "按任意键退出."

pause >nul
