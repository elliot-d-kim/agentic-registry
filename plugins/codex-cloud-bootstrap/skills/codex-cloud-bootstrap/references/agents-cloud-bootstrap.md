# Codex Cloud Plugin Bootstrap

When this repo runs in Codex Cloud, local Codex plugin marketplace state from a developer machine is not assumed to exist.

The cloud environment setup script may clone `elliot-d-kim/agentic-registry` into:

```text
~/.codex-cloud/agentic-registry
```

If `AGENTIC_REGISTRY_ROOT` is configured in the Codex Cloud environment, it may
point to a different clone path. Exports made only inside the setup script may
not be visible in every agent shell, so do not rely on the variable being set.

```text
$AGENTIC_REGISTRY_ROOT
```

## Repo Brain Fallback

When the user asks to set up docs, update docs after work, log decisions, inspect roadmap state, understand what is next, or explain why a project decision was made, use repo-brain behavior.

Prefer installed plugin or skill invocation if available. If plugin invocation is not available in Codex Cloud, read:

```text
~/.codex/skills/repo-brain/SKILL.md
~/.codex-cloud/agentic-registry/plugins/repo-brain/skills/repo-brain/SKILL.md
$AGENTIC_REGISTRY_ROOT/plugins/repo-brain/skills/repo-brain/SKILL.md
```

Then follow the skill manually.

## Bootstrap Expectations

- Do not fetch private plugin repos during the agent phase.
- Do not ask the user to paste a GitHub token into the prompt.
- If bootstrap files are missing, report that the cloud setup script likely did not run or the environment cache is stale.
- If hooks are present, treat them as diagnostics and reinforcement, not as the only source of plugin behavior.
