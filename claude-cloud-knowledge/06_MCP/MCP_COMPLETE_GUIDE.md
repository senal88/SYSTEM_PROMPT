# Model Context Protocol (MCP) - Guia Completo para Claude

## 📋 Visão Geral

**Model Context Protocol (MCP)** é um protocolo padrão que permite que LLMs como Claude acessem informações e capacidades externas de forma segura e estruturada através de servidores MCP.

---

## 🎯 Conceitos Fundamentais

### O Que é MCP?

MCP é um protocolo que permite:
- **Servers** fornecem capacidades (tools, resources, prompts)
- **Clients** (como Claude) consomem essas capacidades
- **Comunicação** via JSON-RPC sobre STDIO ou HTTP

### Três Tipos de Capacidades

MCP servers podem fornecer três tipos principais de capacidades:

1. **Resources**: Dados tipo arquivo que podem ser lidos por clients (como respostas de API ou conteúdo de arquivos)
2. **Tools**: Funções que podem ser chamadas pelo LLM (com aprovação do usuário)
3. **Prompts**: Templates pré-escritos que ajudam usuários a realizar tarefas específicas

---

## 🏗️ Arquitetura MCP

### Componentes

```
┌─────────────┐
│   Client    │  (Claude, Claude for Desktop, etc.)
│  (LLM)      │
└──────┬──────┘
       │ JSON-RPC
       │ (STDIO ou HTTP)
       ▼
┌─────────────┐
│ MCP Server  │  (Fornece tools, resources, prompts)
│             │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ External    │  (APIs, Databases, Filesystems)
│ Services    │
└─────────────┘
```

### Protocolo de Comunicação

- **Transport**: STDIO (padrão) ou HTTP
- **Protocolo**: JSON-RPC 2.0
- **Formato**: Mensagens JSON estruturadas

---

## 🔧 Como Construir um MCP Server

### Tipos de Transport

#### STDIO (Standard Input/Output)
- **Padrão** para servidores MCP
- Comunicação via stdin/stdout
- **Importante**: Nunca escrever em stdout (apenas stderr)
- Ideal para scripts e processos locais

#### HTTP
- Comunicação via HTTP/HTTPS
- Logging em stdout permitido
- Ideal para serviços web e APIs remotas

---

## 📝 Implementação por Linguagem

### Python (Recomendado para Início)

#### Requisitos
- Python 3.10 ou superior
- MCP SDK 1.2.0 ou superior
- `uv` para gerenciamento de pacotes

#### Estrutura Básica

```python
from mcp.server.fastmcp import FastMCP

# Inicializar servidor
mcp = FastMCP("nome-do-servidor")

# Registrar tool
@mcp.tool()
async def minha_tool(parametro: str) -> str:
    """Descrição do que a tool faz.
    
    Args:
        parametro: Descrição do parâmetro
    """
    # Lógica da tool
    return "resultado"

# Executar servidor
def main():
    mcp.run(transport='stdio')

if __name__ == "__main__":
    main()
```

#### Logging em STDIO

**❌ NUNCA FAÇA:**
```python
print("Mensagem")  # Quebra JSON-RPC!
```

**✅ FAÇA:**
```python
import logging
logging.info("Mensagem")  # Vai para stderr
```

### Node.js/TypeScript

#### Requisitos
- Node.js 16 ou superior
- TypeScript
- `@modelcontextprotocol/sdk`

#### Estrutura Básica

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "nome-do-servidor",
  version: "1.0.0",
  capabilities: {
    tools: {},
  },
});

// Registrar tool
server.tool(
  "minha_tool",
  "Descrição da tool",
  {
    parametro: z.string().describe("Descrição")
  },
  async ({ parametro }) => {
    return {
      content: [{
        type: "text",
        text: "resultado"
      }]
    };
  }
);

// Executar servidor
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Servidor rodando");
}

main();
```

#### Logging em STDIO

**❌ NUNCA FAÇA:**
```javascript
console.log("Mensagem");  // Quebra JSON-RPC!
```

**✅ FAÇA:**
```javascript
console.error("Mensagem");  // stderr é seguro
```

### Java/Kotlin

#### Requisitos
- Java 17 ou superior
- Spring Boot 3.3.x (para Java)
- Kotlin SDK (para Kotlin)

#### Estrutura Básica (Java com Spring AI)

```java
@Service
public class MeuServico {
    
