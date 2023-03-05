## Configurasi your Domain

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






