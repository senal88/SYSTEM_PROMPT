# Cursor IDE Settings

This directory centralizes Cursor-specific configuration that you may want to version control alongside this workspace. The Cursor desktop app (built on top of VS Code) stores user-level settings in `~/Library/Application Support/Cursor/User/`.

## Recommended workflow

1. Identify the settings files you want to track (for example `settings.json`, `keybindings.json`, or custom snippets).
2. Copy them *or* create symbolic links into this folder so that each file has a clear purpose and can be referenced by the team.
3. Keep sensitive or machine-specific values out of version control. A good pattern is to check in `.example` variants that document the available knobs.

```bash
mkdir -p "$(pwd)/config/cursor"
ln -s "$HOME/Library/Application Support/Cursor/User/settings.json" "$(pwd)/config/cursor/global-settings.json"
```

> **Tip:** Cursor and VS Code share many configuration keys. Document the intent of non-obvious settings so collaborators understand why they exist.
