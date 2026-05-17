# Loose skills

This directory is reserved for standalone Claude Code skills that are not (yet) packaged as plugins. A loose skill is a single folder containing a `SKILL.md` and optional supporting files; it has no `plugin.json` and is not listed in `.claude-plugin/marketplace.json`.

No loose skills live here yet.

## Installing a loose skill manually

When this directory has skills, copy the one you want into `~/.claude/skills/<skill-name>/` (so that `~/.claude/skills/<skill-name>/SKILL.md` exists). Claude Code will discover it automatically.

## Relationship to `plugins/`

When a loose skill matures into something with its own commands, hooks, MCP servers, or just a more deliberate distribution story, promote it: create `plugins/<name>/` with a `.claude-plugin/plugin.json`, move the skill folder under `plugins/<name>/skills/<name>/`, and add an entry to `.claude-plugin/marketplace.json`.
