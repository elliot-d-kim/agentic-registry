# Theme contract — the shared shadcn variable set

Both of this plugin's lanes — shadcn/ui (React components) and Basecoat (plain HTML) — consume
the same CSS custom-property contract. A theme authored once against this contract restyles
either lane unchanged, and theme generators that target shadcn/ui (e.g. TweakCN) produce output
that drops into both.

## Variables and roles

| Variable(s) | Role |
|---|---|
| `--background` / `--foreground` | Page surface and default text |
| `--card`, `--card-foreground` | Raised surfaces (cards, panels) |
| `--popover`, `--popover-foreground` | Overlay surfaces (menus, popovers, tooltips) |
| `--primary`, `--primary-foreground` | The functional accent: primary actions, active/selected emphasis |
| `--secondary`, `--secondary-foreground` | Secondary buttons and surfaces |
| `--muted`, `--muted-foreground` | Subdued fills and secondary text |
| `--accent`, `--accent-foreground` | Hover/selected wash — a subtle background tint. Naming trap: this is not the brand accent; `--primary` carries the accent |
| `--destructive`, `--destructive-foreground` | Destructive actions and error emphasis |
| `--border`, `--input` | Hairlines and form-control borders |
| `--ring` | Focus indicator; keep it in the same hue family as `--primary` |
| `--radius` | Corner-radius scale |
| `--chart-1` … `--chart-5` | Categorical data-series colors |
| `--sidebar`, `--sidebar-foreground`, `--sidebar-primary(-foreground)`, `--sidebar-accent(-foreground)`, `--sidebar-border`, `--sidebar-ring` | Sidebar component family; include when the theme should cover sidebars |

## Authoring rules

1. A theme is variable overrides only — no component-selector styling.
2. Load order: base stylesheet first, theme variables after (last-wins cascade).
3. Dark scheme lives under the `.dark` class on `<html>`, and the dark block sets
   `color-scheme: dark`. Neither lane's shipped CSS reacts to `prefers-color-scheme` on its
   own — honor the OS preference by toggling the class at startup, or expose a UI toggle.
4. Pair every surface variable with its `-foreground` partner, and keep each pair at
   WCAG AA (≥ 4.5:1 for text) in both schemes.
5. Any valid CSS color format works; upstream themes commonly ship OKLCH, plain hex is fine.

## Skeleton

```css
:root {
  --background: #ffffff;
  --foreground: #1f2328;
  --primary: #0969da;
  --primary-foreground: #ffffff;
  --ring: #0969da;
  /* …remaining pairs… */
}
.dark {
  color-scheme: dark;
  --background: #0d1117;
  --foreground: #e6edf3;
  --primary: #58a6ff;
  --primary-foreground: #0d1117;
  --ring: #58a6ff;
  /* …remaining pairs… */
}
```

## Bridging attribute-based scheme toggles

Pages that track color scheme with an attribute (e.g. `data-theme`) apply the contract by
mirroring the state onto the class:

```js
const t = document.documentElement.dataset.theme;
document.documentElement.classList.toggle("dark", t === "dark");
```
