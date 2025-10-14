#!/bin/bash
set -euo pipefail

echo "### Verificação Pós-Instalação Limpa do macOS ###"

echo -e "\n1. Versão do macOS Instalada:"
# Deve mostrar a versão do macOS recém-instalada, como macOS Sonoma (ou a que foi baixada)
sw_vers

echo -e "\n2. Modelo do Hardware (MacBook Pro M4):"
sysctl -n hw.model

echo -e "\n3. Informações do Disco e Espaço Livre (deve estar quase vazio):"
# O volume de dados deve ter uma grande quantidade de espaço livre, confirmando a limpeza.
df -h /System/Volumes/Data

echo -e "\n4. Lista de Volumes no Sistema (deve haver apenas volumes padrão do macOS):"
diskutil list

echo -e "\n5. Usuários no Sistema (apenas o usuário recém-criado e usuários de sistema):"
dscl . list /Users | grep -v '_'

echo -e "\n6. Listar Aplicativos Instalados (apenas os padrão da Apple):"
# Este comando pode ser um pouco lento.
ls -l /Applications | awk '{print $NF}' | grep -v ':' | grep -v '^$' | grep -v 'total' | sort

echo -e "\n--- Verificação Concluída ---"
echo "Se todos os pontos acima estiverem conforme o esperado (versão correta, disco vazio, poucos usuários, apenas apps padrão), seu macOS foi reinstalado do zero com sucesso."
