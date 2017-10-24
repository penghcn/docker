#!/bin/bash
KEY_PATH=~/.ssh/keys

if [ ! -n "$1" ] ;then
    	echo "参考如下使用方式（针对macOs）"
	echo "sh gen-ssh-key.sh test-key-name test-user test-host"
	echo "sh gen-ssh-key.sh sps fy_sps 192.168.8.29"
	exit
else
    echo "let's go..."
fi

keyName=$1
keyFile=$KEY_PATH/$keyName
domain=$2@$3

ssh-keygen -t rsa -C 'auto gen' -f $keyFile
scp $keyFile.pub $domain:.

echo "\n1、再次使用密码登录目标服务器，并执行下面命令"
echo "cat $keyName.pub >> ~/.ssh/authorized_keys"

echo "\n2、回到本地机子，vi ~/.ssh/config 添加如下"
echo "Host $keyName
        HostName $3
        User $2
        PubkeyAuthentication yes
        IdentityFile $keyFile"
echo "\n3、保存退出。以后就可以这样简单连接了 ssh $keyName"

