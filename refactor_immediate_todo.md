# All immediate tasks complete

---

## HLD type + hldHelpers injection (this session)

### What changed

- `concretise/hld-helpers.nix`: added `isHLD` helper
  (`x: x._isHighLevelDerivation or false`) alongside the existing
  `getVersionsFromCudaFiles` / `getVersionsFromVersionFiles` functions.

- `pkgs/hld-type.nix` (new file): exports `mkHLD`, a constructor/validator
  function for HLD attrsets.
  - Required fields: `packageName`, `highLevelDeps`, `getVersions`, `buildBin`,
    `buildSource`
  - Optional fields: `data` (defaults to `{}`)
  - Throws with a clear diagnostic on missing or unknown fields
  - Automatically stamps the result with `_isHighLevelDerivation = true` and
    fills in `data = {}` so HLD authors never set those manually

- `pkgs/default.nix`: extended fixed-point scope with a `utilities` attrset
  (`{ hldHelpers, mkHLD }`) that is merged into the internal scope before the
  per-package entries.  The returned (external) scope still contains only the
  three HLD attrsets — utilities are not exported.

- `pkgs/torch/high-level.nix`: signature changed from `{ }:` to
  `{ hldHelpers, mkHLD }:`; `let hldHelpers = import …;` block removed; return
  value wrapped with `mkHLD { … }`; `_isHighLevelDerivation = true` removed.

- `pkgs/flash-attn/high-level.nix`: same treatment; `assert` updated from
  `torch._isHighLevelDerivation or false` to `hldHelpers.isHLD torch`.

- `pkgs/causal-conv1d/high-level.nix`: same treatment as flash-attn.

### Effect for future package authors

Adding a new package under `pkgs/<name>/high-level.nix` now requires only:
1. Declare `{ hldHelpers, mkHLD }:` (plus any peer HLD names) as arguments.
2. Return `mkHLD { packageName = …; highLevelDeps = …; getVersions = …;
   buildBin = …; buildSource = …; }`.
3. Misspelled or missing fields are caught immediately at evaluation time with
   a clear error from `mkHLD`.

---

## Previous completed work (kept for reference)

- Steps 7a + 7b + 7c complete
- pkgs/ refactor complete (torch/, flash-attn/, causal-conv1d/ → pkgs/)
- Compiler-version validation in concretise/default.nix complete
- Cross-concretise mixing detection (concretiseMarker + checkedWithPackages) complete

---

# Next steps (longer term)

- Implement `buildSource` / the four-derivation split described in
  `refactor_plan.md` — this is the main remaining feature
- 7c mixing check limitation: only fires via `result.python.withPackages`;
  document this when buildSource lands