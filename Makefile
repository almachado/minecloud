ENV ?= prod
TF_DIR = terraform/environments/$(ENV)
ANSIBLE_DIR = ansible
INSTANCE_ID_CMD = cd $(TF_DIR) && terraform output -raw instance_id
BUCKET_NAME_CMD = cd $(TF_DIR) && terraform output -raw backup_bucket_name

init:
	@cd $(TF_DIR) && terraform init

plan:
	@cd $(TF_DIR) && terraform plan

infra:
	@cd $(TF_DIR) && terraform apply

destroy:
	@cd $(TF_DIR) && terraform destroy

deploy:
	@INSTANCE_ID=$$($(INSTANCE_ID_CMD)) && \
	BUCKET_NAME=$$($(BUCKET_NAME_CMD)) && \
	cd $(ANSIBLE_DIR) && \
	MINECLOUD_INSTANCE_ID=$$INSTANCE_ID \
	ansible-playbook \
		-i inventories/$(ENV)/hosts.yml \
		playbooks/setup.yml \
		-e backup_bucket_name=$$BUCKET_NAME

start:
	@./scripts/start.sh

stop:
	@./scripts/stop.sh

ip:
	@INSTANCE_ID=$$($(INSTANCE_ID_CMD)) && \
	IP=$$(aws ec2 describe-instances \
		--instance-ids $$INSTANCE_ID \
		--query "Reservations[0].Instances[0].PublicIpAddress" \
		--output text) && \
	if [ "$$IP" = "None" ]; then \
		echo "Instance has no public IP (likely stopped)"; \
		exit 1; \
	fi && \
	echo $$IP

connect:
	@INSTANCE_ID=$$($(INSTANCE_ID_CMD)) && \
	aws ssm start-session --target $$INSTANCE_ID

logs:
	@INSTANCE_ID=$$($(INSTANCE_ID_CMD)) && \
	aws ssm start-session \
		--target $$INSTANCE_ID \
		--document-name AWS-StartInteractiveCommand \
		--parameters command="sudo journalctl -u minecraft -f"

help:
	@echo ""
	@echo "Usage:"
	@echo "  make init        - Terraform init"
	@echo "  make plan        - Terraform plan"
	@echo "  make infra       - Apply infrastructure"
	@echo "  make destroy     - Destroy infrastructure"
	@echo ""
	@echo "  make deploy      - Configure EC2 with Ansible"
	@echo ""
	@echo "  make start       - Start Minecraft server"
	@echo "  make stop        - Stop Minecraft server"
	@echo ""
	@echo "  make ip          - Get public IP"
	@echo "  make ssm         - Connect via SSM"
	@echo "  make logs        - View Minecraft logs"
	@echo ""
	@echo "Optional:"
	@echo "  ENV=dev|homolog|prod (default: prod)"
	@echo ""