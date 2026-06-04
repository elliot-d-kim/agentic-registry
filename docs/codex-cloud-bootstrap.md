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

Treat `~/.codex/skills/<name>` and any deterministic clone path such as
`~/.codex-cloud/agentic-registry` as the reliable runtime evidence. Environment
variables configured in the Codex Cloud UI are available for the full task, but
variables exported inside the setup script do not automatically persist into
the agent process. The setup template writes an env file and updates
`~/.bashrc` as a convenience, not as the primary contract.

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

Initial cloud testing on June 4, 2026 showed that copying
`repo-brain` into `~/.codex/skills/repo-brain` made the skill file readable to
the cloud agent. The same run did not show `AGENTIC_REGISTRY_ROOT` in the agent
shell and did not produce the hook-written status file, so the template now
writes diagnostics during setup as well.
