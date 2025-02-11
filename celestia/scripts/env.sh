#!/bin/bash

CHAIN_ID=local_devnet
BINARY="/home/mssong/decipher-cosmbench/celestia/bin/celestia-appd"
MONIKER="cosmbench"

KEYRING_BACKEND="test"

NODE_COUNT=4
ACCOUNT_COUNT_PER_LOOP=5000 

UNIT="stake"
SEND_AMOUNT=100

NODE_ROOT_DIR="node"
ACCOUNT_DIR=$CHAIN_ID"_accounts"

ACCOUNT_NAME_PREFIX="account_"

GENESIS_DIR=$NODE_ROOT_DIR"/node0"

UNSIGNED_TX_PREFIX="unsigned_tx_"
SIGNED_TX_PREFIX="signed_tx_"
ENCODED_TX_PREFIX="encoded_tx_"

UNSIGNED_TX_ROOT_DIR=$CHAIN_ID"_unsigned_txs"
SIGNED_TX_ROOT_DIR=$CHAIN_ID"_signed_txs"
ENCODED_TX_ROOT_DIR=$CHAIN_ID"_encoded_txs"

DEPLOY_DIR="deploy_run_nodes_scripts"
