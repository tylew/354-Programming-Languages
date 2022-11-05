module Interpreter where

import AbsNumbers

eval :: Exp -> Integer
eval (Num n) = n
eval (Plus n m) = (eval n) + (eval m)
eval (Times n m) = (eval n) * (eval m)
eval (Minus n m) = (eval n) - (eval m)
eval (Divide n m) = ((eval n) `quot` (eval m))
eval (Exponent n m) = (eval n) ^ (eval m)
eval (Modulus n m) = mod (eval n) (eval m)
eval (Unary n) = negate (eval n)
eval (Binary n m) = (eval n) - (eval m);