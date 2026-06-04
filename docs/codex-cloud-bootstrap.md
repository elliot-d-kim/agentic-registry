# Codex Cloud Plugin Bootstrap

Codex marketplace registration is not the same as Codex Cloud provisioning.

For local Codex CLI/App, a Git-backed marketplace lets Codex clone a registry and install plugin bundles from that marketplace checkout. For Codex Cloud, each task starts in a fresh container. The cloud environment checks out the target repo, runs the configured setup script, removes setup-only secrets, and then starts the agent phase.

## Recommended Shape

Use a setup-first bootstrap:

1. Store any GitHub fine-grained PAT as a Codex Cloud secret, not as a normal environment variable.
2. In the cloud setup script, clone the private registry or plugin repo with that token.
3. Immediately rewrite token-bearing Git remotes to tokenless URLs.
4. Copy any must-have skill files into a stable path such as `~/.codex/skills/<name>`.
5. Add repo-local `AGENTS.md` guidance that tells the agent where to read the workflow if plugin invocation is unavailable.
6. Optionally add repo-local hooks to write bootstrap diagnostics or reinforce behavior.

## Why Hooks Are Secondary

Hooks run in the agent loop. They are good for diagnostics, policy checks, and turn/session behavior. They are a weaker primary installer for private plugins because Codex Cloud secrets are removed before the agent phase. A hook that needs a PAT either cannot read the secret or requires exposing the token as a normal environment variable.

## Artifacts In This Registry

The `codex-cloud-bootstrap` Codex plugin provides a setup/audit skill plus templates:

- setup-script snippet
- `AGENTS.md` cloud bootstrap section
- optional `.codex/config.toml` hook config
- optional hook status script
- design notes and open cloud tests

## Open Validation Items

The current docs establish the setup/secret/agent-phase model, but do not fully specify whether arbitrary setup-created plugin state is loaded by Codex Cloud. The safe fallback is to make workflows readable through repo-local guidance and copied skill files while treating full plugin activation as something to test per Codex Cloud release.
