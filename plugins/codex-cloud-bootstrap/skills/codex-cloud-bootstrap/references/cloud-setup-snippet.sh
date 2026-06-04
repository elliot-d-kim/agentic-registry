#!/usr/bin/env bash
set -euo pipefail

# Codex Cloud setup-script snippet.
# Configure the secret AGENTIC_REGISTRY_GITHUB_TOKEN only when the registry or
# plugin repos are private. Secrets are available during setup only and are
# removed before the agent phase.

REGISTRY_REPO="${AGENTIC_REGISTRY_REPO:-elliot-d-kim/agentic-registry}"
REGISTRY_REF="${AGENTIC_REGISTRY_REF:-main}"
REGISTRY_ROOT="${AGENTIC_REGISTRY_ROOT:-$HOME/.codex-cloud/agentic-registry}"

rm -rf "$REGISTRY_ROOT"
mkdir -p "$(dirname "$REGISTRY_ROOT")"

if [ -n "${AGENTIC_REGISTRY_GITHUB_TOKEN:-}" ]; then
  git clone --depth 1 --branch "$REGISTRY_REF" \
    "https://x-access-token:${AGENTIC_REGISTRY_GITHUB_TOKEN}@github.com/${REGISTRY_REPO}.git" \
    "$REGISTRY_ROOT"
  git -C "$REGISTRY_ROOT" remote set-url origin "https://github.com/${REGISTRY_REPO}.git"
else
  git clone --depth 1 --branch "$REGISTRY_REF" \
    "https://github.com/${REGISTRY_REPO}.git" \
    "$REGISTRY_ROOT"
fi

# Best-effort skill fallback. This does not rely on plugin activation; it makes
# bundled skills readable to the agent if Codex Cloud does not load arbitrary
# plugin marketplace state.
if [ -d "$REGISTRY_ROOT/plugins/repo-brain/skills/repo-brain" ]; then
  mkdir -p "$HOME/.codex/skills"
  rm -rf "$HOME/.codex/skills/repo-brain"
  cp -R "$REGISTRY_ROOT/plugins/repo-brain/skills/repo-brain" "$HOME/.codex/skills/repo-brain"
fi

# Persist the path for interactive shells and hook scripts in the agent phase.
grep -q "AGENTIC_REGISTRY_ROOT=" "$HOME/.bashrc" 2>/dev/null || {
  printf '\nexport AGENTIC_REGISTRY_ROOT=%q\n' "$REGISTRY_ROOT" >> "$HOME/.bashrc"
}
