# Scripts de Instalação e Configuração do Gemini CLI

Este diretório contém scripts automatizados para instalação, configuração e validação do Gemini CLI integrado com 1Password.

## 📁 Arquivos

- **`install-gemini-cli.sh`**: Instala e configura o Gemini CLI
- **`validate-gemini-cli.sh`**: Valida instalação e configuração
- **`README.md`**: Este arquivo

## 🚀 Uso Rápido

### Instalação Completa

```bash
cd scripts/gemini-cli
chmod +x *.sh
./install-gemini-cli.sh
```

### Validação

```bash
./validate-gemini-cli.sh
```

## 📋 Pré-requisitos

Antes de executar os scripts, certifique-se de que:

1. ✅ Node.js 18+ está instalado
2. ✅ npm está instalado
3. ✅ 1Password CLI está instalado e autenticado
4. ✅ Item `gemini` existe no vault `shared_infra` com campo `api_key`

## 🔍 Verificações dos Scripts

### `install-gemini-cli.sh`

- Verifica pré-requisitos (Node.js, npm, 1Password CLI)
- Instala o Gemini CLI globalmente
- Configura autenticação usando 1Password
- Cria arquivo de configuração básico
- Adiciona variáveis de ambiente ao `~/.zshrc`

### `validate-gemini-cli.sh`

- Verifica instalação do Gemini CLI
- Valida configuração da API key
- Testa autenticação
- Verifica diretório de configuração
- Lista ferramentas disponíveis
- Testa comandos básicos

## 📚 Documentação Completa

Para documentação detalhada, consulte:

- [Documentação Completa](../../docs/gemini-cli/README.md)
- [Documentação Oficial do Gemini CLI](https://github.com/google-gemini/gemini-cli)

## 🔒 Segurança

Os scripts seguem as melhores práticas de segurança:

- ✅ Nunca expõem secrets em logs
- ✅ Usam 1Password para gerenciar API keys
- ✅ Validam permissões antes de executar
- ✅ Tratam erros adequadamente com `set -euo pipefail`

## 🐛 Troubleshooting

### Erro: "1Password CLI não está autenticado"

```bash
op signin --account <seu-apelido>
```

### Erro: "API key não encontrada no 1Password"

Certifique-se de que o item existe:

```bash
op item get gemini --vault=shared_infra
```

### Erro: "Node.js 18+ é necessário"

```bash
# macOS
brew install node

# Ou atualizar versão existente
brew upgrade node
```

## 📝 Notas

- Os scripts são compatíveis com macOS Silicon (M1/M2/M3)
- Suporte para Linux pode requerer ajustes menores
- Os scripts salvam logs com timestamps para debugging
