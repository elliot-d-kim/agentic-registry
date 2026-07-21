# shadcn

shadcn component-family adapter: one plugin carries both delivery lanes of the shadcn design
system plus the official MCP server, so the pieces travel together and toggle as one unit.

Two kinds of content ship here:

- **Vendored (external source of truth):** `skills/shadcn/` is a byte-identical copy of the
  official shadcn skill from
  [`shadcn-ui/ui`](https://github.com/shadcn-ui/ui/tree/main/skills/shadcn), at the commit
  pinned in `UPSTREAM.md`. Upstream docs: [ui.shadcn.com](https://ui.shadcn.com).
- **Authored (written for this plugin):** `skills/basecoat/` and
  `references/theme-contract.md`. The basecoat skill is not copied from anywhere — no official
  Basecoat skill exists — but it documents an external library:
  [Basecoat](https://basecoatui.com) ([`hunvreus/basecoat`](https://github.com/hunvreus/basecoat),
  [`basecoat-css` on npm](https://www.npmjs.com/package/basecoat-css)).

## Contents

| Path | Provenance | What it is |
|---|---|---|
| `skills/shadcn/` | Vendored from [`shadcn-ui/ui`](https://github.com/shadcn-ui/ui/tree/main/skills/shadcn) | React lane: CLI workflows, component rules, registries, MCP usage |
| `skills/basecoat/` | Authored here; documents [Basecoat](https://basecoatui.com) | HTML lane: shadcn-look markup without React (pinned CDN or npm+Tailwind) |
| `references/theme-contract.md` | Authored here | The shared CSS-variable contract both lanes consume; a theme written once serves both |
| `.mcp.json` | Wires the official [shadcn MCP server](https://ui.shadcn.com/docs/mcp) | `npx shadcn@latest mcp`, registered when the plugin is enabled |
| `UPSTREAM.md` | — | Vendoring provenance (pinned commits) and the manual sync procedure |
| `LICENSE-shadcn-ui` | Copied from upstream | MIT license text covering the vendored skill |

## Lanes

- React project → the `shadcn` skill applies (components as source via the shadcn CLI, with
  the MCP server for search/browse/install).
- Plain HTML, server-rendered templates, htmx/Alpine, static pages → the `basecoat` skill
  applies.

## Theming

Both lanes consume the shadcn CSS-variable contract; see `references/theme-contract.md`.
Themes from shadcn theme generators drop into either lane unchanged.

## Updates

Vendored content is synced manually, on request, at pinned upstream commits — procedure and
current pins in `UPSTREAM.md`. Authored content (`basecoat` skill, theme contract) versions
with this plugin; its version-pinned facts (Basecoat release, CDN URLs) track the Basecoat
releases linked above.
