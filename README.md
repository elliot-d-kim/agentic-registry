# repo-brain

A Claude Code plugin for managing a three-pillar documentation architecture across any project.

## What it does

Repo Brain gives Claude a `/repo-brain` skill with seven modes:

| Mode | Trigger | What it does |
|------|---------|--------------|
| **Setup** | "set up docs for this repo" | Scaffolds the full doc structure (new or existing repo) |
| **Update** | "we just built X, update docs" | Routes changes to the right files |
| **Audit** | "check docs for gaps" | 7-point consistency check |
| **Evaluate** | "should we do X or Y?" | Evaluates options against principles and decisions |
| **Recall** | "why did we do X?" | Finds rationale across decisions, plans, principles |
| **Scope** | "what should we work on next?" | Prioritizes from the roadmap |
| **Execute** | "do the next thing" | Picks up the next task and runs |

## The architecture

Three pillars of documentation, each with a different rate of change:

- **`docs/principles/`** — WHY (durable design insights, rarely change)
- **`docs/product-requirements/`** — WHAT (goals, features, requirements)
- **`docs/plans/`** — HOW (task breakdowns, archived when done)

Plus six sidecar files: ROADMAP, CHANGELOG, DECISIONS, SNAPSHOT, CONVENTIONS, SETUP.

## Install

```
claude plugin install elliot-d-kim/repo-brain
```
