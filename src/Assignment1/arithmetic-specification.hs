-- A Virtual Machine (VM) for Arithmetic (specification)

-----------------------
-- Data types of the VM
-----------------------

-- Natural numbers
data NN = O | S NN
  deriving (Eq,Show) -- for equality and printing

-- Integers
data II = II NN NN
  deriving (Eq,Show) -- for equality and printing

-- Positive integers (to avoid dividing by 0)
data PP = I | T PP

-- Rational numbers
data QQ =  QQ II PP

------------------------
-- Arithmetic on the  VM
------------------------

----------------
-- NN Arithmetic
----------------

-- add natural numbers
addN :: NN -> NN -> NN
addN O m = m
addN (S n) m = S (addN n m)

-- multiply natural numbers
multN :: NN -> NN -> NN
multN O m = O
multN (S n) m = addN (multN n m) m

----------------
-- II Arithmetic
----------------

-- Addition: (a-b)+(c-d)=(a+c)-(b+d)
addI :: II -> II -> II

-- Multiplication: (a-b)*(c-d)=(ac+bd)-(ad+bc)
multI :: II -> II -> II

-- Subtraction: (a-b)-(c-d)=(a+d)-(b+c)
subtrI :: II -> II -> II

-- Negation: -(a-b)=(b-a)
negI :: II -> II

----------------
-- QQ Arithmetic
----------------

-- add positive numbers
addP :: PP -> PP -> PP

-- multiply positive numbers
multP :: PP -> PP -> PP

-- convert numbers of type PP to numbers of type II
ii_pp :: PP -> II

-- Addition: (a/b)+(c/d)=(ad+bc)/(bd)
addQ :: QQ -> QQ -> QQ

-- Multiplication: (a/b)*(c/d)=(ac)/(bd)
multQ :: QQ -> QQ -> QQ

----------------
-- Normalisation
----------------

normalizeI :: II -> II

----------------------------------------------------
-- Converting between VM-numbers and Haskell-numbers
----------------------------------------------------

-- Precondition: Inputs are non-negative
nn_int :: Integer -> NN

int_nn :: NN->Integer

ii_int :: Integer -> II

int_ii :: II -> Integer

-- Precondition: Inputs are positive
pp_int :: Integer -> PP

int_pp :: PP->Integer

float_qq :: QQ -> Float

------------------------------
-- Normalisation by Evaluation
------------------------------

nbv :: II -> II

----------
-- Testing
----------

main = do
    -- Integers: (II i j) represents i-j, (II k l) represents k-l
    let i = 4
    let j = 2
    let k = 1
    let l = 3
    print $ int_ii (addI (II (nn_int i) (nn_int j)) (II (nn_int k) (nn_int l)))
    print $ int_ii (multI (II (nn_int i) (nn_int j)) (II (nn_int k) (nn_int l)))
    -- Fractions: (QQ i j) represents i/j, (QQ k l) represents k/l
    print $ float_qq (addQ (QQ (ii_int i) (pp_int j)) (QQ (ii_int k) (pp_int l)))
    print $ float_qq (multQ (QQ (ii_int i) (pp_int j)) (QQ (ii_int k) (pp_int l)))
    -- Normalisation (recursive definition)
    print $ normalizeI (II (nn_int i) (nn_int j))
    -- Normalisation (by evaluation)
    print $ nbv (II (nn_int i) (nn_int j))
