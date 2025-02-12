# Makefile for initializing nodes, validators, and updating transaction heights

# Variables
SCRIPTS_DIR=scripts

.PHONY: init init-nodes assign-validators create-accounts initialize-env generate-transactions run send restart calculate update stop

init: check-celestia install-bin init-nodes assign-validators create-accounts initialize-env generate-transactions
	@echo "Initialization complete."

check-celestia:
	@if [ -f /usr/local/bin/celestia-appd ]; then \
		echo "Celestia binary already exists. Skipping install-bin."; \
		touch .celestia_installed; \
	fi

install-bin:
	@if [ -f /usr/local/bin/celestia-appd ]; then \
		echo "Celestia already installed. Skipping..."; \
	else \
		echo "Installing Celestia App..."; \
		rm -rf celestia-app; \
		git clone https://github.com/celestiaorg/celestia-app.git; \
		cd celestia-app && make enable-bbr && git checkout tags/v3.3.1 && make install; \
		cd ..; \
		echo "Moving celestia-appd to /usr/local/bin/"; \
		sudo mv $$HOME/go/bin/celestia-appd /usr/local/bin/celestia-appd; \
		sudo chmod +x /usr/local/bin/celestia-appd; \
		rm -rf celestia-app; \
		echo "Installation complete."; \
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
