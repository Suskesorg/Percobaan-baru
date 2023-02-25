Untuk Auto installasi silahkan lihat di : https://github.com/SaujanaOK/nolus-core/tree/main/SiPalingOK

# Manual Installasi
### Set Env Variable
```
```

### Package

```
sudo apt update && sudo apt upgrade -y
sudo apt install nginx certbot python3-certbot-nginx -y
```

###  Allow Port
```
sudo ufw allow 443 && sudo ufw allow 80 && sudo ufw allow 43317 && sudo ufw allow 43090 && sudo ufw allow 43090
```

###  Install PIP
```
sudo apt install python3 python3-venv libaugeas0
```

###  Setup virtual
```
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
```

###  Menambahkan Apache
```
sudo /opt/certbot/bin/pip install certbot certbot-apache
```

###  Menambahkan nginx
```
sudo /opt/certbot/bin/pip install certbot certbot-nginx
```

### Create a symlink
```
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
```

###  Create API Config (Sung paste aja)
```
sudo tee /etc/nginx/sites-enabled/${API_Domain}.conf >/dev/null <<EOF
server {
    server_name ${API_Domain};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;
	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;
        proxy_pass http://0.0.0.0:43317;
    }
}
EOF
```

### Create RPC Config (Sung paste aja)
```
sudo tee /etc/nginx/sites-enabled/${RPC_Domain}.conf >/dev/null <<EOF
server {
    server_name ${RPC_Domain};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;
	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;
        proxy_pass http://127.0.0.1:43657;
    }
}
EOF
```

### Create gRPC Config (Sung paste aja)
```
sudo tee /etc/nginx/sites-enabled/${gRPC_Domain}.conf >/dev/null <<EOF
server {
    server_name ${gRPC_Domain};
    listen 80;
    location / {
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Max-Age 3600;
        add_header Access-Control-Expose-Headers Content-Length;
	proxy_set_header   X-Real-IP        \$remote_addr;
        proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
        proxy_set_header   Host             \$host;
        proxy_pass http://0.0.0.0:43091;
    }
}
EOF
```
### ## Setting Api Config
Untuk yang api gak langsung jadi ya gan, karna gua gak tau autonya, silahkan edit dulu
```
nano $HOME/.nolus/config/app.toml
```
Pastikan settingan seperti pada gambar, lalu save CTRL + X dan Y
<p align="center"><img src="https://github.com/SaujanaOK/Images/blob/main/apinolus.png" alt=""></p>

### Restart Node Nolus
```
sudo systemctl restart nolusd
sudo systemctl restart nginx
```

### Memasang SSL
```
sudo certbot --nginx --register-unsafely-without-email
```

### Lanjutkan
```
sudo certbot --nginx
```

## Done