    @Tool(description = "Descrição da tool")
    public String minhaTool(
        @ToolParam(description = "Descrição") String parametro
    ) {
        // Lógica da tool
        return "resultado";
    }
}
```

### C#

#### Requisitos
- .NET 8 SDK ou superior
- `ModelContextProtocol` NuGet package

#### Estrutura Básica

```csharp
using ModelContextProtocol;

var builder = Host.CreateEmptyApplicationBuilder(settings: null);

builder.Services.AddMcpServer()
    .WithStdioServerTransport()
    .WithToolsFromAssembly();

var app = builder.Build();
await app.RunAsync();
```

---

## 🛠️ Exemplo Completo: Weather Server

### Estrutura do Projeto

```
weather-server/
├── weather.py (ou index.ts, etc.)
├── requirements.txt (ou package.json)
└── README.md
```

### Implementação Python Completa

```python
from typing import Any
import httpx
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("weather")

NWS_API_BASE = "https://api.weather.gov"
USER_AGENT = "weather-app/1.0"

async def make_nws_request(url: str) -> dict[str, Any] | None:
    """Fazer requisição à API NWS."""
    headers = {
        "User-Agent": USER_AGENT,
        "Accept": "application/geo+json"
    }
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(url, headers=headers, timeout=30.0)
            response.raise_for_status()
            return response.json()
        except Exception:
            return None

@mcp.tool()
async def get_alerts(state: str) -> str:
    """Obter alertas meteorológicos para um estado dos EUA.
    
    Args:
        state: Código de duas letras do estado (ex: CA, NY)
    """
    url = f"{NWS_API_BASE}/alerts/active/area/{state}"
    data = await make_nws_request(url)
    
    if not data or "features" not in data:
        return "Não foi possível buscar alertas."
    
    if not data["features"]:
        return "Nenhum alerta ativo para este estado."
    
    alerts = []
    for feature in data["features"]:
        props = feature["properties"]
        alert = f"""
Event: {props.get('event', 'Unknown')}
Area: {props.get('areaDesc', 'Unknown')}
Severity: {props.get('severity', 'Unknown')}
Description: {props.get('description', 'No description')}
"""
        alerts.append(alert)
    
    return "\n---\n".join(alerts)

@mcp.tool()
async def get_forecast(latitude: float, longitude: float) -> str:
    """Obter previsão do tempo para uma localização.
    
    Args:
        latitude: Latitude da localização
        longitude: Longitude da localização
    """
    points_url = f"{NWS_API_BASE}/points/{latitude},{longitude}"
    points_data = await make_nws_request(points_url)
    
    if not points_data:
        return "Não foi possível buscar dados para esta localização."
    
    forecast_url = points_data["properties"]["forecast"]
    forecast_data = await make_nws_request(forecast_url)
    
    if not forecast_data:
        return "Não foi possível buscar previsão detalhada."
    
    periods = forecast_data["properties"]["periods"]
    forecasts = []
    
    for period in periods[:5]:
        forecast = f"""
{period['name']}:
Temperature: {period['temperature']}°{period['temperatureUnit']}
Wind: {period['windSpeed']} {period['windDirection']}
Forecast: {period['detailedForecast']}
"""
        forecasts.append(forecast)
    
    return "\n---\n".join(forecasts)

def main():
    mcp.run(transport='stdio')

if __name__ == "__main__":
    main()
