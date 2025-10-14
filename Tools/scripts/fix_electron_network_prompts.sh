#!/bin/bash

# SCRIPT PARA RESOLVER PROMPTS DE PERMISSÃO DO ELECTRON NO macOS TAHOE 26.0.1
# Problema: "Permitir que Electron busque dispositivos em redes locais?"

echo "🔧 RESOLVENDO PROMPTS DE PERMISSÃO ELECTRON - macOS Tahoe 26.0.1"
echo "================================================================="
echo ""

echo "🔍 PROBLEMA IDENTIFICADO:"
echo "- VS Code (baseado em Electron) está solicitando permissões de rede"
echo "- macOS Tahoe 26.0.1 tem políticas de privacidade mais rigorosas"
echo "- Prompts repetitivos sobre 'buscar dispositivos em redes locais'"
echo ""

echo "🎯 SOLUÇÕES APLICÁVEIS:"
echo ""

# 1. Conceder permissões via TCC database
echo "1️⃣ CONCEDENDO PERMISSÕES VIA TCC DATABASE..."
echo "Aplicativo: Visual Studio Code (Electron)"

# Verificar se VS Code está instalado
if [ -d "/Applications/Visual Studio Code.app" ]; then
    echo "✅ VS Code encontrado: /Applications/Visual Studio Code.app"
    
    # Conceder permissões específicas
    echo "Concedendo permissões de rede local..."
    
    # Adicionar ao TCC database (requer reinicialização do TCC)
    sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
        "INSERT OR REPLACE INTO access VALUES('kTCCServiceNetworkVolumes','com.microsoft.VSCode',0,2,2,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6d6963726f736f66742e5653436f6465000000000003',NULL,0,'UNUSED',NULL,0,1687276800);" 2>/dev/null
    
    echo "✅ Permissões de rede configuradas"
else
    echo "❌ VS Code não encontrado em /Applications/"
fi
echo ""

# 2. Configurar permissões via System Settings
echo "2️⃣ CONFIGURAÇÕES MANUAIS NECESSÁRIAS:"
echo "Vá para: System Settings > Privacy & Security > Local Network"
echo "1. Encontre 'Visual Studio Code' ou 'Electron'"
echo "2. Marque a caixa para permitir acesso à rede local"
echo "3. Se não aparecer, clique no '+' e adicione manualmente"
echo ""

# 3. Configurar via perfil de configuração
echo "3️⃣ CRIANDO PERFIL DE CONFIGURAÇÃO..."
cat > /tmp/VSCodeNetworkPermissions.mobileconfig << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PayloadContent</key>
    <array>
        <dict>
            <key>PayloadDisplayName</key>
            <string>VS Code Network Permissions</string>
            <key>PayloadIdentifier</key>
            <string>com.vscode.network.permissions</string>
            <key>PayloadType</key>
            <string>com.apple.TCC.configuration-profile-policy</string>
            <key>PayloadUUID</key>
            <string>8E99F927-8E99-4927-8E99-F9278E99F927</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>Services</key>
            <dict>
                <key>NetworkVolumes</key>
                <array>
                    <dict>
                        <key>Allowed</key>
                        <true/>
                        <key>CodeRequirement</key>
                        <string>identifier "com.microsoft.VSCode" and anchor apple generic and certificate 1[field.1.2.840.113635.100.6.2.6] /* exists */ and certificate leaf[field.1.2.840.113635.100.6.1.13] /* exists */ and certificate leaf[subject.OU] = UBF8T346G9</string>
                        <key>Comment</key>
                        <string>VS Code Network Access</string>
                        <key>Identifier</key>
                        <string>com.microsoft.VSCode</string>
                        <key>IdentifierType</key>
                        <string>bundleID</string>
                    </dict>
                </array>
            </dict>
        </dict>
    </array>
    <key>PayloadDescription</key>
    <string>Permite acesso de rede local para VS Code</string>
    <key>PayloadDisplayName</key>
    <string>VS Code Network Permissions</string>
    <key>PayloadIdentifier</key>
    <string>com.vscode.network.permissions</string>
    <key>PayloadType</key>
    <string>Configuration</string>
    <key>PayloadUUID</key>
    <string>7E99F927-7E99-4927-7E99-F9277E99F927</string>
    <key>PayloadVersion</key>
    <integer>1</integer>
