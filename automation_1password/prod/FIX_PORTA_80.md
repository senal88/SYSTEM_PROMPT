# 🔧 Fix: Porta 80 já em uso

**Erro:** `Bind for 0.0.0.0:80 failed: port is already allocated`

---

## 🔍 Diagnóstico

A porta 80 está sendo usada por outro serviço. Precisa identificar e resolver.

---

## ✅ Soluções

### Opção 1: Identificar e Parar Serviço Conflitante

```bash
# Na VPS
# Verificar o que está usando a porta 80
sudo lsof -i :80
# ou
sudo netstat -tlnp | grep :80

# Se for outro container Traefik ou nginx
docker ps | grep -E 'traefik|nginx'
docker stop <container-id>

# Ou se for serviço do sistema
sudo systemctl stop nginx  # ou apache2
```

### Opção 2: Usar Porta Alternativa (Temporário)

Se não puder parar o serviço na porta 80, usar porta alternativa:

**Editar docker-compose.traefik.yml:**
```yaml
traefik:
  ports:
    - "8080:80"    # Mudar para 8080
    - "8443:443"  # Mudar para 8443
```

**Limitação:** Cloudflare precisa da porta 80 para validação SSL.

### Opção 3: Parar Serviço Conflitante e Usar Traefik (Recomendado)

**Se for outro Traefik:**
```bash
# Parar Traefik antigo
docker ps | grep traefik
docker stop <container-id>
docker rm <container-id>

# Iniciar novo Traefik
cd ~/automation_1password/prod
docker compose -f docker-compose.traefik.yml up -d
```

**Se for nginx:**
```bash
# Parar nginx
sudo systemctl stop nginx
sudo systemctl disable nginx  # Desabilitar auto-start

# Iniciar Traefik
docker compose -f docker-compose.traefik.yml up -d
```

---

## 🔍 Comandos de Diagnóstico

```bash
# Ver processos usando porta 80
sudo lsof -i :80

# Ver containers Docker rodando
docker ps -a

# Ver serviços systemd
sudo systemctl list-units --type=service | grep -E 'nginx|apache|http'

# Ver porta 80 especificamente
sudo ss -tlnp | grep :80
```

---

## ✅ Próximos Passos Após Resolver

1. ✅ Parar serviço conflitante
2. ✅ Iniciar Traefik: `docker compose -f docker-compose.traefik.yml up -d`
3. ✅ Verificar status: `docker compose -f docker-compose.traefik.yml ps`
4. ✅ Ver logs: `docker compose -f docker-compose.traefik.yml logs traefik`

---

## ⚠️ Importante

**Traefik PRECISA da porta 80** para:
- Validação ACME (Let's Encrypt)
- Redirecionamento HTTP → HTTPS
- Funcionamento correto com Cloudflare

**Não use porta alternativa** a menos que seja temporário.

---

**Execute os comandos de diagnóstico acima para identificar o conflito!**

