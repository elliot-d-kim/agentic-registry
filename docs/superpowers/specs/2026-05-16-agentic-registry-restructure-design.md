# agentic-registry restructure — design

**Date:** 2026-05-16
**Status:** Approved
**Author:** Elliot Kim (with Claude Code)

## Context

The local directory was renamed from `repo-brain` to `agentic-registry`. The repo today is shaped as a single-plugin marketplace: `repo-brain` lives at the repo root as both the marketplace owner and its sole plugin. The user wants to flip it into a **marketplace-of-many** — a curated home for their own plugins plus reference entries to approved third-party plugins.

### Current state

```
repo-brain/                       (local dir already renamed to agentic-registry)
├── .claude-plugin/
│   ├── marketplace.json          # marketplace points at a single plugin: repo-brain
│   └── plugin.json               # the repo-brain plugin manifest
├── skills/
│   └── repo-brain/
│       ├── SKILL.md
│       └── references/
├── README.md
└── bash.exe.stackdump            # crash dump cruft
```

Current marketplace.json points the `repo-brain` plugin at `elliot-d-kim/repo-brain` (the external GitHub repo URL). After restructure, the plugin will be housed *inside* this marketplace repo at `plugins/repo-brain/`.

### Why this matters

A real marketplace needs:
- A directory dedicated to first-party plugins (`plugins/`).
- A directory for loose skills not yet packaged as plugins (`skills/`).
- A marketplace manifest that mixes inline plugin sources with external GitHub references.
- A landing page (README) that orients visitors to the registry as a whole, not a single plugin.

## Goals

- Rename and restructure the repo so it functions as a Claude Code plugin marketplace.
- Move `repo-brain` from being the repo itself into being one entry under `plugins/`.
- Add reference entries for two approved third-party plugins: `mattpocock-skills` and `superpowers`.
- Reserve a top-level `skills/` directory for future loose skills.
- Keep the marketplace installable via `claude plugin marketplace add elliot-d-kim/agentic-registry`.

## Non-goals

- Adding any new first-party plugins beyond the existing `repo-brain`.
- Seeding any loose skills into `skills/` — it ships empty with a README.
- Vendoring or mirroring third-party plugin code locally.
- Renaming the GitHub remote (`elliot-d-kim/repo-brain` → `elliot-d-kim/agentic-registry`) or archiving the old repo — handled by the user out-of-band.
- Updating the local git remote URL after the GitHub rename — handled by the user.

## Target layout

```
agentic-registry/
├── .claude-plugin/
│   └── marketplace.json          # the marketplace manifest (own + 3rd-party entries)
├── plugins/
│   └── repo-brain/
│       ├── .claude-plugin/
│       │   └── plugin.json       # moved from repo root
│       ├── skills/
│       │   └── repo-brain/
│       │       ├── SKILL.md
│       │       └── references/
│       └── README.md             # short plugin-level README (optional, may defer)
├── skills/
│   └── README.md                 # explains purpose; dir is otherwise empty
├── README.md                     # rewritten as marketplace landing page
└── docs/                         # this spec + future docs
```

## Design

### Marketplace manifest

