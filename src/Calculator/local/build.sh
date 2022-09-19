#! /usr/bin/env nix-shell
#! nix-shell shell.nix
bnfc -m --haskell numbers.cf
make
ghc Calculator.hs
echo "1+2*3" | ./Calculator
