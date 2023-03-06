#!/bin/bash
clear
echo -e "\e[96m"       
echo -e "  **********                    **                             "
echo -e " **////////                                                    "
echo -e "/**         ******   **   **    **  ******   *******   ******  "
echo -e "/********* //////** /**  /**   /** //////** //**///** //////** "
echo -e "////////**  ******* /**  /**   /**  *******  /**  /**  ******* "
echo -e "       /** **////** /**  /** **/** **////**  /**  /** **////** "
echo -e " ******** //********//******//*** //******** ***  /**//********"
echo -e "////////   ////////  //////  ///   //////// ///   //  //////// "
echo -e "\e[0m"

echo "===================================================================" 
echo -e '\e[36mGarapan      :\e[39m' Membuat Relayer Nolus Core
echo -e '\e[36mAuthor       :\e[39m' Saujana
echo -e '\e[36mTelegram     :\e[39m' @SaujanaOK
echo -e '\e[36mTwitter      :\e[39m' @SaujanaCrypto
echo -e '\e[36mDiscord      :\e[39m' DEFFAN#0372
echo -e '\e[36mGithub       :\e[39m' https://github.com/SaujanaOK/
echo "===================================================================" 

sleep 2

# Set Vars Relayer
if [ ! $Snapshot_Domain_Nolus ]; then
        read -p "ENTER YOUR RELAYER NAME : " $RELAYER_NAME_NOLUS
        echo 'export $RELAYER_NAME_NOLUS='$RELAYER_NAME_NOLUS >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR RELAYER NAME : \e[1m\e[35m$RELAYER_NAME_NOLUS\e[0m"
echo ""

# Set Vars Phrase
if [ ! $Snapshot_Domain_Nolus ]; then
        read -p "ENTER YOUR PHRASE WALLET : " $PHRASE_WALLET_NOLUSRELAYER
        echo 'export $PHRASE_WALLET_NOLUSRELAYER='$PHRASE_WALLET_NOLUSRELAYER >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR PHRASE WALLET : \e[1m\e[35m******\e[0m"
echo ""


# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install unzip -y

# Download Hermes
cd $HOME
wget https://github.com/informalsystems/hermes/releases/download/v1.2.0/hermes-v1.2.0-x86_64-unknown-linux-gnu.zip

# Unzip File
unzip hermes-v1.2.0-x86_64-unknown-linux-gnu.zip
sudo mv hermes /usr/local/bin
rm -rf $HOME/hermes-v1.2.0-x86_64-unknown-linux-gnu.zip
hermes version

# Make hermes home dir
mkdir $HOME/.hermes

# Create hermes config
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
rpc_addr = 'http://rpc.nolus.deffanok.me'
grpc_addr = 'http://grpc.nolus.deffanok.me'
websocket_addr = 'ws://127.0.0.1:43657/websocket'
rpc_timeout = '10s'
account_prefix = 'nolus'
key_name = 'wallet'
address_type = { derivation = 'cosmos' }
store_prefix = 'ibc'
default_gas = 100000
max_gas = 600000
gas_price = { price = 0.025, denom = 'unls' }
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
gas_price = { price = 0.025, denom = 'uosmo' }
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
EOF

# Validate Configuration
hermes config validate

# Perform a health check
hermes health-check

# Create hermes service daemon
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

# Add relayer wallet A
sudo tee $HOME/.hermes/keys/keys-A.json > /dev/null <<EOF
${$PHRASE_WALLET_NOLUSRELAYER}
EOF

# Add relayer wallet B
sudo tee $HOME/.hermes/keys/keys-B.json > /dev/null <<EOF
${$PHRASE_WALLET_NOLUSRELAYER}
EOF

# Recover wallets using mnemonic files
hermes keys add --chain nolus-rila --mnemonic-file $HOME/.hermes/keys/keys-A.json
hermes keys add --chain osmo-test-4 --mnemonic-file $HOME/.hermes/keys/keys-B.json

# Restart hermes
sudo systemctl daemon-reload
sudo systemctl enable hermesd
sudo systemctl restart hermesd

# End
