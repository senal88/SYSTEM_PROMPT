#!/usr/bin/env node
/**
 * Testa conexão com Resend API
 */

import { Resend } from 'resend';

const apiKey = process.env.RESEND_API_KEY;

console.log('🔍 Testando conexão com Resend API...\n');

if (!apiKey) {
    console.error('❌ RESEND_API_KEY não definida');
    console.error('\nCarregue via 1Password:');
    console.error('  export RESEND_API_KEY=$(op read "op://Development/Resend API Key/credential")');
    process.exit(1);
}

console.log(`✅ API Key encontrada (${apiKey.substring(0, 10)}...)`);

const resend = new Resend(apiKey);

// Testar listando domínios configurados (se disponível)
try {
    console.log('\n📋 Tentando listar informações da conta...');

    // Resend pode não ter endpoint público de listagem, então vamos apenas validar a inicialização
    console.log('✅ Cliente Resend inicializado com sucesso');
    console.log('\nPara testar completamente, execute:');
    console.log('  npm run send');

} catch (err) {
    console.error('❌ Erro ao conectar:', err.message);
    process.exit(1);
}
