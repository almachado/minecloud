# MineCloud

![AWS](https://img.shields.io/badge/AWS-us--east--1-orange)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)
![Ansible](https://img.shields.io/badge/Config-Ansible-green)
![EC2](https://img.shields.io/badge/Compute-EC2_t3.large-blue)

On-demand Minecraft Java Edition server on AWS, automated with Infrastructure as Code.

---

## Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured (`aws configure`)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) with `community.aws` collection
- [AWS Session Manager Plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html)
- Python `boto3` library (`pip install boto3`)

---

## Bootstrap

One-time setup — creates the S3 + DynamoDB remote state backend.

```bash
aws s3api create-bucket --bucket minecloud-tfstate --region us-east-1

aws s3api put-bucket-versioning \
  --bucket minecloud-tfstate \
  --versioning-configuration Status=Enabled

aws dynamodb create-table \
  --table-name minecloud-tfstate-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

---

## Getting Started

```bash
# 1. Clone
git clone git@github.com:<your-username>/minecloud.git && cd minecloud

# 2. Set your home IP
cp terraform/environments/prod/terraform.tfvars.example \
   terraform/environments/prod/terraform.tfvars
# edit: allowed_ip = "YOUR_IP/32"

# 3. Deploy
make init && make infra && make deploy
```

Connect in Minecraft Java Edition: `<IP>:25565`

---

## Daily Usage

| Command | Action |
|---|---|
| `make start` | Start the EC2 instance |
| `make stop` | Stop the EC2 instance |
| `make ip` | Get current public IP |
| `make ssm` | Open SSM session |
| `make logs` | Tail server logs |
| `make destroy` | Destroy all infrastructure |

> The public IP changes on every start. Route 53 integration is planned.

---

## Project Structure

```
minecloud/
├── terraform/
│   ├── modules/
│   │   ├── vpc/                 # VPC, subnet, IGW, route table
│   │   ├── ec2/                 # EC2, IAM role, EBS, volume attachment
│   │   └── security-group/      # Inbound/outbound rules
│   └── environments/
│       └── prod/                # Production environment configuration
├── ansible/
│   ├── inventories/prod/        # SSM-based inventory
│   ├── roles/minecraft/         # Server setup role
│   └── playbooks/               # Entry point playbooks
├── scripts/
│   ├── start.sh                 # Start the EC2 instance
│   └── stop.sh                  # Stop the EC2 instance
└── docs/                        # Additional documentation
```

---

## Stack

| Layer | Technology |
|---|---|
| Cloud | AWS (us-east-1) |
| IaC | Terraform + S3/DynamoDB backend |
| Config | Ansible over SSM (no SSH) |
| Compute | EC2 t3.large · Ubuntu 24.04 |
| Runtime | Java 25 · Minecraft 26.1 |

---

Built as a personal portfolio project combining real-world use with production-grade infrastructure practices.