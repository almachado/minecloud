#!/usr/bin/env bash

set -euo pipefail

TERRAFORM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../terraform/environments/prod" && pwd)"

echo "🚀 Starting MineCloud server..."

INSTANCE_ID=$(cd "$TERRAFORM_DIR" && terraform output -raw instance_id 2>/dev/null)

if [ -z "$INSTANCE_ID" ]; then
  echo "❌ Could not retrieve instance ID. Is the infrastructure deployed?"
  exit 1
fi

CURRENT_STATE=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].State.Name" \
  --output text)

if [ "$CURRENT_STATE" == "running" ]; then
  echo "✅ Instance is already running."
else
  echo "▶️  Starting instance $INSTANCE_ID..."
  aws ec2 start-instances --instance-ids "$INSTANCE_ID" > /dev/null

  echo "⏳ Waiting for instance to be running..."
  aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

  echo "⏳ Waiting for SSM agent to be available (this may take ~30s)..."
  sleep 30
fi

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo ""
echo "✅ MineCloud server is up!"
echo "🌐 IP Address : $PUBLIC_IP"
echo "🎮 Connect at : $PUBLIC_IP:25565"