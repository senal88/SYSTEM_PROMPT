import markdown

# Conteúdo CSS e HTML base
html_template = '''
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documentação 1Password</title>
    <style>
        body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; line-height: 1.6; margin: 0; padding: 20px; background-color: #f4f4f4; color: #333; }}
        .container {{ max-width: 900px; margin: auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        h1, h2, h3, h4, h5, h6 {{ color: #0056b3; margin-top: 1.5em; margin-bottom: 0.5em; }}
        a {{ color: #007bff; text-decoration: none; }} a:hover {{ text-decoration: underline; }}
        pre, code {{ background-color: #e9e9e9; padding: 2px 4px; border-radius: 4px; font-family: 'SF Mono', 'Consolas', 'Monaco', monospace; }}
        pre {{ padding: 10px; overflow-x: auto; }}
        table {{ width: 100%; border-collapse: collapse; margin-bottom: 1em; }} th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }} th {{ background-color: #f2f2f2; }}
        blockquote {{ border-left: 4px solid #ccc; margin-left: 0; padding-left: 1em; color: #666; }}
        .mermaid {{ text-align: center; margin: 20px 0; }}
    </style>
</head>
<body>
    <div class="container">
        {html_content}
    </div>
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.0/dist/mermaid.min.js"></script>
    <script>mermaid.initialize({{ startOnLoad: true }});</script>
</body>
</html>
'''

# Ler o conteúdo Markdown
with open('documentacao_completa_1password.md', 'r') as f:
    md_content = f.read()

# Converter Markdown para HTML, incluindo extensões para tabelas, código e mermaid
html_body = markdown.markdown(md_content, extensions=['fenced_code', 'tables', 'attr_list', 'pymdownx.extra', 'pymdownx.superfences', 'pymdownx.highlight', 'pymdownx.tasklist'])

# Inserir o HTML gerado no template
final_html = html_template.format(html_content=html_body)

# Escrever o HTML final no arquivo index.html
with open('index.html', 'w') as f_html:
    f_html.write(final_html)

print("documentacao_completa_1password.md convertida para index.html com sucesso!")

