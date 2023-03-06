____________________________________

# How to Make a Snapshot nolus

____________________________________
## Auto Setting
```
wget -O Snapshot.sh https://raw.githubusercontent.com/SaujanaOK/nolus-core/main/How%20To%20Make%20a%20Snapshot%20Nolus/Snapshot.sh && chmod +x Snapshot.sh && ./Snapshot.sh
```
____________________________________

## Manual Setting
### Configurasi your Domain
Custom CNAME your domain to IP VPS, Like `snapshot.nolus.example.com`

### Instructions
#### Install dependencies
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

### Make Snapshot Folder
```
cd /var/www/
mkdir -p snapshot/nolus
sudo apt install lz4
```

### Stop Node
```
cd $HOME/.nolus
sudo systemctl stop nolusd
```

### Make Snapshot File
```
tar -cf - data | lz4 > /var/www/snapshot/nolus/snapshot_latest.tar.lz4
```

### Make Snapshot Config
**Noted** : Please change `<Your_Domain>` to your Snapshot Domain like `snapshot.nolus.example.com`
```
sudo tee /etc/nginx/sites-enabled/<Your_Domain>.conf >/dev/null <<EOF
server {
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name <Your_Domain>; 


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

### Install SSL
```
sudo certbot --nginx --register-unsafely-without-email
```
And select your snapshot domain
        
### Restart Ngin and Node
```
sudo systemctl start nginx
sudo systemctl start nolusd
```
______________________________
# This Our Snapshot
https://snapshot.nolus.sarjananode.studio/nolus/
______________________________
        
## How to Use our Snapshot
### Stop the service and reset the data
```
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data
```
### Download our snapshot
```
curl -L https://snapshot.nolus.sarjananode.studio/nolus/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nolus
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json
```

### Restart the service and check the log
```
sudo systemctl start nolusd && sudo journalctl -u nolusd -f --no-hostname -o cat
```
