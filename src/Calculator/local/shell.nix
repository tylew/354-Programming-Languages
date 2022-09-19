with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    ghc 
    haskellPackages.BNFC
  ];
}
