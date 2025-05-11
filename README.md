# Simple Node Status

Aplicação Node.js com endpoint de status. Suporta deploy contínuo em produção com rollback automático via EC2 e execução automatizada de testes em ambiente de desenvolvimento.

---

## 🐳 Docker

### Build da imagem and Execução do container

```bash
./deploy.sh
```

A aplicação estará disponível em `http://localhost:3000/status`.

---

## Testes de Integração via GitHub Actions

Sempre que houver:

- Push para a branch `develop`
- Pull Request com destino `main`

A pipeline `CI - Develop` será executada com os seguintes passos:

1. Build da imagem Docker
2. Execução do container em background
3. Espera de 10 segundos
4. Teste do endpoint `/status` via `curl`
5. Encerramento e remoção do container

---

## 🚀 Deploy em Produção com Rollback

O deploy ocorre automaticamente via GitHub Actions quando há push na branch `main`.

### Processo

1. Código é enviado para a instância EC2 via `rsync`.
2. Script `remote_deploy.sh` é executado remotamente:
   - Cria uma nova release em `/home/ec2-user/releases`
   - Atualiza o symlink `/home/ec2-user/current`
   - Executa o `deploy.sh` da nova release
   - Se falhar, o rollback é feito automaticamente para a release anterior

### Estrutura na EC2

```
/home/ubuntu/
├── deploy/                # Recebe arquivos da action
│   ├── deploy.sh          # Starta o container
│   └── remote_deploy.sh   # Gerencia releases e rollback
├── releases/
│   ├── 20250510_103050/
│   └── ...
└── current -> releases/20250510_103050
```

### deploy.sh (exemplo)

```bash
#!/bin/bash

# Build da imagem Docker
docker build -t simple-node-status-prod .

# Remove container anterior, se existir
docker rm -f status-prod || true

# Executa o novo container
docker run -d -p 3000:3000 --name status-prod simple-node-status-prod
```

---

## Variáveis e Segredos

No GitHub, defina os seguintes segredos:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `AWS_SSH_PRIVATE_KEY`
- `AWS_EC2_USER` 
- `AWS_SECRET_IP` (IP público da instância)

---

## 📦 Requisitos

- Docker instalado na máquina local e no EC2
- GitHub Actions ativado no repositório
- A instância EC2 deve aceitar conexões SSH e permitir `rsync`/`scp`

