# Repo Brain — Document Templates

## Principle doc

```markdown
# [Area] Principles

> **What belongs here:** [Explicit scope — what this file covers AND what it doesn't.
> Name the neighboring docs where out-of-scope content should go instead.]

---

## Primary Principles

### 1. [Principle name]

Explanatory paragraph. WHY this matters, not just WHAT to do. Squishy, durable language that would survive an implementation rewrite.

**How to apply:** Practical guidance. When to invoke this principle. What questions to ask.

### 2. [Next principle]

...

---

## Applied Principles

_These arise when the primary principles meet specific technology or domain choices.
They are important but downstream — rooted in the principles above._

### A1. [Applied principle name]

Explanatory paragraph.

**How to apply:** Practical guidance.

**Derives from:** [Which primary principle(s) this is downstream of]
```

**Structure guidance:**
- **Primary principles** are broadly applicable values — modularity, composability, configurability, etc. They would survive a rewrite and are independent of specific technology choices.
- **Applied principles** are downstream consequences that arise when primary principles meet the project's specific stack. They should trace back to one or more primary principles.
- Not every principle doc needs both tiers. A file with only 2-3 principles can use a flat structure. Add the two-tier hierarchy when there are enough principles (4+) to make the distinction valuable.

**Quality checks:**
- Would this survive a complete rewrite of the codebase? If not → convention or implementation detail.
- Does it explain WHY, not just WHAT? "Use snake_case" is a convention. "Consistent naming because ambiguity costs more than rigidity" is a principle.
- Does "How to apply" give actionable guidance? Not "follow this" but "when X, ask Y before Z."
- Does the scope statement at the top make it clear what belongs here vs elsewhere?
- Are primary principles truly high-level, or are they really downstream of something more general?

## Feature doc

```markdown
# Feature: [Name]

## Scope
What the feature is and is not.

## Problem
Why it matters / what pain it solves.

## Requirements
What must be true when this is done.

## Options considered
### Option A: [description]
→ Decision: picked / rejected + why

### Option B: [description]
→ Decision: picked / rejected + why

## Decision & rationale
Why the chosen option was selected. Trade-offs accepted.

## Open questions
Anything unresolved.

## Status
[idea | backlog | spec'd | in-progress | done]
```

**Notes:**
- An `[idea]` might just have Scope and Status — not every section is needed at every stage.
- Options and Decision fill in as the feature gains clarity.
- Open questions should include enough context for someone picking this up cold.

## Plan doc

```markdown
# Plan: [Name]

**Date:** YYYY-MM-DD
**Related:** features/FEATURE.md

## Goal
Single-sentence outcome.

## Tasks
1. Task name
   - Files touched
   - How to verify
2. ...

## Test plan
How we know it worked.

## Decisions made during this plan
(Inline; extract to DECISIONS.md when this plan archives.)

## Status
[in-progress | done]
```

**Notes:**
- Plans are tactical — tasks, files, verification steps. Not architecture debates.
- Decisions live inline during execution, extract when plan archives.
- Archive by moving to `plans/archive/` when done.

## Essay doc

```markdown
# Essay: [Title]

**Date:** YYYY-MM-DD
**Context:** What discussion, session, or line of inquiry this essay came from.

## Why this essay exists
Why this should remain context-rich writing instead of being forced directly into canonical docs.

## Main argument
Long-form reasoning, examples, tensions, and open texture from the discussion.

## Implications for the canonical docs
What, if anything, should later be extracted into principles, product requirements, decisions, plans, or conventions.
```

**Rules:**
- Essays are intentionally non-canonical — they preserve context and argument, not authoritative facts.
- If durable knowledge emerges, extract it into the canonical docs (principles, DECISIONS, features, CONVENTIONS) and link back.
- Do not let essays become a shadow source of truth. The canonical docs remain authoritative.
- Essays are optional. Skip the lane entirely if the project won't produce long-form reflective writing.

## DECISIONS.md entry

```markdown
### D-NNN: [Short title]

**Decision:** What was decided.

**Rationale:** Why — the reasoning, constraints, or trade-offs.

**Rejected:**
- [Alternative A] — why rejected
- [Alternative B] — why rejected
```

**Rules:**
- Every decision MUST have a rejected alternative. No alternative = a fact, not a decision.
- Number sequentially (D-001, D-002, ...).
- Group by date/topic: `## YYYY-MM-DD — [Topic]`
- Pending decisions use P-NNN prefix.
- Overturned decisions: keep the original, add the new one with a cross-reference. The trail matters.

## SNAPSHOT.md

```markdown
# Snapshot

> Current state of the project, for fast orientation.
>
> **As of:** YYYY-MM-DD

## What this project is
One paragraph.

## Architecture
Brief description. ASCII diagram if applicable.

## Currently active work
What's in progress right now.

## Most recent changes
Last few notable changes (orientation, not full changelog).

## Where to find things

| Need | Look in |
|------|---------|
| Why we do things this way | `docs/principles/` |
| What we're building | `docs/product-requirements/` |
| How we're building it | `docs/plans/` |
| Reflective synthesis (optional) | `docs/essays/` |
| What we built | `docs/CHANGELOG.md` |
| Decisions made | `docs/DECISIONS.md` |
| What's next | `docs/ROADMAP.md` |
| Current state | this file |
| How to run it | `docs/SETUP.md` |
| Rules of the road | `docs/CONVENTIONS.md` |

## Key dependencies
External services, libraries, APIs.
```

## ROADMAP.md

```markdown
# Roadmap

> Single source of truth for all future work. Entries are hooks — open the linked doc to act.
>
> **Related:** [CHANGELOG.md](CHANGELOG.md) · [DECISIONS.md](DECISIONS.md) · [SNAPSHOT.md](SNAPSHOT.md)

## Next

## High

## Low

## Ideas

*(empty — vague concepts not yet committed)*

## Completed
```

## CHANGELOG.md entry

```markdown
## YYYY-MM-DD — [Short title]

- Bullet per notable change
- Focus on WHAT changed, not HOW
- New entries use new paths; old entries keep old paths (historical record)
```

## CONVENTIONS.md

```markdown
# Conventions

> Specific rules of the road. Principles explaining why → `principles/DEVELOPMENT.md`.

## File naming
(Adapt to project)

## Commit format
- Subject: under 72 chars, imperative mood
- Body: what changed and why

## Code style
(Adapt to project)

## Documentation single-purpose rule
Each doc has one job. Duplication = one of them is wrong.
```

## AGENTS.md

```markdown
# Agent Context

## Doc Routing

| Working on... | Load these |
|---------------|-----------|
| Project setup | `docs/SETUP.md` |
| Architecture | `docs/SNAPSHOT.md` + `docs/principles/ARCHITECTURE.md` |
| Adding a feature | `docs/ROADMAP.md` + `docs/CONVENTIONS.md` |
| (project-specific rows) |

## Key Constraints
(Critical constraints that affect every task)

## Conventions
(Brief summary — link to `docs/CONVENTIONS.md`)
```

## PROJECT-GOALS.md

```markdown
# Project Goals

> Top-level product goals. Not implementation — targets.

## What this project is
One paragraph defining the project and its primary question.

## Required goals
Goals the project must hit. Each with a "success looks like" criterion.

### G-1: [Goal name]
Description. Why this is required.
**Success looks like:** ...

## Nice-to-have goals
Aligned with constraints but not the point. Not worth compromising required goals.

### N-1: [Goal name]
Description. Why it's nice-to-have, not required.

## Non-goals (explicitly out of scope)
- Things you will NOT build, to prevent scope creep.
```
