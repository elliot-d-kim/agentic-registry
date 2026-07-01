---
name: handoff-cc
description: >
  Write a Claude Code-tuned handoff so a fresh session (after /compact or /clear) can continue the work.
  Use this whenever the user is about to compact, clear, or end a session and wants to pick up cleanly
  later — trigger phrases: "handoff-cc", "prep handoff", "prep for compact", "prep to compact", "prepare
  to clear", "checkpoint before compacting", "write a handoff", "I'm going to compact/clear". This is the
  generic `handoff` skill with three Claude Code adjustments: (1) write the handoff POINTER-STYLE and
  deliberately under-summarized; (2) persist it to committed git (`docs/handoffs/`), NOT the OS temp dir
  or auto-memory, so it survives a fresh cloud container; (3) pair it with `pickup-cc` by baking in the
  "read source first-hand, then continue without a double-check" contract. Companion to `pickup-cc`.
---

# handoff-cc

Write a handoff so a fresh Claude Code session can resume the work. This is the generic `handoff` skill (summarise the conversation, include a suggested-skills section, reference other artifacts by path instead of duplicating them, redact secrets/PII) **with the adjustments below** — most importantly, it is **saved into the repo (committed), not the OS temp dir.** If the user passed arguments, treat them as the focus of the next session and tailor accordingly.

## The three adjustments (this is the whole point)

### 1. Pointer-style, deliberately under-summarized
The handoff is a **map to the source, not a replacement for it.** A rich summary tempts the next session to act on the handoff alone and skip the actual docs — exactly the failure to avoid. So:
- **Name the next step and the docs to read — do NOT reproduce the detailed state.** Where you'd write a paragraph of current state, write "read `<path>` first-hand" instead.
- Open the doc with an explicit warning: *"This is a pointer, not a summary. Do NOT act on this file alone — read the source docs below first-hand."*
- Reference everything by path/URL (specs, plans, evaluation artifacts, commits). Don't paste their contents.

### 2. Durable layer = committed git, never `/tmp` or auto-memory
The OS temp dir does **not** survive a cloud session: every remote (`CLAUDE_CODE_REMOTE=true`) session is a fresh container, so `/tmp` is wiped on teardown — and there is no `~/.claude/MEMORY.md` in cloud either. A handoff written to `/tmp`, or a fact left only in auto-memory, is simply **gone** before the next session starts. The only thing that survives is **committed git.** So:
- Write the handoff into the repo at **`docs/handoffs/<timestamp>-<topic-slug>.md`** and **commit it** — and in cloud, **push it** so it rides the session's branch/PR off the ephemeral instance.
  - Timestamp via `date -u +%Y-%m-%d-%H%M` (add `%S` if two handoffs could land in the same minute), then the slug — e.g. `docs/handoffs/2026-06-05-2231-cloud-writeback.md`. Lexical order = chronological, so `pickup-cc` reads the **latest** file.
