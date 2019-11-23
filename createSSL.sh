#!/bin/sh
#
#	Author: Faritor
#	Email: faritor@unmz.net
#	Date: 2019-11-22 20:53:09
#
#####################################################################

read -p "please input domain: " DOMAIN
if [ -z "$DOMAIN" ];then
	echo -e "\033[1;31m not exist domain!!!\033[0m"
	exit
fi

read -p "please specify the website root directory(default:/data/wwwroot): " WWWROOT
if [ -z "$WWWROOT" ];then
	WWWROOT='/data/wwwroot'
fi

read -p "please specify the directory where the certificate is stored(default:/data/nginx/ssl): " SSL_PATH
if [ -z "$SSL_PATH" ];then
	SSL_PATH='/data/nginx/ssl'
fi

Path=~/.acme.sh
if [ ! -d "$Path" ]; then  
	echo -e "\033[1;36m this machine or the currently logged in user has not installed acme, downloading...\033[0m"
    curl https://get.acme.sh | sh
    echo -e "\033[1;36m Download completed and start creating a certificate\033[0m"
else
	echo -e '\033[1;36m the local or current user has downloaded acme, skipped\033[0m'
fi

if [ ! -d "$WWWROOT" ];then
	mkdir $WWWROOT
fi

if [ ! -d "$SSL_PATH" ];then
	mkdir $SSL_PATH
fi

PWDIR=$WWWROOT/$DOMAIN
SSL_DIR=$SSL_PATH/$DOMAIN

if [ ! -d "$PWDIR" ]; then
	mkdir $PWDIR
fi

~/.acme.sh/acme.sh --issue -d $DOMAIN -w $PWDIR

fullchain=~/.acme.sh/$DOMAIN/fullchain.cer

if [ -f "$fullchain" ]; then
	if [ ! -d "$SSL_DIR" ]; then
		mkdir $SSL_DIR
	fi
	
	~/.acme.sh/acme.sh --installcert -d $DOMAIN --key-file $SSL_DIR/$DOMAIN.key --fullchain-file $SSL_DIR/$DOMAIN.cer --reloadcmd "docker exec -it nginx service nginx force-reload"
	
	echo -e 'key path:' $SSL_DIR/$DOMAIN.key
	echo -e 'cer path:' $SSL_DIR/$DOMAIN.cer
	echo -e '\033[1;36m Certificate generation completed!\033[0m'
else
	echo -e '\033[1;31m Certificate generation failed!\033[0m'
fi
