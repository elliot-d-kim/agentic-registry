---
name: pickup-cc
description: >
  Resume work at the start of a fresh Claude Code session (after /compact, /clear, or a new session)
  by loading the committed handoff, reading the source docs first-hand, and continuing the next step
  WITHOUT a confirmation double-check. Use when the user opens a session with a resume cue — trigger
  phrases: "pickup-cc", "pickup from handoff", "pick up from the handoff", "pick up where we left off",
  "continue from where we left off", "resume", "resume the work", "continue" (as a session-opening
  resume, not a mid-task nudge). Companion to `handoff-cc`: it consumes the committed `docs/handoffs/`
  pointer + the durable in-repo docs and proceeds. The point is to SKIP the ceremonial "here's my plan,
  shall I proceed?" round-trip the user finds repetitive.
---

# pickup-cc

Resume cleanly after a compact/clear/handoff. The user wants the read-everything-then-double-check pattern replaced with: **get oriented, read the real source, and just continue.** The double-check is the friction to remove — not the reading. Showing your understanding and a quick plan up front is *welcome*; what's removed is the **waiting for sign-off**, not the reading or the plan.

## Do this, in order

1. **Load the handoff + background.** Read the **latest** handoff in `docs/handoffs/*.md` (lexically last = most recent) — the committed pointer that survives across sessions, including fresh cloud containers. Treat it as a **pointer, not the truth.** Auto-memory (`MEMORY.md` + memories) is auto-loaded where it exists (local sessions) and is **absent in cloud** — treat it as background, not the handoff itself.
2. **Read the named source docs FIRST-HAND.** The handoff deliberately under-describes the state to force this. Open the actual docs it points to — roadmap/plan, status index, evaluation/scoring artifacts, specs, the working files themselves — and read them directly. **Do not act on the handoff summary alone.** Recalled-memory content reflects what was true when written; verify a named file/flag/function still exists before relying on it.
3. **Verify the working state** the docs assume (branch, clean tree, a test harness banner) before changing anything.
4. **Post a short orientation + plan, and mirror it into `TodoWrite` — then keep going.** In a few concise lines, show you actually read the source (not just the handoff): the track/doc you loaded, the state you verified (branch, working tree, a key fact or two), and the next step. Lay the plan out as a short bullet list and create a matching `TodoWrite`. This proves understanding and makes the plan legible — it's a **statement of intent you act on immediately**, not a "shall I proceed?" checkpoint.
5. **Continue in the same turn — no confirmation gate.** Acting on the plan you just posted, do the next step named by the roadmap/handoff. **Do NOT wait for approval or ask "should I proceed?"** — proceed and report as you go, updating the todos.

## When you ARE allowed to stop and ask
Removing the *ceremonial* double-check does not remove real judgment. Still pause to ask when:
- there's a **genuine blocker** (a decision the docs don't resolve, a missing credential, a destructive/irreversible or outward-facing action that needs sign-off);
- the source docs **contradict each other or the handoff**, or the "next step" is genuinely ambiguous;
- a **standing rule** requires confirmation (e.g. commit/push only when asked) — honor it.

Otherwise: continue. The orientation + plan + todos from step 4 are your "picking up X → doing Y" — post them and keep moving; no approval round-trip.

## What this is not
- Not "skip the reading" — reading the source first-hand is the load-bearing part.
- Not "act autonomously on anything" — durable confirmations and real decision points still hold.
- Not a substitute for `handoff-cc` — they're a pair (write the committed pointer; then read-and-continue from it).
