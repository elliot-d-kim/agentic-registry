---
name: repo-brain
description: "Set up, maintain, query, and act on a three-pillar documentation architecture (principles/product-requirements/plans + sidecars). Use this skill whenever the user asks to: initialize or set up project docs, update documentation after a discussion/build/decision, find gaps or contradictions in docs, evaluate options against existing principles or decisions, recall why something was decided, scope or plan what to work on next from the roadmap, or execute the next task. Also use when the user says things like 'update the docs', 'log this decision', 'what's next', 'why did we do X', 'do the next thing', or when you notice the project has this doc structure (docs/principles/, docs/product-requirements/, ROADMAP.md, DECISIONS.md) and the user's task would benefit from consulting or updating it. Even if the user doesn't mention 'docs' explicitly, use this skill when their request involves project planning, decision-making, or architectural discussion that should be captured."
---

# Repo Brain

A living documentation architecture that separates WHY (principles) from WHAT (product-requirements) from HOW (plans), with sidecar docs for routing, history, and state.

## Why this system exists

Documentation rots in predictable ways: implementation details leak into principle docs, principles get buried in plans, the same fact gets written in three places and two of them go stale. LLM coding agents make it worse — they read the first summary they find and skip drilling into source docs, propagating stale information.

This architecture fights that by:
- **Separating by rate of change.** Principles rarely change. Requirements change slowly. Plans change constantly and archive when done. Mixing them in one doc means stable content gets buried by churn.
- **Starving summaries.** ROADMAP entries are hooks (~10 words), not summaries. This forces anyone (human or LLM) to drill into the source doc.
- **Single source of truth.** Each fact lives in exactly one doc. "See also" links between two docs with the same content means one is wrong.

## How to use this skill

Match the user's request to a mode. If ambiguous, ask. If the request spans modes, handle them in sequence.

| User says something like... | Mode |
|---|---|
| "set up docs" / "initialize documentation" / new repo | **Setup** |
| "we just built X" / "update docs" / "log this decision" / "we discussed X" | **Update** |
| "find gaps" / "audit" / "what's missing" / "contradictions" / "ask me questions" | **Audit** |
| "should we do X or Y" / "evaluate against principles" / "help me decide" | **Evaluate** |
| "why did we do X" / "remind me" / "what alternatives" / "reasons we didn't" | **Recall** |
| "what's next" / "scope next work" / "let's plan" / "roadmap review" | **Scope** |
| "do the next thing" / "execute from roadmap" / "keep going" | **Execute** |

---

## Mode: Setup

Read `references/structure.md` for the directory tree and `references/templates.md` for all file templates before starting.

### New repo

1. **Understand the project.** Ask (or infer from existing files): What is this project? What problem does it solve? What are the key goals?

2. **Create the directory structure:**
   ```
   docs/
   ├── principles/
   ├── product-requirements/features/
   ├── plans/archive/
   └── data/  (if applicable)
   ```

3. **Create sidecars** (each references the others):
   - `docs/ROADMAP.md` — empty hook-index with priority sections
   - `docs/CHANGELOG.md` — first entry: "Project initialized"
   - `docs/DECISIONS.md` — empty with header
   - `docs/SNAPSHOT.md` — current state based on what exists
   - `docs/CONVENTIONS.md` — file naming, commit format, code style
   - `docs/SETUP.md` — prerequisites and how to run

4. **Create initial principle files** only if enough context exists. Do not fabricate principles — a thin honest file beats a padded one.

5. **Create `product-requirements/PROJECT-GOALS.md`** with required vs nice-to-have goals.

6. **Update `README.md`** — add a Docs section linking to the structure.

7. **Create/update `AGENTS.md`** — doc routing table for coding agents.

### Existing repo with existing docs

1. **Read everything first.** Map what exists, where duplication lives, and what's misplaced.
2. **Propose a migration plan** — map old docs to new locations. Get user approval.
3. **Migrate one category at a time.** Verify after each: no content lost, no content fabricated.
4. **Delete old structure** only after all content has landed.
5. **Update all internal links.** Grep for old paths — should return zero results (excluding CHANGELOG, which is historical).

### Scaling to the project

Don't force the full structure onto a project with 3 docs worth of content. Start with ROADMAP + CHANGELOG + SNAPSHOT and add sidecars as the project grows. The pillars (principles/, product-requirements/, plans/) can start empty.

---

## Mode: Update

Something happened — a discussion, a build, a decision, a status change. Route it to the right doc(s).

### Routing table

| What happened | Update these |
|---|---|
| **Decision made** (with rejected alternatives) | `DECISIONS.md` if plan is archived, or inline in active plan |
| **Feature built / shipped** | `CHANGELOG.md`, `ROADMAP.md` (→ Completed), archive plan if exists |
| **New feature idea** | `ROADMAP.md` (one-liner hook in appropriate priority section) |
| **Feature gaining clarity** | Create `features/FEATURE-NAME.md`, update ROADMAP to `[spec'd]` |
| **Ready to build** | Create `plans/YYYY-MM-DD-name.md`, update ROADMAP to `[in-progress]` |
| **Principle discovered** | `principles/RELEVANT.md` — must be durable enough to survive a rewrite |
| **Convention established** | `CONVENTIONS.md` |
| **Architecture changed** | `SNAPSHOT.md`, possibly `principles/ARCHITECTURE.md` |
| **Status changed** | `SNAPSHOT.md` active work section |
| **Bug fixed / improvement** | `CHANGELOG.md` only (unless it involved a real decision) |