`.claude-plugin/marketplace.json` becomes the central registry. Per the Claude Code marketplace schema ([docs](https://code.claude.com/docs/en/plugin-marketplaces#plugin-sources)):

- Plugins housed inline use a relative-path **string** source: `"source": "./plugins/<name>"`. The path must start with `./` and is resolved relative to the marketplace root.
- Plugins fetched from an external GitHub repo use an **object** source where the inner `source` discriminator is `"github"`. The full shape is `"source": { "source": "github", "repo": "owner/name" }`. (The nested `source` key is canonical, not a typo — it acts as a discriminator across source types: `github`, `url`, `git-subdir`, `npm`.)
- The plugin entry's `version` field is optional. For git-based sources (`github`, `url`, relative paths inside a git-hosted marketplace), omitting `version` means each new upstream commit counts as a new version — exactly the behavior we want for reference-only third-party entries, since users auto-pick up upstream changes.
- **Do not set `version` in both `plugin.json` and the marketplace entry.** The `plugin.json` value silently wins. For `repo-brain`, version stays in its `plugin.json` (where it already lives) and is omitted from the marketplace entry.

```json
{
  "$schema": "https://json.schemastore.org/claude-code-marketplace.json",
  "name": "agentic-registry",
  "description": "Elliot Kim's curated marketplace of Claude Code plugins — own work plus approved third-party collections.",
  "owner": { "name": "Elliot Kim" },
  "plugins": [
    {
      "name": "repo-brain",
      "description": "Three-pillar documentation architecture (principles/product-requirements/plans) with sidecars and optional essays lane.",
      "source": "./plugins/repo-brain",
      "author": { "name": "Elliot Kim" },
      "category": "workflow",
      "tags": ["documentation", "architecture", "planning", "decisions", "roadmap", "essays"]
    },
    {
      "name": "mattpocock-skills",
      "description": "Matt Pocock's curated skill collection — TDD, systematic-debugging (diagnose), grill-me, grill-with-docs, triage, to-issues, to-prd, write-a-skill, caveman, and more. Approved 3rd-party; source of truth is upstream mattpocock/skills.",
      "source": { "source": "github", "repo": "mattpocock/skills" },
      "author": { "name": "Matt Pocock" },
      "category": "engineering",
      "tags": ["tdd", "debugging", "engineering", "productivity", "skills"]
    },
    {
      "name": "superpowers",
      "description": "Jesse Vincent's opinionated development methodology — brainstorming, executing-plans, TDD, systematic-debugging, code-review, verification-before-completion, parallel-agents, and more. Approved 3rd-party; source of truth is upstream obra/superpowers.",
      "source": { "source": "github", "repo": "obra/superpowers" },
      "author": { "name": "Jesse Vincent" },
      "category": "workflow",
      "tags": ["methodology", "workflow", "tdd", "debugging", "agents"]
    }
  ]
}
```

### `plugins/repo-brain/`

The existing plugin moves wholesale:

- `.claude-plugin/plugin.json` → `plugins/repo-brain/.claude-plugin/plugin.json` (contents unchanged; already contains `name`, `version: "1.1.0"`, `description`, `author` — all still correct after the move because the plugin manifest doesn't encode its own filesystem location).
- `skills/repo-brain/` → `plugins/repo-brain/skills/repo-brain/` (contents unchanged; `git mv` preserves history).

The plugin's internal layout (SKILL.md and references) is unchanged. The marketplace manifest's `source: ./plugins/repo-brain` is resolved by Claude Code relative to the marketplace.json, so the plugin loads exactly as before from the consumer's perspective.

### `skills/`

Top-level directory reserved for loose (non-packaged) skills. Ships empty with `skills/README.md` that:

- States the dir's purpose ("standalone skills not yet packaged as plugins").
- Notes that consumers can install by copying a skill folder into `~/.claude/skills/`.
- Acknowledges no skills live here yet.

### Root README

Rewritten as the marketplace landing page. Sections:

- **What this is** — one paragraph: a curated Claude Code plugin marketplace.
- **Install** — `claude plugin marketplace add elliot-d-kim/agentic-registry`, then `claude plugin install <plugin-name>`.
- **Plugins** — table listing each plugin, source (inline/upstream), author, what it does.
- **Loose skills** — pointer to `skills/` and how to install one manually.
- **Curation policy** — one paragraph: own plugins reflect the author's work; third-party plugins are approved selections with their upstream as source of truth; updates to third-party metadata happen here, but upstream changes flow through automatically when consumers install.
- **Contributing** — light touch: open an issue to propose additions.

### Cleanup

- Delete `bash.exe.stackdump` (Windows crash dump cruft; already shown in `git status` as untracked).

## Mechanical migration steps

1. Create `plugins/repo-brain/.claude-plugin/` directory.
2. `git mv .claude-plugin/plugin.json plugins/repo-brain/.claude-plugin/plugin.json`.
3. `git mv skills/repo-brain plugins/repo-brain/skills/repo-brain`.
4. Overwrite `.claude-plugin/marketplace.json` with the new manifest.
5. Add `skills/README.md`.
6. Rewrite root `README.md`.
7. Delete `bash.exe.stackdump`.
8. Commit (single commit or split — TBD at plan time).

## Decisions and rationale

- **`.claude-plugin/` singular** (not `.claude-plugins/`) — matches the official Claude Code marketplace spec; required for `claude plugin marketplace add` to work.
- **Marketplace name = repo name** (`agentic-registry`) — keeps the install command memorable: `claude plugin marketplace add elliot-d-kim/agentic-registry`.
- **`repo-brain` source = relative path** (`./plugins/repo-brain`) — Claude Code resolves it relative to the manifest, so no extra GitHub round-trip and no risk of repo-brain's source URL drifting from where it actually lives.
- **Third-party plugins reference-only** — upstream is the source of truth; we avoid the maintenance burden of mirroring code and the drift risk that comes with vendoring.
- **`skills/` ships empty with a README** — establishes the dir as first-class layout without requiring content today; lower friction than gating it behind the first contribution.
- **Plugins vs skills boundary** — `plugins/` holds packaged plugins with their own `.claude-plugin/plugin.json`; `skills/` holds standalone skill folders (SKILL.md only) that aren't wrapped in a plugin. A skill that grows into a plugin gets promoted out of `skills/` into `plugins/<name>/skills/<name>/`.

## Open questions

- Should `plugins/repo-brain/README.md` be created now or deferred? Current spec marks it optional. Recommendation: defer — the SKILL.md is already self-documenting.
- Will the user rename the GitHub remote before or after this restructure lands? If after, the marketplace will still install (GitHub auto-redirects), but the install command in the README should already use `elliot-d-kim/agentic-registry`.

## Validation

After the migration, run `claude plugin validate .` from the repo root. This is the official Claude Code marketplace validator — it catches JSON syntax errors, missing required fields, duplicate plugin names, and `..` in source paths. The plan should include this as the success check.

## Risk and mitigation

- **Risk:** `git mv` of `.claude-plugin/plugin.json` could be misread as a rename when the file content is the same but the directory it lives in semantically changed. **Mitigation:** the marketplace.json change in the same commit makes the intent clear from the diff.
- **Risk:** Anyone with the old marketplace already installed (`elliot-d-kim/repo-brain`) won't auto-migrate to the new one. **Mitigation:** out-of-scope for this work; user will handle the announce/migration message separately.
