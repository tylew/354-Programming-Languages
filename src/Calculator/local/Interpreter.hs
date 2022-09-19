module Interpreter where

import AbsNumbers

eval :: Exp -> Integer
eval (Plus n m) = (eval n) + (eval m)
eval (Minus n m) = (eval n) - (eval m)
eval (Times n m) = (eval n) * (eval m)
eval (Div n m) = quot (eval n) (eval m)
eval (Pow n m) = (eval n) ^ (eval m)
eval (Neg n) = - (eval n) 
eval (Op1 n m) = (eval n) `mod` (eval m)
eval (Op2 n m) = (eval n) `rem` (eval m)
eval (Num n) = n

{-
ghc Calculator.hs
echo "-1+2" | ./Calculator
echo "-1+-2" | ./Calculator
echo "-1+--2" | ./Calculator
echo "-(--2*--3)" | ./Calculator
echo "2^3+4" | ./Calculator
echo "2^-1" | ./Calculator
echo "2^3/3" | ./Calculator
echo "3^3^3" | ./Calculator
echo "3^(3^3)" | ./Calculator
echo "(3^3)^3" | ./Calculator
-}