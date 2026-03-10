# MineCloud ☁️

Servidor Minecraft Java Edition na AWS com infraestrutura gerenciada como código.

## Sobre o Projeto

Infraestrutura completa para hospedar um servidor Minecraft na AWS com foco em automação, boas práticas de DevOps/SRE e otimização de custos. O servidor opera sob demanda — liga e desliga conforme necessário, evitando custos com instâncias ociosas.

## Stack

- **Cloud:** AWS (us-east-1)
- **IaC:** Terraform
- **Configuration Management:** Ansible
- **CI/CD:** GitHub Actions
- **Compute:** EC2 Spot Instance (t3.large)
- **Storage:** EBS gp3 + S3 (backups)
- **OS:** Ubuntu Server 24.04 LTS
- **Runtime:** Java 21 + Minecraft Java Edition
- **DNS:** Route 53
- **Monitoramento:** Grafana + Prometheus

## Arquitetura

> Em construção

## Roadmap

- [x] Infraestrutura manual (VPC, EC2 Spot, EBS, Security Group, SSM)
- [ ] Infraestrutura como Código com Terraform
- [ ] Configuração automatizada com Ansible
- [ ] Pipeline CI/CD com GitHub Actions
- [ ] Start/stop sob demanda
- [ ] Auto-shutdown por inatividade
- [ ] Backup automático para S3
- [ ] DNS automático com Route 53
- [ ] Monitoramento com Grafana + Prometheus

## Custo Estimado

| Recurso | Configuração | USD/mês |
|---|---|---|
| EC2 Spot t3.large | ~16h/mês | $0,52 |
| EBS gp3 | 8GB | $0,64 |
| **Total** | | **~$1,16** |

## Autor

Desenvolvido como projeto pessoal de portfólio com foco em Cloud Infrastructure, DevOps e SRE.