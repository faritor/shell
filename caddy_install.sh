#!/bin/bash

#author faritor@unmz.net
#date 2018-3-19 21:47:34
#description Simplify the installation process only need to configure Caddyfile can use


curl https://getcaddy.com | bash -s personal

mkdir /etc/caddy

mv /usr/local/bin/caddy /etc/caddy/

echo >> /etc/caddy/Caddyfile

echo -e "#!/bin/bash \n\n\n\nnohup ./caddy -conf="./Caddyfile" >/dev/null 2>log & " >> /etc/caddy/start

echo -e "#!/bin/bash \n\n\n\npkill caddy" >> /etc/caddy/stop

chmod +x /etc/caddy/s*
