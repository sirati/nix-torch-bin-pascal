# Immediate TODOs

## Continue test runs

The following test cases still need to be built and run (in order — flash-attn last):

  nix build .#packages.x86_64-linux.test-mamba-py313-cu128 && nix run .#test-mamba-py313-cu128 --impure
  nix build .#packages.x86_64-linux.test-mamba-source-py313-cu128 && nix run .#test-mamba-source-py313-cu128 --impure
  nix build .#packages.x86_64-linux.test-example && nix run .#test-example --impure
  nix build .#packages.x86_64-linux.test-flash-attn-bin-py313-cu128 --max-jobs 7 --cores 6 && nix run .#test-flash-attn-bin-py313-cu128 --impure
  nix build .#packages.x86_64-linux.test-flash-attn-bin-py313-cu126 --max-jobs 7 --cores 6 && nix run .#test-flash-attn-bin-py313-cu126 --impure
  nix build .#packages.x86_64-linux.test-flash-attn-source-py313-cu128 --max-jobs 7 --cores 6 && nix run .#test-flash-attn-source-py313-cu128 --impure
  nix build .#packages.x86_64-linux.test-all-py313-cu128 --max-jobs 7 --cores 6 && nix run .#test-all-py313-cu128 --impure
  nix build .#packages.x86_64-linux.test-all-py313-cu126 --max-jobs 7 --cores 6 && nix run .#test-all-py313-cu126 --impure
  nix build .#packages.x86_64-linux.test-all-py313-cu130 --max-jobs 7 --cores 6 && nix run .#test-all-py313-cu130 --impure
  nix build .#packages.x86_64-linux.default --max-jobs 7 --cores 6 && nix run .#default --impure

## Test gen-hashes refactor

Run the refactored runner end-to-end (binary hashes only, single tag) for each
github-releases package to confirm the shared main + default regex work correctly:

  nix run .#default.flash-attn.gen-hashes -- --skip-source --tag v2.8.1
  nix run .#default.causal-conv1d.gen-hashes -- --skip-source --tag v1.6.0
  nix run .#default.mamba-ssm.gen-hashes -- --skip-source --tag v2.3.0

And for torch-website packages:

  nix run .#default.torch.gen-hashes -- --cuda cu128
  nix run .#default.triton.gen-hashes

Verify that the generated .nix files are identical to the existing ones (no content
change expected for github-releases packages — only the `# To regenerate:` comment
line changes from `nix-shell` to `nix run .#default.<pkg>.gen-hashes`).
For triton, per-version files are expected instead of `any.nix`.

## Known: cu126 GPU ops fail on RTX 5090

torch 2.10.0+cu126 was not built with sm_120 (Blackwell) support — the stress
test (`torch.randn(1024, 1024, device="cuda")`) raises
`cudaErrorNoKernelImageForDevice`.  cu128 and cu130 both support sm_120 and pass.

The cuDNN 9.15.1 fix (cuda-packages-cudnn-fix.nix + manifests) is in place and
working — both cu126 and cu130 now report cuDNN 91501.  The cu126 GPU failure is
a PyTorch wheel limitation, not a packaging bug.  No action needed unless a newer
torch version with cu126 + sm_120 support becomes available.