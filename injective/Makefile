# Makefile for initializing nodes, validators, and updating transaction heights

# Variables
SCRIPTS_DIR=scripts

.PHONY: init install-bin init-nodes assign-validators create-accounts initialize-env generate-transactions run send restart calculate update stop

init: install-bin init-nodes assign-validators create-accounts initialize-env generate-transactions
	@echo "Initialization complete."

install-bin:
	@if [ -f /usr/local/bin/injectived ]; then \
		echo "Injectived binary already exists. Skipping installation."; \
	else \
		echo "Downloading Injective binary..."; \
		wget -q https://github.com/InjectiveLabs/injective-chain-releases/releases/download/v1.14.0-1739303348/linux-amd64.zip -O injective.zip; \
		echo "Extracting Injective binary..."; \
		unzip -o injective.zip; \
		echo "Moving binaries to /usr/local/bin/..."; \
		sudo mv injectived peggo /usr/local/bin/; \
		sudo chmod +x /usr/local/bin/injectived /usr/local/bin/peggo; \
		echo "Moving libwasmvm.x86_64.so to /usr/lib/..."; \
		sudo mv libwasmvm.x86_64.so /usr/lib/; \
		echo "Cleaning up installation files..."; \
		rm -f injective.zip; \
		echo "Injective installation complete."; \
	fi

init-nodes:
	@echo "Initializing nodes..."
	bash $(SCRIPTS_DIR)/1_init_nodes.sh

assign-validators:
	@echo "Assigning validators..."
	bash $(SCRIPTS_DIR)/2_assign_validator.sh

create-accounts:
	@echo "Creating accounts..."
	bash $(SCRIPTS_DIR)/3_create_account.sh

initialize-env:
	@echo "Initializing environment and persistent peers..."
	bash $(SCRIPTS_DIR)/91_init.sh

generate-transactions:
	@echo "Generating transactions..."
	bash $(SCRIPTS_DIR)/4_generate_transactions.sh

run:
	@echo "Starting all nodes..."
	for i in 0 1 2 3; do \
		bash ./scripts/92_run.sh $$i & \
	done; \
	wait

send:
	@echo "Sending transactions with TPS=$(firstword $(ARGS)) and RunTime=$(word 2, $(ARGS))..."
	@go run send_tx.go types.go $(ARGS)

restart:
	@echo "Restarting environment and nodes..."
	make initialize-env
	make run

calculate:
	@echo "Calculating metrics..."
	@go run update_height.go
	@go run calc_metrics.go
	@go run conv_json_to_csv.go

update-height:
	@echo "Updating transaction heights in the log..."
	@go run update_height.go types.go

stop:
	@echo "Stopping all nodes..."
	@pkill -f "bash scripts/92_run.sh" || echo "No nodes running."
