# {{PROJECT_NAME}}

{{PROJECT_DESCRIPTION}}

## 🚀 Início Rápido

### Pré-requisitos
- {{PREREQUISITES}}
- Node.js {{NODE_VERSION}}+
- Python {{PYTHON_VERSION}}+
- Docker {{DOCKER_VERSION}}+

### Instalação

```bash
# Clone o repositório
git clone {{REPO_URL}}
cd {{PROJECT_NAME}}

# Instale as dependências
{{INSTALL_COMMANDS}}

# Configure as variáveis de ambiente
cp .env.example .env
# Edite .env com suas configurações

# Execute o projeto
{{RUN_COMMANDS}}
```

### Secrets (1Password)

```bash
# Preencher .env a partir do cofre 1Password
op inject -i .env.tpl -o .env
```

> Padronize as referências utilizando `~/infra/docker/secrets/default.env.tpl`. Os cofres recomendados são `1p_macos` (local) e `1p_vps` (deploy remoto).

## 📁 Estrutura do Projeto

```
{{PROJECT_NAME}}/
├── src/                    # Código fonte
├── tests/                  # Testes
├── docs/                   # Documentação
├── scripts/                # Scripts utilitários
├── .env.example           # Exemplo de variáveis de ambiente
├── .editorconfig          # Configuração do editor
├── .gitignore             # Arquivos ignorados pelo Git
├── Makefile               # Comandos automatizados
├── README.md              # Este arquivo
└── {{MAIN_FILES}}         # Arquivos principais
```

## 🛠️ Desenvolvimento

### Comandos Disponíveis

```bash
# Instalar dependências
make install

# Executar em modo desenvolvimento
make dev

# Executar testes
make test

# Construir para produção
make build

# Limpar arquivos temporários
make clean

# Verificar código
make lint

# Formatar código
make format
```

### Configuração do Ambiente

1. **Variáveis de Ambiente**: Copie `.env.example` para `.env` e configure as variáveis necessárias
2. **Editor**: Use `.editorconfig` para manter consistência de formatação
3. **Git**: Configure `.gitignore` para ignorar arquivos desnecessários

## 🧪 Testes

```bash
# Executar todos os testes
make test

# Executar testes com cobertura
make test-coverage

# Executar testes em modo watch
make test-watch
```

## 📦 Deploy

### Desenvolvimento
```bash
make dev
```

### Produção
```bash
make build
make start
```

### Docker
```bash
# Construir imagem
docker build -t {{PROJECT_NAME}} .

# Executar container
docker run -p {{PORT}}:{{PORT}} {{PROJECT_NAME}}
```

## 📚 Documentação

- [Guia de Contribuição](docs/CONTRIBUTING.md)
- [API Reference](docs/API.md)
- [Changelog](CHANGELOG.md)

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença {{LICENSE}}. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Autores

- **{{AUTHOR_NAME}}** - *Trabalho inicial* - [{{AUTHOR_GITHUB}}](https://github.com/{{AUTHOR_GITHUB}})

## 🙏 Agradecimentos

- {{ACKNOWLEDGMENTS}}

---

**Última atualização**: {{DATE}}
