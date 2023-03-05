## Configurasi your Domain
Custom CNAME your domain to IP VPS, Like `snapshot.nolus.example.com`

## Prepare
```
sudo apt update && sudo apt upgrade -y
```

```
sudo apt install nginx certbot python3-certbot-nginx -y
```

```
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
```

```
sudo apt-get update && apt install -y nodejs git
```

```
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

```
sudo apt-get update && sudo apt-get install yarn -y
```

## Make Snapshot Folder
```
cd /var/www/
mkdir -p snapshot/nolus
sudo apt install lz4
```

## Stop Node
```
cd $HOME/.nolus
sudo systemctl stop nolusd
```

## Make Snapshot File
```
cd $HOME/.nolus
tar -cf - data | lz4 > /var/www/snapshot/planq/planq-snapshot-$(date +%Y%m%d).tar.lz4
```

## Make Snapshot Config
```
sudo tee /etc/nginx/sites-enabled/<Your Domain>.conf >/dev/null <<EOF
server {
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name <Your Domain>; 


        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                # try_files $uri $uri/ =404;
                root /var/www/snapshot/;
                autoindex on;
    }
}
EOF
```
Please change <Your Domain> to your Snapshot Domain like snapshot.nolus.example.com

## Install SSL
```
sudo certbot --nginx --register-unsafely-without-email
sudo certbot --nginx --redirect
```
And select your snapshot domain
        
## Restart Ngin and Node
```
sudo systemctl start nginx
sudo systemctl start nolusd
```
______________________
# This Our Snapshot
https://snapshot.nolus.belajar.codes/nolus-snapshot-20230305.tar.lz4

