# Auto Install
```
wget -O nolus.sh https://raw.githubusercontent.com/SaujanaOK/nolus-core/main/nolus.sh && chmod +x nolus.sh && ./nolus.sh
```
## Check Log dan Sync pasca Install

### check logs
```
sudo systemctl restart nolusd && sudo journalctl -u nolusd -f --no-hostname -o cat
```

### Chek sync log setelah 10 menit
```
nolusd status 2>&1 | jq .SyncInfo
```
### check version
```
nolusd version
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
### Simpan Info Wallet
```
NOLUS_WALLET_ADDRESS=$(nolusd keys show $WALLET -a)
NOLUS_VALOPER_ADDRESS=$(nolusd keys show $WALLET --bech val -a)
echo 'export NOLUS_WALLET_ADDRESS='${NOLUS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NOLUS_VALOPER_ADDRESS='${NOLUS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### Check Saldo Wallet
```
nolusd query bank balances $NOLUS_WALLET_ADDRESS
```

### Restart Node
```
sudo systemctl daemon-reload
sudo systemctl enable nolusd
sudo systemctl restart nolusd
source $HOME/.bash_profile
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
- Check transaksi ID di https://nolus.explorers.guru/ atau https://explorer-rila.nolus.io/
- Kemudian copy linknya dan submit di Crew3 : 
https://crew3.xyz/c/nolus/invite/szl85ZQ5Opq8F_Uj3_siu


### Jika ingin Edit existing validator
```
nolusd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id nolus-rila \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--fees 675unls \
-y
```

__________________________________


# Uninstall Node
```
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm /etc/systemd/system/nolusd.service
sudo systemctl daemon-reload
rm -f $(which nolusd)
rm -rf $HOME/.nolus
rm -rf $HOME/nolus-core
rm -rf $HOME/nolus.sh
```

__________________________________

### Chek status sync
```
nolusd status 2>&1 | jq .SyncInfo
```
__________________________________

Unjail validator
```
nolusd tx slashing unjail --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Jail reason
```
nolusd query slashing signing-info $(nolusd tendermint show-validator)
```

List all active validators
```
nolusd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

List all inactive validators
```
nolusd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

View validator details
```
nolusd q staking validator $(nolusd keys show wallet --bech val -a)
```

💲 Token management
Withdraw rewards from all validators
```
nolusd tx distribution withdraw-all-rewards --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Withdraw commission and rewards from your validator
```
nolusd tx distribution withdraw-rewards $(nolusd keys show wallet --bech val -a) --commission --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Delegate tokens to yourself
```
nolusd tx staking delegate $(nolusd keys show wallet --bech val -a) 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Delegate tokens to validator
```
nolusd tx staking delegate <TO_VALOPER_ADDRESS> 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Redelegate your stake from one validator to another validator
```
nolusd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Redelegate your stake from another validator to yourself
```
nolusd tx staking redelegate <srcValidatorAddress> $(nolusd keys show wallet --bech val -a) 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Redelegate your stake from yourself to another validator 
```
nolusd tx staking redelegate $(nolusd keys show wallet --bech val -a) <destValidatorAddress> 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Unbond tokens from your validator
```
nolusd tx staking unbond $(nolusd keys show wallet --bech val -a) 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Send tokens to the wallet
```
nolusd tx bank send wallet <TO_WALLET_ADDRESS> 1000000unls --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```


🗳 Governance
List all proposals
```
nolusd query gov proposals
```

View proposal by id
```
nolusd query gov proposal 1
```

Vote 'Yes'
```
nolusd tx gov vote 1 yes --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Vote 'No'
```
nolusd tx gov vote 1 no --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Vote 'Abstain'
```
nolusd tx gov vote 1 abstain --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

Vote 'NoWithVeto'
```
nolusd tx gov vote 1 nowithveto --from wallet --chain-id nolus-rila --gas-adjustment 1.4 --gas auto --fees 500unls -y
```

⚡️ Utility
Update ports
```
CUSTOM_PORT=10
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.nolus/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.nolus/config/app.toml
```

Update Indexer
Disable indexer
```
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.nolus/config/config.toml
```

Enable indexer
```
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.nolus/config/config.toml
```

Update pruning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.nolus/config/app.toml
```

🚨 Maintenance
Get validator info
```
nolusd status 2>&1 | jq .ValidatorInfo
```

Get sync info
```
nolusd status 2>&1 | jq .SyncInfo
```

Get node peer
```
echo $(nolusd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.nolus/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

Check if validator key is correct
```
[[ $(nolusd q staking validator $(nolusd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(nolusd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

Get live peers
```
curl -sS http://localhost:39657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

Set minimum gas price
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025unls\"/" $HOME/.nolus/config/app.toml
```

Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.nolus/config/config.toml
```

Reset chain data
```
nolusd tendermint unsafe-reset-all --home $HOME/.nolus --keep-addr-book
```

⚙️ Service Management
Reload service configuration
```
sudo systemctl daemon-reload
```

Enable service
```
sudo systemctl enable nolusd
```

Disable service
```
sudo systemctl disable nolusd
```

Start service
```
sudo systemctl start nolusd
```

Stop service
```
sudo systemctl stop nolusd
```

Restart service
```
sudo systemctl restart nolusd
```

Check service status
```
sudo systemctl status nolusd
```

Check service logs
```
sudo journalctl -u nolusd -f --no-hostname -o cat
```

__________________________________



