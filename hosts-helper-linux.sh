#!/bin/bash
#2016年09月12日 星期一 16时50分13秒 

sudo -K #清除时间戳,以免if判断出错

#判断执行权限
if [ $USER != "root" ]
then 
   echo "脚本需要root权限" 
   read -s -p "输入用户密码: " sudoPW
   echo $sudoPW | sudo -S echo 2>nul || { echo ;echo "密码错误";rm -f nul; exit; }
fi  

#重定向错误流
exec 2>nul 

echo "正在从https://github.com/racaljk/hosts下载hosts......"
curl https://coding.net/u/scaffrey/p/hosts/git/raw/master/hosts-files/hosts > temp || { echo "下载失败！";exit; } 
echo "下载成功"

#比较文件
cmp -s temp /etc/hosts
if [ $? -eq 0 ]
then
 echo "hosts无更新."
 rm -f temp
 rm -f nul
 exit
fi

echo "hosts有更新,正在替换......"
{ sudo cp -f temp /etc/hosts  && echo "替换成功"; } || { echo "替换失败" ; exit; }
rm -f temp 
sudo /etc/init.d/networking restart > nul && echo "重启网络成功" || { echo "重启网络失败,需重启电脑使host生效.";exit; }
rm -f nul


