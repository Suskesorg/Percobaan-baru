## Set Variabel
```
RELAYER_NAME_NOLUS=<Nama_Kamu>
```

## Update system dan Install unzip
```
sudo apt update && sudo apt upgrade -y
sudo apt install unzip -y
```

## Download Hermes
```
cd $HOME
wget https://github.com/informalsystems/hermes/releases/download/v1.2.0/hermes-v1.2.0-x86_64-unknown-linux-gnu.zip
unzip hermes-v1.2.0-x86_64-unknown-linux-gnu.zip
sudo mv hermes /usr/local/bin
rm -rf $HOME/hermes-v1.2.0-x86_64-unknown-linux-gnu.zip
hermes version
```

## Create hermes config
```
rm -rf $HOME/.hermes
mkdir $HOME/.hermes

sudo tee $HOME/.hermes/config.toml > /dev/null <<EOF
[global]
log_level = 'info'

[mode]

[mode.clients]
enabled = true
refresh = true
misbehaviour = true

[mode.connections]
enabled = false

[mode.channels]
enabled = false

[mode.packets]
enabled = true
clear_interval = 100
clear_on_start = true
tx_confirmation = true

[rest]
enabled = true
host = '127.0.0.1'
port = 3000

[telemetry]
enabled = true
host = '127.0.0.1'
port = 3001

[[chains]]
### CHAIN_A ###
id = 'nolus-rila'
rpc_addr = 'https://nolus-testnet.rpc.kjnodes.com:443'
grpc_addr = 'http://127.0.0.1:9090'
websocket_addr = 'ws://127.0.0.1:43657/websocket'
rpc_timeout = '10s'
account_prefix = 'nolus'
key_name = 'wallet'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 100000
max_gas = 600000
min-gas-price = 0
gas_price = { price = 500, denom = 'unls' }
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 2097152
clock_drift = '5s'
max_block_time = '30s'
trusting_period = '2days'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = '${RELAYER_NAME_NOLUS} Relayer'

[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-0'], # Osmosis
]

[[chains]]
### CHAIN_B ###
id = 'osmo-test-4'
rpc_addr = 'https://rpc-test.osmosis.zone'
grpc_addr =  'tcp://grpc-test.osmosis.zone:443'
websocket_addr = 'wss://rpc-test.osmosis.zone/websocket'
rpc_timeout = '10s'
account_prefix = 'osmo'
key_name = 'wallet'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 100000
max_gas = 600000
min-gas-price = 0
gas_price = { price = 0.0026, denom = 'uosmo' }
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 2097152
clock_drift = '5s'
max_block_time = '30s'
trusting_period = '2days'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = '${RELAYER_NAME_NOLUS} Relayer'

[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-1837'], # nolus
]
EOF
```

## Validate Configuration
```
hermes config validate
```

## Perform a health check
```
hermes health-check
```

## Create hermes service daemon
```
sudo tee /etc/systemd/system/hermesd.service > /dev/null <<EOF
[Unit]
Description=hermes
After=network-online.target

[Service]
User=$USER
ExecStart=$(which hermes) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Add relayer wallet A
Wallet A dan B masukan saja Phrase yang sama
```
nano $HOME/.hermes/keys/keys-A.json
```

## Add relayer wallet B
```
nano $HOME/.hermes/keys/keys-B.json
```

## Recover wallets using mnemonic files
```
hermes keys add --chain nolus-rila --mnemonic-file $HOME/.hermes/keys/keys-A.json
hermes keys add --chain osmo-test-4 --mnemonic-file $HOME/.hermes/keys/keys-B.json
```

## Restart hermes
```
sudo systemctl daemon-reload
sudo systemctl enable hermesd
sudo systemctl restart hermesd
```

## Check hermes logs
```
journalctl -u hermesd -f -o cat
```

# Find free channels
```
hermes query channels --chain nolus-rilla
hermes query channels --chain osmo-test-4
```

## Done


