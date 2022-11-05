-- A Virtual Machine (VM) for Arithmetic (template)
-- Copyright: Alexander Kurz 2022

-----------------------
-- Data types of the VM
-----------------------

-- Natural numbers
data NN = O | S NN
  deriving (Eq,Show,Ord) -- for equality and printing

-- Integers
data II = II NN NN
  deriving Show -- for printing

-- Positive integers (to avoid dividing by 0)
data PP = I | T PP
  deriving Show

-- Rational numbers
data QQ =  QQ II PP
  deriving Show

------------------------
-- Arithmetic on the  VM
------------------------

----------------
-- PP Arithmetic
----------------

-- add positive numbers
addP :: PP -> PP -> PP
addP I n = T (n)
addP (T n) m = T (addP n m)

-- multiply positive numbers
multP :: PP -> PP -> PP
multP I m = m
multP (T n) m = T (addP n m)

-- convert numbers of type PP to numbers of type NN
nn_pp :: PP -> NN
nn_pp I = S (O)
nn_pp (T n) = S (nn_pp n)

-- convert numbers of type PP to numbers of type II
ii_pp :: PP -> II
ii_pp I = II (S O) O
ii_pp (T n) = II (S (nn_pp n)) O

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

-- division, eg 13 divided by 5 is 2
divN :: NN -> NN -> NN
divN n m
  |n >= m = S (divN (n) (addN m m))
  |otherwise = O

-- remainder, eg 13 modulo by 5 is 3
modN :: NN -> NN -> NN
modN (S n) m
  |n > multN (divN n m) m = S(modN n m)
  |n == multN (divN n m) m = S(O)
  |otherwise = O

----------------
-- II Arithmetic
----------------

-- Addition: (a-b)+(c-d)=(a+c)-(b+d)
addI :: II -> II -> II
addI (II a b) (II c d) = II (addN a c) (addN b d)

-- Multiplication: (a-b)*(c-d)=(ac+bd)-(ad+bc)
multI :: II -> II -> II
multI (II a b) (II c d) = II (addN (multN a c) (multN b d)) (addN (multN a d) (multN b c))

-- Negation: -(a-b)=(b-a)
negI :: II -> II
negI (II a b) = II b a 

-- Equality of integers
instance Eq II where
  (II a b) == (II c d) = int_ii (II a b) == int_ii (II c d)

----------------
-- QQ Arithmetic
----------------

-- Addition: (a/b)+(c/d)=(ad+bc)/(bd)
addQ :: QQ -> QQ -> QQ
addQ (QQ a b) (QQ c d) = QQ (addI (multI a (ii_pp d)) (multI (ii_pp b) c)) (multP b d)

-- Multiplication: (a/b)*(c/d)=(ac)/(bd)
multQ :: QQ -> QQ -> QQ
multQ (QQ a b) (QQ c d) = QQ (multI a c) (multP b d)

-- Equality of fractions
instance Eq QQ where
  (QQ a b) == (QQ c d) = float_qq (QQ a b) == float_qq (QQ c d)


----------------
-- Normalisation
----------------

normalizeI :: II -> II
normalizeI (II m O) = II m O 
normalizeI (II O n) = II O n
normalizeI (II (S m) (S n)) = normalizeI (II m n)

----------------------------------------------------
-- Converting between VM-numbers and Haskell-numbers
----------------------------------------------------

-- Precondition: Inputs are non-negative
nn_int :: Integer -> NN
nn_int 0 = O 
nn_int m = S (nn_int (m-1))

int_nn :: NN->Integer
int_nn O = 0
int_nn (S n) = 1 + (int_nn n)

ii_int :: Integer -> II
ii_int 0 = (II O O)
ii_int m = addI (II (S O) O) (ii_int (m-1))

int_ii :: II -> Integer
int_ii (II m O) = int_nn m
int_ii (II m (S n)) = (int_ii (II m n)) - 1

-- Precondition: Inputs are positive
pp_int :: Integer -> PP
pp_int 1 = I
pp_int m = T (pp_int (m - 1))

int_pp :: PP->Integer
int_pp I = 1
int_pp (T n) = 1 + (int_pp n)

float_qq :: QQ -> Float
float_qq (QQ a b) = (fromIntegral( int_ii a)) / (fromIntegral( int_pp b))

------------------------------
-- Normalisation by Evaluation
------------------------------

nbe :: II -> II
nbe m = ii_int (int_ii m)

----------
-- Testing
----------
main = do

  print $ addP (T(T(T(T(I))))) (T(T I)) -- T (T (T (T (T (T (T I))))))
  print $ multP (T I)(T I) -- (T (T (T I)))
  print $ nn_pp (T(T(T(I)))) -- S (S (S (S O))))
  print $ ii_pp (T(T(T(I)))) -- II (S (S (S (S O)))) O
  print $ addN (S (S O)) (S O) -- S (S (S O))
  print $ multN (S (S O)) (S (S (S O))) -- S (S (S (S (S (S O)))))
  print $ divN (S(S(S(S((S O)))))) (S(S O)) -- S (S O)
  print $ modN (S(S(S(S((S O)))))) (S(S O)) -- S O
  print $ addI (II O O) (II (S (S O)) O) -- II (S (S O)) O
  print $ multI (II (S(S(S O))) O) (II (S(S O)) O) -- II (S (S (S (S (S (S O)))))) O
  print $ negI (II (S(S(S O))) O) -- O (S (S (S O)))
  print $ addQ (QQ (II (S O) O) (T (T I))) (QQ (II (S O) O) (T (T I))) -- QQ (II (S (S (S (S (S (S O)))))) O) (T (T (T (T (T (T (T (T I))))))))
  print $ multQ (QQ (II (S O) O) (T (T I))) (QQ (II (S O) O) (T (T I))) -- QQ (II (S O) O) (T (T (T (T (T (T (T (T I))))))))
  print $ normalizeI (II (nn_int 10) (nn_int 5)) -- II II (S (S (S (S (S O))))) O
  print $ nn_int 10 -- S (S (S (S (S (S (S (S (S (S O)))))))))
  print $ int_nn (S(S(S O))) -- 3
  print $ ii_int 18 -- (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S O)))))))))))))))))) O
  print $ int_ii (II(S(S(S(S O)))) (S (S O))) -- 2
  print $ pp_int 6 -- T (T (T (T (T I))))
  print $ int_pp (T(T(T(T(T I))))) -- 6
  print $ float_qq (QQ (II (S(S (S O))) O) (T(T I))) -- 1.0
  print $ nbe (II (nn_int 3) (nn_int 1)) -- II (S (S O)) O
