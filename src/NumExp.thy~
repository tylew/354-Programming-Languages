(* Samuel Balco 2018 and Alexander Kurz 2019, 2021 *) 

(* This file is an Isabelle/HOL supplement to the lecture notes https://hackmd.io/@alexhkurz/HJnQDm1wK *)

section "Arithmetic Expressions"

theory NumExp imports Main "HOL-Eisbach.Eisbach" begin

subsection "Arithmetic Expressions"

(* num ::= 1 | num + 1 
   exp ::= num | exp + exp | exp * exp *)

(* The datatypes num and exp implement the abstract syntax of the language.
   Concrete syntax is obtained not from a context free grammar,
   but from annotating the abstract syntax with "infix" sugar such as ":+:" 
   and precedences such as "14".*)
datatype num = One ("\<one>") | S num ("_+\<one>")
datatype exp = Num num ("\<langle>_\<rangle>") | Plus exp exp (infix ":+:" 14) | Mult exp exp (infix ":*:" 15)

(* eval_num is the interpreter for numbers. *)
fun eval_num :: "num \<Rightarrow> int" where
"eval_num \<one> = 1" |
"eval_num (num+\<one>) = (eval_num num) + 1"

(* Open the "Output" pane and hover the mouse over a line to run the interpreter. *)
value "eval_num \<one>"
value "eval_num (\<one>+\<one>+\<one>)"

(* eval_exp is the interpreter for expressions. *)
fun eval_exp :: "exp \<Rightarrow> int" where
"eval_exp \<langle>num\<rangle> = eval_num num" |
"eval_exp (a\<^sub>1 :+: a\<^sub>2) = eval_exp a\<^sub>1 + (eval_exp a\<^sub>2)" |
"eval_exp (a\<^sub>1 :*: a\<^sub>2) = eval_exp a\<^sub>1 * (eval_exp a\<^sub>2)"

(* Open the "Output" pane and hover the mouse over a line to run the interpreter. *)
value "eval_exp (Plus (Num (S One)) (Num One))"
value "eval_exp (\<langle>\<one>+\<one>\<rangle> :+: \<langle>\<one>+\<one>\<rangle> :*: \<langle>\<one>+\<one>+\<one>\<rangle>)"
value "eval_exp (Mult (Num (S One)) (Num One))"

(* Commutativity on the semantic side is easy because addition in integers is commutative *)
(* In fact, the proof can be done automatically by the tactic "simp".  *)
lemma "eval_exp (e\<^sub>1 :+: e\<^sub>2) = eval_exp (e\<^sub>2 :+: e\<^sub>1)"
 by simp

(* How can we prove commutativity on the syntactic side? 
   We need to assume something, that captures that Plus is addition.
   In our simple situation, associativity is enough *)

(* First, we define syntactic equality. *) 
inductive equal_exp :: "exp \<Rightarrow> exp \<Rightarrow> bool" (infix "\<approx>" 13) where
equal_exp_refl:         "e \<approx> e" |
equal_exp_symm:         "e\<^sub>1 \<approx> e\<^sub>2 \<Longrightarrow> e\<^sub>2 \<approx> e\<^sub>1" |
equal_exp_trans[trans]: "e\<^sub>1 \<approx> e\<^sub>2 \<Longrightarrow> e\<^sub>2 \<approx> e\<^sub>3 \<Longrightarrow> e\<^sub>1 \<approx> e\<^sub>3" |
equal_exp_cong_plus:    "e\<^sub>1 \<approx> e\<^sub>1' \<Longrightarrow> e\<^sub>2 \<approx> e\<^sub>2' \<Longrightarrow> e\<^sub>1 :+: e\<^sub>2 \<approx> e\<^sub>1' :+: e\<^sub>2'" |
equal_exp_plusone:      "\<langle>n+\<one>\<rangle> \<approx> \<langle>n\<rangle> :+: \<langle>\<one>\<rangle>" |
equal_exp_assoc:        "(e\<^sub>1 :+: (e\<^sub>2 :+: e\<^sub>3)) \<approx> ((e\<^sub>1 :+: e\<^sub>2) :+: e\<^sub>3)" 

(* Proposition 1 in the lecture notes. *)
lemma plusone: "\<langle>\<one>\<rangle> :+: \<langle>n\<rangle> \<approx> \<langle>n\<rangle> :+: \<langle>\<one>\<rangle>"
(* Show 1+n=n+1 by induction on n:
   Base case: 1+1=1+1
   Inductive case: 1+Sn = 1+(n+1) = (1+n)+1 = (n+1)+1 = Sn+1
*)
  apply (induction n) 
    (* Open the output pane and tick the Proof state box *)
    (* The goal is to show the base case and the incuctive step *)
  apply (rule equal_exp_refl)
    (* The base case is proved *)
    (* Goal is 1+Sn=Sn+1 *)
  apply(rule equal_exp_trans)
  apply(rule equal_exp_cong_plus)
  apply(rule equal_exp_refl)
  apply(rule equal_exp_plusone)
    (* 1+Sn = 1+(n+1) is proved *)
    (* remaining goal is 1+(n+1)=Sn+1 *)
  apply(rule equal_exp_trans)
  apply(rule equal_exp_assoc)
    (* 1+(n+1) = (1+n)+1 is proved *)
    (* remaining goal is 1+(n+1)=Sn+1 *)
  apply(rule equal_exp_trans)
  apply(rule equal_exp_cong_plus)
  apply simp
  apply(rule equal_exp_refl)
    (* (1+n)+1 = (n+1)+1 is proved *)
    (* remaining goal is (n+1)+1=Sn+1 *)
  apply(rule equal_exp_cong_plus)
  apply(rule equal_exp_symm)
  apply(rule equal_exp_plusone)
  apply(rule equal_exp_refl)
    (* no remaining goal *)
  done
(* Exercise: Compare the Isabelle proof to the pen and paper proof of the lecture notes. *)

(* Commutativity on the syntactic side. *)
(* Recall that "\<langle>n\<rangle> :+: \<langle>m\<rangle> \<approx> \<langle>m\<rangle> :+: \<langle>n\<rangle>" is an abbreviation for
   "equal_exp (Plus (Num n) (Num m)) (Plus (Num m) (Num n))".  *)
lemma commutativity_num: "\<langle>n\<rangle> :+: \<langle>m\<rangle> \<approx> \<langle>m\<rangle> :+: \<langle>n\<rangle>"
(* Recall the pen and paper proof:
   Induction on m: 
   If n=1, then we need to show 1+m=m+1, which we proved in lemma plusone
   If n = Sl, then 
    n+m = Sl+m = (l+1)+m = (1+l)+m = 1+(l+m) = 1+(m+l) = (1+m)+l = (m+1)+l 
     = m+(1+l) = m+(l+1) =  m+n
*)
proof(induction n)
case One
  then show ?case by (rule plusone)
next
  case (S l)
  have "\<langle>l+\<one>\<rangle> :+: \<langle>m\<rangle> \<approx> (\<langle>l\<rangle> :+: \<langle>\<one>\<rangle>) :+: \<langle>m\<rangle>"
    apply(rule equal_exp_cong_plus)
    apply(rule equal_exp_plusone)
    by(rule equal_exp_refl)
  also have      "\<dots> \<approx> (\<langle>\<one>\<rangle> :+: \<langle>l\<rangle>) :+: \<langle>m\<rangle>"
    apply(rule equal_exp_cong_plus)
    apply(rule equal_exp_symm)
    apply(rule plusone)
    by(rule equal_exp_refl)
  also have      "\<dots> \<approx> \<langle>\<one>\<rangle> :+: (\<langle>l\<rangle> :+: \<langle>m\<rangle>)"
    apply(rule equal_exp_symm)
    by(rule equal_exp_assoc)
  also have      "\<dots> \<approx> \<langle>\<one>\<rangle> :+: (\<langle>m\<rangle> :+: \<langle>l\<rangle>)"
    apply(rule equal_exp_cong_plus)
    apply(rule equal_exp_refl)
    by(rule S)
  also have      "\<dots> \<approx> (\<langle>\<one>\<rangle> :+: \<langle>m\<rangle>) :+: \<langle>l\<rangle>"
    by(rule equal_exp_assoc)
  also have      "\<dots> \<approx> (\<langle>m\<rangle> :+: \<langle>\<one>\<rangle>) :+: \<langle>l\<rangle>"
    apply(rule equal_exp_cong_plus)
    apply(rule plusone)
    by(rule equal_exp_refl)
  also have      "\<dots> \<approx> \<langle>m\<rangle> :+: (\<langle>\<one>\<rangle> :+: \<langle>l\<rangle>)"
    apply(rule equal_exp_symm)
    by(rule equal_exp_assoc)
  also have      "\<dots> \<approx> \<langle>m\<rangle> :+: (\<langle>l\<rangle> :+: \<langle>\<one>\<rangle>)"
    apply(rule equal_exp_cong_plus)
    apply(rule equal_exp_refl)
    by(rule plusone)
  also have      "\<dots> \<approx> \<langle>m\<rangle> :+: \<langle>l+\<one>\<rangle>"
    apply(rule equal_exp_cong_plus)
    apply(rule equal_exp_refl)
    apply(rule equal_exp_symm)
    by(rule equal_exp_plusone)
  finally show ?case by simp
qed

(* We added a simple tactic called exp_tac, which simply tries 
   all the rules on a goal in this order:

   1) try refl
   2) try plusone
   3) try symmetry and then plusone
   ...
   6) try split on n + m and recursively try to solve n and m
   7) try custom derived rule
   8) try symmetry and then custom rule

   this tactic does not apply the transitivity rule (why?)
