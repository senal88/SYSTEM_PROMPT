# Workspace Overview

This repository centralizes personal tooling, automation, and reference material for working with AI-assisted editors and agents. It complements the Cursor IDE setup and related experiments that live under the `awesome-cursorrules`, `claude-task-master`, and `system-prompts-and-models-of-ai-tools` directories.

## Quick start

1. Copy `.env.example` to `.env` and fill in secrets for Google Cloud:
   ```bash
   cp .env.example .env
   ```
2. Populate `config/google-ai/google-ai.config.json` using the example file provided here, or keep the values in environment variables if you prefer.
3. Optionally link your Cursor desktop settings into `config/cursor/` so they can be versioned alongside the rest of the workspace.

## Helpful scripts

- `scripts/collect_sys_info.sh` gathers macOS version, architecture, PATH, and common tool versions. Redirect the output to a file whenever you need to capture the current environment state for debugging or onboarding:
  ```bash
  ./scripts/collect_sys_info.sh > sys-info.txt
  ```

## Directory highlights

- `awesome-cursorrules` — curated rules and assets for tailoring Cursor.
- `claude-task-master` — task management utilities and MCP servers focused on Anthropic's Claude.
- `system-prompts-and-models-of-ai-tools` — prompt libraries and configuration notes covering a broad range of AI code assistants.
- `config/` — workspace-specific configuration stubs. Keep real secrets outside version control.
- `docs/` — additional documentation, including an extended directory map.

See `docs/directory-overview.md` for a deeper look at the structure and recommended practices.

## Permissions

Ensure the workspace directory remains executable so shell scripts can run correctly:

```bash
chmod 755 /Users/luiz.sena88/Projetos/cursor
```

If you prefer to restrict access to your account only, tighten it to:

```bash
chmod 700 /Users/luiz.sena88/Projetos/cursor
```

Remember to mark any shell scripts as executable (`chmod +x path/to/script.sh`) after creation.
