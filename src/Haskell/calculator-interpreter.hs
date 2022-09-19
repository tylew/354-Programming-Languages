-------------------------------------
-- data type of abstract syntax trees
data Exp = Plus Exp Exp | Times Exp Exp | Num Integer

-------------------------------------
-- interpreter
eval :: Exp -> Integer
eval (Num n) = n
eval (Plus n m) = (eval n) + (eval m)
eval (Times n m) = (eval n) * (eval m)

-------------------------------------
-- for testing ... add your own
exp1 = Num 7
exp2 = Plus (Num 2) (Num 3)
exp3 = Times exp2 exp2
exp4 = Times (Num 5) (Plus (Times (Plus (Num 4) (Num 3)) (Num 2)) (Num 1))

main = do
  print $ eval exp4 -- change for testing