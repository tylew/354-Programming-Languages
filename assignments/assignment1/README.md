# Assignment 1

### https://github.com/alexhkurz/programming-languages-2022/blob/main/assignment-1.md

## Critical Appraisal Overview
<div style="padding-left: 1.5em">
The Critical Appraisal is worth 5 points for each part. My general expectation is that you use the critical appraisal to

be upfront about any requirements not implemented, or any remaining bugs you know of;
highlight what you learned doing this assignment; describe salient points of particular interest to you. Specifically for this assignment,

for Part 1, choose 5 functions for which you show the computation using equational reasoning, similar to what I asked you to do in hw3;
for Part 2, also include discussions on what order of operations you designed for your calculator, what examples you used to guide this design, how the grammar reflects these design decisions. The number of points awarded will depend on how interesting your critical appraisal is.

You can also use the critical appraisal to give me feedback on what was difficult, or what could be changed in the future.
</div>

## Part 1

Equational reasoning for five selected functions detailed in Part1 of this repository

<!-- 
addI :: II -> II -> II
addI (II a b) (II c d) = II (addN a c) (addN b d)

dd natural numbers
addN :: NN -> NN -> NN
addN O m = m
addN (S n) m = S (addN n m) 

-->
addI
```
addI (II O O) (II (S (S O)) O)  
    addN (O (S (S O)) )
        (S (S O))
    addN (O O)
        O
II (S (S O)) O
```
<!-- 
-- add natural numbers
addN :: NN -> NN -> NN
addN O m = m
addN (S n) m = S (addN n m)
 -->
addN
```
addN (S (S O)) (S O)  
    S (addN (S O) (S O) )
        S (addN O (S O))
            (S O)
S (S (S O))
```
<!-- 
nn_int :: Integer -> NN
nn_int 0 = O 
nn_int m = S (nn_int (m-1))
-->
nn_int
```
nn_int 4
    S (nn_int (3))
        S (nn_int (2))
            S (nn_int (1))
                S (nn_int (O))
                    O
S (S (S (S O)))
```
<!--  
-- Precondition: Inputs are positive
pp_int :: Integer -> PP
pp_int 1 = I
pp_int m = T (pp_int (m - 1))
-->
pp_int
```
pp_int 4 
    T (pp_int (3) )
        T (pp_int (2) )
            T (pp_int (1) )
                I
T (T (T I))
```
<!--  
int_pp :: PP->Integer
int_pp I = 1
int_pp (T n) = 1 + (int_pp n)
-->
int_pp
```
int_pp (T (T (T I)))
    1 + (int_pp (T (T I)))
        1 + (int_pp (T I))
            1 + (int_pp I)
                1
4
```

## Part 2