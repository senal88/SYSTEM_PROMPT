# 📧 Resend Email - Exemplo de Integração

Exemplo completo de integração com [Resend](https://resend.com) usando 1Password para gerenciamento seguro de API keys.

## 🔐 Configuração Segura (1Password)

### 1. Criar Item no 1Password

```bash
# Via CLI
op item create \
  --category="API Credential" \
  --title="Resend API Key" \
  --vault="Development" \
  --tags="api-key,resend,email" \
  credential="re_xxxxxxxxxxxxxxxxxxxxxxxxxx"

# Ou via interface gráfica do 1Password
```

**Campos:**

- **Tipo:** API Credential
- **Nome:** Resend API Key
- **Vault:** Development
- **Campo credential:** sua chave da Resend (obtida em <https://resend.com/api-keys>)
- **Tags:** `api-key`, `resend`, `email`

### 2. Carregar API Key

**Opção A: Via script load_ai_keys.sh (recomendado)**

Adicione ao script `~/Dotfiles/scripts/load_ai_keys.sh`:

```bash
# RESEND
RESEND_KEY=$(op read "op://Development/Resend API Key/credential" 2>/dev/null || echo "")
if [ -n "$RESEND_KEY" ]; then
  export RESEND_API_KEY="$RESEND_KEY"
  ok "RESEND_API_KEY carregada"
else
  warn "RESEND_API_KEY não encontrada (opcional)"
fi
```

Depois:

```bash
source ~/Dotfiles/scripts/load_ai_keys.sh
```

**Opção B: Manualmente**

```bash
export RESEND_API_KEY=$(op read "op://Development/Resend API Key/credential")
echo $RESEND_API_KEY | grep -q "re_" && echo "✅ Carregada" || echo "❌ Erro"
```

## 📦 Instalação

```bash
# Navegar para o diretório
cd ~/Dotfiles/system_prompts/global/templates/resend-email-example

# Instalar dependências
npm install

# Copiar configuração de exemplo (opcional para dev local)
cp .env.example .env.local
# Editar .env.local e adicionar sua chave (NÃO commitar!)
```

## 🚀 Uso

### Teste de Conexão

```bash
npm run test
```

### Envio Simples

```bash
npm run send
```

**Código:**

```javascript
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

await resend.emails.send({
  from: 'Seu App <onboarding@resend.dev>',
  to: ['usuario@exemplo.com'],
  subject: 'Hello World',
  html: '<p>Funciona!</p>',
});
```

### Envio com Template

```bash
npm run send:template
```

Templates localizados em `templates/*.html` com variáveis `{{variavel}}`:

```javascript
await sendTemplateEmail({
  from: 'App <onboarding@resend.dev>',
  to: ['usuario@exemplo.com'],
  subject: 'Bem-vindo!',
  template: 'welcome',
  variables: {
    name: 'João Silva',
    loginUrl: 'https://app.com/login',
    supportEmail: 'suporte@app.com',
  },
});
```

## 📁 Estrutura

```
resend-email-example/
├── package.json
├── .env.example          # Exemplo de configuração
├── .gitignore
├── README.md
├── src/
│   ├── send-email.js     # Exemplo básico
│   ├── send-template.js  # Exemplo com templates
│   └── test-connection.js # Teste de conexão
└── templates/
    ├── welcome.html      # Template de boas-vindas
    └── notification.html # Template de notificação
```

## 🎨 Templates Disponíveis

### `welcome.html` - Boas-vindas

Variáveis:

- `{{name}}` - Nome do usuário
- `{{loginUrl}}` - URL de login
- `{{supportEmail}}` - Email de suporte

### `notification.html` - Notificação de Sistema

Variáveis:

- `{{title}}` - Título da notificação
- `{{message}}` - Mensagem principal
- `{{timestamp}}` - Data/hora
- `{{detailsUrl}}` - URL para detalhes

## 🔧 Uso Programático

```javascript
import { sendEmail } from './src/send-email.js';

const result = await sendEmail({
  from: 'App <onboarding@resend.dev>',
  to: ['usuario@exemplo.com'],
  subject: 'Assunto do Email',
  html: '<h1>HTML aqui</h1>',
  text: 'Versão texto alternativa',
  replyTo: 'contato@app.com',
});

if (result.success) {
  console.log('Email enviado! ID:', result.data.id);
} else {
  console.error('Erro:', result.error);
}
```

## 🛡️ Segurança

### ✅ O que fazer

- Usar 1Password CLI para gerenciar a API key
- Carregar via variável de ambiente `RESEND_API_KEY`
- Adicionar `.env` e `.env.local` ao `.gitignore`
- Usar referências `op://` na documentação

### ❌ O que NÃO fazer

- Hardcode da API key no código
- Commit de arquivos `.env` com valores reais
- Expor a key em logs ou console
- Compartilhar a key em texto plano

## 📚 Recursos Adicionais

- [Documentação Resend](https://resend.com/docs)
- [API Reference](https://resend.com/docs/api-reference)
- [1Password CLI](https://developer.1password.com/docs/cli)
- [Resend Dashboard](https://resend.com/emails)

## 🐛 Troubleshooting

### "RESEND_API_KEY não definida"

```bash
# Verificar se 1Password está autenticado
op account list

# Re-autenticar
eval $(op signin)

# Verificar se o item existe
op item get "Resend API Key"

# Testar leitura
op read "op://Development/Resend API Key/credential"
```

### Email não chega

1. Verificar domínio verificado no [Resend Dashboard](https://resend.com/domains)
2. Checar logs no dashboard
3. Verificar spam/lixeira
4. Confirmar formato do email `from` (deve ser `Name <email@domain.com>`)

### Rate Limits

Resend tem limites de envio:

- Conta gratuita: limitado
- Veja limites em: <https://resend.com/pricing>

## 📄 Licença

MIT
