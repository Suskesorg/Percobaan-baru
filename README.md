# Auto Install
```
wget -O nolus.sh https://raw.githubusercontent.com/SaujanaOK/nolus-core/main/nolus.sh && chmod +x nolus.sh && ./nolus.sh
```
## Check Log dan Sync pasca Install

### check logs
```
sudo journalctl -u nolusd -f --no-hostname -o cat
```

### Chek sync log setelah 10 menit
```
nolusd status 2>&1 | jq .SyncInfo
```

##### Kalau Pake Auto Install, setelah kelar, langsung lompat ke bagian add wallet gan
__________________________________

# Manual Install
Check di : https://github.com/SaujanaOK/nolus-core/tree/main/Manual
__________________________________
# Add Wallet

### Jika Membuat Wallet baru
```
nolusd keys add wallet
```

### Jika Import Wallet yang sudah ada
```
nolusd keys add wallet --recover
```

### Untuk melihat daftar wallet saat ini
```
nolusd keys list
```

__________________________________
# Validator management
### Create Validator
```
nolusd tx staking create-validator \
--amount 1000000unls \
--pubkey $(nolusd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id nolus-rila \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 675unls \
-y
```

### Submit Crew3
- Check transaksi ID di https://nolus.explorers.guru/
- Kemudian copy linknya dan submit di Crew3 : 
https://crew3.xyz/c/nolus/invite/szl85ZQ5Opq8F_Uj3_siu


### Jika ingin Edit existing validator
```
nolusd tx staking edit-validator \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL"
--chain-id nolus-rila \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 675unls \
-y
```

__________________________________
# Setting RPC
Pastikan anda memiliki domain dengan settingan seperti gambar ini kira-kira


Setelah setting DNS pada domain kelar, mari lanjutkan di VPS

```
sudo apt update && sudo apt upgrade -y
sudo apt install nginx certbot python3-certbot-nginx -y
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get update && apt install -y nodejs git
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y
```


```
nano $HOME/.nolus/config/app.toml
```

```
nano $HOME/.nolus/config/config.toml
```

### Restart service
```
sudo systemctl restart nolusd
```

### Membuat Config API
Pastikan untuk merubah nama domainmu
```
nano /etc/nginx/sites-enabled/api.nolus.<namadomainmu>.conf
```
```
server {
    server_name api.nolus.<namadomainmu>;
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
```

### Setting RPC
Pastikan untuk merubah nama domainmu
```
nano /etc/nginx/sites-enabled/rpc.nolus.<namadomainmu>.conf
```
```
server {
    server_name rpc.nolus.<namadomainmu>;
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
```

### Setting GRPC
Pastikan untuk merubah nama domainmu
```
nano /etc/nginx/sites-enabled/grpc.nolus.<namadomainmu>.conf
```
```
server {
    server_name grpc.nolus.<namadomainmu>;
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;

	proxy_set_header   X-Real-IP        $remote_addr;
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
        proxy_set_header   Host             $host;

         proxy_pass http://0.0.0.0:43090;

    }
}
```


### Memasang ssl
```
sudo certbot --nginx --register-unsafely-without-email
sudo certbot --nginx --redirect
```




```

```




```

```




```

```




```

```




```

```




```

```



# Uninstall Node
```
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm /etc/systemd/system/nolusd.service
sudo systemctl daemon-reload
rm -f $(which nolusd)
rm -rf $HOME/.nolus
rm -rf $HOME/nolus-core

```



