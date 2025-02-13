# Injective Setup Guide

## 1. Initialize Nodes, Assign Validators, Create Accounts, and Generate Transactions

Run the following command to initialize the entire setup:

```bash
make init
```

This command will execute the following steps:
- **Initialize Nodes**:
    - Load environment variables from `env.sh`
    - Remove any existing node data in `$NODE_ROOT_DIR`
    - Initialize `$NODE_COUNT` nodes with unique monikers
    - Create a backup of each node's `genesis.json` file
    - Display the node IDs for all initialized nodes

- **Assign Validators**:
    - Add accounts to the genesis file for each node
    - Assign an initial balance to each genesis account
    - Generate validator transactions (`gentx`) for each node
    - Collect all `gentx` transactions into a single genesis file
    - Save the final `genesis.json` as `validator_genesis.json` in node 0

- **Create Accounts**:
    - Generate multiple accounts for each node
    - Assign an initial balance to each account in the genesis file
    - Backup keyring information for all created accounts
    - Display the account addresses for verification

- **Generate Transactions**:
    - Clean and recreate directories for unsigned, signed, and encoded transactions
    - Generate unsigned transactions for each account
    - Sign transactions using the corresponding account
    - Encode the signed transactions for broadcasting
    - Save the final encoded transactions for later use

---

## 2. Initialize Node Environment

Run the following command to initialize the node environment:

```bash
make initialize-env
```

This command will:
- Copy the initialized node data to a test directory
- Ensure all nodes use the same `genesis.json`
- Replace `"stake"` in `genesis.json`
- Update `config.toml` for:
    - Custom RPC, P2P, API, and gRPC ports
    - Allowing duplicate IPs
    - Increasing mempool size
- Enable the REST API in `app.toml`
- Set up persistent peers between nodes to ensure connectivity

---

## 3. Run Nodes

After initializing everything, start all nodes by running:

```bash
make run
```

This will:
- Execute `scripts/92_run.sh` for each node in parallel
- Start all nodes and wait for them to be fully operational

---

## 4. Send Transactions

Run the following command to send transactions:

```bash
go run send_tx.go <TPS> <RunTime>
```

This script will:
- Load encoded transactions from the `scripts/axelar-cosmbench_encoded_txs` directory
- Broadcast transactions to the blockchain network asynchronously
- Log transaction hashes and timestamps for tracking
- Save transaction logs in `results/tx_log.json`

### Arguments:
1. **TPS (Transactions Per Second)**:
- Specifies the number of transactions to send per second.
- Example: `40` means the script will attempt to send 40 transactions per second.

2. **RunTime (Seconds)**:
- Defines the total duration (in seconds) for which transactions will be sent.
- Example: `5` means the script will run for 5 seconds, sending transactions continuously during this period.

#### Example Usage:

```bash
go run send_tx.go 40 5
```

This will send transactions at a rate of **40 transactions per second** for **5 seconds**.

After execution, transaction logs will be stored in:

```bash
results/tx_log.json
```

This file contains transaction indices, timestamps, and transaction hashes for verification.

---

## 5. Calculate Metrics

Once transactions have been sent, you can calculate performance metrics by running:

```bash
make calculate
```

This command will:
- **Update block heights** using `update_height.go`
- **Calculate transaction metrics** using `calc_metrics.go`
- **Convert results into CSV format** using `conv_json_to_csv.go`

### Results:

After running this command, the calculated metrics will be available in the `results/` directory.  
These results provide insights into transaction performance and system behavior.