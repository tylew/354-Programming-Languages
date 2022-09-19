{-arithmetic.idr-}
{-Samuel Balco, Sept 2018-}

{- the following is pre-defined
data Nat    = Z   | S Nat           -- Natural numbers
                                    -- (zero and successor)
plus : Nat -> Nat -> Nat
plus Z y = y
plus (S n)  y = S (plus n y)
similarly mult
-}

infixr 11 :+:
infixr 12 :*:

data Num = O | S Num
data Exp = N Num | (:+:) Exp Exp | (:*:) Exp Exp

total eval_num : Num -> Nat
eval_num O = 1
eval_num (S n) = S (eval_num n)

total eval_exp : Exp -> Nat
eval_exp (N n) = eval_num n
eval_exp (e1 :+: e2) = (eval_exp e1) + (eval_exp e2)
eval_exp (e1 :*: e2) = (eval_exp e1) * (eval_exp e2)

total eval_exp_comm : (e1 : Exp) -> (e2: Exp) -> eval_exp (e1 :+: e2) = eval_exp (e2 :+: e1)
eval_exp_comm e1 e2 = rewrite plusCommutative (eval_exp e1) (eval_exp e2) in Refl

infixr 10 :=:

data (:=:) : Exp -> Exp -> Type where
   EqExpRefl : e :=: e
   EqExpSymm : e1 :=: e2 -> e2 :=: e1
   EqExpTrans : e1 :=: e2 -> e2 :=: e3 -> e1 :=: e3
   EqExpPlusEq : e1 :=: e1' -> e2 :=: e2' -> e1 :+: e2 :=: e1' :+: e2'
   EqExpPlusOne : (N (S n)) :=: (N n) :+: (N O)
   EqExpAssoc : e1 :+: (e2 :+: e3) :=: (e1 :+: e2) :+: e3

total plusone : (n : Num) -> (N O) :+: (N n) :=: (N n) :+: (N O)
plusone O = EqExpRefl
plusone (S n) =
    EqExpTrans
        (EqExpPlusEq EqExpRefl EqExpPlusOne)
        (EqExpTrans EqExpAssoc
    (EqExpTrans
        (EqExpPlusEq
            (plusone n)
            EqExpRefl)
        (EqExpPlusEq
            (EqExpSymm EqExpPlusOne)
            EqExpRefl)))

total comm_plus : (n : Num) -> (m : Num) -> (N n) :+: (N m) :=: (N m) :+: (N n)
comm_plus O m = plusone m
comm_plus (S l) m =
    EqExpTrans
        (EqExpPlusEq EqExpPlusOne EqExpRefl)
    (EqExpTrans
        (EqExpPlusEq
            (EqExpSymm (plusone l))
            EqExpRefl)
    (EqExpTrans
        (EqExpSymm EqExpAssoc)
    (EqExpTrans
        (EqExpPlusEq
            EqExpRefl
            (comm_plus l m))
    (EqExpTrans
        EqExpAssoc
    (EqExpTrans
        (EqExpPlusEq
            (plusone m)
            EqExpRefl)
    (EqExpTrans
        (EqExpSymm EqExpAssoc)
    (EqExpTrans
        (EqExpPlusEq
            EqExpRefl
            (plusone l))
        (EqExpPlusEq
            EqExpRefl
            (EqExpSymm EqExpPlusOne)))))))))
