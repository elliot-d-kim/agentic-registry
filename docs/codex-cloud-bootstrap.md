# Codex Cloud Plugin Bootstrap

Codex marketplace registration is not the same as Codex Cloud provisioning.

For local Codex CLI/App, a Git-backed marketplace lets Codex clone a registry and install plugin bundles from that marketplace checkout. For Codex Cloud, each task starts in a fresh container. The cloud environment checks out the target repo, runs the configured setup script, removes setup-only secrets, and then starts the agent phase.

## Recommended Shape

Use a setup-first bootstrap:

1. Store any GitHub fine-grained PAT as a Codex Cloud secret, not as a normal environment variable.
2. In the cloud setup script, clone the private registry or plugin repo with that token.
3. Immediately rewrite token-bearing Git remotes to tokenless URLs.
4. Copy any must-have skill files into a stable path such as `~/.codex/skills/<name>`.
5. Write a setup-time status file such as `.codex-cloud/bootstrap-status.md`.
6. Add repo-local `AGENTS.md` guidance that tells the agent where to read the workflow if plugin invocation is unavailable.
7. Optionally add repo-local hooks to refresh diagnostics or reinforce behavior.

Treat `~/.codex/skills/<name>` and any deterministic clone path such as `~/.codex-cloud/agentic-registry` as the reliable runtime evidence. Environment variables configured in the Codex Cloud UI are available for the full task, but variables exported inside the setup script do not automatically persist into the agent process. The setup template writes an env file and updates `~/.bashrc` as a convenience, not as the primary contract.

## Current Path Diagram

```text
Local desktop / CLI marketplace path

  developer machine
        |
        | codex plugin marketplace add elliot-d-kim/agentic-registry
        v
  local Codex marketplace metadata
  ~/.codex/... marketplace state
        |
        | reads .agents/plugins/marketplace.json
        v
  marketplace checkout of agentic-registry
        |
        | local entries resolve to bundled plugin folders
        v
  plugins/repo-brain/...
  plugins/codex-cloud-bootstrap/...
        |
        v
  locally installed / activated plugin workflows

Codex Cloud bootstrap path

  Codex Cloud task starts fresh
        |
        v
  target repo checkout
        |
        | setup script runs before agent phase
        v
  setup clone
  ${AGENTIC_REGISTRY_ROOT:-~/.codex-cloud/agentic-registry}
        |
        +--> registry plugin copy
        |    plugins/repo-brain/skills/repo-brain/SKILL.md
        |    plugins/codex-cloud-bootstrap/...
        |
        +--> ~/.codex/skills copy
        |    ~/.codex/skills/repo-brain/SKILL.md
        |
        +--> setup/status diagnostics
        |    .codex-cloud/bootstrap-status.md
        |
        v
  agent phase
        |
        +--> AGENTS.md fallback says where to read the workflow
        |
        +--> optional hook/status diagnostics if project hooks are trusted
        |
        v
  manual skill fallback or tested plugin activation

Visible redundancies

  .agents/plugins/marketplace.json  (local marketplace metadata)
      overlaps with setup clone contents in cloud.

  registry plugin copy in setup clone
      overlaps with ~/.codex/skills/repo-brain copy.

  ~/.codex/skills copy
      overlaps with AGENTS.md fallback guidance.

  setup/status diagnostics
      overlaps with hook/status diagnostics.
```

## Redundancy Audit

| Redundancy | Classification | Reason |
|---|---|---|
| Local marketplace metadata plus cloud setup clone | Keep intentionally | They serve different runtimes: local Codex marketplace install versus fresh Codex Cloud provisioning. The maintenance cost is keeping metadata paths aligned with bundled plugin folders. |
| Registry plugin copy inside the setup clone plus copied `~/.codex/skills/repo-brain` | Keep temporarily | This is deliberate until cloud plugin activation and setup-created skill discovery are tested. The duplicate copy costs sync/diagnostic complexity, but improves reliability because the skill file is readable even without plugin activation. |
| Setup-time `.codex-cloud/bootstrap-status.md` plus hook-written status diagnostics | Keep temporarily | Setup diagnostics are stronger evidence in fresh cloud containers. Hook diagnostics are useful only when project hook trust behavior is understood. Maintaining both costs template complexity. |
| `AGENTS.md` fallback plus copied skill files | Keep intentionally | `AGENTS.md` is the no-plugin guidance path. Copied skills preserve the source workflow text. The duplication is acceptable because one tells the agent where to look and the other provides the material. |
| `.bashrc` env-file persistence plus normal Codex Cloud environment variables | Keep temporarily | Normal environment variables are the clearer contract for agent-phase visibility. The env file is a convenience for interactive shells and hooks, but should be removed if it causes confusion or is not needed. |
| Multiple status locations documenting the same paths | Remove | Durable path explanations should live here; generated status files should report observed state only. Avoid repeating design rationale in generated diagnostics. |

## Why Hooks Are Secondary

Hooks run in the agent loop. They are good for diagnostics, policy checks, and turn/session behavior. They are a weaker primary installer for private plugins because Codex Cloud secrets are removed before the agent phase. A hook that needs a PAT either cannot read the secret or requires exposing the token as a normal environment variable. Project-local hooks also depend on hook trust, so setup-time diagnostics are stronger evidence in a fresh cloud environment.

## Artifacts In This Registry

The `codex-cloud-bootstrap` Codex plugin provides a setup/audit skill plus templates:

- setup-script snippet
- `AGENTS.md` cloud bootstrap section
- optional `.codex/config.toml` hook config
- optional hook status script
- design notes and open cloud tests

## Open Validation Items

The current docs establish the setup/secret/agent-phase model, but do not fully specify whether arbitrary setup-created plugin state is loaded by Codex Cloud. The safe fallback is to make workflows readable through repo-local guidance and copied skill files while treating full plugin activation as something to test per Codex Cloud release.

Initial cloud testing on June 4, 2026 showed that copying `repo-brain` into `~/.codex/skills/repo-brain` made the skill file readable to the cloud agent. The same run did not show `AGENTIC_REGISTRY_ROOT` in the agent shell and did not produce the hook-written status file, so the template now writes diagnostics during setup as well.

Current validation should continue through the roadmap hooks in [`ROADMAP.md`](ROADMAP.md): environment variable visibility, plugin activation versus manual skill fallback, setup cache behavior, hook trust behavior, and redundancy cleanup.
