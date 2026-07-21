---
name: basecoat
description: Build shadcn-look interfaces without React — plain HTML, server-rendered templates (Jinja, Nunjucks, Rails), htmx or Alpine stacks, static pages — using Basecoat (basecoat-css) component classes, data-attribute variants, vanilla-JS behaviors, and shadcn-compatible theming. Use when a non-React surface should match shadcn/ui visuals or reuse an existing shadcn theme, when adding Basecoat to a page, or when writing or reviewing Basecoat component markup.
---

# Basecoat — shadcn's visual language without React

Basecoat (`basecoat-css`) is a vanilla HTML/CSS/JS implementation of the shadcn/ui design
system, authored in Tailwind CSS v4 and framework-agnostic. It consumes the same CSS-variable
contract as shadcn/ui, so a theme authored for one works in the other unchanged — the contract
lives in [theme-contract.md](../../references/theme-contract.md).

Examples below pin `1.0.2` (current at authoring). Pin an exact version in production markup
and keep the CSS and JS pinned to the same version.

## Install

**CDN (standalone — no Tailwind, no build step):**

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/basecoat.cdn.min.css">
<script src="https://cdn.jsdelivr.net/npm/basecoat-css@1.0.2/dist/js/all.min.js" defer></script>
```

The CDN bundle is precompiled and carries only the utilities Basecoat itself uses — do not
rely on arbitrary Tailwind utility classes on this path; write plain CSS for page layout.

**npm + Tailwind v4 (Tailwind required):**

```bash
npm install basecoat-css
```

```css
@import "tailwindcss";
@import "basecoat-css";
/* theme variable overrides load after Basecoat */
```

```js
import "basecoat-css/all";        // every behavior
// or selectively: import "basecoat-css/basecoat" (core, required first),
// then e.g. import "basecoat-css/dropdown-menu";
```

Order matters on both paths: Tailwind base → Basecoat → theme overrides.

**Style packs:** the default look is Vega. Seven alternates (nova, maia, lyra, mira, luma,
sera, rhea) ship as standalone bundles — `dist/basecoat-<style>.cdn.min.css` on the CDN or
`@import "basecoat-css/<style>"` via npm. Pick exactly one; never load one pack over another.

## Markup conventions

One component class on the root element; variants and sizes are `data-*` attributes, not
modifier classes; semantic child elements carry structure. Component classes include: `btn`,
`badge`, `alert`, `card`, `field`, `form`, `input`, `textarea`, `select`, `native-select`,
`checkbox`, `radio`, `switch`, `dialog`, `dropdown-menu`, `popover`, `tabs`, `table`,
`accordion`, `combobox`, `command`, `drawer`, `sidebar`, `toast`, `tooltip`, `skeleton`,
`progress`, `breadcrumb`, `avatar`, `kbd`.

```html
<button type="button" class="btn">Primary</button>
<button type="button" class="btn" data-variant="outline" data-size="sm">Small outline</button>
```

Button variants: `data-variant="primary|secondary|outline|ghost|link|destructive"` (primary is
the default, no attribute needed); sizes `data-size="xs|sm|default|lg|icon"` plus icon-xs /
icon-sm / icon-lg; icons inside a button take `data-icon="inline-start|inline-end"`.

Form field wrapper:

```html
<div role="group" class="field">
  <label for="email">Email</label>
  <input id="email" type="email" placeholder="m@example.com" />
  <p>Enter your email address.</p>
</div>
```

Card structure:

```html
<div class="card">
  <header><h2>Title</h2><p>Subtitle</p></header>
  <section>…content…</section>
  <footer>…actions…</footer>
</div>
```

For JS-driven components (dropdown-menu, select, combobox, tabs, …) the id/ARIA wiring between
trigger and popover is load-bearing — copy the full pattern from the component's page at
`basecoatui.com/components/<name>/` rather than improvising. Dropdown-menu skeleton: root
`div.dropdown-menu` containing a trigger `button[aria-haspopup][aria-controls][aria-expanded]`
and a `div[data-popover][aria-hidden]` wrapping `div[role="menu"]` with `div[role="menuitem"]`
children. Popover placement via `data-side` / `data-align` on the `[data-popover]` element.

## JavaScript behaviors

- Need JS: accordion, combobox, command, drawer, dropdown-menu, popover, range, select,
  sidebar, tabs, toast. CSS-only: btn, badge, alert, card, input, table, tooltip, skeleton,
  and the other static components.
- Dialog needs no Basecoat JS — it is the native `<dialog>` element:

```html
<button type="button" class="btn" onclick="document.getElementById('confirm').showModal()">Open</button>
<dialog id="confirm" class="dialog" onclick="if (event.target === this) this.close()">…</dialog>
```

- Initialization is automatic: components initialize on `DOMContentLoaded`, and a
  MutationObserver initializes dynamically injected markup (htmx swaps, fetch-rendered
  fragments) — no manual re-init in the common case.
- Manual control via `window.basecoat`: `initAll({force: true})` (e.g. after a history
  restore), `refresh(element)`, `theme.get()` / `theme.set('dark'|'light')` / `theme.toggle()`.
- Events: `basecoat:initialized` fires on a component's root when ready; `basecoat:themechange`
  fires on theme switch. Custom `select`/`combobox` submit through a hidden input and dispatch
  `change` with `event.detail.value`.

## Dark mode

The `.dark` class on `<html>` is the only mechanism — the shipped CSS has no
`prefers-color-scheme` fallback. `window.basecoat.theme` manages the class and persists the
choice to `localStorage` (`themeMode`). To honor the OS preference on first visit, run this
inline in `<head>` before the stylesheet (avoids a flash):

```html
<script>
  const saved = localStorage.getItem("themeMode");
  const dark = saved ? saved === "dark" : matchMedia("(prefers-color-scheme: dark)").matches;
  document.documentElement.classList.toggle("dark", dark);
</script>
```

## Theming

Basecoat consumes the shadcn/ui CSS-variable contract (`--background`, `--primary`,
`--accent`, `--ring`, `--radius`, `--chart-1..5`, and the rest) — the full set, semantic
roles, and authoring rules are in [theme-contract.md](../../references/theme-contract.md). A
theme from any shadcn theme generator drops in unchanged: load its variables after the
Basecoat stylesheet, with dark values under `.dark`.

## Lane boundary

Basecoat is the non-React lane. React projects take shadcn/ui itself — components added as
source via the shadcn CLI, registries, and MCP, covered by this plugin's `shadcn` skill.
