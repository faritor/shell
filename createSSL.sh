#!/bin/sh
#
#	Author: Faritor
#	Email: faritor@unmz.net
#	Date: 2019-11-22 20:53:09
#
#######################

read -p "请输入需要生成证书的域名:" DOMAIN
if [ -z "$DOMAIN" ];then
	echo -e "\033[31m请输入域名!!!\033[0m"
	exit
fi

read -p "请指定网站根目录(默认:/data/wwwroot/test):" WWWROOT
if [ -z "$WWWROOT" ];then
	WWWROOT='/data/wwwroot/test'
fi

read -p "请指定证书存放的目录(默认:/data/nginx/ssl):" SSL_PATH
if [ -z "$SSL_PATH" ];then
	SSL_PATH='/data/nginx/ssl'
fi

PWDIR=$WWWROOT/$DOMAIN
SSL_DIR=$SSL_PATH/$DOMAIN

mkdir $PWDIR

/root/.acme.sh/acme.sh --issue -d $DOMAIN -w $PWDIR

mkdir $SSL_DIR

/root/.acme.sh/acme.sh --installcert -d $DOMAIN --key-file $SSL_DIR/$DOMAIN.key --fullchain-file $SSL_DIR/$DOMAIN.cer --reloadcmd "docker exec -it nginx service nginx force-reload"

echo 'key的路径:' $SSL_DIR/$DOMAIN.key
echo 'cer的路径:' $SSL_DIR/$DOMAIN.cer
echo '创建完成!'