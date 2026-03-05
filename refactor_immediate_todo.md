## flash-attn source + all-packages source builds still untested

`test-flash-attn-source-py313-cu128` and `test-all-py313-cu128` were queued
to build when the session ended.  Run and confirm they pass:

```
nix run .#test-flash-attn-source-py313-cu128
nix run .#test-all-py313-cu128
```

## torch 2.10 test coverage – confirm or add

All cu128 test cases already have a torch-2.10 counterpart (the `-from-source-`
and `-source-` variants).  Verify with the user that no additional explicit
`torch210`-named packages are wanted; if they are, add them to `test.nix`
following the existing pattern.