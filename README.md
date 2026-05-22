# agentic-registry

A curated [Claude Code](https://www.anthropic.com/claude-code) plugin marketplace. A convenient bundle that points at standalone plugin repos — Elliot Kim's own plus approved third-party collections — so you can install them together from one place.

Every plugin lives in its own repo. This marketplace doesn't host plugin code; it just references upstream sources. That means any other marketplace can pick and choose individual plugins from this list and bundle them however they like.

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
| `repo-brain` | upstream [`elliot-d-kim/repo-brain`](https://github.com/elliot-d-kim/repo-brain) | Elliot Kim | Three-pillar documentation architecture (principles/product-requirements/plans) with sidecars and optional essays lane. |
| `mattpocock-skills` | upstream [`mattpocock/skills`](https://github.com/mattpocock/skills) | Matt Pocock | Curated skill collection — TDD, systematic-debugging (`diagnose`), `grill-me`, `grill-with-docs`, `triage`, `to-issues`, `to-prd`, `write-a-skill`, `caveman`, and more. |

## Loose skills

`skills/` is reserved for standalone skills that aren't (yet) wrapped in a plugin repo. None live here yet — see [`skills/README.md`](skills/README.md) for the policy and manual install instructions.

## Curation policy

- **Every plugin lives in its own repo** and is referenced from `.claude-plugin/marketplace.json` as a `github` source. Upstream is always the source of truth — when you install one, Claude Code pulls directly from the upstream repo, so fixes and updates flow through automatically.
- **Own plugins** (authored by Elliot Kim) and **third-party plugins** use the same reference-by-upstream model. The only difference is who maintains them.
- Inclusion of a third-party plugin means I've used it, vouch for it, and trust the upstream maintainer's release discipline. It does not mean I maintain it.
- Other marketplaces are welcome to reference any of these upstream repos directly — the per-repo layout is the point.

## Contributing

Open an issue with a proposal — what the plugin is, who maintains it, and why it belongs here. Pull requests welcome for typos, broken links, or metadata corrections.
