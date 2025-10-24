
# Criar estrutura completa de automação 1Password
# Baseado em melhores práticas e documentação oficial

import json
from datetime import datetime

onepassword_automation = {
    "metadata": {
        "title": "Automação Completa 1Password",
        "version": "1.0",
        "created": datetime.now().strftime("%Y-%m-%d"),
        "author": "Luiz Sena",
        "based_on": [
            "1Password Connect Server API",
            "1Password CLI v2",
            "1Password Service Accounts",
            "Best Practices from 1Password Developer Docs"
        ]
    },
    
    "1_overview": {
        "objetivo": "Automação end-to-end de secrets management usando 1Password",
        "componentes_principais": [
            "1Password Connect Server (self-hosted REST API)",
            "1Password CLI v2 (command-line tool)",
            "1Password Service Accounts (machine authentication)",
            "1Password Kubernetes Operator (K8s secrets sync)"
        ],
        "casos_uso": [
            "Provisionar secrets em CI/CD pipelines",
            "Sincronizar secrets com Kubernetes",
            "Automatizar gestão de credenciais de infraestrutura",
            "Integrar secrets em aplicações (via API/SDK)",
            "Rotação automática de secrets"
        ]
    },
    
    "2_arquitetura": {
        "camadas": {
            "vault_layer": {
                "nome": "1Password Vault (Source of Truth)",
                "descricao": "Vaults compartilhados com secrets de infraestrutura",
                "estrutura_recomendada": {
                    "vault_infra_prod": "Secrets de produção",
                    "vault_infra_staging": "Secrets de staging",
                    "vault_infra_dev": "Secrets de desenvolvimento",
                    "vault_ci_cd": "Secrets de pipelines CI/CD",
                    "vault_databases": "Credenciais de databases"
                },
                "best_practices": [
                    "Princípio de least privilege",
                    "Segregação por ambiente",
                    "Nomenclatura consistente",
                    "Tags para categorização"
                ]
            },
            
            "connect_layer": {
                "nome": "1Password Connect Server",
                "descricao": "API REST self-hosted para acesso programático",
                "componentes": [
                    "connect-api: serve REST API",
                    "connect-sync: sincroniza com 1Password"
                ],
                "vantagens": [
                    "Unlimited requests (sem rate limits)",
                    "Baixa latência (cache local)",
                    "Self-hosted (controle total)",
                    "Alta disponibilidade (deploy redundante)"
                ],
                "deployment_options": [
                    "Docker Compose",
                    "Kubernetes (Helm Chart)",
                    "Railway/Cloud Run",
                    "AWS ECS/Fargate"
                ]
            },
            
            "automation_layer": {
                "nome": "Camada de Automação",
                "ferramentas": [
                    "1Password CLI v2",
                    "1Password SDKs (Python, Go, JS)",
                    "Shell scripts",
                    "Terraform/Pulumi providers",
                    "CI/CD integrations"
                ]
            }
        },
        
        "fluxo_dados": [
            "1. Secrets criados/atualizados em 1Password Vault",
            "2. Connect Server sincroniza mudanças (connect-sync)",
            "3. Aplicações consultam via Connect API/CLI",
            "4. Secrets injetados em runtime (env vars, config files)",
            "5. Logs de auditoria mantidos automaticamente"
        ]
    },
    
    "3_setup_connect_server": {
        "step_1_criar_secrets_automation": {
            "via_web": [
                "1. Acessar https://my.1password.com",
                "2. Developer > Directory > Infrastructure Secrets Management",
                "3. Create a Connect server",
                "4. Selecionar vaults com acesso",
                "5. Baixar 1password-credentials.json",
                "6. Copiar access token"
            ],
            "via_cli": [
                "# Criar Connect server",
                "op connect server create \"My Connect Server\" --vaults=\"Infra Prod,Infra Staging\"",
                "",
                "# Gerar token",
                "op connect token create \"My Connect Server\" --server=\"My Connect Server\"",
                "",
                "# Salvar token no 1Password",
                "op item create --category=password --title=\"Connect Token\" --vault=\"Private\" password=<TOKEN>"
            ],
            "outputs": {
                "credentials_file": "1password-credentials.json (deploy do server)",
                "access_token": "Token para autenticação de apps"
            }
        },
        
        "step_2_deploy_connect_server": {
            "docker_compose": {
                "arquivo": "docker-compose.yml",
                "conteudo": """version: '3.8'

services:
  connect-api:
    image: 1password/connect-api:latest
    ports:
      - "8080:8080"
    environment:
      - OP_SESSION=/home/opuser/.op/data/1password-credentials.json
    volumes:
      - ./1password-credentials.json:/home/opuser/.op/data/1password-credentials.json:ro
      - op-data:/home/opuser/.op/data
    depends_on:
      - connect-sync

  connect-sync:
    image: 1password/connect-sync:latest
    environment:
      - OP_SESSION=/home/opuser/.op/data/1password-credentials.json
    volumes:
      - ./1password-credentials.json:/home/opuser/.op/data/1password-credentials.json:ro
      - op-data:/home/opuser/.op/data

volumes:
  op-data:"""
            },
            
            "kubernetes_helm": {
                "install": [
                    "# Adicionar repo Helm",
                    "helm repo add 1password https://1password.github.io/connect-helm-charts",
                    "helm repo update",
                    "",
                    "# Criar secret com credentials",
                    "kubectl create namespace 1password",
                    "kubectl create secret generic op-credentials \\",
                    "  --from-file=1password-credentials.json \\",
                    "  -n 1password",
                    "",
                    "# Instalar Connect + Operator",
                    "helm install connect 1password/connect \\",
                    "  --set-file connect.credentials=1password-credentials.json \\",
                    "  --set operator.create=true \\",
                    "  --set operator.token.value=<ACCESS_TOKEN> \\",
                    "  --namespace 1password"
                ]
            },
            
            "validacao": [
                "# Testar conectividade",
                "curl -H \"Authorization: Bearer <TOKEN>\" http://localhost:8080/v1/health",
                "",
                "# Listar vaults",
                "curl -H \"Authorization: Bearer <TOKEN>\" http://localhost:8080/v1/vaults"
            ]
        },
        
        "step_3_configurar_access_tokens": {
            "descricao": "Criar tokens separados por aplicação/serviço",
            "best_practices": [
                "1 token por aplicação (isolamento)",
                "Least privilege: acesso apenas aos vaults necessários",
                "Tokens de curta duração para CI/CD (rotação)",
                "Armazenar tokens em 1Password (não hardcode)"
            ],
            "comandos": [
                "# Listar tokens existentes",
                "op connect token list --server=\"My Connect Server\"",
                "",
                "# Criar novo token",
                "op connect token create \"App Production\" --server=\"My Connect Server\"",
                "",
                "# Revogar token",
                "op connect token revoke <TOKEN_ID> --server=\"My Connect Server\""
            ]
        }
    },
    
    "4_automacao_cli": {
        "instalacao": {
            "macos": "brew install 1password-cli",
            "linux": "curl -sSO https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-latest-amd64.deb && sudo dpkg -i 1password-cli-latest-amd64.deb",
            "windows": "winget install 1Password.CLI",
            "docker": "docker pull 1password/op:2"
        },
        
        "autenticacao": {
            "biometric_local": [
                "# Conectar ao app 1Password desktop",
                "eval $(op signin)",
                "",
                "# Usar biometria (Touch ID, Apple Watch)",
                "op vault list  # Solicita biometria automaticamente"
            ],
            
            "service_account_ci_cd": [
                "# Usar Service Account (sem interação humana)",
                "export OP_SERVICE_ACCOUNT_TOKEN=<TOKEN>",
                "",
                "# Comandos funcionam automaticamente",
                "op vault list",
                "op item get \"Database Password\" --vault=\"Infra Prod\""
            ],
            
            "connect_server": [
                "# Configurar para usar Connect Server",
                "export OP_CONNECT_HOST=http://localhost:8080",
                "export OP_CONNECT_TOKEN=<ACCESS_TOKEN>",
                "",
                "# Comandos usam Connect automaticamente",
                "op vault list",
                "op item get \"API Key\" --vault=\"CI/CD\""
            ]
        },
        
        "operacoes_comuns": {
            "criar_item": {
                "template_json": {
                    "title": "Database Production",
                    "category": "login",
                    "fields": [
                        {"id": "username", "label": "username", "value": "admin"},
                        {"id": "password", "label": "password", "value": "super-secret-123"},
                        {"id": "hostname", "label": "hostname", "value": "db.prod.example.com"},
                        {"id": "port", "label": "port", "value": "5432"}
                    ]
                },
                "comando": [
                    "# Criar item via template",
                    "cat template.json | op item create --vault=\"Infra Prod\"",
                    "",
                    "# Criar item inline",
                    "op item create \\",
                    "  --category=password \\",
                    "  --title=\"API Token\" \\",
                    "  --vault=\"CI/CD\" \\",
                    "  token=ghp_abc123xyz"
                ]
            },
            
            "buscar_secret": {
                "get_password": [
                    "# Buscar password de um item",
                    "op item get \"Database Production\" --vault=\"Infra Prod\" --fields password",
                    "",
                    "# Buscar campo específico",
                    "op item get \"Database Production\" --vault=\"Infra Prod\" --fields hostname"
                ],
                
                "secret_reference": [
                    "# Secret reference format",
                    "# op://<vault>/<item>/<field>",
                    "",
                    "# Exemplo",
                    "export DB_PASSWORD=\"op://Infra Prod/Database Production/password\"",
                    "",
                    "# CLI substitui automaticamente",
                    "op run -- psql -h db.prod.example.com -U admin"
                ]
            },
            
            "listar_items": [
                "# Listar todos os items de um vault",
                "op item list --vault=\"Infra Prod\"",
                "",
                "# Filtrar por categoria",
                "op item list --categories=password --vault=\"CI/CD\"",
                "",
                "# Output JSON para processamento",
                "op item list --vault=\"Infra Prod\" --format=json | jq"
            ],
            
            "atualizar_secret": [
                "# Atualizar campo específico",
                "op item edit \"API Token\" --vault=\"CI/CD\" token=new-token-value",
                "",
                "# Atualizar múltiplos campos",
                "op item edit \"Database Production\" \\",
                "  password=new-password \\",
                "  hostname=db-new.prod.example.com"
            ],
            
            "deletar_item": [
                "# Deletar item",
                "op item delete \"Old API Token\" --vault=\"CI/CD\"",
                "",
                "# Deletar com confirmação",
                "op item delete \"Database Production\" --vault=\"Infra Prod\" --archive"
            ]
        }
    },
    
    "5_integracao_ci_cd": {
        "github_actions": {
            "setup": [
                "# Adicionar Service Account token aos Secrets",
                "# Settings > Secrets > Actions > New repository secret",
                "# Name: OP_SERVICE_ACCOUNT_TOKEN",
                "# Value: ops_<token>"
            ],
            
            "workflow_exemplo": """name: Deploy with 1Password Secrets

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install 1Password CLI
        uses: 1password/install-cli-action@v1
      
      - name: Load secrets from 1Password
        env:
          OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}
        run: |
          # Export secrets como env vars
          export AWS_ACCESS_KEY_ID=$(op item get "AWS Credentials" --vault="CI/CD" --fields access_key_id)
          export AWS_SECRET_ACCESS_KEY=$(op item get "AWS Credentials" --vault="CI/CD" --fields secret_access_key)
          
          # Ou usar secret references
          op run --env-file=".env.op" -- npm run deploy
      
      - name: Deploy to production
        run: |
          # Secrets já disponíveis como env vars
          ./deploy.sh"""
        },
        
        "gitlab_ci": {
            "variables": [
                "# GitLab CI/CD > Settings > CI/CD > Variables",
                "# Variable: OP_SERVICE_ACCOUNT_TOKEN",
                "# Type: Masked, Protected"
            ],
            
            "gitlab_ci_yml": """stages:
  - deploy

deploy_prod:
  stage: deploy
  image: 1password/op:2
  variables:
    OP_SERVICE_ACCOUNT_TOKEN: $OP_SERVICE_ACCOUNT_TOKEN
  script:
    - op vault list
    - export DB_PASSWORD=$(op item get "Database Prod" --vault="Infra Prod" --fields password)
    - ./deploy.sh
  only:
    - main"""
        },
        
        "jenkins": {
            "credentials": [
                "# Jenkins > Manage Jenkins > Credentials",
                "# Add Credentials > Secret text",
                "# ID: op-service-account-token"
            ],
            
            "jenkinsfile": """pipeline {
    agent any
    
    environment {
        OP_SERVICE_ACCOUNT_TOKEN = credentials('op-service-account-token')
    }
    
    stages {
        stage('Load Secrets') {
            steps {
                sh '''
                    curl -sSO https://downloads.1password.com/linux/debian/amd64/stable/1password-cli-latest-amd64.deb
                    sudo dpkg -i 1password-cli-latest-amd64.deb
                    
                    export DB_PASSWORD=$(op item get "Database Prod" --vault="Infra Prod" --fields password)
                    echo "Secret loaded successfully"
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}"""
        }
    },
    
    "6_integracao_kubernetes": {
        "onepassword_operator": {
            "descricao": "Sincroniza automaticamente secrets do 1Password para K8s",
            "instalacao": "Já incluído se instalou Connect via Helm com --set operator.create=true",
            
            "uso_basico": {
                "criar_secret_no_1password": "Item no vault com campos username, password, hostname",
                
                "criar_onepassworditem_crd": """apiVersion: onepassword.com/v1
kind: OnePasswordItem
metadata:
  name: database-credentials
  namespace: production
spec:
  itemPath: "vaults/Infra Prod/items/Database Production\"""",
                
                "usar_secret_no_pod": """apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: production
spec:
  template:
    spec:
      containers:
      - name: app
        image: myapp:latest
        env:
        - name: DB_USERNAME
          valueFrom:
            secretKeyRef:
              name: database-credentials
              key: username
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: database-credentials
              key: password"""
            },
            
            "auto_restart_on_update": {
                "descricao": "Operator detecta mudanças e restart pods automaticamente",
                "annotation": """metadata:
  annotations:
    operator.1password.io/auto-restart: \"true\""""
            }
        },
        
        "external_secrets_operator": {
            "descricao": "Alternativa ao 1Password Operator, mais flexível",
            "setup": [
                "# Install External Secrets Operator",
                "helm repo add external-secrets https://charts.external-secrets.io",
                "helm install external-secrets external-secrets/external-secrets -n external-secrets --create-namespace",
                "",
                "# Criar SecretStore",
                "kubectl apply -f secret-store.yaml"
            ],
            
            "secret_store_yaml": """apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: onepassword-store
  namespace: production
spec:
  provider:
    onepassword:
      connectHost: http://connect-api.1password.svc.cluster.local:8080
      vaults:
        Infra Prod: 1
      auth:
        secretRef:
          connectToken:
            name: op-credentials
            key: token""",
            
            "external_secret_yaml": """apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: database-secret
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: onepassword-store
    kind: SecretStore
  target:
    name: database-credentials
    creationPolicy: Owner
  data:
  - secretKey: username
    remoteRef:
      key: Database Production
      property: username
  - secretKey: password
    remoteRef:
      key: Database Production
      property: password"""
        }
    },
    
    "7_secret_references": {
        "descricao": "Substituir secrets em runtime sem hardcode",
        "formato": "op://<vault>/<item>[/<section>]/<field>",
        
        "uso_env_vars": {
            "dot_env_file": """# .env.op
DATABASE_URL=op://Infra Prod/Database Production/connection_string
API_KEY=op://CI/CD/External API/api_key
AWS_ACCESS_KEY_ID=op://Infra Prod/AWS Credentials/access_key_id""",
            
            "carregar_secrets": [
                "# Injetar secrets no ambiente",
                "op run --env-file=.env.op -- npm start",
                "",
                "# Ou export direto",
                "op run --env-file=.env.op -- env"
            ]
        },
        
        "uso_config_files": {
            "config_template": """# config.yaml.op
database:
  host: op://Infra Prod/Database Production/hostname
  port: op://Infra Prod/Database Production/port
  username: op://Infra Prod/Database Production/username
  password: op://Infra Prod/Database Production/password

api:
  key: op://CI/CD/External API/api_key
  endpoint: https://api.example.com""",
            
            "injetar_secrets": [
                "# Gerar config.yaml com secrets",
                "op inject -i config.yaml.op -o config.yaml",
                "",
                "# Ou usar direto",
                "cat config.yaml.op | op inject | kubectl apply -f -"
            ]
        }
    },
    
    "8_sdks_programaticos": {
        "python": {
            "instalacao": "pip install onepassword-sdk",
            
            "exemplo": """from onepassword import Client, OP_CONNECT_HOST, OP_CONNECT_TOKEN
import os

# Configurar client
client = Client(
    url=os.environ.get('OP_CONNECT_HOST'),
    token=os.environ.get('OP_CONNECT_TOKEN')
)

# Buscar secret
item = client.items.get('Database Production', vault='Infra Prod')
password = item.fields['password'].value

# Listar vaults
vaults = client.vaults.list()
for vault in vaults:
    print(f"Vault: {vault.name}")

# Criar item
new_item = client.items.create(
    vault='CI/CD',
    title='New API Token',
    category='password',
    fields=[
        {'label': 'token', 'value': 'abc123xyz'}
    ]
)"""
        },
        
        "go": {
            "instalacao": "go get github.com/1Password/connect-sdk-go",
            
            "exemplo": """package main

import (
    "context"
    "fmt"
    "os"
    
    "github.com/1Password/connect-sdk-go/connect"
    "github.com/1Password/connect-sdk-go/onepassword"
)

func main() {
    client := connect.NewClient(
        os.Getenv("OP_CONNECT_HOST"),
        os.Getenv("OP_CONNECT_TOKEN"),
    )
    
    // Get item
    item, err := client.GetItem("Database Production", "Infra Prod")
    if err != nil {
        panic(err)
    }
    
    password := item.Fields[0].Value
    fmt.Printf("Password: %s\\n", password)
    
    // List vaults
    vaults, err := client.GetVaults()
    if err != nil {
        panic(err)
    }
    
    for _, vault := range vaults {
        fmt.Printf("Vault: %s\\n", vault.Name)
    }
}"""
        },
        
        "javascript": {
            "instalacao": "npm install @1password/connect",
            
            "exemplo": """import { OnePasswordConnect } from '@1password/connect';

const op = OnePasswordConnect({
  serverURL: process.env.OP_CONNECT_HOST,
  token: process.env.OP_CONNECT_TOKEN,
  keepAlive: true
});

// Get secret
const item = await op.getItem('Database Production', 'Infra Prod');
const password = item.fields.find(f => f.label === 'password').value;

// List vaults
const vaults = await op.listVaults();
vaults.forEach(vault => {
  console.log(`Vault: ${vault.name}`);
});

// Create item
const newItem = await op.createItem('CI/CD', {
  title: 'New API Token',
  category: 'password',
  fields: [
    { label: 'token', value: 'abc123xyz' }
  ]
});"""
        }
    },
    
    "9_best_practices_seguranca": {
        "least_privilege": [
            "✓ 1 token por aplicação/serviço",
            "✓ Acesso apenas aos vaults necessários",
            "✓ Service Accounts em vez de contas pessoais",
            "✓ Revogar tokens não utilizados"
        ],
        
        "rotacao_secrets": [
            "✓ Rotação automática via scripts",
            "✓ Monitorar idade dos secrets",
            "✓ Alertar quando expiração próxima",
            "✓ Documentar procedimentos de emergência"
        ],
        
        "auditoria": [
            "✓ Ativar Events API para logs",
            "✓ Monitorar acesso aos secrets",
            "✓ Alertas para padrões suspeitos",
            "✓ Revisão periódica de permissões"
        ],
        
        "armazenamento_tokens": [
            "✗ NUNCA hardcode tokens em código",
            "✗ NUNCA commit tokens no Git",
            "✓ Armazenar tokens em 1Password",
            "✓ Usar env vars em runtime",
            "✓ Tokens de curta duração para CI/CD"
        ]
    },
    
    "10_troubleshooting": {
        "connect_server_nao_responde": [
            "# Verificar logs",
            "docker logs connect-api",
            "docker logs connect-sync",
            "",
            "# Testar conectividade",
            "curl http://localhost:8080/v1/health",
            "",
            "# Validar credentials",
            "cat 1password-credentials.json | jq"
        ],
        
        "cli_nao_autentica": [
            "# Verificar sessão",
            "op whoami",
            "",
            "# Re-signin",
            "eval $(op signin)",
            "",
            "# Verificar env vars",
            "echo $OP_SERVICE_ACCOUNT_TOKEN",
            "echo $OP_CONNECT_HOST",
            "echo $OP_CONNECT_TOKEN"
        ],
        
        "kubernetes_secrets_nao_sincronizam": [
            "# Verificar Operator logs",
            "kubectl logs -n 1password -l app=connect-operator",
            "",
            "# Verificar OnePasswordItem status",
            "kubectl describe onepassworditem database-credentials -n production",
            "",
            "# Validar itemPath",
            "# Format: vaults/<VAULT_NAME>/items/<ITEM_NAME>"
        ]
    }
}