- Do **not** rely on auto-memory as the durable layer (absent in cloud; and per this initiative, durable facts live in versioned homes, not auto-memory).
- **Invoking this skill authorizes committing the handoff file itself** — the one exception to "commit only when asked," because the committed file *is* the durable artifact. Still **redact** secrets/PII first, commit on the working branch (follow repo branch norms — don't commit to a protected default directly), and push only when in cloud (or when the user asks).

### 3. Bake in the pickup contract
End the handoff with the behavior the next session should follow — the same contract `pickup-cc` enforces:

> **"pickup from handoff" / "continue" means:** read the latest `docs/handoffs/` entry + the named source docs first-hand → **continue with the next step without asking me to confirm.** Only stop on a genuine blocker or a real ambiguity the docs don't resolve. Don't re-present a plan for approval.

## The resume block (top of every handoff)

Every handoff opens — **above the pointer banner** — with a copy-paste resume block, so the user can start a fresh session and trigger pickup without retyping the branch or filename, and so the next agent maps the prompt straight to this doc. Exact shape:

````
# Handoff — <title>

**Local working tree:** `<path>` (branch `<branch>`) — a dedicated `.worktrees/<name>` worktree, or the repo-root checkout

`/pickup-cc` prompt:
```
/pickup-cc <context phrase> — @<this doc's repo-relative path> (branch <branch>)
```

---

> **Pointer, not a summary. …**   ← the adjustment-1 banner follows here
````

Fill it in:
- **`<context phrase>`** — a few content-ful words for the track (e.g. `Linx eval-set curation`). Lead with the project/track and use real words: the fresh session auto-titles from this line, so an empty or generic phrase yields a junk tab name (e.g. "pickup credit card").
- **`<path>` + `<branch>`** — where the work lives and the branch it's on, the two coordinates the next session needs. Say which kind of working tree it is: a **dedicated `git worktree`** (e.g. `.worktrees/eval-set`) — where the branch is bound to that directory, so `cd`-ing in lands the next session on the right branch automatically — **or the repo-root checkout** on `<branch>`. This line is the single home for the branch (the title no longer repeats it), keeping the "where to resume" coordinates together in one place. Drop the line if there's no particular working tree to sit in (e.g. plain work on the default branch in the repo root).
- **`@<path>`** — this handoff's own repo-relative path, so a session opened in that working tree resolves it directly. `pickup-cc` reads the doc regardless, so the `@` is convenience, not load-bearing.
- The fenced line is the literal paste — it leads with `/pickup-cc`, no surrounding backticks.

**Then print it to the user in chat** (the QoL payoff — they paste it straight into the next session): the local `cd` plus the prompt.

```
Resume in a fresh session:

  cd <absolute worktree path>        # local machine only

  /pickup-cc <context phrase> — @<doc path> (branch <branch>)
```

The `cd` is **local-only** (a cloud container has a different layout) — label it so, and keep it in the chat output, **not** in the committed doc (the doc just names the working tree).

## Default: include a verbatim "Recent conversation" section
The pointer-style state above captures *where the work is*; it does **not** capture *how the user's intent evolved* — the exact asks, corrections, and constraints that produced the current state. That intent is the most expensive thing to reconstruct after a compact and the easiest to lose. So **by default, end the handoff with a "Recent conversation" section** covering the recent relevant turns:
- **User turns: verbatim.** Reproduce the user's inputs word-for-word (redacting only secrets/PII). Paraphrase loses the precise wording, corrections, and priorities the user chose — which is exactly the signal worth preserving.
- **Agent turns: condense to the concepts the user engaged with — not a bare activity log.** Preserve the load-bearing ideas, claims, or options the user's next turn reacts to (what they push back on, qualify, build on, or approve), so their verbatim response stays legible and the reasoning is traceable. Less verbose than the full turn, but not lossy on the points that mattered. Point to artifacts instead of reproducing them.
- **Label turns `User:` and `Agent:` — no first-person.** It is a third-person record; never "I" / "me" / "my".
- This is the **one place** the handoff is deliberately fuller than pointer-style — here the fidelity *is* the point, and it does not invite acting-on-the-handoff-alone (it's a record of intent, not of state). Keep it to the turns since the last handoff (or the session's relevant arc), not the entire history.

## Two tiers: ephemeral handoffs → periodic durable rollup

`docs/handoffs/` is the **frequent, ephemeral** layer — one cheap pointer per handoff, committed so it survives. The **durable docs** (roadmap / status index / spec) are the **consolidated** layer, and they are **not** rewritten on every handoff. Instead:
- When `docs/handoffs/` has accumulated past a **soft, judgment threshold** — roughly **≥5 entries or spanning more than ~a day** (use judgment, surface it in-flight; it is not a hard rule) — propose a rollup: *"N handoffs have piled up in `docs/handoffs/` since `<date>` — want me to distill their takeaways into `<ROADMAP/status doc>` and clear them?"*
- On rollup (with the user's go-ahead): consolidate the sum takeaways into the durable docs, then **delete** the consumed handoff files (git history keeps them for provenance). This keeps `docs/handoffs/` lean and the durable docs authoritative.

## Process

1. **Ask a few alignment questions up front.** Before capturing threads or writing anything, ask the user a small number of targeted questions whose answers would change what the next session does — what to prioritize next, what's genuinely settled vs. still open (see *Don't presume the last turn was approved*), and any constraint or intent not yet written down. Keep it light — a couple of clarifying questions to lock alignment, not a relentless interview; the user is wrapping up, so skip anything the session already makes clear.
2. **Capture every live thread into durable docs *first*.** The handoff is a pointer — so the comprehensive docs it points to must already exist. Before writing it, sweep the session for threads **big and small** and ensure each is captured in a doc **whose type matches the thread's maturity**: an early or uncertain thread → *exploration / research notes, open questions, requirements-in-progress*; a genuinely settled thread → *roadmap, status index, design doc, spec*. **Most live threads are mid-exploration — default to the research-stage forms; reaching for "design doc" or "spec" by default manufactures a finality the work doesn't have.** A thread that lives only in the conversation has nothing for the pointer to point at — **write it down first** (don't lean on the verbatim Recent-conversation section as a substitute). "Comprehensive" means good coverage across threads, not length. Within each doc, separate what's *crystallized* (enduring) from what's *still open* (tentative), and **keep the body's tone matched to the maturity** — a "draft" banner on confident, design-sounding prose still loads as decided for a future agent, so write an exploratory thread in exploratory terms *in the body itself* (findings / questions / requirements-in-progress, not asserted architecture). The handoff points at these docs; it doesn't duplicate them.
3. **Write the handoff** to `docs/handoffs/<timestamp>-<topic-slug>.md`, pointer-style, with:
   - the **resume block** at the very top, above everything else (see *The resume block* above);
   - the **pointer/warning** preamble (adjustment 1);
   - **how to pick up, in order:** the named source docs to read first-hand → how to verify (branch, clean tree, test harness) → the next step;
   - **constraints/conventions** the next session must honor (commit policy, branch state, project rules) — by reference where possible;
   - a **suggested-skills** section (invoke as the work dictates, not all up front);
   - a **"Recent conversation"** section — recent relevant turns, **user verbatim + assistant summarized** (see the Default section below);
   - the **pickup contract** (adjustment 3).
4. **Redact** secrets/PII, then **commit** the handoff — and in cloud, **push** it so it survives teardown.
5. If `docs/handoffs/` is past the rollup threshold, **offer the rollup** (above).
6. Tell the user where the handoff is (`docs/handoffs/...`), **print the resume block's chat form** (the local `cd` + the `/pickup-cc` prompt, per *The resume block*) so they can paste it straight into the next session, confirm the durable docs are current, and note they can `/compact` (or `/clear`) then resume with `pickup-cc` / "continue".

## Don't presume the last turn was approved
A handoff is **not** a claim that everything just produced is signed off — "handoff" ≠ "the most recent assistant turn was satisfactory in its entirety." Capture the **real approval state per thread**: what's **locked**, what's **drafted-pending-adjustment**, what the user **explicitly approved** vs merely **didn't object to**. The user may be satisfied *enough to compact* while still intending separate adjustments. Frame the next step in those terms — often "pick up the user's pending/segmented adjustments," not "continue from where I stopped" — and don't auto-advance to the next stage unprompted.

## What this is not
- Not a full state dump — that's what the source docs are for (an over-dump defeats the purpose).
- Not a `/tmp` or auto-memory artifact — it's a **committed** pointer that survives a fresh cloud container.
