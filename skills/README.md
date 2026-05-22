# Loose skills

This directory is reserved for standalone Claude Code skills that are not (yet) packaged as plugins. A loose skill is a single folder containing a `SKILL.md` and optional supporting files; it has no `plugin.json` and is not listed in `.claude-plugin/marketplace.json`.

No loose skills live here yet.

## Installing a loose skill manually

When this directory has skills, copy the one you want into `~/.claude/skills/<skill-name>/` (so that `~/.claude/skills/<skill-name>/SKILL.md` exists). Claude Code will discover it automatically.

## Promoting a loose skill to a plugin

When a loose skill matures into something with its own commands, hooks, MCP servers, or just a more deliberate distribution story, promote it to a standalone plugin repo:

1. Create a new GitHub repo (e.g. `elliot-d-kim/<name>`) with `.claude-plugin/plugin.json` at the root and the skill folder under `skills/<name>/`.
2. Add an entry to this marketplace's `.claude-plugin/marketplace.json` pointing at the new repo as a `github` source.
3. Remove the loose skill from this directory.

This mirrors how `repo-brain` is structured — see [`elliot-d-kim/repo-brain`](https://github.com/elliot-d-kim/repo-brain) for the canonical layout. Hosting plugins in their own repos lets other marketplaces reference them directly without depending on this bundle.
