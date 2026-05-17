# agentic-registry

A curated [Claude Code](https://www.anthropic.com/claude-code) plugin marketplace. Mixes Elliot Kim's own plugins with approved third-party collections, so you can install them together from one place.

## Install the marketplace

```
claude plugin marketplace add elliot-d-kim/agentic-registry
```

Then install any plugin from the table below:

```
claude plugin install <plugin-name>@agentic-registry
```

## Plugins

| Plugin | Source | Author | What it does |
|---|---|---|---|
| `repo-brain` | inline (`./plugins/repo-brain`) | Elliot Kim | Three-pillar documentation architecture (principles/product-requirements/plans) with sidecars and optional essays lane. |
| `mattpocock-skills` | upstream [`mattpocock/skills`](https://github.com/mattpocock/skills) | Matt Pocock | Curated skill collection — TDD, systematic-debugging (`diagnose`), `grill-me`, `grill-with-docs`, `triage`, `to-issues`, `to-prd`, `write-a-skill`, `caveman`, and more. |
| `superpowers` | upstream [`obra/superpowers`](https://github.com/obra/superpowers) | Jesse Vincent | Opinionated development methodology — brainstorming, executing-plans, TDD, systematic-debugging, code-review, verification-before-completion, parallel-agents, and more. |

## Loose skills

`skills/` is reserved for standalone skills that aren't (yet) wrapped in a plugin. None live here yet — see [`skills/README.md`](skills/README.md) for the policy and manual install instructions.

## Curation policy

- **Own plugins** live inline under `plugins/<name>/` and are released from this repo.
- **Third-party plugins** are listed as reference-only entries in `.claude-plugin/marketplace.json` with a GitHub source. Upstream is the source of truth — when you install one, Claude Code pulls directly from the upstream repo, so upstream fixes and updates flow through automatically.
- Inclusion of a third-party plugin means I've used it, vouch for it, and trust the upstream maintainer's release discipline. It does not mean I maintain it.

## Contributing

Open an issue with a proposal — what the plugin is, who maintains it, and why it belongs here. Pull requests welcome for typos, broken links, or metadata corrections.
