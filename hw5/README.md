# HW 5
## CPSC 354
## Tyler Lewis
## Editor of choice: TextEdit

### Steps taken:

> Used file (LambdaNat0.cf)[https://github.com/alexhkurz/programming-languages-2022/blob/main/src/LambdaNat0/grammar/LambdaNat0.cf] from course repository to generate parser for Lambda Calc expressions

Build parser: bnfc -m --haskell grammar/LambdaNat0.cf && make

To parse (\ x.x): echo "\ x.x" | ./TestLambdaNat


bnfc parser:

```
------------------
-- Lambda Calculus
------------------

Prog.   Program ::= Exp ;
EAbs.   Exp ::= "\\" Id "." Exp ;  
EApp.   Exp ::= Exp Exp1 ; 
EVar.   Exp1 ::= Id ;

coercions Exp 1 ;

token Id (letter (letter | digit | '_')*) ; -- A letter followed by letters, digits, or underscores

comment "//" ; 
comment "/*" "*/" ;
```