*)

method exp_tac uses rule = 
    rule equal_exp_refl |
    rule equal_exp_plusone |
    (rule equal_exp_symm ; rule equal_exp_plusone) |
    rule equal_exp_assoc |
    (rule equal_exp_symm ; rule equal_exp_assoc) |
    (rule equal_exp_cong_plus ; (exp_tac rule:rule)+) |
    rule rule  |
    (rule equal_exp_symm ; rule rule)

(* Here is another way of writing the proof of 1+n=n+1. *)
lemma plusone_isar: "\<langle>\<one>\<rangle> :+: \<langle>n\<rangle> \<approx> \<langle>n\<rangle> :+: \<langle>\<one>\<rangle>"
(* Show 1+n=n+1 by induction on n:
   If n=1, then 1+1=1+1
   If n=Sm, then 1+n = 1+Sm = 1+(m+1) = (1+m)+1 = (m+1)+1 = Sm+1 = n+1
*)
proof (induction n)
  case One
  then show ?case by (simp add: equal_exp_refl)
next
  case (S m)
  have "\<langle>\<one>\<rangle> :+: \<langle>m+\<one>\<rangle> \<approx> \<langle>\<one>\<rangle> :+: (\<langle>m\<rangle> :+: \<langle>\<one>\<rangle>)" by exp_tac
  also have      "\<dots> \<approx> (\<langle>\<one>\<rangle> :+: \<langle>m\<rangle>) :+: \<langle>\<one>\<rangle>" by exp_tac
  also have      "\<dots> \<approx> (\<langle>m\<rangle> :+: \<langle>\<one>\<rangle>) :+: \<langle>\<one>\<rangle>" by(exp_tac rule:S)
  also have      "\<dots> \<approx> (\<langle>m+\<one>\<rangle>) :+: \<langle>\<one>\<rangle>" by exp_tac
  finally show ?case by simp
