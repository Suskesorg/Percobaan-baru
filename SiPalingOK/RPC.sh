#!/bin/bash
clear
echo -e "\e[96m"       
echo -e "  **********                    **                             "
echo -e " **////////                                                    "
echo -e "/**         ******   **   **    **  ******   *******   ******  "
echo -e "/********* //////** /**  /**   /** //////** //**///** //////** "
echo -e "////////**  ******* /**  /**   /**  *******  /**  /**  ******* "
echo -e "       /** **////** /**  /** **/** **////**  /**  /** **////** "
echo -e " ******** //********//******//*** //******** ***  /**//********"
echo -e "////////   ////////  //////  ///   //////// ///   //  //////// "
echo -e "\e[0m"

echo -e '\e[36mGarapan      :\e[39m' Setting RPC/gRPC dan API Nolus
echo -e '\e[36mAuthor       :\e[39m' Saujana
echo -e '\e[36mTelegram     :\e[39m' @SaujanaOK
echo -e '\e[36mTwitter      :\e[39m' @SaujanaCrypto
echo -e '\e[36mDiscord      :\e[39m' DEFFAN#0372
echo -e '\e[36mGithub       :\e[39m' https://github.com/SaujanaOK/
echo "==========================================================================================" 

sleep 1
# Variable
remote_addr=$remote_addr
proxy_add_x_forwarded_for=$proxy_add_x_forwarded_for
host=$host

echo "export remote_addr=${remote_addr}" >> $HOME/.bash_profile
echo "export proxy_add_x_forwarded_for=${proxy_add_x_forwarded_for}" >> $HOME/.bash_profile
echo "export host=${host}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars api
if [ ! $API_Domain ]; then
        read -p "ENTER YOUR API_Domain : " API_Domain
        echo 'export API_Domain='$API_Domain >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR API_Domain  : \e[1m\e[35m$API_Domain\e[0m"
echo ""

# Set Vars RPC
if [ ! $RPC_Domain ]; then
        read -p "ENTER YOUR RPC_Domain : " RPC_Domain
        echo 'export RPC_Domain='$RPC_Domain >> $HOME/.bash_profile

fi
echo ""
echo -e "YOUR RPC_Domain  : \e[1m\e[35m$RPC_Domain\e[0m"
echo ""

# Set Vars gRPC
if [ ! $gRPC_Domain ]; then
        read -p "ENTER YOUR gRPC_Domain : " gRPC_Domain
        echo 'export gRPC_Domain='$gRPC_Domain >> $HOME/.bash_profile

fi
echo ""
echo -e "YOUR gRPC_Domain : \e[1m\e[35m$gRPC_Domain \e[0m"
echo ""

# Package
sudo apt update && sudo apt upgrade -y
sudo apt install nginx certbot python3-certbot-nginx -y

# Allow Port
sudo ufw allow 443 && sudo ufw allow 80 && sudo ufw allow 43317 && sudo ufw allow 43090 && sudo ufw allow 43090 && sudo ufw enable -y

# Install PIP
sudo apt install python3 python3-venv libaugeas0

# Setup virtual
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip

# Install Apache
sudo /opt/certbot/bin/pip install certbot certbot-apache

# Install nginx
sudo /opt/certbot/bin/pip install certbot certbot-nginx

# Create a symlink
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot

# Remove file
rm -rf /etc/nginx/sites-enabled/${API_Domain}.conf
rm -rf /etc/nginx/sites-enabled/${RPC_Domain}.conf
rm -rf /etc/nginx/sites-enabled/${gRPC_Domain}.conf

# Create API Config
sudo tee /etc/nginx/sites-enabled/${API_Domain}.conf >/dev/null <<EOF
server {
    server_name ${API_Domain};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

        proxy_pass http://0.0.0.0:43317;

    }
}
EOF

# Create RPC Config
sudo tee /etc/nginx/sites-enabled/${RPC_Domain}.conf >/dev/null <<EOF
server {
    server_name ${RPC_Domain};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

        proxy_pass http://127.0.0.1:43657;

    }
}
EOF

# Create gRPC Config
sudo tee /etc/nginx/sites-enabled/${gRPC_Domain}.conf >/dev/null <<EOF
server {
    server_name ${gRPC_Domain};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

        proxy_pass http://0.0.0.0:43091;

    }
}
EOF

# Restart Service
sudo systemctl restart nolusd
sudo systemctl restart nginx

echo '=============== Settingan Kelar Gan ==================='
echo -e "Silahkan Lanjutkan memasang SSL: \e[1m\e[35msudo certbot --nginx --register-unsafely-without-email\e[0m"

# End