```

---

## 🔌 Configuração no Claude for Desktop

### Localização do Arquivo de Configuração

**macOS:**
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Windows:**
```
%AppData%\Claude\claude_desktop_config.json
```

### Estrutura de Configuração

```json
{
  "mcpServers": {
    "weather": {
      "command": "uv",
      "args": [
        "--directory",
        "/ABSOLUTE/PATH/TO/weather",
        "run",
        "weather.py"
      ]
    }
  }
}
```

### Configuração por Linguagem

#### Python (uv)
```json
{
  "mcpServers": {
    "weather": {
      "command": "uv",
      "args": [
        "--directory",
        "/ABSOLUTE/PATH/TO/weather",
        "run",
        "weather.py"
      ]
    }
  }
}
```

#### Node.js
```json
{
  "mcpServers": {
    "weather": {
      "command": "node",
      "args": ["/ABSOLUTE/PATH/TO/weather/build/index.js"]
    }
  }
}
```

#### Java
```json
{
  "mcpServers": {
    "weather": {
      "command": "java",
      "args": [
        "-jar",
        "/ABSOLUTE/PATH/TO/weather.jar"
      ]
    }
  }
}
```

#### C#
```json
{
  "mcpServers": {
    "weather": {
      "command": "dotnet",
      "args": [
        "run",
        "--project",
        "/ABSOLUTE/PATH/TO/PROJECT"
      ]
    }
  }
}
```

---

## ⚠️ Regras Críticas de Logging

### STDIO Servers

**NUNCA escreva em stdout:**
- `print()` em Python
- `console.log()` em JavaScript
- `fmt.Println()` em Go
- Qualquer função que escreva em stdout

**Por quê?** Isso corrompe mensagens JSON-RPC e quebra o servidor.

**✅ Use stderr:**
- `logging` em Python
- `console.error()` em JavaScript
- Logging em arquivos

### HTTP Servers

- Logging em stdout é permitido
- Não interfere com respostas HTTP

---

## 🎯 Best Practices

### Nomenclatura de Tools

Siga o formato especificado na especificação:
- Use snake_case
- Seja descritivo
- Evite abreviações ambíguas

### Tratamento de Erros

```python
@mcp.tool()
async def minha_tool(param: str) -> str:
    try:
        # Lógica
        return resultado
    except SpecificError as e:
        return f"Erro: {str(e)}"
    except Exception as e:
        logging.error(f"Erro inesperado: {e}")
        return "Erro ao processar requisição"
```

### Documentação de Tools

```python
@mcp.tool()
async def minha_tool(
    param1: str,
    param2: int
) -> str:
    """Descrição clara do que a tool faz.
    
    Args:
        param1: Descrição detalhada do parâmetro 1
        param2: Descrição detalhada do parâmetro 2
    
    Returns:
        Descrição do que é retornado
    
    Raises:
        ExceptionType: Quando isso acontece
    """
    # Implementação
```

### Validação de Entrada

```python
from typing import Annotated
from annotated_types import Gt, Lt

@mcp.tool()
async def minha_tool(
    valor: Annotated[float, Gt(0), Lt(100)]
) -> str:
    """Tool com validação de entrada."""
    # valor sempre será entre 0 e 100
