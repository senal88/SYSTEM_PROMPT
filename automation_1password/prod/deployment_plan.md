# Plano de Implantação: macOS DEV → VPS PROD

**VPS:** 147.79.81.59 (senamfo.com.br)  
**Sistema:** Ubuntu 22.04 LTS  
**Data:** $(date '+%Y-%m-%d')

---

## Fase 1: Preparação (1-2 horas)

- [x] Coletar dados de DEV (scripts executados)
- [x] Analisar inventory
- [ ] Preparar 1Password sincronização
- [ ] Criar docker-compose.yml para PROD
- [ ] Validar todas as dependências

## Fase 2: Configuração VPS (1-2 horas)

- [ ] SSH na VPS
- [ ] Instalar Docker + Docker Compose
- [ ] Instalar 1Password CLI
- [ ] Configurar firewall
- [ ] Clonar repositório Git

## Fase 3: Sincronização Credenciais (30 min)

- [ ] Exportar 1p_macos (se necessário)
- [ ] Criar/validar 1p_vps cofre
- [ ] Sincronizar secrets essenciais
- [ ] Testar acesso 1Password CLI na VPS

## Fase 4: Deploy Stacks (2-3 horas)

- [ ] Docker pull images
- [ ] docker-compose up (staging)
- [ ] Health checks
- [ ] Database migrations (se necessário)
- [ ] Testes E2E básicos

## Fase 5: Go-Live (30 min)

- [ ] Validar serviços
- [ ] Setup SSL/TLS (se necessário)
- [ ] Verificar logs
- [ ] Rollback procedure pronta

## Tempo Total Estimado: 5-8 horas
## Risk Level: MEDIUM

---

## Checklist de Segurança

- [ ] Nenhuma credencial hardcoded
- [ ] Todos os secrets no 1Password
- [ ] .env files no .gitignore
- [ ] Firewall configurado
- [ ] Backup procedure documentada

