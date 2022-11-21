# README

## Critical appraisal

It is interesting that `#:#` does not parse, but `(#):#` does. Nothing in particular to me stands out in the interpreter to cause this. I would be curious to know why one gets parsed, and the other does not despite following grammar rules either way. I have a feeling this may be a reason similar to a problem I encountered in reverse and solved with parenthesis around the expression in front of the `:#`.


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
