# README

## Critical appraisal

Attempt at ERec. I am intrigued by the logic behind these functions and have attempted EMinusX but think utilizing the recurrsion would be useful but I am unsure on some things.

## Summary of Commands

To build the parser and interpreter run, in any `LambdaNatX` folder, the following from the command line. 

```
./build.sh
```
or
```
cd grammar
bnfc -m --haskell LambdaNat0.cf
make
cd ..
cp grammar/*.hs src
make build
```
