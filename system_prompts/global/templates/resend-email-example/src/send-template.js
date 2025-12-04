#!/usr/bin/env node
/**
 * Exemplo de envio de email com template HTML separado
 */

import fs from 'fs/promises';
import path from 'path';
import { Resend } from 'resend';

const apiKey = process.env.RESEND_API_KEY;

if (!apiKey) {
    console.error('❌ RESEND_API_KEY não definida');
    process.exit(1);
}

const resend = new Resend(apiKey);

// Carregar template HTML
async function loadTemplate(templateName, variables = {}) {
    try {
        const templatePath = path.join(process.cwd(), 'templates', `${templateName}.html`);
        let html = await fs.readFile(templatePath, 'utf-8');

        // Substituir variáveis no template
        Object.keys(variables).forEach(key => {
            const regex = new RegExp(`{{${key}}}`, 'g');
            html = html.replace(regex, variables[key]);
        });

        return html;
    } catch (err) {
        console.error(`❌ Erro ao carregar template "${templateName}":`, err.message);
        throw err;
    }
}

// Enviar email usando template
async function sendTemplateEmail(options) {
    const { template, variables, ...emailOptions } = options;

    console.log(`📧 Enviando email com template "${template}"...`);

    const html = await loadTemplate(template, variables);

    const { data, error } = await resend.emails.send({
        ...emailOptions,
        html,
    });

    if (error) {
        console.error('❌ Erro:', error);
        return { success: false, error };
    }

    console.log('✅ Email enviado!');
    console.log(`   ID: ${data.id}`);
    return { success: true, data };
}

// Exemplo de uso
async function main() {
    // Exemplo 1: Email de boas-vindas
    await sendTemplateEmail({
        from: 'Seu App <onboarding@resend.dev>',
        to: ['usuario@exemplo.com'],
        subject: 'Bem-vindo ao nosso app!',
        template: 'welcome',
        variables: {
            name: 'João Silva',
            loginUrl: 'https://app.exemplo.com/login',
            supportEmail: 'suporte@exemplo.com',
        },
    });

    // Exemplo 2: Notificação de sistema
    await sendTemplateEmail({
        from: 'Sistema <alerts@resend.dev>',
        to: ['admin@exemplo.com'],
        subject: '[ALERTA] Backup concluído',
        template: 'notification',
        variables: {
            title: 'Backup Concluído',
            message: 'O backup diário foi concluído com sucesso.',
            timestamp: new Date().toLocaleString('pt-BR'),
            detailsUrl: 'https://admin.exemplo.com/backups',
        },
    });
}

main();

export { loadTemplate, sendTemplateEmail };

