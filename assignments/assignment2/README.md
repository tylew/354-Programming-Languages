# README

## Critical appraisal

submission located in `LambdaNat5/test/mytests.lc` I have implemented all but LambdaNat5 `even`, which has been a bit of trouble. Will be back soon to update.

It is interesting that `#:#` does not parse, but `(#):#` does. Nothing in particular to me stands out in the interpreter to cause this. I would be curious to know why one gets parsed, and the other does not despite following grammar rules either way. I have a feeling this may be a reason similar to a problem I encountered in LambdaNat5 reverse and solved with parenthesis around the expression in front of the `:#`.

It was both difficult and interesting to program with a high reliance on recursion as required by LambdaNat5. I found myself wondering how functions like modulo and division are inplemented, and an awe of the programming languages I usually work in.

`LambdaNat4` introduced within the grammar the separator `;;` allowing for multiple functions to run in a series.

calculator focused on determining value by successors, LambdaNat5 uses call-by-value. `+,-,*` are used directly on an integer value, otherwise the expression will be left in its initial form. 

LambdaNat5 has a very limited scope of functions to work with, in comparison to Haskell with a wider array of usability. A more powerful programming language is a long way from LN5, but if one were to extend it to include loops and non-recurrsive variables it would start to become usable.

Does `weave` satisfy the invariant "the output-list is sorted if the input-lists are sorted"? I do not think so, consider the following expression:
```
weave 5:6:7:# 1:3:4:#

output: 5:1:6:3:7:4:#
```
The output is clearly not sorted whatsoever and thus does not satisfy the invariant to my understanding.



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