qed

(* Here is another way of writing the proof of 1+n=n+1. *)
lemma commutativity_num_isar: "\<langle>n\<rangle> :+: \<langle>m\<rangle> \<approx> \<langle>m\<rangle> :+: \<langle>n\<rangle>"
(* Induction on m: 
   If n=1, then we need to show 1+m=m+1, which we proved in lemma plusone
   If n = Sl, then 
    n+m = Sl+m = (l+1)+m = (1+l)+m = 1+(l+m) = 1+(m+l) = (1+m)+l = (m+1)+l 
     = m+(1+l) = m+(l+1) =  m+n
*)
proof(induction n)
case One
  then show ?case by (rule plusone)
next
  case (S l)
  have "\<langle>l+\<one>\<rangle> :+: \<langle>m\<rangle> \<approx> (\<langle>l\<rangle> :+: \<langle>\<one>\<rangle>) :+: \<langle>m\<rangle>" by exp_tac
  also have      "\<dots> \<approx> (\<langle>\<one>\<rangle> :+: \<langle>l\<rangle>) :+: \<langle>m\<rangle>" by(exp_tac rule:plusone)
  also have      "\<dots> \<approx> \<langle>\<one>\<rangle> :+: (\<langle>l\<rangle> :+: \<langle>m\<rangle>)" by exp_tac
  also have      "\<dots> \<approx> \<langle>\<one>\<rangle> :+: (\<langle>m\<rangle> :+: \<langle>l\<rangle>)" by(exp_tac rule:S)
  also have      "\<dots> \<approx> (\<langle>\<one>\<rangle> :+: \<langle>m\<rangle>) :+: \<langle>l\<rangle>" by exp_tac
  also have      "\<dots> \<approx> (\<langle>m\<rangle> :+: \<langle>\<one>\<rangle>) :+: \<langle>l\<rangle>" by(exp_tac rule:plusone)
  also have      "\<dots> \<approx> \<langle>m\<rangle> :+: (\<langle>\<one>\<rangle> :+: \<langle>l\<rangle>)" by exp_tac
  also have      "\<dots> \<approx> \<langle>m\<rangle> :+: (\<langle>l\<rangle> :+: \<langle>\<one>\<rangle>)" by(exp_tac rule:plusone)
  also have      "\<dots> \<approx> \<langle>m\<rangle> :+: \<langle>l+\<one>\<rangle>" by exp_tac
  finally show ?case by simp
qed

end

