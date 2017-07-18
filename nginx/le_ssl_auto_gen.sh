#!/bin/sh

## http://www.tuicool.com/articles/iUvY3aF
## https://github.com/diafygi/acme-tiny
## https://github.com/certbot/certbot
## https://certbot.eff.org/docs/using.html#getting-certbot
## 最终获得le_ssl_chained.pem 和 le_ssl_domain.key
echo "auto update letsencrypt..."
## define you path
PATH=/data/docker_conf/nginx/ssl/le

## download file
## https://github.com/diafygi/acme-tiny
ACME_TINY_FILE=$PATH/acme_tiny.py
LE_ACME_DIR=$LE_PATH/challenges/

## domain ssl path
LE_PATH=$PATH/passet.com.cn

## define you all dns
DNS=DNS:passet.com.cn,DNS:www.passet.com.cn

cd $LE_PATH/tmp
rm -rf $LE_PATH/tmp/*
# Step 1: Create a Let's Encrypt account private key (if you haven't already)
#建立Let's Encrypt账户的私钥
## 如果要申请多个，account.key可以不用变化
openssl genrsa 4096 > account.key

# Step 2: Create a certificate signing request (CSR) for your domains.
# 生成域名的私钥
openssl genrsa 4096 > domain.key

## 生成对应域名的domain.csr
## 对于单个域名
#openssl req -new -sha256 -key domain.key -subj "/CN=pengh.cn" > domain.csr
## 对于多域名
#openssl req -new -sha256 -key domain.key -subj "/" \
#	-reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:pengh.cn,DNS:www.pengh.cn,DNS:*.pengh.cn")) > domain.csr

## shell里面对()会起作用，故使用临时文件，笨方法 
echo "[SAN]\nsubjectAltName=$DNS" > openssl.cnf.1.tmp
cat /etc/ssl/openssl.cnf openssl.cnf.1.tmp > openssl.cnf.tmp
openssl req -new -sha256 -key domain.key -subj "/" -reqexts SAN -config openssl.cnf.tmp  -out domain.csr
rm -f openssl.cnf.tmp openssl.cnf.1.tmp

# Step 3: Make your website host challenge files
# Step 4: Get a signed certificate!
# 验证域名所有者
# 就是通过在 /.well-known/acme-challenge/ 里写文件，然后通过公网来访问，看是否能正常访问
# nginx 配置
# 其中，alias的路径要跟${LE_ACME_DIR} 保持一致
# server {
# 	listen 80;
# 	server_name www.pengh.cn pengh.cn;
# 	location ^~ /.well-known/acme-challenge/ {
# 		alias /data/docker_conf/nginx/ssl/le/challenges/;
# 		try_files $uri =404;
# 	}
# 	##...the rest of your config
# 	location / {
# 		rewrite ^/(.*)$ https://pengh.cn/$1 permanent;
# 	}		
# }
sudo python $ACME_TINY_FILE \
	--account-key $LE_PATH/tmp/account.key \
	--csr $LE_PATH/tmp/domain.csr \
	--acme-dir $LE_ACME_DIR > $LE_PATH/tmp/signed.crt


# Step 5: Install the certificate
#NOTE: For nginx, you need to append the Let's Encrypt intermediate cert to your cert
sudo wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > $LE_PATH/tmp/intermediate.pem
sudo cat $LE_PATH/tmp/signed.crt $LE_PATH/tmp/intermediate.pem > $LE_PATH/tmp/chained.pem


## back up
DATE=`date   +%Y%m%d`
cp $LE_PATH/le_ssl_chained.pem $LE_PATH/backup/le_ssl_chained.pem.$DATE
cp $LE_PATH/le_ssl_domain.key $LE_PATH/backup/le_ssl_domain.key.$DATE

cp $LE_PATH/tmp/chained.pem $LE_PATH/le_ssl_chained.pem 
cp $LE_PATH/tmp/domain.key $LE_PATH/le_ssl_domain.key

#rm -rf  $LE_PATH/tmp/*

#sudo service nginx reload

# cd /data/docker_conf && git add . && git status && git commit -m "auto le ssl for pengh" && git push
