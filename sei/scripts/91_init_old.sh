#!/bin/bash
source ./env.sh
source ./run_env.sh



if [ -d "$TESTDIR" ]; then
    echo "Removing $TESTDIR directory..."
    rm -rf $TESTDIR
fi

cp -rf $NODE_ROOT_DIR $TESTDIR

for ((i=1;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$TESTDIR/node$i
    cp -f $TESTDIR/node0/config/genesis.json $CURRENT_DATA_DIR/config/genesis.json 
done

for ((i=0;i<$NODE_COUNT;i++))
do
    INDEX=$i
    CURRENT_DATA_DIR=$TESTDIR/node$i


    # macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # "stake" -> "usei"로 변경
        sed -i '' 's/"stake"/"usei"/g' "$CURRENT_DATA_DIR/config/genesis.json"

        # Proxy App PORT 변경
        echo "sed -i '' "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # RPC PORT 변경
        echo "sed -i '' "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i '' "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # P2P PORT 변경
        echo "sed -i '' "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # [pprof port] 변경
        echo "sed -i '' "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # 중복 IP 허용
        echo "sed -i '' 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Mempool Size 변경
        echo "sed -i '' 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # cache size 변경 (Mempool size 변경에서 오는 변경 사항 폐기용)
        sed -i '' 's/cache-size = 600000/cache-size = 10000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Minimum Gas Prices 변경
        echo "sed -i '' 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC PORT 변경
        echo "sed -i '' "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC WEB PORT 변경
        echo "sed -i '' "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # TCP PORT 변경
        echo "sed -i '' "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml"
    else # Linux and others
        # "stake" -> "usei"로 변경
        sed -i 's/"stake"/"usei"/g' "$CURRENT_DATA_DIR/config/genesis.json"

        # Proxy App PORT 변경
        echo "sed -i "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # RPC PORT 변경
        echo "sed -i "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # P2P PORT 변경
        echo "sed -i "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # [pprof port] 변경
        echo "sed -i "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # 중복 IP 허용
        echo "sed -i 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Mempool Size 변경
        echo "sed -i 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # cache size 변경 (Mempool size 변경에서 오는 변경 사항 폐기용)
        sed -i 's/cache-size = 600000/cache-size = 10000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Minimum Gas Prices 변경
        echo "sed -i 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml""
        sed -i 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC PORT 변경
        echo "sed -i "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC WEB PORT 변경
        echo "sed -i "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # TCP PORT 변경
        echo "sed -i "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml"

        # HTTP PORT 변경
        echo "sed -i "s#http_port = 8545#http_port = ${HTTP_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#http_port = 8545#http_port = ${HTTP_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml"

        # WebSocket PORT 변경
        echo "sed -i "s#ws_port = 8546#ws_port = ${WS_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#ws_port = 8546#ws_port = ${WS_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml"

        # sc-enable && ss-enable 변경
        echo "sed -i "s#sc-enable = false#sc-enable = true#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#sc-enable = false#sc-enable = true#g" "$CURRENT_DATA_DIR/config/app.toml"
        echo "sed -i "s#ss-enable = false#ss-enable = true#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#ss-enable = false#ss-enable = true#g" "$CURRENT_DATA_DIR/config/app.toml"

        # p2p-no-peers-available-window-seconds 변경
        echo "sed -i 's/p2p-no-peers-available-window-seconds = 0/p2p-no-peers-available-window-seconds = 30/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/p2p-no-peers-available-window-seconds = 0/p2p-no-peers-available-window-seconds = 30/g' "$CURRENT_DATA_DIR/config/config.toml"

        # statesync-no-peers-available-window-seconds 변경
        echo "sed -i 's/statesync-no-peers-available-window-seconds = 0/statesync-no-peers-available-window-seconds = 30/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/statesync-no-peers-available-window-seconds = 0/statesync-no-peers-available-window-seconds = 30/g' "$CURRENT_DATA_DIR/config/config.toml"

        # blocks-behind-threshold 변경
        echo "sed -i 's/blocks-behind-threshold = 0/blocks-behind-threshold = 30/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/blocks-behind-threshold = 0/blocks-behind-threshold = 30/g' "$CURRENT_DATA_DIR/config/config.toml"

        # statesync enable=false
        # echo "sed -i 's/enable = false/enable = true/g' "$CURRENT_DATA_DIR/config/config.toml""
        # sed -i 's/enable = false/enable = true/g' "$CURRENT_DATA_DIR/config/config.toml"

        # use-p2p = false
        # echo "sed -i 's/use-p2p = false/use-p2p = true/g' "$CURRENT_DATA_DIR/config/config.toml""
        # sed -i 's/use-p2p = false/use-p2p = true/g' "$CURRENT_DATA_DIR/config/config.toml"

        # db-sync-enable = "false"
        # echo "sed -i 's/db-sync-enable = false/db-sync-enable = true/g' "$CURRENT_DATA_DIR/config/config.toml""
        # sed -i 's/db-sync-enable = \"false\"/db-sync-enable = true/g' "$CURRENT_DATA_DIR/config/config.toml"

        # unsafe-propose-timeout-override = "300ms"
        # echo "sed -i 's/unsafe-propose-timeout-override = \"300ms\"/unsafe-propose-timeout-override = \"5300ms\"/g' "$CURRENT_DATA_DIR/config/config.toml""
        # sed -i 's/unsafe-propose-timeout-override = \"300ms\"/unsafe-propose-timeout-override = \"5300ms\"/g' "$CURRENT_DATA_DIR/config/config.toml"

        echo "sed -i 's/mode = \"full\"/mode = \"validator\"/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/mode = \"full\"/mode = \"validator\"/g' "$CURRENT_DATA_DIR/config/config.toml"
        
    fi
done

# [persistent peers]
echo "Update persistent_peers"
PERSISTENT_PEERS=""
for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    $BINARY tendermint show-node-id --home $CURRENT_DATA_DIR
done


for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    NODE_ID=$($BINARY tendermint show-node-id --home $CURRENT_DATA_DIR)
    PERSISTENT_PEERS=$PERSISTENT_PEERS${NODE_ID}'@'${PRIVATE_HOSTS[$i]}':'${P2P_PORTS[$i]}','
done
PERSISTENT_PEERS=${PERSISTENT_PEERS%,} #마지막에 ,를 제거하겠다는 의미

echo "PERSISTENT_PEERS : "$PERSISTENT_PEERS
for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$TESTDIR/node$i

    # macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "sed -i '' "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i '' "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" "$CURRENT_DATA_DIR/config/config.toml"
    else
        echo "sed -i "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" "$CURRENT_DATA_DIR/config/config.toml"
        sed -i "s/bootstrap-peers = ".*"/bootstrap-peers = \"$PERSISTENT_PEERS\"/g" "$CURRENT_DATA_DIR/config/config.toml"
        sed -i "s/blocksync-peers = ".*"/blocksync-peers = \"$PERSISTENT_PEERS\"/g" "$CURRENT_DATA_DIR/config/config.toml"
    fi
done
