Untuk versi manual, silahkan check [di sini](https://github.com/SaujanaOK/nolus-core/tree/main/Setting%20RPC%20Manual)

## Auto Set UP API, RPC dan gRPC Nolus

```
wget -O gRPCApi.sh https://raw.githubusercontent.com/SaujanaOK/nolus-core/main/SiPalingOK/gRPCApi.sh && chmod +x gRPCApi.sh && ./gRPCApi.sh
```

## Memasang SSL
```
sudo certbot --nginx --register-unsafely-without-email
```

## Lanjutkan
```
sudo certbot --nginx
```

## Setting Api Config
Untuk yang api gak langsung jadi ya gan, karna gua gak tau autonya, silahkan edit dulu
```
nano $HOME/.nolus/config/app.toml
```
Pastikan settingan seperti pada gambar, lalu save CTRL + X dan Y
<p align="center"><img src="https://github.com/SaujanaOK/Images/blob/main/apinolus.png" alt=""></p>

## Restart Node Nolus
```
sudo systemctl restart nolusd
```

## Done
Silahkan check kembali Api domainmu
