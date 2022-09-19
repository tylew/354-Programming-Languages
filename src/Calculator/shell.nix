with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    ghc-8.10.7 
    haskellPackages.BNFC
    haskellPackages.alex
    haskellPackages.happy
  ];
}
