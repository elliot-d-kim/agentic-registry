# agentic-registry

A curated plugin marketplace for agentic coding clients, with manifests for both [Claude Code](https://www.anthropic.com/claude-code) and Codex-compatible plugin consumers. It bundles Elliot Kim's own plugins plus approved third-party collections.

Claude Code can install plugin entries directly from their upstream GitHub repos. Codex consumes a GitHub-backed marketplace by cloning this registry repo and resolving each marketplace entry to a plugin folder inside that checkout.

## Install the marketplace

### Claude Code

```
claude plugin marketplace add elliot-d-kim/agentic-registry
```

Then install any plugin from the table below:

```
claude plugin install <plugin-name>@agentic-registry
```

Claude Code reads the marketplace manifest from [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json).

### Codex plugin consumers

This repo also ships a Codex marketplace manifest at [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json). Register this repository as the Git-backed marketplace:

```
codex plugin marketplace add elliot-d-kim/agentic-registry
```

Codex reads the marketplace from `.agents/plugins/marketplace.json`, then installs bundled plugin folders from `plugins/<plugin-name>/` inside the marketplace checkout.

## Plugins

| Plugin | Source | Author | What it does |
|---|---|---|---|
| `repo-brain` | upstream [`elliot-d-kim/repo-brain`](https://github.com/elliot-d-kim/repo-brain), bundled for Codex in [`plugins/repo-brain`](plugins/repo-brain) | Elliot Kim | Three-pillar documentation architecture (principles/product-requirements/plans) with sidecars and optional essays lane. |
| `codex-cloud-bootstrap` | bundled for Codex in [`plugins/codex-cloud-bootstrap`](plugins/codex-cloud-bootstrap) | Elliot Kim | Sets up cloud-safe repo guidance, setup-script snippets, and optional hooks for Codex Cloud plugin workflows. |
| `mattpocock-skills` | upstream [`mattpocock/skills`](https://github.com/mattpocock/skills) | Matt Pocock | Claude Code marketplace entry for TDD, systematic-debugging (`diagnose`), `grill-me`, `grill-with-docs`, `triage`, `to-issues`, `to-prd`, `write-a-skill`, `caveman`, and more. |

## Codex Cloud

Codex Cloud does not automatically inherit local marketplace installs or desktop plugin state. Use [`codex-cloud-bootstrap`](plugins/codex-cloud-bootstrap) and the notes in [`docs/codex-cloud-bootstrap.md`](docs/codex-cloud-bootstrap.md) to prepare target repos with setup-script bootstrap, `AGENTS.md` fallback guidance, and optional repo-local hooks.

## Loose skills

`skills/` is reserved for standalone skills that are not yet wrapped in a plugin repo. None live here yet; see [`skills/README.md`](skills/README.md) for the policy and manual install instructions.

## Curation policy

- **Claude entries point at upstream repos.** Upstream is the source of truth for Claude-compatible plugin installs.
- **Codex entries are bundled under `plugins/`.** The Codex marketplace is still GitHub-backed: Codex clones this registry repo, then resolves entries to plugin folders in that checkout. Keep bundled copies synced from upstream plugin repos.
- **Own plugins** (authored by Elliot Kim) and **third-party plugins** use the same curation standards. The difference is who maintains the upstream source.
- Inclusion of a third-party plugin means I have used it, vouch for it, and trust the upstream maintainer's release discipline. It does not mean I maintain it.
- Other marketplaces are welcome to reference any upstream plugin directly or mirror bundled Codex plugin folders from this registry.

## Contributing

Open an issue with a proposal: what the plugin is, who maintains it, and why it belongs here. Pull requests welcome for typos, broken links, or metadata corrections.
