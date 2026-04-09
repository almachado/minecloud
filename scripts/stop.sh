#!/usr/bin/env bash

set -euo pipefail

TERRAFORM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../terraform/environments/prod" && pwd)"

echo "🛑 Stopping MineCloud server..."

INSTANCE_ID=$(cd "$TERRAFORM_DIR" && terraform output -raw instance_id 2>/dev/null)

if [ -z "$INSTANCE_ID" ]; then
  echo "❌ Could not retrieve instance ID. Is the infrastructure deployed?"
  exit 1
fi

CURRENT_STATE=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].State.Name" \
  --output text)

if [ "$CURRENT_STATE" == "stopped" ]; then
  echo "✅ Instance is already stopped."
  exit 0
fi

echo "💾 Running world backup..."
COMMAND_ID=$(aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters '{"commands":["/opt/minecraft/backup.sh"]}' \
  --query "Command.CommandId" \
  --output text)

echo "⏳ Waiting for backup to complete..."
aws ssm wait command-executed \
  --command-id "$COMMAND_ID" \
  --instance-id "$INSTANCE_ID"

BACKUP_STATUS=$(aws ssm get-command-invocation \
  --command-id "$COMMAND_ID" \
  --instance-id "$INSTANCE_ID" \
  --query "Status" \
  --output text)

if [ "$BACKUP_STATUS" != "Success" ]; then
  echo "⚠️  Backup failed with status: ${BACKUP_STATUS}. Proceed with shutdown? (y/n)"
  read -r CONFIRM
  if [ "$CONFIRM" != "y" ]; then
    echo "❌ Shutdown cancelled."
    exit 1
  fi
fi

echo "⏳ Stopping instance $INSTANCE_ID..."
aws ec2 stop-instances --instance-ids "$INSTANCE_ID" > /dev/null

echo "⏳ Waiting for instance to stop..."
aws ec2 wait instance-stopped --instance-ids "$INSTANCE_ID"

echo ""
echo "✅ MineCloud server stopped successfully."
echo "💾 World data is preserved on EBS volume."