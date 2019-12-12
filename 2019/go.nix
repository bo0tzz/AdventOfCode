with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "go-env";
  buildInputs = [
    # Python requirements (enough to get a virtualenv going).
    go_bootstrap
    jetbrains.goland
  ];
  shellHook = ''
    export GOPATH=/home/boet/go
  '';
}
