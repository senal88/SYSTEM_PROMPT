# Configuração do Projeto Google AI

Os arquivos deste diretório descrevem como configurar credenciais do Google Cloud e do Google AI para desenvolvimento local. **Não** faça commit de segredos brutos ou JSON de contas de serviço neste repositório; prefira variáveis de ambiente ou um cofre privado de credenciais.

## Variáveis de ambiente

Crie um arquivo `.env` na raiz do repositório (ou exporte as variáveis no seu perfil de shell) com os valores necessários para suas ferramentas. Nunca comite esse arquivo em VCS.

### Exemplo (.env) — NÃO coloque segredos reais aqui

```bash
# ID do projeto no GCP
GCP_PROJECT_ID=your-gcp-project-id
# Região padrão para recursos
GCP_REGION=us-central1
# Chave/Token para Google AI Studio ou outra API (substitua por seu segredo no ambiente)
AI_STUDIO_API_KEY=your-api-key
# Caminho para o arquivo JSON do OAuth client (opcional)
OAUTH_CLIENT_SECRET_PATH=$HOME/Dotfiles/credentials/oauth_client_secret.json
# Caminho para o JSON da conta de serviço (opcional)
SERVICE_ACCOUNT_CREDENTIALS_PATH=$HOME/Dotfiles/credentials/service_account.json
```

Carregue essas variáveis na sua aplicação com uma biblioteca como `dotenv` (Node.js) ou `python-dotenv` (Python), ou garanta que o shell as exporte antes de executar comandos. Exemplos rápidos:

- Node.js (instale dotenv: `npm install dotenv`) no seu arquivo de entrada:

```javascript
require('dotenv').config();
console.log(process.env.GCP_PROJECT_ID);
```

- Python (instale python-dotenv: `pip install python-dotenv`) em `app.py`:

```python
from dotenv import load_dotenv
import os

load_dotenv()
print(os.getenv('GCP_PROJECT_ID'))
```

## Modelos de configuração

- `google-ai.config.example.json` documenta a estrutura esperada para quem prefere um arquivo de configuração em JSON. Copie-o para `google-ai.config.json`, preencha os valores e mantenha o arquivo real fora do controle de versão.

## Permissões de arquivos

Garanta que os arquivos de credenciais sejam legíveis apenas por você. No macOS e Linux, use:

```bash
chmod 600 "$HOME/Dotfiles/credentials/oauth_client_secret.json"
chmod 600 "$HOME/Dotfiles/credentials/service_account.json"
```

Se os arquivos estiverem em um caminho diferente (por exemplo `/HOME/luiz.sena88/...`), atualize para o caminho correto do macOS (`/Users/luiz.sena88/...`) ou para o local onde você os armazenou.

Dica: adicione o `.env` e qualquer arquivo de credencial sensível ao `.gitignore` do repositório para evitar commits acidentais. Exemplo mínimo de `.gitignore`:

```gitignore
# Credenciais
.env
**/credentials/*.json
```

Para uso temporário no terminal (sem escrever no `.env`), exporte as variáveis no shell:

```bash
export AI_STUDIO_API_KEY="your-api-key"
export GCP_PROJECT_ID="your-gcp-project-id"
```

Essas variáveis permanecerão apenas na sessão atual do terminal.