```

---

## 🧪 Testando seu Servidor

### Verificar se Servidor está Funcionando

1. **Claude for Desktop**:
   - Procure pelo ícone "Search and tools"
   - Deve mostrar suas tools listadas
   - Teste fazendo uma pergunta que use a tool

2. **Logs**:
   ```bash
   # macOS
   tail -f ~/Library/Logs/Claude/mcp*.log
   ```

### Comandos de Teste

Após configurar no Claude for Desktop:
- "Qual é o tempo em Sacramento?"
- "Quais são os alertas meteorológicos ativos no Texas?"

---

## 🐛 Troubleshooting

### Servidor não aparece no Claude

**Verificar:**
1. Sintaxe do `claude_desktop_config.json`
2. Caminho absoluto (não relativo)
3. Comando e argumentos corretos
4. Reiniciar Claude for Desktop completamente (Cmd+Q, não apenas fechar janela)

### Tool calls falhando silenciosamente

**Verificar:**
1. Logs do Claude (`~/Library/Logs/Claude/`)
2. Servidor compila e executa sem erros
3. Reiniciar Claude for Desktop

### Erros de JSON-RPC

**Causa comum**: Escrevendo em stdout

**Solução**: Usar apenas stderr para logging

### Servidor não inicia

**Verificar:**
1. Dependências instaladas
2. Caminho do executável correto
3. Permissões de execução
4. Ambiente virtual ativado (se Python)

---

## 📚 Recursos e Exemplos

### Repositórios Oficiais

- **Python**: https://github.com/modelcontextprotocol/quickstart-resources/tree/main/weather-server-python
- **TypeScript**: https://github.com/modelcontextprotocol/quickstart-resources/tree/main/weather-server-typescript
- **Java**: https://github.com/spring-projects/spring-ai-examples/tree/main/model-context-protocol/weather
- **Kotlin**: https://github.com/modelcontextprotocol/kotlin-sdk/tree/main/samples/weather-stdio-server
- **C#**: https://github.com/modelcontextprotocol/csharp-sdk/tree/main/samples/QuickstartWeatherServer

### Documentação

- **Especificação MCP**: https://modelcontextprotocol.io/specification
- **SDKs Disponíveis**: Ver documentação oficial
- **Exemplos**: Gallery de servidores MCP oficiais

---

## 🔄 Fluxo de Execução

### Quando o Claude Usa uma Tool

1. **Usuário faz pergunta**: "Qual é o tempo em Sacramento?"
2. **Claude analisa**: Identifica que precisa de previsão do tempo
3. **Claude escolhe tool**: `get_forecast`
4. **Client executa tool**: Via MCP server
5. **Server processa**: Faz requisição à API
6. **Resultado retorna**: Para o Claude
7. **Claude formula resposta**: Em linguagem natural
8. **Resposta exibida**: Para o usuário

---

## 🔐 Segurança

### Considerações Importantes

1. **Validação de entrada**: Sempre valide parâmetros
2. **Rate limiting**: Implemente limites de taxa
3. **Autenticação**: Use tokens/secrets quando necessário
4. **Sanitização**: Limpe dados de entrada
5. **Logging seguro**: Não logue informações sensíveis

### Gerenciamento de Secrets

**✅ Use 1Password:**
```python
from mcp.server.fastmcp import FastMCP
import subprocess

mcp = FastMCP("meu-servidor")

def get_secret(key: str) -> str:
    """Obter secret do 1Password."""
    result = subprocess.run(
        ["op", "item", "get", key, "--field", "password"],
        capture_output=True,
        text=True
    )
    return result.stdout.strip()

@mcp.tool()
async def minha_tool() -> str:
    api_key = get_secret("API Key")
    # Usar api_key
```

---

## 📊 Comparação de Linguagens

| Linguagem | Facilidade | Performance | SDK Mature | Recomendado Para |
|-----------|-----------|-------------|------------|-------------------|
| **Python** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | Início rápido, prototipagem |
| **TypeScript** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Aplicações web, Node.js |
| **Java** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Aplicações enterprise |
| **Kotlin** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | Android, JVM |
| **C#** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | .NET ecosystem |

---

## 🎓 Próximos Passos

### Aprendizado Progressivo

1. **Comece simples**: Tool única com lógica básica
2. **Adicione validação**: Valide entradas
3. **Trate erros**: Implemente tratamento robusto
4. **Adicione resources**: Se necessário
5. **Adicione prompts**: Para templates

### Recursos Avançados

- **Resources**: Dados que podem ser lidos
- **Prompts**: Templates pré-escritos
- **Sampling**: Para recursos grandes
- **Streaming**: Para respostas longas

---

## 📋 Checklist de Implementação

### Setup Inicial
- [ ] Escolher linguagem
- [ ] Instalar SDK MCP
- [ ] Criar estrutura básica do projeto
- [ ] Configurar logging (stderr)

### Desenvolvimento
- [ ] Implementar tool(s)
- [ ] Adicionar validação de entrada
- [ ] Implementar tratamento de erros
- [ ] Documentar tools adequadamente
- [ ] Testar localmente

### Integração
- [ ] Configurar `claude_desktop_config.json`
- [ ] Testar no Claude for Desktop
- [ ] Verificar logs
- [ ] Validar funcionamento

### Produção
- [ ] Revisar segurança
- [ ] Implementar rate limiting
- [ ] Documentar uso
- [ ] Testar com casos reais

---

**Última atualização:** 2025-11-05
**Versão:** 1.0.0
**Baseado em:** Documentação oficial MCP


