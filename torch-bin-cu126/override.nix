{ pkgs, cudaPackages, torchVersion ? "2.10.0" }:

let
  # Get the Python version (e.g., "3.13")
  pythonVersion = pkgs.python3.pythonVersion;

  # Convert to pyXXX format (e.g., "3.13" -> "py313")
  # Note: For free-threaded Python, this would be "py313t"
  pyVer = "py${builtins.replaceStrings ["."] [""] pythonVersion}";

  # Detect OS and architecture from stdenv.system
  # stdenv.system examples: "x86_64-linux", "aarch64-linux", "x86_64-darwin"
  systemParts = builtins.split "-" pkgs.stdenv.system;
  arch = builtins.elemAt systemParts 0;  # e.g., "x86_64" or "aarch64"
  osName = builtins.elemAt systemParts 2; # e.g., "linux" or "darwin"

  # Map Nix OS names to wheel OS names
  os = if osName == "linux" then "linux"
       else if osName == "darwin" then "darwin"
       else if osName == "mingw32" || osName == "cygwin" then "windows"
       else throw "Unsupported OS: ${osName}";

  # Import binary hashes for the requested torch version
  versionData = import ./binary-hashes.nix torchVersion;

  # Navigate the nested structure: version -> pyXXX -> os -> arch
  wheelData =
    if builtins.hasAttr pyVer versionData then
      let pyData = versionData.${pyVer}; in
      if builtins.hasAttr os pyData then
        let osData = pyData.${os}; in
        if builtins.hasAttr arch osData then
          osData.${arch}
        else throw "Unsupported architecture for torch ${torchVersion}: ${arch} (available: ${builtins.toString (builtins.attrNames osData)})"
      else throw "Unsupported OS for torch ${torchVersion}: ${os} (available: ${builtins.toString (builtins.attrNames pyData)})"
    else throw "Unsupported Python version for torch ${torchVersion}: ${pyVer} (available: ${builtins.toString (builtins.attrNames versionData)})";

in
# First, override the function arguments to use our CUDA 12.6 packages
(pkgs.python3Packages.torch-bin.override {
  cudaPackages = cudaPackages;
}).overrideAttrs (old: {
  # Then override the source to use the CUDA 12.6 wheel
  # Note: The same binary wheel works for both regular and Pascal variants
  # The difference is only in the CUDA runtime libraries (cuDNN, cuTENSOR versions)
  src = pkgs.fetchurl wheelData;
})
