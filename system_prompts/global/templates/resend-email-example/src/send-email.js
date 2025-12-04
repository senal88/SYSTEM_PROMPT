#!/usr/bin/env node
/**
 * Exemplo básico de envio de email com Resend
 * Usa variável de ambiente RESEND_API_KEY carregada via 1Password
 */

import { Resend } from 'resend';

// Carregar API key da variável de ambiente
const apiKey = process.env.RESEND_API_KEY;

if (!apiKey) {
    console.error('❌ RESEND_API_KEY não definida');
    console.error('');
    console.error('Configure no 1Password:');
    console.error('  1. Item: "Resend API Key"');
    console.error('  2. Vault: Development');
    console.error('  3. Campo: credential');
    console.error('');
    console.error('Carregue via:');
    console.error('  export RESEND_API_KEY=$(op read "op://Development/Resend API Key/credential")');
    console.error('  # ou');
    console.error('  source ~/Dotfiles/scripts/load_ai_keys.sh');
    process.exit(1);
}

// Inicializar Resend
const resend = new Resend(apiKey);

// Função auxiliar para enviar email
async function sendEmail({ from, to, subject, html, text, replyTo }) {
    try {
        console.log('📧 Enviando email...');
        console.log(`   De: ${from}`);
        console.log(`   Para: ${to.join(', ')}`);
        console.log(`   Assunto: ${subject}`);

        const { data, error } = await resend.emails.send({
            from,
            to,
            subject,
            html,
            text,
            replyTo,
        });

        if (error) {
            console.error('❌ Erro ao enviar email:', error);
            return { success: false, error };
        }

        console.log('✅ Email enviado com sucesso!');
        console.log(`   ID: ${data.id}`);
        return { success: true, data };
    } catch (err) {
        console.error('❌ Exceção ao enviar email:', err.message);
        return { success: false, error: err };
    }
}

// Exemplo de uso
async function main() {
    const result = await sendEmail({
        from: 'Seu App <onboarding@resend.dev>',
        to: ['delivered@resend.dev'],
        subject: 'Teste de Email - Resend + 1Password',
        html: `
      <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto;">
        <h1 style="color: #333;">🎉 Funciona!</h1>
        <p>Este email foi enviado via <strong>Resend API</strong> com integração segura ao <strong>1Password</strong>.</p>
        <p>Configuração:</p>
        <ul>
          <li>API Key gerenciada via 1Password CLI</li>
          <li>Sem hardcode de credenciais</li>
          <li>Totalmente seguro e auditável</li>
        </ul>
        <p style="color: #666; font-size: 12px; margin-top: 30px;">
          Enviado em ${new Date().toLocaleString('pt-BR')}
        </p>
      </div>
    `,
        text: 'Funciona! Email enviado via Resend + 1Password',
        replyTo: 'contato@seudominio.com',
    });

    if (result.success) {
        console.log('\n✨ Processo concluído com sucesso');
    } else {
        console.error('\n⚠️  Processo concluído com erros');
        process.exit(1);
    }
}

// Executar
main();

// Exportar para uso em outros módulos
export { resend, sendEmail };
