# Upstream provenance

Vendored content in this plugin. Vendored files are never edited locally — the byte-identity
invariant is that `git hash-object <file>` equals the upstream blob SHA at the pinned commit.

| Local path | Upstream repo | Upstream path | Pinned commit | Fetched | License |
|---|---|---|---|---|---|
| `skills/shadcn/` (entire directory, 15 files) | `shadcn-ui/ui` | `skills/shadcn/` | `20442886c5cfb440441c35030462fbdf64838655` | 2026-07-20 | MIT (`LICENSE-shadcn-ui`, copied from upstream `LICENSE.md`) |

## Sync procedure (manual, on request)

1. Resolve the new upstream commit: `gh api repos/shadcn-ui/ui/commits/main --jq .sha`.
2. List the tree at that commit:
   `gh api "repos/shadcn-ui/ui/git/trees/<sha>:skills/shadcn?recursive=1" --jq '.tree[] | select(.type=="blob") | .path + " " + .sha'`.
3. Compare each listed blob SHA against `git hash-object` of the local copy; re-fetch changed
   or added blobs (`gh api repos/shadcn-ui/ui/git/blobs/<blob-sha> --jq .content | base64 -d`),
   delete removed files.
4. Review the diff, update the pinned commit and date in the table above, bump the plugin
   version in `.claude-plugin/plugin.json`, and commit.