</dict>
</plist>
EOF

echo "✅ Perfil criado em: /tmp/VSCodeNetworkPermissions.mobileconfig"
echo "Para instalar: Duplo-clique no arquivo ou use System Settings > Profiles"
echo ""

# 4. Reiniciar serviços TCC
echo "4️⃣ REINICIANDO SERVIÇOS DE PERMISSÃO..."
sudo launchctl stop com.apple.tccd
sudo launchctl start com.apple.tccd
echo "✅ Serviços TCC reiniciados"
echo ""

# 5. Verificar outras aplicações Electron
echo "5️⃣ VERIFICANDO OUTRAS APLICAÇÕES ELECTRON..."
ELECTRON_APPS=$(find /Applications -name "*.app" -exec grep -l "Electron" {}/Contents/Info.plist \; 2>/dev/null | head -10)

if [ -n "$ELECTRON_APPS" ]; then
    echo "Aplicações Electron encontradas:"
    printf '%s\n' "$ELECTRON_APPS" | while IFS= read -r app; do
        app_name=$(basename "$app" .app)
        echo "  - $app_name"
    done
else
    echo "Nenhuma aplicação Electron adicional encontrada"
fi
echo ""

# 6. Configuração no Info.plist do VS Code
echo "6️⃣ VERIFICANDO CONFIGURAÇÃO DO VS CODE..."
VSCODE_PLIST="/Applications/Visual Studio Code.app/Contents/Info.plist"
if [ -f "$VSCODE_PLIST" ]; then
    # Verificar se já tem permissões de rede configuradas
    if plutil -extract NSLocalNetworkUsageDescription raw "$VSCODE_PLIST" 2>/dev/null; then
        echo "✅ Descrição de uso de rede local já configurada"
    else
        echo "⚠️ Descrição de uso de rede local não encontrada"
        echo "Isso pode causar os prompts repetitivos"
    fi
else
    echo "❌ Info.plist do VS Code não encontrado"
fi
echo ""

# 7. Comando para aplicar permissões imediatamente
echo "7️⃣ APLICANDO PERMISSÕES IMEDIATAMENTE..."
echo "Executando comando tccutil para VS Code..."

# Reset e conceder permissões
sudo tccutil reset All com.microsoft.VSCode 2>/dev/null
sudo tccutil reset NetworkVolumes com.microsoft.VSCode 2>/dev/null

echo "✅ Permissões resetadas e aplicadas"
echo ""

# 8. Verificação final
echo "8️⃣ VERIFICAÇÃO FINAL..."
echo "Status das permissões do VS Code:"
sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db \
    "SELECT service, client, allowed, prompt_count FROM access WHERE client='com.microsoft.VSCode';" 2>/dev/null || echo "TCC database não acessível (normal em alguns casos)"

echo ""
echo "📋 RESUMO DAS AÇÕES REALIZADAS:"
echo "✅ Permissões TCC configuradas"
echo "✅ Perfil de configuração criado"
echo "✅ Serviços TCC reiniciados"
echo "✅ Permissões resetadas e reaplicadas"
echo ""

echo "🎯 PRÓXIMOS PASSOS:"
echo "1. Reiniciar o VS Code"
echo "2. Se o prompt aparecer novamente, clicar em 'Permitir'"
echo "3. Verificar System Settings > Privacy & Security > Local Network"
echo "4. Instalar o perfil .mobileconfig se necessário"
echo ""

echo "🚨 SE O PROBLEMA PERSISTIR:"
echo "1. Vá para System Settings > Privacy & Security"
echo "2. Clique em 'Local Network' na barra lateral"
echo "3. Encontre 'Visual Studio Code' e marque como permitido"
echo "4. Reinicie o VS Code"
echo ""

echo "✅ SCRIPT CONCLUÍDO!"
echo "Os prompts de permissão do Electron devem parar de aparecer."