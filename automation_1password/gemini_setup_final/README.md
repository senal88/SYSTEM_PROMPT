# Guia Definitivo: Setup de Autenticação Gemini

Este pacote automatiza a configuração de permissões do Google Cloud para usar o Gemini (VS Code, Cursor, CLI) no projeto `gcp-ai-setup-24410`.

## Como Usar

Siga as instruções para seu ambiente.

---

### Ambiente 1: macOS / Desktop (Conta de Usuário)

1.  **Autentique-se no Google Cloud:**
    ```bash
    gcloud auth login
    ```

2.  **Execute o Script de Configuração:**
    ```bash
    cd scripts
    chmod +x *.sh
    ./setup_auth.sh
    ```

---

### Ambiente 2: VPS Ubuntu (Conta de Serviço)

1.  **Posicione a Chave:**
    -   Faça o download da sua chave de conta de serviço (`gemini-vps-agent@...`).
    -   Mova o arquivo JSON para a pasta `config/` e renomeie-o para `gcp-service-account.json`.

2.  **Autentique-se com a Chave:**
    ```bash
    gcloud auth activate-service-account --key-file=config/gcp-service-account.json
    ```

3.  **Execute o Script de Configuração:**
    ```bash
    cd scripts
    chmod +x *.sh
    ./setup_auth.sh
    ```

---

### Verificando a Configuração (Opcional)

Após o setup, execute o script de verificação para confirmar que tudo está correto.

```bash
./verify_config.sh
```
