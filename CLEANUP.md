# Cleanup Checklist for Publishing

This document outlines all the tasks needed to prepare this flake for publication.

## 1. Remove Development Files

### Files to Delete
- [ ] `__pyproject.toml` - Development Python project configuration
- [ ] `uv.lock` - UV lock file from development
- [ ] `devenv.lock` - Devenv lock file
- [ ] `devenv.nix` - Devenv configuration
- [ ] `devenv.yaml` - Devenv YAML config
- [ ] `.devenv/` - Devenv state directory (if exists)
- [ ] `.envrc` - Direnv configuration (if exists)
- [ ] `TODO.md` - Development TODO list
- [ ] `torch_build_gcc13_final.log` - Build log files
- [ ] `torch_build_cudnn9102.log` - Build log files
- [ ] Any other `*.log` files in root
- [ ] `/tmp/` cache files (if any were created in project)

### Directories to Review and Clean
- [ ] `.git/` - Review git history, consider squashing commits if needed
- [ ] `nix-retry-wrapper/` - Verify all files are necessary
- [ ] `test-retry-wrappers.nix` - Decide if test suite should be published

## 2. Update Documentation

### README.md
- [ ] Create or update `README.md` with:
  - [ ] Project description
  - [ ] Features (CUDA 12.6, Pascal support, multiple Python versions)
  - [ ] Installation instructions
  - [ ] Usage examples
  - [ ] Quick start guide
  - [ ] Available packages list
  - [ ] System requirements
  - [ ] License information

### Add Usage Examples
```nix
# Example 1: Using in flake.nix
inputs.torch-cu126.url = "github:YOUR_USERNAME/YOUR_REPO";

# Example 2: Using with nix run
nix run github:YOUR_USERNAME/YOUR_REPO#test-torch-pascal

# Example 3: Building specific package
nix build github:YOUR_USERNAME/YOUR_REPO#torch-bin-cu126-pascal-py313
```

### Document Package Structure
- [ ] Document the package naming scheme:
  - `torch-bin-cu126-py{VERSION}` - Regular cuDNN 9.13.0
  - `torch-bin-cu126-pascal-py{VERSION}` - Pascal-compatible cuDNN 9.10.2
  - `python{VERSION}-torch-cu126` - Python environment with torch
  - `python{VERSION}-torch-cu126-pascal` - Python environment with Pascal torch

## 3. Review and Clean Code

### flake.nix
- [ ] Remove commented-out code
- [ ] Verify all package definitions are correct
- [ ] Check that descriptions are accurate
- [ ] Review overlay implementation
- [ ] Verify NixOS module is complete and documented

### torch-bin-cu126/
- [ ] Verify `binary-hashes.nix` is complete for both 2.9.1 and 2.10.0
- [ ] Ensure `generate-hashes.py` has proper shebang and is executable
- [ ] Clean up `gen-binary-hashes.sh` or remove if redundant
- [ ] Verify `override.nix` handles all edge cases
- [ ] Check `cuda-packages-pascal.nix` has correct cuDNN 9.10.2

### nix-retry-wrapper/
- [ ] Review if retry wrappers should be included in public release
- [ ] If keeping: Document their purpose and usage
- [ ] If removing: Test builds without them
- [ ] Consider making them optional

### test-torch.py
- [ ] Add better error handling for missing GPU
- [ ] Add option to skip GPU tests on CPU-only systems
- [ ] Make output more user-friendly
- [ ] Consider adding `--help` flag

## 4. Licensing

- [ ] Add LICENSE file (choose appropriate license)
- [ ] Add license headers to source files if required
- [ ] Review NVIDIA redistribution terms for cuDNN/CUDA
- [ ] Document any third-party licenses

## 5. Metadata and Configuration

### flake.nix metadata
- [ ] Update `description` field
- [ ] Verify all outputs are documented
- [ ] Add proper metadata for apps

