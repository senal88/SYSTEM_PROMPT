#!/bin/bash

# VERIFICAÇÃO DE PERMISSÕES ELECTRON PÓS-CONFIGURAÇÃO
# Verifica se os prompts de "buscar dispositivos em redes locais" foram resolvidos

echo "🔍 VERIFICAÇÃO DE PERMISSÕES ELECTRON - macOS Tahoe 26.0.1"
echo "=========================================================="
echo ""

# 1. Verificar se o VS Code está rodando
echo "1️⃣ STATUS DO VS CODE:"
if pgrep -f "Visual Studio Code" > /dev/null; then
    echo "✅ VS Code está em execução"
    echo "PID: $(pgrep -f "Visual Studio Code")"
else
    echo "❌ VS Code não está rodando"
    echo "Recomendação: Inicie o VS Code para testar as permissões"
fi
echo ""

# 2. Verificar logs TCC recentes
echo "2️⃣ LOGS TCC RECENTES (últimos 10 minutos):"
echo "Buscando por prompts de permissão do VS Code/Electron..."
recent_logs=$(sudo log show --predicate 'subsystem == "com.apple.TCC"' --last 10m | grep -i -E "(vscode|electron|network|local)" | tail -5)

if [ -n "$recent_logs" ]; then
    echo "Logs encontrados:"
    echo "$recent_logs"
else
    echo "✅ Nenhum log de permissão recente encontrado (bom sinal!)"
fi
echo ""

# 3. Verificar configurações de rede local no System Settings
echo "3️⃣ STATUS DE PERMISSÕES DE REDE LOCAL:"
echo "Verificando se VS Code tem permissões de rede local..."

# Verificar através do tccutil
if vscode_network_status=$(sudo tccutil status NetworkVolumes com.microsoft.VSCode 2>/dev/null); then
    echo "Status TCC: $vscode_network_status"
else
    echo "⚠️ Não foi possível verificar via tccutil (pode ser normal)"
fi

# Verificar através de sqlite (se acessível)
tcc_entry=$(sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
    "SELECT service, allowed, prompt_count FROM access WHERE client='com.microsoft.VSCode' AND service LIKE '%Network%';" 2>/dev/null)

if [ -n "$tcc_entry" ]; then
    echo "Entrada TCC encontrada: $tcc_entry"
else
    echo "ℹ️ Nenhuma entrada TCC específica de rede encontrada"
fi
echo ""

# 4. Verificar perfil de configuração
echo "4️⃣ PERFIL DE CONFIGURAÇÃO:"
if [ -f "/tmp/VSCodeNetworkPermissions.mobileconfig" ]; then
    echo "✅ Perfil de configuração disponível em: /tmp/VSCodeNetworkPermissions.mobileconfig"
    echo "Tamanho: $(wc -c < /tmp/VSCodeNetworkPermissions.mobileconfig) bytes"
else
    echo "❌ Perfil de configuração não encontrado"
fi
echo ""

# 5. Verificar processos Electron ativos
echo "5️⃣ PROCESSOS ELECTRON ATIVOS:"
electron_processes=$(pgrep -fl electron || true)
if [ -n "$electron_processes" ]; then
    echo "Processos Electron encontrados:"
    printf '%s\n' "$electron_processes" | head -5
else
    echo "ℹ️ Nenhum processo Electron adicional encontrado"
fi
echo ""

# 6. Testar conectividade de rede local
echo "6️⃣ TESTE DE CONECTIVIDADE DE REDE LOCAL:"
echo "Testando descoberta de dispositivos na rede local..."

# Verificar interface de rede principal
primary_interface=$(route get default 2>/dev/null | awk '/interface:/{print $2; exit}')
if [ -n "$primary_interface" ]; then
    echo "Interface principal: $primary_interface"
    
    # Obter subnet da rede local
    local_ip=$(ifconfig "$primary_interface" | awk '/inet /{print $2; exit}')
    if [ -n "$local_ip" ]; then
        echo "IP local: $local_ip"
        
        # Teste básico de descoberta de rede
        echo "Testando descoberta de rede (ping broadcast)..."
        broadcast_ip="${local_ip%.*}.255"
        if ping -c 1 -t 1 "$broadcast_ip" >/dev/null 2>&1; then
            echo "✅ Rede local acessível"
        else
            echo "ℹ️ Broadcast não respondeu (normal em algumas redes)"
        fi
    fi
else
    echo "⚠️ Não foi possível determinar a interface de rede principal"
fi
echo ""

# 7. Instruções para teste manual
echo "7️⃣ TESTE MANUAL RECOMENDADO:"
echo "Para confirmar que os prompts pararam:"
echo "1. Feche completamente o VS Code (Cmd+Q)"
echo "2. Abra o VS Code novamente"
echo "3. Abra um projeto com extensões que usam rede (como Git, Live Server)"
echo "4. Se NÃO aparecer o prompt 'Permitir que Electron busque dispositivos...', está resolvido!"
echo ""

# 8. Comandos de emergência se o problema persistir
echo "8️⃣ COMANDOS DE EMERGÊNCIA (se o problema persistir):"
echo ""
echo "Resetar TODAS as permissões do VS Code:"
echo "sudo tccutil reset All com.microsoft.VSCode"
echo ""
echo "Conceder permissão manualmente:"
echo "sudo tccutil grant NetworkVolumes com.microsoft.VSCode"
echo ""
echo "Verificar System Settings:"
echo "open 'x-apple.systempreferences:com.apple.preference.security?Privacy_LocalNetwork'"
echo ""

# 9. Status final
echo "9️⃣ STATUS FINAL DA VERIFICAÇÃO:"
current_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "Verificação executada em: $current_time"

if pgrep -f "Visual Studio Code" > /dev/null; then
    if [ -z "$recent_logs" ]; then
        echo "🎉 RESULTADO: Provavelmente RESOLVIDO!"
        echo "   - VS Code rodando: ✅"
        echo "   - Sem logs de permissão recentes: ✅"
    else
        echo "⚠️ RESULTADO: Pode ainda ter prompts"
        echo "   - VS Code rodando: ✅"
        echo "   - Logs de permissão encontrados: ⚠️"
    fi
else
    echo "ℹ️ RESULTADO: Inicie o VS Code para testar"
    echo "   - VS Code não está rodando"
fi
echo ""

echo "✅ VERIFICAÇÃO CONCLUÍDA!"
echo "Se ainda aparecerem prompts, execute os comandos de emergência acima."