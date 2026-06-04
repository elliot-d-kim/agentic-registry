#!/usr/bin/env python3
"""Report Codex Cloud plugin bootstrap state without using secrets."""

from __future__ import annotations

import os
from pathlib import Path


def main() -> int:
    repo_root = Path.cwd()
    registry_root = Path(os.environ.get("AGENTIC_REGISTRY_ROOT", "~/.codex-cloud/agentic-registry")).expanduser()
    status_dir = repo_root / ".codex-cloud"
    status_dir.mkdir(exist_ok=True)
    status_file = status_dir / "bootstrap-status.md"

    candidates = [
        registry_root / "plugins" / "repo-brain" / "skills" / "repo-brain" / "SKILL.md",
        Path("~/.codex/skills/repo-brain/SKILL.md").expanduser(),
    ]
    found = [path for path in candidates if path.exists()]

    lines = [
        "# Codex Cloud Bootstrap Status",
        "",
        f"Registry root: `{registry_root}`",
        "",
        "## Repo Brain Skill",
        "",
    ]
    if found:
        lines.extend(f"- Found `{path}`" for path in found)
    else:
        lines.append("- Not found. Check the Codex Cloud setup script and reset the environment cache if needed.")

    status_file.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {status_file}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
