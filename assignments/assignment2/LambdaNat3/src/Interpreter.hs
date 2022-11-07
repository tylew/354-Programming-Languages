module Interpreter ( execCBN ) where

import AbsLambdaNat 
import ErrM
import PrintLambdaNat

execCBN :: Program -> Exp  
execCBN (Prog e) = evalCBN e
evalCBN :: Exp -> Exp  
evalCBN (EApp e1 e2) = case (evalCBN e1) of
    (EAbs i e3) -> evalCBN (subst i e2 e3)
    e3 -> EApp e3 e2
evalCBN ENat0 = ENat0 
evalCBN (ENatS e) = ENatS (evalCBN e)
----------------------------------------------------
evalCBN (EIf e0 e1 e2 e3) = if (evalCBN e0) == (evalCBN e1) then (evalCBN e2) else (evalCBN e3)
evalCBN (ELet id e0 e1) = evalCBN( EApp (EAbs id e1) e0)
evalCBN (EFix e) = evalCBN (EApp e (EFix e))
evalCBN (ERec i e1 e2) = evalCBN (EApp (EAbs i e2) (EFix (EAbs i e1)))
evalCBN (EMinusOne e0) = case (evalCBN e0) of
    ENatS e0 -> evalCBN(e0)

----------------------------------------------------
evalCBN x = x -- this is a catch all clause, currently only for variables, must be the last clause of the eval function

-- a quick and dirty way of getting fresh names. Rather inefficient for big terms...
fresh_aux :: Exp -> String
fresh_aux (EVar (Id i)) = i ++ "0"
fresh_aux (EApp e1 e2) = fresh_aux e1 ++ fresh_aux e2
fresh_aux (EAbs (Id i) e) = i ++ fresh_aux e
fresh_aux _ = "0"

fresh = Id . fresh_aux -- for Id see AbsLamdaNat.hs

-- subst implements the beta rule
-- (\x.e)e' reduces to subst x e' e
subst :: Id -> Exp -> Exp -> Exp
subst id s (EVar id1) | id == id1 = s
                      | otherwise = EVar id1
subst id s (EApp e1 e2) = EApp (subst id s e1) (subst id s e2)
subst id s (EAbs id1 e1) = 
    let f = fresh (EAbs id1 e1)
        e2 = subst id1 (EVar f) e1 in 
        EAbs f (subst id s e2)
----------------------------------------------------------------
--- YOUR CODE goes here if subst needs to be extended as well
----------------------------------------------------------------
subst id s ENat0 = ENat0 
subst id s (ENatS e) = ENatS (subst id s e)
subst id s (EIf e1 e2 e3 e4) = EIf (subst id s e1) (subst id s e2) (subst id s e3) (subst id s e4)
subst id s (ELet x e1 e2) = subst id s (EApp (EAbs x e1) e2)
subst id s (EFix e) = EFix (subst id s e)
subst id s (ERec x e1 e2) = subst id s (EApp (EAbs x e2) (EFix (EAbs x e1)))
