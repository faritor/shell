#!/bin/sh
#
#	Author: Faritor
#	Email: faritor@unmz.net
#	Date: 2019-11-22 20:53:09
#
#####################################################################

read -p "请输入需要生成证书的域名:" DOMAIN
if [ -z "$DOMAIN" ];then
	echo -e "\033[36m请输入域名!!!\033[0m"
	exit
fi

read -p "请指定网站根目录(默认:/data/wwwroot):" WWWROOT
if [ -z "$WWWROOT" ];then
	WWWROOT='/data/wwwroot'
fi

read -p "请指定证书存放的目录(默认:/data/nginx/ssl):" SSL_PATH
if [ -z "$SSL_PATH" ];then
	SSL_PATH='/data/nginx/ssl'
fi

if [ ! -d "~/.acme.sh" ];then
    echo -e "\033[36m本机或当前登录用户还未安装acme,正在下载...\033[0m"
    curl https://get.acme.sh | sh
    echo -e "\033[36m下载完成,开始创建证书\033[0m"
fi

if [ ! -d "$WWWROOT" ];then
	mkdir $WWWROOT
fi

if [ ! -d "$SSL_PATH" ];then
	mkdir $SSL_PATH
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