# Salvar estrutura
with open('1password_automation_complete.json', 'w', encoding='utf-8') as f:
    json.dump(onepassword_automation, f, ensure_ascii=False, indent=2)

# Imprimir sumário
print("=" * 80)
print("ESTRUTURA COMPLETA: AUTOMAÇÃO 1PASSWORD")
print("=" * 80)
print(f"\nTítulo: {onepassword_automation['metadata']['title']}")
print(f"Versão: {onepassword_automation['metadata']['version']}")
print(f"Criado: {onepassword_automation['metadata']['created']}")

print("\n" + "=" * 80)
print("COMPONENTES PRINCIPAIS")
print("=" * 80)
for comp in onepassword_automation['1_overview']['componentes_principais']:
    print(f"  • {comp}")

print("\n" + "=" * 80)
print("CASOS DE USO")
print("=" * 80)
for caso in onepassword_automation['1_overview']['casos_uso']:
    print(f"  • {caso}")

print("\n" + "=" * 80)
print("ESTRUTURA DA AUTOMAÇÃO")
print("=" * 80)
sections = [
    "1. Overview e Arquitetura",
    "2. Setup Connect Server",
    "3. Automação via CLI",
    "4. Integração CI/CD",
    "5. Integração Kubernetes",
    "6. Secret References",
    "7. SDKs Programáticos",
    "8. Best Practices",
    "9. Troubleshooting"
]
for section in sections:
    print(f"  {section}")

print("\n" + "=" * 80)
print("✓ Estrutura completa salva em: 1password_automation_complete.json")
print("=" * 80)
