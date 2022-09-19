with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    ghc 
    cabal-install
    haskellPackages.BNFC
    haskellPackages.alex
    haskellPackages.happy
  ];
}
