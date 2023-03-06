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
sudo tee /etc/nginx/sites-enabled/$DomainSnapshotNolus.conf >/dev/null <<EOF
server {
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name $DomainSnapshotNolus; 


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

