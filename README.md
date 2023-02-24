## Setup validator name
```
MONIKER="YOUR_MONIKER_GOES_HERE"
```

## Update system and install build tools
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
## Install Go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.6.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
# Download and build binaries
## Clone project repository
```
cd $HOME
rm -rf nolus-core
git clone https://github.com/Nolus-Protocol/nolus-core.git
cd nolus-core
git switch -c v0.1.43
```
## Build binaries
```
cd $HOME/nolus-core
make build
```
## Prepare binaries for Cosmovisor
```
cd $HOME/nolus-core
mkdir -p $HOME/.nolus/cosmovisor/genesis/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/genesis/bin/
rm -rf build
```
## Create application symlinks
```
cd $HOME/nolus-core
ln -s $HOME/.nolus/cosmovisor/genesis $HOME/.nolus/cosmovisor/current
sudo ln -s $HOME/.nolus/cosmovisor/current/bin/nolusd /usr/local/bin/nolusd
```

# Install Cosmovisor and create a service
## Download and install Cosmovisor
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0
```
## Create service
```
sudo tee /etc/systemd/system/nolusd.service > /dev/null << EOF
[Unit]
Description=nolus-testnet node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.nolus"
Environment="DAEMON_NAME=nolusd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.nolus/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nolusd
```
#Initialize the node
## Set node configuration
```
## Initialize the node
```
nolusd init $MONIKER --chain-id nolus-rila
```
## Download genesis and addrbook
```
## Add seeds
```
sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@nolus-testnet.rpc.kjnodes.com:43659\"|" $HOME/.nolus/config/config.toml
```
## Set minimum gas price
```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0025unls\"|" $HOME/.nolus/config/app.toml
```
## Set pruning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "nothing"|' \
  $HOME/.nolus/config/app.toml
```
## Set custom ports
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

```

```

```

