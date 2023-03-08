## Update system dan Install unzip
```
sudo apt update && sudo apt upgrade -y
```

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

```
source "$HOME/.cargo/env"
```

```
sudo apt-get install pkg-config libssl-dev
```

```
sudo apt install librust-openssl-dev build-essential git
```



## Download Hermes
```
cargo install ibc-relayer-cli --bin hermes --locked
mkdir -p $HOME/hermes
git clone https://github.com/informalsystems/ibc-rs.git hermes
cd hermes
git checkout v1.3.0
```

```
cd $HOME/hermes
mkdir -p $HOME/.hermes
mkdir -p $HOME/.hermes/keys
cp config.toml $HOME/.hermes
cd
```
## Check hermes version
```
hermes version
```

## Set Variabel
```
RELAYER_NAME_NOLUS=<Nama_Kamu>
```

## Create hermes config
```
rm -rf $HOME/.hermes/config.toml
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
port = 4000

[telemetry]
enabled = true
host = '127.0.0.1'
port = 4001

[[chains]]
### CHAIN_A ###
id = 'nolus-rila'
rpc_addr = 'http://127.0.0.1:43657/'
grpc_addr = 'http://127.0.0.1:43090/'
websocket_addr = 'ws://127.0.0.1:43657/websocket'
rpc_timeout = '10s'
account_prefix = 'nolus'
key_name = 'wallet'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 100000
max_gas = 600000
gas_price = { price = 0.0025, denom = 'unls' }
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 2097152
clock_drift = '5s'
max_block_time = '30s'
trusting_period = '14days'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = '${RELAYER_NAME_NOLUS} Relayer'

[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-1837'], # nolus
]

[[chains]]
### CHAIN_B ###
id = 'osmo-test-4'
rpc_addr = 'https://rpc-test.osmosis.zone/'
grpc_addr =  'tcp://grpc-test.osmosis.zone:443/'
websocket_addr = 'wss://rpc-test.osmosis.zone/websocket'
rpc_timeout = '10s'
account_prefix = 'osmo'
key_name = 'wallet'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 100000
max_gas = 600000
gas_price = { price = 0.0026, denom = 'uosmo' }
gas_multiplier = 1.1
max_msg_num = 30
max_tx_size = 2097152
clock_drift = '5s'
max_block_time = '30s'
trusting_period = '10days'
trust_threshold = { numerator = '1', denominator = '3' }
memo_prefix = '${RELAYER_NAME_NOLUS} Relayer'

[chains.packet_filter]
policy = 'allow'
list = [
  ['transfer', 'channel-0'], # osmo
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

## Add your Phrase
```
nano $HOME/.hermes/keys/nolus-rila.mnemonic
```

## Copy file
```
cp $HOME/.hermes/keys/nolus-rila.mnemonic $HOME/.hermes/keys/osmo-test-4.mnemonic
```

## Recover wallets using mnemonic files
```
hermes keys add --chain nolus-rila --mnemonic-file $HOME/.hermes/keys/nolus-rila.mnemonic
hermes keys add --chain osmo-test-4 --mnemonic-file $HOME/.hermes/keys/osmo-test-4.mnemonic
```

## Start hermes
```
cd $HOME/hermes
hermes start
```

## Find query channel client
```
hermes query channel client --chain osmo-test-4 --port transfer --channel channel-0
hermes query channel client --chain nolus-rilla --port transfer --channel channel-1837
```

## Create Client
```
hermes create client --host-chain nolus-rila --reference-chain osmo-test-4
hermes create client --host-chain osmo-test-4 --reference-chain nolus-rila 
```


## Create connection
```
hermes create connection --a-chain nolus-rila --b-chain osmo-test-4
hermes create connection --b-chain osmo-test-4 --a-chain nolus-rila  
```
_________________________________

## Uninstall hermes
```
sudo systemctl stop hermesd
sudo systemctl disable hermesd
sudo rm /etc/systemd/system/hermesd.service
sudo systemctl daemon-reload
rm -f $(which hermesd)
rm -rf $HOME/.hermesd
rm -rf $HOME/hermes
```


