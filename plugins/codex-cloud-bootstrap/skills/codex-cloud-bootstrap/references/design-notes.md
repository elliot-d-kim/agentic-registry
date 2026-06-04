# Codex Cloud Bootstrap Design Notes

## Confirmed From Current Codex Docs

- Codex Cloud creates a container, checks out the target repo, runs setup, then starts the agent phase.
- Setup scripts have internet access and can read configured secrets.
- Secrets are removed before the agent phase.
- Normal environment variables remain available throughout the task.
- Agent internet access is off by default unless the environment enables it.
- Codex uses `AGENTS.md` when present in a cloud task.
- Project-local `.codex/config.toml` and hooks exist, but project-local hooks require the project layer to be trusted.
- Non-managed command hooks require trust before they run.

## Design Consequences

Use setup for private fetches. Use `AGENTS.md` for reliable behavior. Use hooks for verification and diagnostics.

Avoid a hook that clones private repos with a PAT. That requires making the token visible during the agent phase or relying on unavailable setup-only secrets.

## Open Questions To Test In Real Codex Cloud

1. Does Codex Cloud load setup-created `~/.codex/skills/<name>/SKILL.md` as a skill?
2. Is `codex` CLI available in the setup script, and does `codex plugin add` affect the later agent runtime?
3. Are project-local hooks trusted automatically for trusted GitHub repos in cloud, or skipped until explicit review?
4. Does a `SessionStart` hook run early enough to affect skill discovery, or only to provide diagnostics?
5. Does writing `~/.codex/config.toml` during setup alter the cloud agent runtime config?

Until those are verified, treat plugin activation as experimental and make `AGENTS.md` the guaranteed fallback.
