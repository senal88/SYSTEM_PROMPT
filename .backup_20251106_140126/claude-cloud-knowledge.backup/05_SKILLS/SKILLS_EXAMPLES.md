# Skills - Exemplos Práticos

## 📚 Exemplos de Estrutura

### Exemplo 1: Skill Simples

```
simple-skill/
└── SKILL.md
```

**SKILL.md**:
```yaml
---
name: git-helper
description: Common Git operations and workflows. Use when user needs Git commands, branching strategies, or repository management.
---

# Git Helper

## Quick Commands

```bash
# Status
git status

# Create branch
git checkout -b feature/new-feature

# Commit
git commit -m "Description"
```
```

---

### Exemplo 2: Skill com Scripts

```
deployment-skill/
├── SKILL.md
└── scripts/
    ├── deploy.sh
    └── validate.sh
```

**SKILL.md**:
```yaml
---
name: deployment-automation
description: Automate deployment processes for applications. Use when deploying, validating infrastructure, or managing releases.
---

# Deployment Automation

## Deploy

Use the deployment script:
```bash
bash scripts/deploy.sh [environment]
```

## Validate

Validate before deploying:
```bash
bash scripts/validate.sh
```
```

---

### Exemplo 3: Skill com Recursos

```
api-integration/
├── SKILL.md
├── REFERENCE.md
├── scripts/
│   └── api-call.py
└── resources/
    ├── schema.json
    └── examples/
        └── request.json
```

**SKILL.md**:
```yaml
---
name: api-integration
description: Integrate with REST APIs, handle authentication, and process responses. Use when working with APIs, webhooks, or external services.
---

# API Integration

## Quick Start

See [REFERENCE.md](REFERENCE.md) for API documentation.

## Make API Call

```bash
python scripts/api-call.py --endpoint /users --method GET
```

## Schema

API schema: [resources/schema.json](resources/schema.json)
```

---

## 🎯 Casos de Uso Comuns

### DevOps Automation

```yaml
---
name: devops-tasks
description: Common DevOps operations including Docker, deployment, monitoring. Use when managing infrastructure, containers, or CI/CD pipelines.
---
```

### Data Processing

```yaml
---
name: data-processing
description: Process and analyze data files (CSV, JSON, Excel). Use when working with datasets, data transformation, or analysis.
---
```

### Documentation

```yaml
---
name: documentation-generator
description: Generate and format documentation from code or specifications. Use when creating docs, README files, or technical documentation.
---
```

---

**Versão:** 1.0.0

