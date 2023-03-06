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
echo -e '\e[36mGarapan      :\e[39m' Membuat Snapshot Nolus Core
echo -e '\e[36mAuthor       :\e[39m' Saujana
echo -e '\e[36mTelegram     :\e[39m' @SaujanaOK
echo -e '\e[36mTwitter      :\e[39m' @SaujanaCrypto
echo -e '\e[36mDiscord      :\e[39m' DEFFAN#0372
echo -e '\e[36mGithub       :\e[39m' https://github.com/SaujanaOK/
echo "===================================================================" 

# Set Vars api
if [ ! $Snapshot_Domain_Nolus ]; then
        read -p "ENTER YOUR Snapshot Domain Nolus : " Snapshot_Domain_Nolus
        echo 'export Snapshot_Domain_Nolus='$Snapshot_Domain_Nolus >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR Snapshot Domain Nolus  : \e[1m\e[35m$Snapshot_Domain_Nolus\e[0m"
echo ""

# Install dependencies 1
sudo apt update && sudo apt upgrade -y

# Install dependencies 2
sudo apt install nginx certbot python3-certbot-nginx -y

# Install dependencies 3
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -

# Install dependencies 4
sudo apt-get update && apt install -y nodejs git

# Install dependencies 5
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Install dependencies 6
sudo apt-get update && sudo apt-get install yarn -y

# Make Snapshot Folder
cd /var/www/
mkdir -p snapshot/nolus
sudo apt install lz4

# Stop Node
cd $HOME/.nolus
sudo systemctl stop nolusd

### Make Snapshot File
tar -cf - data | lz4 > /var/www/snapshot/nolus/snapshot_latest.tar.lz4

# Make Snapshot Config
sudo tee /etc/nginx/sites-enabled/${Snapshot_Domain_Nolus}.conf >/dev/null <<EOF
server {
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name ${Snapshot_Domain_Nolus}; 


        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                # try_files $uri $uri/ =404;
                root /var/www/snapshot/;
                autoindex on;
    }
}
EOF

# Restart Ngin and Node
sudo systemctl start nginx
sudo systemctl start nolusd

# Install SSL
sudo certbot --nginx --register-unsafely-without-email

