# ☁️ Infraestrutura – Terraform + Kubernetes (Hack SOAT FIAP)

Este repositório representa a **infraestrutura como código** do projeto **Sistema de Processamento de Vídeos – FIAP X**, desenvolvido como parte da disciplina de **Arquitetura de Software** no curso de pós-graduação da FIAP.

Ele é responsável por provisionar toda a infraestrutura necessária para hospedar os microsserviços do sistema utilizando **Terraform** e **Kubernetes**, seguindo as boas práticas propostas no desafio.

---

## 📦 Visão Geral do Projeto

A infraestrutura foi construída para dar suporte a uma aplicação de **processamento de vídeos**, com foco em:

- **Escalabilidade** – possibilitando o processamento de múltiplos vídeos em paralelo.  
- **Persistência** – garantindo que requisições não sejam perdidas em caso de falhas.  
- **Segurança** – infraestrutura preparada para autenticação e controle de acesso.  
- **Observabilidade** – recursos prontos para integração com ferramentas de monitoramento.  

---

## 🛠️ Tecnologias Utilizadas

- **Terraform** – Provisionamento da infraestrutura.  
- **Kubernetes** – Orquestração de microsserviços.  
- **Helm** – Gerenciamento de pacotes Kubernetes.  
- **PostgreSQL** – Banco de dados relacional.  
- **Redis** – Suporte a cache e filas.  
- **Ingress NGINX** – Roteamento de tráfego externo.  

---

## 🧩 Pré-requisitos

- Conta em provedor cloud (AWS, GCP ou Azure).  
- [Terraform](https://developer.hashicorp.com/terraform/downloads) instalado.  
- [kubectl](https://kubernetes.io/docs/tasks/tools/) instalado.  
- [Helm](https://helm.sh/docs/intro/install/) instalado.  
- CLI do provedor configurada (ex.: `aws configure` no caso da AWS).  

---

## 🚀 Como Executar

### 1. Clonar o repositório

```bash
git clone https://github.com/<seu-usuario>/terraform-infra-k8s-microservices.git
cd terraform-infra-k8s-microservices
```

### 2. Inicializar Terraform

```bash
terraform init
```

### 3. Visualizar mudanças

```bash
terraform plan
```

### 4. Aplicar infraestrutura

```bash
terraform apply
```

> **Obs.:** A criação dos recursos pode levar alguns minutos.

---

## ☸️ Deploy dos Microsserviços

Após o provisionamento, utilize os manifests/Helm Charts presentes na pasta `k8s/` para aplicar os serviços no cluster:

```bash
kubectl apply -f k8s/
```

---

## 📁 Estrutura de Pastas

```
.
├── main.tf               # Configurações principais do Terraform
├── variables.tf          # Variáveis customizáveis
├── outputs.tf            # Saídas relevantes
├── modules/              # Módulos reutilizáveis (eks, rds, vpc, etc.)
└── k8s/                  # Manifests Kubernetes para os microsserviços
```

---

## 📊 Observabilidade

O repositório já está preparado para integração com ferramentas como:

- **Prometheus + Grafana**  
- **ELK Stack**  
- **CloudWatch / Stackdriver / Monitor** (dependendo do provedor utilizado)  

---

## 👨‍💻 Autores

Projeto desenvolvido pelo grupo SOAT 67 para o Hackaton - Pós-Graduação em Arquitetura de Software (FIAP).

