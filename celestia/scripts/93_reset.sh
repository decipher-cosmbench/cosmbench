#!/bin/bash

cores=(core0 core1 core2 core3)

content='{
  "height": "0",
  "round": 0,
  "step": 0
}'

for core in "${cores[@]}"; do
	  data_dir="${core}/data"  
	  rm -rf "${data_dir}"/*.db "${data_dir}/snapshots/" "${data_dir}/cs.wal" "${data_dir}/priv_validator_state.json"
	  echo "${content}" > "${data_dir}/priv_validator_state.json"
done
