This File is _literate Haskell_.
That means that (in some sense) code and comments are reversed.
By default, everything that I type is actually a comment.
To write code, I preface it with a 'greater than' symbol.

In this lab, we will define a small language and its operational semantics.
We'll first describe the language:

e ::= true
    | false
    | if e then e else e
    | i 
    | succ e
    | pred e

The "::=" symbol above should be read as "can be", and "|" should be read as "or".
The metavariable "e" represents an expression.
Where needed, we will use "e1", "e2", "e'", etc. as additional metavariables
for expressions.

Representing this language in Haskell is fairly straightforward.
(Note the use of the '>' to denote code below.)

> data Exp = ETrue
>          | EFalse
>          | Eif Exp Exp Exp
>          | EInt Int
>          | Succ Exp
>          | Pred Exp
>  deriving Show


We also need to decide what are the valid values in our language.
The metavariable "v" stands for a value; again, we will use "v1", "v2", "v'", etc.
as needed for clarity.
For our initial language, only "true" and "false" will be valid values.
Note that these are **also** valid expresisons in our language.

v ::= true
    | false
    | i

As with our expressions, representing our values in Haskell is straightforward:

> data Val = VTrue
>          | VFalse
>          | VInt Int
>  deriving Show

The next part is to define our "evaluate" function.
We use a downarrow in the slides.
Here we'll use a "->*".

The first 2 rules define the evaluation of boolean expressions.
The value "true" evaluates to itself, and the value "false"
evaluates to itself.

-------------
true ->* true

---------------
false ->* false


The next two rules define the behavior of our if expressions.
Both rules specify that e1 should be evaluated first.
Note that we say "evaluated to" and not "is".
Saying "is" would imply "=", which might not be the case.

If e1 evaluates to true, then e2 should be evaluated to get our result.
The statements above the line are the "premises" or "preconditions"
that must be true for this rule to apply.

  if              and
   e1 ->* true    e2 ->* v
--------------------------------
then (if e1 then e2 else e3 ->* v)

If e1 evalates to false, then e3 should be evaluated to get our result.

   e1 ->* false    e3 ->* v
--------------------------------
  if e1 then e2 else e3 ->* v


With these rules defined, we can convert them to code.
We represent "->*" with an "evaluate" function.
Note that a "->*" in the premises should translate to a recursive call to evaluate.

The VTrue case has been done for you.
You must complete the other cases.


> evaluate :: Exp -> Val
> evaluate ETrue = VTrue
> evaluate EFalse = VFalse
> evaluate (EInt i) = VInt i
> evaluate (Eif e1 e2 e3) = case (evaluate e1) of 
>   VTrue -> evaluate e2
>   VFalse -> evaluate e3
> evaluate (Succ e) = case (evaluate e) of 
>   VInt i -> VInt (i + 1)
>   _ -> error "..."
> evaluate (Pred e) = case (evaluate e) of 
>   VInt i -> VInt (i - 1)
>   _ -> error "..."




And here we have a couple of programs to test.
prog1 should evaluate to VTrue and prog2 should evaluate to VFalse

> prog1 = Eif ETrue ETrue EFalse
> prog2 = Eif (Eif ETrue EFalse ETrue) ETrue (Eif ETrue EFalse ETrue)
> prog3 = Succ (EInt 10)
> prog4 = Pred (EInt 10)


The following lines evaluate the test expressions and display the results.
Note the type of main.  'IO ()' indicates that the function performs IO and returns nothing.
The word 'do' begins a block of code, were you can effectively do sequential statements.
(This is a crude generalization, but we'll talk more about what is going on in this function
when we deal with the great and terrible subject of _monads_.)

> main :: IO ()
> main = do
>   putStrLn $ "Evaluating '" ++ (show prog1) ++ "' results in " ++ (show $ evaluate prog1)
>   putStrLn $ "Evaluating '" ++ (show prog2) ++ "' results in " ++ (show $ evaluate prog2)
>   putStrLn $ "Evaluating '" ++ (show prog3) ++ "' results in " ++ (show $ evaluate prog3)
>   putStrLn $ "Evaluating '" ++ (show prog4) ++ "' results in " ++ (show $ evaluate prog4)


Once you have the evaluate function working
you add in support the expressions 'succ e', 'pred e', and integers.
With this change, it is possible for evaluate to get 'stuck',
e.g. pred true.
For a first pass, simply use the error function in these cases.


