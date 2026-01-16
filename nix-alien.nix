{
  lib,
  fzf,
  nix-index,
  python3,
}:

let
  deps = (lib.importTOML ./src/pyproject.toml).project.dependencies;
in
python3.pkgs.buildPythonApplication {
  version = "0.1.0+ro";
  pname = "nix-alien";
  format = "pyproject";

  src = ./src;

  nativeBuildInputs = [ fzf ];

  propagatedBuildInputs =
    with python3.pkgs;
    [
      nix-index
      setuptools
    ]
    ++ (lib.attrVals deps python3.pkgs);

  meta = with lib; {
    description = "Run unpatched binaries on Nix/NixOS";
    homepage = "https://github.com/thiagokokada/nix-alien";
    license = licenses.mit;
    mainProgram = "nix-alien";
    platforms = platforms.linux;
  };
}
