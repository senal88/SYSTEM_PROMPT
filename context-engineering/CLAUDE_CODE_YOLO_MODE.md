# Claude Code - Yolo Mode e Segurança

## 🎯 O que é Yolo Mode?

**Yolo Mode** é um modo operacional do Claude Code onde todas as solicitações de ferramentas são **aprovadas automaticamente** sem intervenção manual do usuário.

### Características do Yolo Mode

- ✅ **Auto-aprovação**: Todas as tool requests são executadas automaticamente
- ⚡ **Produtividade**: Permite fluxo de trabalho contínuo sem interrupções
- ⚠️ **Segurança**: Requer atenção aos comandos executados

## 🔐 Considerações de Segurança

### ⚠️ Importante: Segurança em Yolo Mode

Como o Yolo Mode aprova automaticamente todas as solicitações de ferramentas:

1. **Sempre revise** o código antes de executar
2. **Use apenas com código confiável**
3. **Esteja ciente** dos riscos de prompt injection
4. **Monitore** as ferramentas sendo usadas

### Notas de Segurança do Claude Code

> Claude can make mistakes
>
> You should always review Claude's responses, especially when running code.
>
> Due to prompt injection risks, only use it with code you trust
>
> For more details see: https://docs.claude.com/s/claude-code-security

## 🚀 Uso Recomendado

### Quando usar Yolo Mode

- ✅ Desenvolvimento local com código próprio
- ✅ Scripts e automações confiáveis
- ✅ Ambientes isolados/testes
- ✅ Trabalho rápido e iterativo

### Quando NÃO usar Yolo Mode

- ❌ Código de fontes desconhecidas
- ❌ Ambientes de produção críticos
- ❌ Executando comandos destrutivos
- ❌ Trabalhando com dados sensíveis

## 📝 Configuração

### Verificar Status Atual

O Yolo Mode é ativado automaticamente quando você aceita os avisos de segurança durante o primeiro uso do Claude Code.

### Desativar Yolo Mode (se necessário)

Para desativar o modo automático e revisar cada solicitação:

1. Reinicie o Claude Code
2. Quando solicitado, escolha revisar cada tool request
3. Ou configure manualmente nas preferências

## 🔧 Integração com Projeto

### Script de Login com Yolo Mode

O script `claude-code-login.sh` configura a API key automaticamente:

```bash
# Login rápido
./scripts/claude-code-login.sh

# Iniciar Claude Code
claude
```

### Variável de Ambiente

```bash
# API key já configurada pelo script
echo $ANTHROPIC_API_KEY | head -c 20

# Verificar status
claude doctor
```

## 📊 Status Atual

- ✅ **Claude Code**: v2.0.33 instalado e funcionando
- ✅ **Yolo Mode**: Ativo (auto-aprovação habilitada)
- ✅ **ANTHROPIC_API_KEY**: Configurada via 1Password
- ✅ **Autenticação**: Funcionando

## 🎯 Fluxo de Trabalho Recomendado

### Com Yolo Mode Ativo

1. **Revisar código gerado** antes de executar
2. **Validar comandos** especialmente destrutivos
3. **Monitorar execução** de ferramentas
4. **Usar ambientes isolados** quando possível

### Boas Práticas

```bash
# 1. Revisar antes de executar
claude "crie um script para fazer backup"

# 2. Validar código gerado
# (Claude Code mostrará o código antes de executar)

# 3. Executar apenas se confiável
# (Yolo Mode executará automaticamente após aprovação)
```

## 🛡️ Segurança e Best Practices

### Checklist de Segurança

Antes de executar código no Yolo Mode:

- [ ] Código é de fonte confiável?
- [ ] Comandos não são destrutivos?
- [ ] Ambiente é isolado/teste?
- [ ] Dados sensíveis protegidos?
- [ ] Revisou o código gerado?

### Comandos Perigosos

⚠️ **Cuidado com estes comandos**:

- `rm -rf`
- `format`
- `delete`
- `drop`
- Modificações em arquivos críticos
- Alterações de sistema

### Ambientes Seguros

Use Yolo Mode preferencialmente em:

- Containers Docker isolados
- Ambientes de desenvolvimento
- Máquinas virtuais
- Branches de teste

## 📚 Referências

- [Claude Code Security Guide](https://docs.claude.com/s/claude-code-security)
- [Prompt Injection Risks](https://docs.claude.com/s/claude-code-security#prompt-injection)
- [Tool Use Documentation](https://docs.claude.com/en/docs/tool-use)

## ✅ Status de Configuração

- ✅ Claude Code instalado (v2.0.33)
- ✅ Yolo Mode ativo
- ✅ ANTHROPIC_API_KEY configurada
- ✅ Autenticação funcionando
- ✅ Pronto para uso

---

**Última atualização**: 2025-01-15
**Versão Claude Code**: 2.0.33
**Status**: ✅ Operacional com Yolo Mode ativo
