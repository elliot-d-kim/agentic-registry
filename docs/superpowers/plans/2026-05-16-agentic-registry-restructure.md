# agentic-registry Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure the repo (currently shaped as a single-plugin marketplace) into a marketplace-of-many: move the existing `repo-brain` plugin into `plugins/repo-brain/`, rewrite the marketplace manifest to also reference two approved third-party plugins (`mattpocock-skills`, `superpowers`), reserve `skills/` for future loose skills, and rewrite the root README as a marketplace landing page.

**Architecture:** A Claude Code marketplace is a git repo containing `.claude-plugin/marketplace.json` at its root. That manifest lists plugin entries; each entry's `source` is either a relative path (`./plugins/<name>` for inline plugins) or an object like `{ "source": "github", "repo": "owner/name" }` for external plugins fetched from GitHub. After this restructure, the repo holds its own `repo-brain` plugin under `plugins/repo-brain/` (with its own `.claude-plugin/plugin.json`) and *references* the two third-party plugins by GitHub source — no upstream code is copied locally.

**Tech Stack:** JSON (marketplace and plugin manifests), Markdown (README + skill docs), git, Claude Code CLI (`claude plugin validate`).

**Spec:** `docs/superpowers/specs/2026-05-16-agentic-registry-restructure-design.md`

---

## File Map

**Created:**
- `plugins/repo-brain/.claude-plugin/plugin.json` — moved from repo root via `git mv`; contents unchanged
- `plugins/repo-brain/skills/repo-brain/` — moved from `skills/repo-brain/` via `git mv`; contents unchanged
- `skills/README.md` — explains the reserved-for-loose-skills purpose; one short paragraph

**Modified:**
- `.claude-plugin/marketplace.json` — overwritten with the new marketplace manifest (3 plugin entries: repo-brain inline + 2 GitHub references)
- `README.md` — rewritten as a marketplace landing page

**Deleted:**
- `bash.exe.stackdump` — Windows crash dump cruft; untracked, just `rm`

**Untouched (verified during the moves):**
- `plugins/repo-brain/.claude-plugin/plugin.json` content (still `{ name: "repo-brain", version: "1.1.0", description, author }`)
- `plugins/repo-brain/skills/repo-brain/SKILL.md` and `references/` content

---

## Task 1: Pre-flight verification

**Files:** none

- [ ] **Step 1: Verify you're on the right branch and the tree is clean**

Run:
```
git status
git rev-parse --abbrev-ref HEAD
```

