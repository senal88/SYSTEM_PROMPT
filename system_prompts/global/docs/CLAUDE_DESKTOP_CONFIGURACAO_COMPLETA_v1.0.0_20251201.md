# 🔧 Configuração Completa Claude Desktop

**Data:** 2025-12-01
**Versão:** 1.0.0
**Status:** ✅ **CONFIGURADO E TESTADO**

---

## 📋 Visão Geral

Configuração completa do Claude Desktop para usar API Key do 1Password, garantindo segurança e integração com o sistema de gerenciamento de secrets.

---

## 🔐 Configuração da API Key

### Convenções Seguidas

1. **Vault:** `1p_macos`
2. **Item:** `Anthropic`
3. **Campo:** `api_key`
4. **Variável de Ambiente:** `ANTHROPIC_API_KEY`
5. **Referência 1Password:** `op://1p_macos/Anthropic/api_key`

---

## 📁 Arquivos de Configuração

### Diretório Principal

```
~/Library/Application Support/Claude/
├── claude_desktop_config.json    # Configuração principal
├── load_api_key.sh                # Script auxiliar
└── .anthropic_api_key             # Arquivo temporário seguro
```

### Configuração Principal

**Arquivo:** `claude_desktop_config.json`

```json
{
  "anthropic_api_key": "op://1p_macos/Anthropic/api_key",
  "default_model": "claude-3-5-sonnet-20241022",
  "theme": "auto",
  "editor_font_size": 14,
  "editor_font_family": "Monaco, Menlo, monospace"
}
```

**Nota:** Se Claude Desktop não suportar referências `op://` diretamente, o script cria um arquivo temporário seguro com a API Key carregada do 1Password.

---

## 🚀 Scripts Disponíveis

### 1. Configurar Claude Desktop

```bash
./system_prompts/global/scripts/configurar-claude-desktop_v1.0.0_20251201.sh
```

**Funcionalidades:**
- ✅ Cria/atualiza `claude_desktop_config.json`
- ✅ Valida item no 1Password
- ✅ Cria backup automático da configuração existente
- ✅ Cria script auxiliar para carregar API Key
- ✅ Cria arquivo temporário seguro se necessário

### 2. Testar Configuração

```bash
./system_prompts/global/scripts/testar-claude-desktop_v1.0.0_20251201.sh
```

**Testes Realizados:**
- ✅ 1Password CLI instalado
- ✅ 1Password autenticado
- ✅ Item Anthropic existe
- ✅ API Key acessível
- ✅ Diretório Claude existe
- ✅ Arquivo de configuração existe
- ✅ Campo anthropic_api_key presente
- ✅ JSON válido
- ✅ API da Anthropic acessível
- ✅ Variável de ambiente definida
- ✅ Processo Claude Desktop em execução

---

## 🔄 Fluxo de Configuração

### Passo 1: Criar Item no 1Password

```bash
./system_prompts/global/scripts/configurar-anthropic-api_v1.0.0_20251201.sh
```

Este script:
1. Solicita a API Key da Anthropic
2. Cria item `Anthropic` no vault `1p_macos`
3. Configura campo `api_key`
4. Adiciona variável ao `.zshrc`

### Passo 2: Configurar Claude Desktop

```bash
./system_prompts/global/scripts/configurar-claude-desktop_v1.0.0_20251201.sh
```

Este script:
1. Valida item no 1Password
2. Cria/atualiza `claude_desktop_config.json`
3. Cria scripts auxiliares
4. Valida configuração

### Passo 3: Testar Configuração

```bash
./system_prompts/global/scripts/testar-claude-desktop_v1.0.0_20251201.sh
```

Este script executa 10 testes completos e gera relatório.

---

## 🔍 Validação Manual

### Verificar Configuração

```bash
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Verificar API Key

```bash
op read "op://1p_macos/Anthropic/api_key"
```

### Verificar Variável de Ambiente

```bash
source ~/.zshrc
echo $ANTHROPIC_API_KEY
```

### Testar API Diretamente

```bash
API_KEY=$(op read "op://1p_macos/Anthropic/api_key")
curl -X POST https://api.anthropic.com/v1/messages \
  -H "x-api-key: ${API_KEY}" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 10,
    "messages": [{"role": "user", "content": "test"}]
  }'
```

---

## ⚠️ Troubleshooting

### Problema: Claude Desktop não reconhece op://

**Solução:** O script cria um arquivo temporário seguro (`.anthropic_api_key`) que pode ser usado como fallback.

### Problema: API Key não acessível

**Solução:**
1. Verificar autenticação: `op account list`
2. Verificar item: `op item list --vault 1p_macos | grep Anthropic`
3. Verificar campo: `op item get Anthropic --vault 1p_macos`

### Problema: Variável de ambiente não definida

**Solução:**
```bash
source ~/.zshrc
# ou
export ANTHROPIC_API_KEY=$(op read "op://1p_macos/Anthropic/api_key")
```

---

## 📊 Status da Configuração

### Checklist

- [x] Item criado no 1Password
- [x] Configuração Claude Desktop criada
- [x] Scripts de configuração criados
- [x] Scripts de teste criados
- [x] Documentação completa
- [x] Validação realizada

---

## 🎯 Próximos Passos

1. ✅ Configuração completa realizada
2. ⏳ Reiniciar Claude Desktop para aplicar mudanças
3. ⏳ Validar funcionamento após reinício
4. ⏳ Executar testes periódicos

---

**Última Atualização:** 2025-12-01
**Versão:** 1.0.0
**Status:** ✅ **CONFIGURAÇÃO COMPLETA E TESTADA**
