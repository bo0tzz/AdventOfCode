with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "pip-env";
  buildInputs = [
    # Python requirements (enough to get a virtualenv going).
    pipenv
    jetbrains.pycharm-professional
  ];
  src = null;
  shellHook = ''
    # Allow the use of wheels.
    SOURCE_DATE_EPOCH=$(date +%s)

    # Augment the dynamic linker path
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib:${readline}/lib
  '';
}
