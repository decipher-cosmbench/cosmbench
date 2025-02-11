#!/bin/bash

curl -X POST \
    -H "Content-Type: application/json" \
    -d'{"tx_bytes":"CokBCoYBChwvY29zbW9zLmJhbmsudjFiZXRhMS5Nc2dTZW5kEmYKKmluajFucWUwcmZ2amM5N3ZtNHpoN3hnZ2V5OTVtOHMzNTZnYXR5ZzVlZhIqaW5qMW5xZTByZnZqYzk3dm00emg3eGdnZXk5NW04czM1NmdhdHlnNWVmGgwKBXN0YWtlEgMxMDASZApcClQKLS9pbmplY3RpdmUuY3J5cHRvLnYxYmV0YTEuZXRoc2VjcDI1NmsxLlB1YktleRIjCiEDjoc4bSGbVvQBHXnLR47Dkl9zSpjRwBLoh1Zyy43QsUwSBAoCCAESBBDAmgwaQWuocdhpcFjD4ICG+QzLPUXq3dOkEvMa7lWg+3/hi85+b4S4XbbrZr7q/8l/yHZTFFkPXyweRggDLtHjkYQWRuMA","mode":"BROADCAST_MODE_SYNC"}' \
    147.46.240.248:22200/cosmos/tx/v1beta1/txs