### Update protocol

1. **Identify what changed.** Ask the user if unclear.
2. **Read the target doc(s)** before editing.
3. **Make the update.** Follow existing style and conventions.
4. **Check for ripple effects:**
   - Does ROADMAP need updating?
   - Does SNAPSHOT need updating?
   - Does CHANGELOG need a new entry?
   - Are there cross-doc references to update?
5. **Do NOT create duplication.** If the info exists somewhere, update it there.

### The resolution gradient

Items move through four stages. Do not skip:

1. **Vague idea** → one-liner in ROADMAP, no doc
2. **Gaining clarity** → feature doc in `features/` (requirements, options, open questions)
3. **Ready to build** → plan in `plans/` (tasks, files, verification)
4. **Built** → plan archives, feature doc stays as living reference, decisions extract to DECISIONS.md, CHANGELOG records

---

## Mode: Audit

Read all docs systematically and report findings.

### Checklist

1. **Structural completeness:**
   - Do all required sidecars exist? (ROADMAP, CHANGELOG, DECISIONS, SNAPSHOT, CONVENTIONS)
   - Does `principles/` have at least one file?
   - Does `PROJECT-GOALS.md` exist?

2. **ROADMAP health:**
   - Are entries hooks (<=10 words)? Flag summaries.
   - Do `[spec'd]` items have linked feature docs? Flag orphans.
   - Do `[in-progress]` items have plans? Flag orphans.
   - Stale `[in-progress]` items?

3. **Duplication:** Search for key phrases — each should appear in exactly one source location (references/links to the source are fine).

4. **Staleness:**
   - Is SNAPSHOT's "as of" date recent?
   - References to deleted files or old paths?
   - Resolved open questions still listed as open?

5. **Decision coverage:**
   - Decisions in archived plans not yet in DECISIONS.md?
   - Pending decisions (P-NNN) that have been resolved?

6. **Pillar separation:**
   - Implementation detail in principle files? (→ plans or code)
   - Principles in feature docs? (→ principles/)
   - Requirements in plan files? (→ features/)

7. **Convention compliance:** File naming, ROADMAP format, template adherence.

Report findings as a prioritized list. Ask the user clarifying questions about anything ambiguous — use audit mode as a two-way conversation, not just a report.

---

## Mode: Evaluate

The user is debating options. Help them evaluate against the project's existing documentation.

1. **Read** `principles/`, `DECISIONS.md`, and `PROJECT-GOALS.md`.
2. **Identify relevant principles and past decisions.**
3. **Evaluate each option** against them. Be specific: "Option A aligns with principle X because..., but conflicts with D-NNN because..."
4. **Surface prior art.** Similar decisions made before? What was decided and why?
5. **Present the analysis.** Don't decide for the user — lay out trade-offs.
6. **If the user decides:** log it appropriately (inline in active plan, or to DECISIONS.md). Always include the rejected alternative and rationale.

---

## Mode: Recall

The user wants to know why something was decided or what alternatives were considered.

1. **Search `DECISIONS.md`** — decisions are numbered (D-NNN) with rationale and rejected alternatives.
2. **Search `plans/archive/`** for in-context discussion around the decision.
3. **Search `CHANGELOG.md`** for when the change landed.
4. **Search `git log`** if docs don't surface enough context.
5. **Present:** the decision, rationale, rejected alternatives, and when it happened. If the decision seems stale or context has changed, flag that.

---

## Mode: Scope

The user wants to figure out what to work on next.

1. **Read `ROADMAP.md`** — understand priorities and status.
2. **Read `SNAPSHOT.md`** — understand current state and active work.
3. **For each candidate** (topmost unstarted items), read its feature doc if one exists.
4. **Present options** with trade-offs: effort, dependencies, value, risk.
5. **If the user picks one:** help create or refine its feature doc and draft a plan if they want to start building.

---

## Mode: Execute

The user wants to do the next thing.

1. **Read `ROADMAP.md`** — find the topmost actionable item (`[next]` or first `[in-progress]`).
2. **Read its feature doc and plan** (if they exist).
3. **If no plan exists,** ask if they want one. For small tasks, a plan may be overkill.
4. **Execute the work.** Update docs as you go (CHANGELOG, ROADMAP status).
5. **When done:** archive plan, extract decisions, update ROADMAP to `[done]`, add CHANGELOG entry.

---

## Cross-cutting rules

These apply to ALL modes:

- **ROADMAP entries are hooks, not summaries.** Max ~10 words after the status tag.
- **Each doc has one job.** Duplication means one of them is wrong.
- **Principles are durable.** Would this survive a rewrite? If not, it's a convention or implementation detail.
- **Decisions have rejected alternatives.** No alternative = not a decision = goes in SNAPSHOT or CONVENTIONS.
- **CHANGELOG is historical — never rewrite old entries.**
- **When in doubt, ask.** One round-trip is cheap. Fabricated content rots permanently.
