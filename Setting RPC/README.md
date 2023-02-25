# Setting RPC
Pastikan anda memiliki domain dengan settingan seperti gambar ini kira-kira


Setelah setting DNS pada domain kelar, mari lanjutkan di VPS

```
sudo apt install nginx certbot python3-certbot-nginx -y
sudo apt update && sudo apt upgrade -y
sudo apt install python3 python3-venv libaugeas0
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
sudo /opt/certbot/bin/pip install certbot certbot-nginx
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot

```

```
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn -y
sudo apt-get update && apt install -y nodejs git
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
