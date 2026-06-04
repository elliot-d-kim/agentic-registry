---
name: codex-cloud-bootstrap
description: "Set up, audit, or explain Codex Cloud bootstrapping for private plugin, marketplace, and skill workflows. Use when the user wants plugins or skills available in Codex Cloud, asks about GitHub PATs/secrets/environment variables for Codex Cloud setup, wants repo-local hooks for Codex, wants to mirror a Claude Code Cloud plugin-bootstrap workflow in Codex, or needs AGENTS.md/setup-script guidance so cloud tasks can reliably follow a plugin workflow."
---

# Codex Cloud Bootstrap

Use this skill to prepare a target repository so Codex Cloud tasks can find and use plugin-like workflows even when local plugin marketplace state is not present.

## Mental model

Codex Cloud does not inherit local `~/.codex/config.toml`, local marketplace snapshots, or desktop plugin picker state. A cloud task creates a container, checks out the target repo, runs the environment setup script, removes setup-only secrets, then starts the agent phase.

That means cloud bootstrap should prefer this order:

1. **Setup script installs or copies materials before the agent starts.**
2. **`AGENTS.md` tells the agent exactly where to read those materials.**
3. **Repo-local hooks verify or reinforce state after startup.**

Do not make hooks the primary private-repo installer when a token is required. Codex Cloud secrets are only available during setup, and normal environment variables remain visible during the agent phase.

## Modes

### Setup

When asked to set up a target repo:

1. Inspect the repo for `AGENTS.md`, `.codex/config.toml`, `.codex/hooks/`, and any existing cloud setup notes.
2. Ask for or infer the marketplace repo, plugin names, and whether the registry is public or private.
3. Add a setup-script snippet based on `references/cloud-setup-snippet.sh`.
4. Add or update `AGENTS.md` using `references/agents-cloud-bootstrap.md`.
5. Optionally add `.codex/config.toml` and `.codex/hooks/codex_cloud_bootstrap_status.py` from the hook templates.
6. Do not commit real tokens, PATs, or secret values. Use placeholder secret names.

### Audit

When asked to audit:

1. Verify that private GitHub access happens in setup, not hooks.
2. Verify that any setup-created files are discoverable without internet during the agent phase.
3. Verify `AGENTS.md` has fallback instructions for when plugin invocation is unavailable.
4. Verify hooks are optional and non-secret-bearing.
5. Call out untested assumptions separately from confirmed behavior.

### Explain

When asked to explain, be crisp about the three layers:

- Git marketplace: distribution for local/App/CLI installs.
- Cloud setup: provisioning into a fresh cloud container.
- Repo guidance/hooks: behavior and fallback once the agent starts.

## Security rules

- Treat GitHub PATs as setup-only secrets.
- Prefer fine-grained PATs scoped to read-only contents for the registry/private plugin repos.
- Never place a PAT in `AGENTS.md`, `.codex/config.toml`, hook scripts, normal environment variables, or shell history.
- After cloning with a token-bearing URL, rewrite the remote URL to a tokenless URL.
- If a hook needs network or auth, stop and explain why that is riskier than setup-time provisioning.

## References

- `references/cloud-setup-snippet.sh`
- `references/agents-cloud-bootstrap.md`
- `references/codex-config-hook.toml`
- `references/codex_cloud_bootstrap_status.py`
- `references/design-notes.md`
