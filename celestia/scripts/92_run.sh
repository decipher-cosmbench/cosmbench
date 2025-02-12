#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/env.sh"
source "$SCRIPT_DIR/run_env.sh"

INDEX=$1
CURRENT_DATA_DIR=$TESTDIR/node$INDEX

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/output$INDEX.log"

mkdir -p "$LOG_DIR"
echo "$BINARY start --home $CURRENT_DATA_DIR"
rm -f "$LOG_FILE"

#$BINARY start --home "$CURRENT_DATA_DIR"

$BINARY start --home "$CURRENT_DATA_DIR" --moniker node0 2>&1 | while IFS= read -r line; do

  if [[ "$line" == *"committed state"* ]]; then
    clean_line=$(echo "$line" | sed -r "s/\x1B\[[0-9;]*[mK]//g")

    timestamped_line="$(date '+%s%3N') $clean_line"
    
    echo "$timestamped_line" | tee -a "logs/output$INDEX.log"
  fi
done