Expected: branch `master` (or a feature branch you've cut for this work). The tree should show only the untracked `bash.exe.stackdump` and any in-progress plan files. If you see other uncommitted changes, stop and resolve them first — the moves in later tasks should be the only diff.

- [ ] **Step 2: Confirm current layout matches the spec's "current state"**

Run:
```
ls -la
ls .claude-plugin/
ls skills/
```

Expected:
- Root contains `.claude-plugin/`, `skills/`, `README.md`, `docs/`, `bash.exe.stackdump`.
- `.claude-plugin/` contains `marketplace.json` and `plugin.json`.
- `skills/` contains `repo-brain/`.

If the layout differs, stop and reconcile against the spec before proceeding — the `git mv` commands assume this starting state.

- [ ] **Step 3: Read the spec end-to-end**

Open `docs/superpowers/specs/2026-05-16-agentic-registry-restructure-design.md` and read it through. Every later task in this plan refers back to decisions made there; if anything in the plan surprises you, the spec is the source of truth.

---

## Task 2: Create `plugins/repo-brain/` and move the plugin manifest

**Files:**
- Create dir: `plugins/repo-brain/.claude-plugin/`
- Move: `.claude-plugin/plugin.json` → `plugins/repo-brain/.claude-plugin/plugin.json`

- [ ] **Step 1: Create the target directories**

Run:
```
mkdir -p plugins/repo-brain/.claude-plugin
```

Expected: no output; the directories now exist.

- [ ] **Step 2: Move the plugin manifest with git mv (preserves history)**

Run:
```
git mv .claude-plugin/plugin.json plugins/repo-brain/.claude-plugin/plugin.json
```

Expected: no output; `git status` now shows `renamed: .claude-plugin/plugin.json -> plugins/repo-brain/.claude-plugin/plugin.json`.

- [ ] **Step 3: Verify content is unchanged**

Run:
```
git diff --cached -- plugins/repo-brain/.claude-plugin/plugin.json
```

Expected: empty output (or only the rename header with no `+`/`-` content lines). The file contents must be byte-identical to before the move — the spec depends on this. If you see any content diff, abort and investigate; the rename should be pure.

- [ ] **Step 4: Commit**

```
git add -A plugins/repo-brain/.claude-plugin/plugin.json .claude-plugin/
git commit -m "refactor: move repo-brain plugin manifest into plugins/repo-brain/"
```

Expected: one file renamed, zero insertions, zero deletions.

---

## Task 3: Move the repo-brain skill directory

**Files:**
- Move: `skills/repo-brain/` → `plugins/repo-brain/skills/repo-brain/`

- [ ] **Step 1: Move the skill directory with git mv**

Run:
```
git mv skills/repo-brain plugins/repo-brain/skills/repo-brain
```

Expected: no output. `git status` shows every file under `skills/repo-brain/` renamed under `plugins/repo-brain/skills/repo-brain/` (SKILL.md and everything under `references/`).

- [ ] **Step 2: Verify the contents are unchanged**

Run:
```
git diff --cached -- plugins/repo-brain/skills/repo-brain/
```

Expected: empty output (pure renames, no content diffs). If anything shows content changes, abort and investigate.

- [ ] **Step 3: Verify `skills/` is now empty**

Run:
```
ls skills/
```

Expected: empty listing. (Task 5 will add a `README.md` here; for now it should be empty.)

- [ ] **Step 4: Commit**

```
git commit -m "refactor: move repo-brain skill into plugins/repo-brain/skills/"
```

Expected: every file under `skills/repo-brain/` renamed; zero content changes.

---

## Task 4: Rewrite the marketplace manifest

**Files:**
- Modify: `.claude-plugin/marketplace.json` (full rewrite)

- [ ] **Step 1: Overwrite `.claude-plugin/marketplace.json` with the new manifest**

Write the file with exactly this content:

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

Notes on intentional choices (cross-reference the spec for full rationale):
- No `version` on any plugin entry. For `repo-brain`, version lives in `plugins/repo-brain/.claude-plugin/plugin.json` (the docs warn against duplicating it). For the GitHub-source entries, omitting `version` means each upstream commit auto-counts as a new version — desired behavior for reference-only listings.
- The nested `"source": { "source": "github", "repo": "..." }` shape is canonical, not a typo — the inner `source` key is the discriminator across source types.
- `tags` (not `keywords`) — `tags` is the marketplace-entry field; `keywords` is for plugin manifests.

- [ ] **Step 2: Validate JSON syntax**

Run:
```
node -e "JSON.parse(require('fs').readFileSync('.claude-plugin/marketplace.json','utf8'))"
```

Expected: no output and exit code 0. Any syntax error (trailing comma, smart quotes, etc.) prints a SyntaxError and exits non-zero — fix it before continuing.

- [ ] **Step 3: Validate with the official Claude Code validator**

Run:
```
claude plugin validate .
```

Expected: validator confirms the marketplace is valid. Common errors to watch for:
- `File not found: .claude-plugin/marketplace.json` → wrong working directory; cd to the repo root.
- `Duplicate plugin name "x" found in marketplace` → typo; each `name` must be unique.
- `plugins[0].source: Path contains ".."` → don't introduce `..` paths.
- Schema warnings ("Plugin name 'X' is not kebab-case", "No marketplace description provided") are non-blocking but should be zero given the manifest above.

If `claude plugin validate` is not on PATH or this is a non-interactive context, the JSON syntax check from Step 2 is the minimum bar.

- [ ] **Step 4: Commit**

```
git add .claude-plugin/marketplace.json
git commit -m "refactor: rewrite marketplace.json for agentic-registry layout

Lists three plugins: repo-brain (inline) plus two reference-only
entries for mattpocock/skills and obra/superpowers. Drops version
from all entries per Claude Code docs (lives in plugin.json for
repo-brain; upstream commit SHA for the GitHub-source entries)."
```

---

## Task 5: Add `skills/README.md`

**Files:**
- Create: `skills/README.md`

- [ ] **Step 1: Create the file**

Write `skills/README.md` with exactly this content:

```markdown
# Loose skills

This directory is reserved for standalone Claude Code skills that are not (yet) packaged as plugins. A loose skill is a single folder containing a `SKILL.md` and optional supporting files; it has no `plugin.json` and is not listed in `.claude-plugin/marketplace.json`.

No loose skills live here yet.

## Installing a loose skill manually

When this directory has skills, copy the one you want into `~/.claude/skills/<skill-name>/` (so that `~/.claude/skills/<skill-name>/SKILL.md` exists). Claude Code will discover it automatically.

## Relationship to `plugins/`

When a loose skill matures into something with its own commands, hooks, MCP servers, or just a more deliberate distribution story, promote it: create `plugins/<name>/` with a `.claude-plugin/plugin.json`, move the skill folder under `plugins/<name>/skills/<name>/`, and add an entry to `.claude-plugin/marketplace.json`.
```

- [ ] **Step 2: Commit**

```
git add skills/README.md
git commit -m "docs: add skills/ README explaining reserved-for-loose-skills purpose"
```

---

## Task 6: Rewrite root `README.md` as the marketplace landing page

**Files:**
- Modify: `README.md` (full rewrite)

- [ ] **Step 1: Overwrite `README.md` with the new landing page**

Write the file with exactly this content:

```markdown
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
```

- [ ] **Step 2: Verify the markdown renders sensibly**

Run:
```
git diff README.md | head -100
```

Eyeball-check: the table renders, the code fences are matched, and no leftover content from the old README is bleeding through.

- [ ] **Step 3: Commit**

```
git add README.md
git commit -m "docs: rewrite root README as agentic-registry marketplace landing"
```

---

## Task 7: Delete `bash.exe.stackdump`

**Files:**
- Delete: `bash.exe.stackdump`

- [ ] **Step 1: Confirm it's untracked, then delete it**

Run:
```
git status --short bash.exe.stackdump
rm bash.exe.stackdump
```

Expected: `git status --short` shows `?? bash.exe.stackdump` (untracked) before deletion; `rm` produces no output. If `git status` shows the file as tracked (`M ` or similar), stop and investigate — this plan assumes it's untracked cruft.

- [ ] **Step 2: Verify it's gone**

Run:
```
ls bash.exe.stackdump 2>&1 || echo "deleted"
```

Expected: prints `deleted` (the `ls` exits non-zero because the file is gone).

No commit needed (the file was never tracked).

---

## Task 8: End-to-end verification

**Files:** none (verification only)

- [ ] **Step 1: Confirm the final layout matches the spec**

Run:
```
ls -la
ls .claude-plugin/
ls plugins/
ls plugins/repo-brain/
ls plugins/repo-brain/.claude-plugin/
ls plugins/repo-brain/skills/repo-brain/
ls skills/
```

Expected:
- Root: `.claude-plugin/`, `plugins/`, `skills/`, `README.md`, `docs/`. No `bash.exe.stackdump`.
- `.claude-plugin/`: only `marketplace.json` (no `plugin.json` at root anymore).
- `plugins/`: `repo-brain/`.
- `plugins/repo-brain/`: `.claude-plugin/`, `skills/`.
- `plugins/repo-brain/.claude-plugin/`: `plugin.json`.
- `plugins/repo-brain/skills/repo-brain/`: `SKILL.md`, `references/`.
- `skills/`: `README.md` only.

- [ ] **Step 2: Re-run marketplace validation**

Run:
```
claude plugin validate .
```

Expected: validator passes. If it didn't pass at the end of Task 4 it won't pass now either; investigate before proceeding.

- [ ] **Step 3: Local install smoke test (optional but recommended)**

Run:
```
claude plugin marketplace add ./
```

Expected: marketplace `agentic-registry` is added. Then:

```
claude plugin install repo-brain@agentic-registry
```

Expected: `repo-brain` installs without error. Verify by listing installed plugins:

```
claude plugin list
```

If install fails, the most likely causes are: relative-path source typo (`./plugins/repo-brain`), missing `plugin.json`, or `skills/repo-brain/SKILL.md` not where the plugin expects it.

Clean up after the smoke test:
```
claude plugin uninstall repo-brain@agentic-registry
claude plugin marketplace remove agentic-registry
```

If your environment doesn't have `claude` CLI available, skip this step but make a note for the user.

- [ ] **Step 4: Review git log**

Run:
```
git log --oneline -10
```

Expected: the recent commits read as a clean sequence — manifest move, skill move, marketplace rewrite, skills README, root README, (nothing for stackdump deletion). If anything looks out of order, that's fine; the file moves and rewrites are independent and reorderable.

- [ ] **Step 5: Report success to the user**

In a one-or-two-sentence end-of-turn summary: confirm the restructure is complete, the marketplace validates, and (if step 3 ran) the smoke install worked. Flag the out-of-scope items the user still needs to do themselves: rename the GitHub remote `elliot-d-kim/repo-brain` → `elliot-d-kim/agentic-registry`, archive the old repo if desired, and update the local git remote URL (`git remote set-url origin git@github.com:elliot-d-kim/agentic-registry.git`).

---

## Out of scope (do NOT do these in this plan)

These are explicitly the user's responsibility per the spec; mentioning so the implementing agent doesn't drift:

- Renaming the GitHub remote repository on github.com.
- Archiving or redirecting the old `elliot-d-kim/repo-brain` GitHub repo.
- Running `git remote set-url origin ...` to point at the new GitHub URL.
- Pushing the branch / opening a PR (the user controls when this lands).
- Adding any new own-plugins or any actual loose skills beyond the `skills/README.md` placeholder.
- Vendoring or mirroring third-party plugin code.
