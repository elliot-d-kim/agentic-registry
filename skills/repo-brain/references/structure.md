# Repo Brain — Directory Structure & Conventions

## Target structure

```
repo-root/
├── README.md                         (human-facing overview, quick start, doc links)
├── AGENTS.md                         (agent-facing doc routing table)
└── docs/
    ├── ROADMAP.md                    (hook-only index of all future work)
    ├── CHANGELOG.md                  (historical record of completed work)
    ├── DECISIONS.md                  (extracted decisions with rationale + rejected alternatives)
    ├── SNAPSHOT.md                   (current state — architecture, active work, key facts)
    ├── CONVENTIONS.md               (specific rules — naming, format, templates, style)
    ├── SETUP.md                     (prerequisites, environment, how to run)
    ├── principles/                  (WHY — durable insights)
    │   ├── ARCHITECTURE.md
    │   ├── DEVELOPMENT.md
    │   └── (domain-specific principle files)
    ├── product-requirements/        (WHAT — targets, goals, feature specs)
    │   ├── PROJECT-GOALS.md         (required vs nice-to-have goals)
    │   └── features/
    │       ├── FEATURE-A.md
    │       └── FEATURE-B.md
    ├── plans/                       (HOW — concrete execution)
    │   ├── YYYY-MM-DD-name.md       (active plans)
    │   └── archive/                 (completed plans — read-only)
    └── data/                        (if applicable — seed files, schemas, etc.)
```

## File purposes

### Sidecars (at `docs/` root)

| File | Purpose | Update when... |
|------|---------|----------------|
| `ROADMAP.md` | Single index of all future work. Hook entries only. | Items added, reprioritized, or completed |
| `CHANGELOG.md` | Historical record. Never rewrite old entries. | After each significant change |
| `DECISIONS.md` | Decisions with rationale + rejected alternatives. Numbered D-NNN. | Plans archive (decisions extract from inline) |
| `SNAPSHOT.md` | Current state for fast orientation. | Major things change (architecture, active work) |
| `CONVENTIONS.md` | Specific rules — the WHAT of how to do things. | Conventions established or changed |
| `SETUP.md` | How to get running. Prerequisites, commands. | Setup steps change |

### Three pillars

| Pillar | Contains | Rate of change | Tone |
|--------|----------|----------------|------|
| `principles/` | WHY — durable design insights | Rarely | Squishy, explanatory, "how to apply" |
| `product-requirements/` | WHAT — goals, features, requirements | Slowly | Concrete, measurable, "success looks like" |
| `plans/` | HOW — task breakdowns, verification | Constantly (archive when done) | Tactical, specific, checkboxes |

### Root files

| File | Purpose |
|------|---------|
| `README.md` | Human-facing: what is this, how to run it, where are the docs |
| `AGENTS.md` | Agent-facing: "working on X → read these files." Key constraints. |

## Naming conventions

- Markdown in `docs/`, `principles/`, `features/`: UPPER_CASE (`ROADMAP.md`, `ARCHITECTURE.md`)
- Plan files: dated kebab-case (`2026-04-11-feature-name.md`)
- Source code: follow language conventions (Python `snake_case`, JS `camelCase`)

## Status tags

| Tag | Meaning |
|-----|---------|
| `[idea]` | Vague concept, not committed |
| `[backlog]` | Committed, not yet specified |
| `[spec'd]` | Has a feature doc in `features/` |
| `[in-progress]` | Actively worked on (has a plan in `plans/`) |
| `[next]` | High priority, about to start |
| `[done]` | Completed |

## ROADMAP entry format

One line per entry. Max ~10 words after the status tag. No parenthetical elaboration.

**Good:**
```
- [spec'd] Text chat mode → features/TEXT-CHAT.md
- [backlog] Chat history persistence ← *depends on: Configurable prompts*
```

**Bad:**
```
- [spec'd] Text chat mode (lets users type instead of speak)   ← summary leak
```

## Dependency syntax

- `← *depends on: X*` — X must land first
- `← *conflicts with: X*` — cannot both be implemented as-is
