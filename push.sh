#！/bin/bash
#保存当前目录
currentDir = $PWD
echo "start to publish ...\n"
# 切换到项目目录
cd /Users/wshicheng/Desktop/CMD-AMD
#执行git命令
git add .
git commit -m 'modify'
git pull origin master
git push origin master