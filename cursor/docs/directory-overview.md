# Directory Overview

| Path | Purpose | Notes |
| ---- | ------- | ----- |
| `awesome-cursorrules/` | Cursor-specific rules, assets, and contribution guidelines. | Review subfolders `rules/` and `rules-new/` for the latest conventions. |
| `claude-task-master/` | Anthropic Claude tooling, MCP servers, tests, and documentation. | Run `npm install` inside this folder before executing scripts or tests. |
| `system-prompts-and-models-of-ai-tools/` | Prompt libraries and agent configurations for multiple AI assistants. | Organize prompts by vendor or workflow to speed up discovery. |
| `config/cursor/` | Workspace-level Cursor or VS Code settings under version control. | Symlink individual files from `~/Library/Application Support/Cursor/User/` as needed. |
| `config/google-ai/` | Templates documenting how to provide Google AI credentials. | Keep the real JSON or `.env` files out of git. |
| `scripts/` | Automation scripts for system introspection and setup tasks. | Add execute permissions (`chmod +x`) to any new scripts. |
| `docs/` | Supplemental documentation for the workspace. | Extend with onboarding guides or troubleshooting notes. |

## Recommended improvements

- Add per-project `README.md` files when creating new folders so collaborators understand the intent quickly.
- Favor relative paths inside scripts to maintain portability across machines.
- When introducing new credentials, document how to rotate or revoke them alongside the usage instructions.
- Consider wrapping common setup steps inside a `bootstrap.sh` script that can be audited and re-run safely.