### Git Configuration
- [ ] Create `.gitignore` if not present with:
  ```
  *.log
  result
  result-*
  .direnv/
  .devenv/
  __pycache__/
  *.pyc
  .envrc
  ```
- [ ] Review what's tracked in git
- [ ] Consider using `git clean -fdx` to remove untracked files

## 6. Testing Before Publication

### Build Tests
- [ ] `nix flake check` passes
- [ ] Build all Python versions (311, 312, 313)
- [ ] Build both regular and Pascal variants
- [ ] Verify cuDNN versions are correct:
  - Regular: 9.13.0.50
  - Pascal: 9.10.2.21

### Runtime Tests
- [ ] `nix run .#test-torch-pascal` works
- [ ] `nix run .#test-torch` works  
- [ ] `nix run .#test-torch-pascal-py311` works
- [ ] `nix run .#test-torch-pascal-py312` works
- [ ] Import test succeeds on clean system

### Integration Tests
- [ ] Test overlay with another flake
- [ ] Test NixOS module integration
- [ ] Verify environment packages include all dependencies

## 7. Repository Structure

### Recommended Final Structure
```
.
├── flake.nix
├── flake.lock
├── README.md
├── LICENSE
├── CLEANUP.md (this file - can be removed after cleanup)
├── test-torch.py
├── torch-bin-cu126/
│   ├── binary-hashes.nix
│   ├── cuda-packages-pascal.nix
│   ├── generate-hashes.py
│   ├── override.nix
│   └── manifests/
│       ├── cudnn/
│       │   ├── redistrib_9.10.2.json
│       │   └── redistrib_9.11.1.json
│       └── libcutensor/
│           └── redistrib_2.1.0.json
├── nix-retry-wrapper/ (optional - consider removing)
└── test-retry-wrappers.nix (optional - consider removing)
```

## 8. Documentation to Add

- [ ] `CONTRIBUTING.md` - If accepting contributions
- [ ] `CHANGELOG.md` - Version history
- [ ] Examples directory with common use cases
- [ ] Architecture diagram showing package relationships
- [ ] Troubleshooting guide for common issues

## 9. Performance and Optimization

- [ ] Review if all CUDA packages are necessary
- [ ] Check closure sizes of packages
- [ ] Verify no unnecessary dependencies
- [ ] Consider lazy evaluation where possible

## 10. Publication Checklist

### GitHub (or hosting platform)
- [ ] Create repository
- [ ] Add description and topics
- [ ] Enable issues if accepting bug reports
- [ ] Add README badges (build status, license, etc.)
- [ ] Tag first release (v1.0.0)

### Flake Registry (optional)
- [ ] Submit to flakehub.com or similar
- [ ] Add to awesome-nix lists if applicable

### Announcement
- [ ] Post on NixOS Discourse
- [ ] Share on relevant communities
- [ ] Update personal/organization documentation

## 11. Post-Publication Maintenance

- [ ] Set up CI/CD for testing (GitHub Actions, etc.)
- [ ] Monitor for PyTorch updates
- [ ] Watch for CUDA/cuDNN version changes
- [ ] Plan for regenerating hashes when new versions release
- [ ] Document update procedure

## Notes

### Retry Wrappers Decision
The retry wrappers were added to handle intermittent build failures. Options:
1. **Keep them**: Document as a reliability feature
2. **Remove them**: If builds are now stable
3. **Make optional**: Let users opt-in via override

Recommendation: Test without them first. If builds are stable, remove to simplify.

### Version Support Strategy
- Currently supports PyTorch 2.9.1 and 2.10.0
- Consider: How often to add new PyTorch versions?
- Suggestion: Automate hash generation for new releases

### Pascal Support
- Well-documented rationale for cuDNN 9.10.2
- Consider adding compute capability detection in test script
- Maybe add warning if non-Pascal GPU detected with Pascal variant

## Final Steps

1. Run through entire checklist
2. Test on fresh clone
3. Ask someone else to test
4. Tag version 1.0.0
5. Publish!