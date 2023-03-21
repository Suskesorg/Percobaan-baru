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

echo "===================================================================" 
echo -e '\e[36mGarapan      :\e[39m' Setting RPC/gRPC dan API BonusBlock Chain
echo -e '\e[36mAuthor       :\e[39m' Saujana
echo -e '\e[36mTelegram     :\e[39m' @SaujanaOK
echo -e '\e[36mTwitter      :\e[39m' @SaujanaCrypto
echo -e '\e[36mDiscord      :\e[39m' DEFFAN#0372
echo -e '\e[36mGithub       :\e[39m' https://github.com/SaujanaOK/
echo "===================================================================" 

# Set Vars api
if [ ! $API_Domain_BonusBlock ]; then
        read -p "ENTER YOUR API_Domain_BonusBlock : " API_Domain_BonusBlock
        echo 'export API_Domain_BonusBlock='$API_Domain_BonusBlock >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR API_Domain_BonusBlock  : \e[1m\e[35m$API_Domain_BonusBlock\e[0m"
echo ""


# Set Vars RPC
if [ ! $RPC_Domain_BonusBlock ]; then
        read -p "ENTER YOUR RPC_Domain_BonusBlock : " RPC_Domain_BonusBlock
        echo 'export RPC_Domain_BonusBlock='$RPC_Domain_BonusBlock >> $HOME/.bash_profile

fi

# Set Vars gRPC
if [ ! $gRPC_Domain ]; then
        read -p "ENTER YOUR gRPC_Domain_BonusBlock : " gRPC_Domain_BonusBlock
        echo 'export gRPC_Domain_BonusBlock='$gRPC_Domain_BonusBlock >> $HOME/.bash_profile

fi

# Set Vars PORT API
if [ ! $ApiPort ]; then
        read -p "Masukkan Port Api BonusBlock : " ApiPort_BonusBlock
        echo 'export ApiPort_BonusBlock='$ApiPort_BonusBlock >> $HOME/.bash_profile

fi


# Set Vars PORT RPC
if [ ! $RPCPort_BonusBlock ]; then
        read -p "Masukkan Port RPC BonusBlock  : " RPCPort_BonusBlock
        echo 'export RPCPort_BonusBlock='$RPCPort_BonusBlock >> $HOME/.bash_profile

fi


# Set Vars PORT gRPC
if [ ! $gRPCPORT_BonusBlock ]; then
        read -p "Masukkan Port gRPC BonusBlock : " gRPCPORT_BonusBlock
        echo 'export gRPCPORT_BonusBlock='$gRPCPORT_BonusBlock >> $HOME/.bash_profile

fi

clear
echo ""
echo -e "YOUR RPC_Domain_BonusBlock  : \e[1m\e[35m$RPC_Domain_BonusBlock\e[0m"
echo -e "YOUR gRPC_Domain_BonusBlock : \e[1m\e[35m$gRPC_Domain_BonusBlock \e[0m"
echo -e "Port Api BonusBlock : \e[1m\e[35m$ApiPort_BonusBlock \e[0m"
echo -e "Port RPC BonusBlock : \e[1m\e[35m$RPCPort_BonusBlock \e[0m"
echo -e "Port gRPC BonusBlock : \e[1m\e[35m$gRPCPORT_BonusBlock \e[0m"
echo ""

# Package
sudo apt update && sudo apt upgrade -y
sudo apt install nginx certbot python3-certbot-nginx -y

# Allow Port
sudo ufw allow 443 && sudo ufw allow 80
sudo ufw allow http && sudo ufw allow https

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
rm -rf /etc/nginx/sites-enabled/${API_Domain_BonusBlock}.conf
rm -rf /etc/nginx/sites-enabled/${RPC_Domain_BonusBlock}.conf
rm -rf /etc/nginx/sites-enabled/${gRPC_Domain_BonusBlock}.conf

# Create API Config
sudo tee /etc/nginx/sites-enabled/${API_Domain_BonusBlock}.conf >/dev/null <<EOF
server {
    server_name ${API_Domain_BonusBlock};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;

        proxy_pass http://0.0.0.0:$ApiPort_BonusBlock;

    }
}
EOF

# Create RPC Config
sudo tee /etc/nginx/sites-enabled/${RPC_Domain_BonusBlock}.conf >/dev/null <<EOF
server {
    server_name ${RPC_Domain_BonusBlock};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;

        proxy_pass http://127.0.0.1:$RPCPort_BonusBlock;

    }
}
EOF

# Create gRPC Config
sudo tee /etc/nginx/sites-enabled/${gRPC_Domain_BonusBlock}.conf >/dev/null <<EOF
server {
    server_name ${gRPC_Domain_BonusBlock};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;

        proxy_pass http://0.0.0.0:$gRPCPORT_BonusBlock;

    }
}
EOF

# Restart Service
sudo systemctl restart bonus-blockd
sudo systemctl restart nginx
rm -rf $HOME/rpcblocktopia.sh

echo '=============== Settingan Kelar Gan ==================='
echo -e "Silahkan Lanjutkan memasang SSL : \e[1m\e[35msudo certbot --nginx --register-unsafely-without-email\e[0m"

# End
