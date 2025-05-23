PART 1 -- Introduction to Lambda Calculus

Lambda-calculus is the world's smallest programming language.
In its entirety, it consists of:
*functions (sometimes called abstractions)
*function application
*variables

Since the Greek letter lambda is not available in ASCII, a number of
programming languages use the backslash character instead. For instance,
in Haskell the identity function (lambda x.x) is written as follows:

> id = \x -> x

Despite the minimal nature of lambda-calculus, it is Turing-complete,
and we can encode a wide array of language features.


PART 2 -- Boolean values

To begin with, lets define boolean values.
We will name them 'tru' and 'fls' to avoid confusion with Haskell's
own constructs.

> tru = \x -> \y -> x
> fls = \x -> \y -> y

Defining booleans as functions may seem odd.  In this case,
'tru' is really 'returnFirstParameter' and 'fls' is
'returnSecondParameter'.  We can use these values to form an
'if then else' construct, which we will call 'test':

> test = \cond -> \thn -> \els -> cond thn els

The above function takes the boolean value and then applies it to the two
expressions.  In the case that it is 'tru', it will result in
returning the first expression.  If it is 'false', it will return
the second expression.

> testTru = transBool $ test tru tru fls
> testFls = transBool $ test fls tru fls

Note that Haskell cannot show lambdas, so the above test cases use a helper function;
everything to the right of the $ is lambda calculus.
Note that the transBool function can make use of the lambda calculus test function.

> transBool b = test b "true" "false"

With our boolean values, we can also define logical operators, such as 'and'.
(We will call it 'andd' to avoid conflict's with Haskell's 'and'.

> andd = \b -> \c -> b c fls

Why does this work?  Here are a couple of tests to consider.

> testAnd1 = transBool $ andd tru tru
> testAnd2 = transBool $ andd fls tru


Define the 'nott' and 'orr' operators below without using andd.

> nott = \b -> b fls tru

> orr = \b -> \c -> b tru c

Here are some test cases:

> testOps1 = transBool $ orr fls (nott fls)
> testOps2 = transBool $ nott (orr fls tru)



PART 3 -- Pairs

We can also encode data structures in lambda calculus.
We'll look at pairs.

> pair = \f -> \s -> \b -> b f s

When this function is applied to two arguments,
'f' is bound to the first item in our pair and 's' to the second item.
The following is equivalent to (\b -> b tru fls):

> myPair = pair tru fls

In order for this to be useful, we must be able to get items out of the pair.
The following functions will get the first and second items, respectively:

> first = \p -> p tru
> second = \p -> p fls

The following lines produce "true" and "false" respectively.
Again, everything to the right of the $ is lambda calculus.

> testPairFst = transBool $ first myPair
> testPairSnd = transBool $ second myPair

From pairs, we can begin to build other data structures such as lists.



PART 4 -- Lists

Following the Lisp approach, we can define lists as pairs, where the first
part of the pair is the 'head' of the list, and the second element of the
list is the 'tail' -- the list containing all of the elements except for
the head.

In Lisp, the function that creates a list is called 'cons' -- we will use
that name here.  Instead of 'head' and 'tail', we will use 'hd' and 'tl'
to avoid conflicts with the Haskell functions of the same name.  As you can
see, we can easily define three of the basic list operations with minimal
effort:

> cons = pair
> hd = first
> tl = second

However, we need two more pieces; we need to have a way of representing
the empty list 'nil', and we need a way to test if a list is empty.

For 'isEmpty', we can exploit the design of pairs.  As a reminder, pairs
are of the form (\b -> b f s).  The 'b' is supposed to be a boolean,
which selects whether to return the first or second element.  However,
we will instead provide it a lambda that ignores its arguments and
always returns false:

> isEmpty = \lst -> lst (\h -> \t -> fls)

With this definition of 'isEmpty', we now know what we need for 'nil'.
The empty list should always return true when it is passed in to 'isEmpty'.

Write the definition for 'nil' below.  (If you are unsure of what the
definition should be, try walking through the derivation of
"isEmpty (pair 1 2)".

> nil = (\b -> tru)

Now we can create some sample lists.  (Note that we are using Haskell numbers
just for easy of testing, though they are not part of the lambda calculus.)

> list1 = cons 0 (cons 1 (cons 2 nil))
> list2 = cons 3 (cons 4 (cons 5 nil))

The following test cases should print "0", "1", "false", and "true"

> testListHead = hd list1
> testListHeadTail = hd (tl list1)
> testNotEmpty = transBool $ isEmpty list1
> testEmpty = transBool $ isEmpty (tl (tl (tl list1)))



PART 5 -- Church numerals

With Boolean values, we were able to represent "primitive" values by
using special functions.  However, there are only two possible values.
How can we represent a potentially infinite set of values, like numbers?

Church numerals define numbers as a collection of functions.
Below we will represent the numbers 0 through three:

> zero  = \s -> \z -> z
> one   = \s -> \z -> s z
> two   = \s -> \z -> s (s z)
> three = \s -> \z -> s (s (s z))

So a number is represented by the number of 's' applications in the body.
Why is this a useful representation?  And what is s exactly?

In these functions, z represents zero, and s represents a "successor".
As you might guess, we will need to create this successor function.

> scc = \n -> \s -> \z -> s (n s z)

So, instead of defining one, two, three manually, we could instead derive them
from zero.

> one'    = scc zero
> two'    = scc one'
> three'  = scc two'

Walking through `scc zero` gives us the following steps:
     (\n -> \s -> \z -> s (n s z)) zero
  -> (\s -> \z -> s (zero s z))
  =  (\s -> \z -> s ((\s' -> \z' -> z') s z))
         [expanding zero -- we use s' and z' to avoid confusion]
  -> (\s -> \z -> s (\z' -> z') z)
  -> (\s -> \z -> s z)

Therefore `scc one'` will have the following steps:
     (\n -> \s -> \z -> s (n s z)) one'
  -> (\s -> \z -> s (one' s z))
  =  (\s -> \z -> s ((\s' -> \z' -> s' z') s z))
  -> (\s -> \z -> s ((\z' -> s z') z))
  -> (\s -> \z -> s (s z))

So is this just a cute trick, or do the Church numerals actually represent numbers
in the real world in some meaningful way?  Note that each number is essentially
instructions for how to construct itself given a successor function and zero.
Exploiting this fact, we can write a fairly simple function to translate
Church numerals into Haskell Ints with the right successor function and zero value.

> transChurchNums n = n (+1) 0

Using this principle, we can define addition of two numbers (m and n)
as getting the successor to n, m times.

> plus = \m -> \n -> \s -> \z -> m s (n s z)

> test3plus2 = transChurchNums $ plus three two

At a step by step level, here is what happens when the above code is invoked:
      plus three two
  =   (\m -> \n -> \s -> \z -> m s (n s z)) three two
  ->* \s -> \z -> three s (two s z)
                        [In reality, the evaluation would stop here]
  =   \s -> \z -> three s ((\s' -> z' -> s' (s' z')) s z)
  ->* \s -> \z -> three s (s (s z))
  =   \s -> \z -> (\s' -> z' -> s' (s' (s' z'))) s (s (s z))
  ->  \s -> \z -> (\z' -> s (s (s z'))) (s (s z))
  ->  \s -> \z -> s (s (s (s (s z))))                     [z' replaced with (s (s z))]


Alternately, we could define plus with our scc function:

> plus' = \m -> \n -> m scc n


Define multiplication in a similar manner:
2 * 3
apply succ to 0 2 times, do this operation 3 times 

multiply n m = (\s -> \z -> s(s(s...(s z))))

> multiply = \n -> \m -> n (plus m) zero


For ease of use, you may use the following function to convert a Haskell integer
to a Church numeral.

> church n = if n == 0
>   then
>     (\s -> \z -> z)
>   else
>     (\s -> \z -> s (church (n-1) s z))



PART 6 -- Recursion

Consider the following function, known as the divergent combinator.

omega = (\x -> x x) (\x -> x x)

Haskell will not accept the above combinator.
Evaluate this function by hand yourself.
After one step, what do you get?
(\x -> x x) (\x -> x x)

The omega function is not terribly useful, though it is interesting.
We can cause a lambda calculus program to go into an infinite loop.

A related function is the **fix combinator**, sometimes called the Y combinator.
(Like omega, fix cannot be run in Haskell).

fix = \f -> (\x -> f (\y -> x x y)) (\x -> f (\y -> x x y))

With the fix combinator, we can create recursive functions.
Let's consider the definition for factorial.
First, we need a way to test for zero.

> isZero = \n -> n (\x -> fls) tru

We also need a predecessor function, which proves to be fairly complex.

zz = pair zero zero
ss = \p -> pair (snd p) (plus one (snd p))
prd = \m -> fst (m ss zz)

With the fix combinator, we need to define a function that effectively does
one step of the recursive evaluation.  Note the 'fct' parameter in the function
below.

g = \fct -> \n -> (test (isZero (prd n)) one (multiply n (fct (prd n))))

Using g and the fix function, we can define factorial.

factorial = fix g

To understand how this works, write out the evaluation steps for `factorial 3`.
fix = \f -> (\x -> f (\y -> x x y)) (\x -> f (\y -> x x y))
fix g = \f -> (\x -> f (\y -> x x y)) (\x -> f (\y -> x x y)) g
    -> (\x -> g (\y -> x x y)) (\x -> g (\y -> x x y))
    -> (\x -> g (\y -> x x y))
fix g 3 ->  (\x -> g (\y -> x x y)) 3
      -> g (\y -> 3 3 y) 3
      -> (test (isZero (prd 3)) one (multiply 3 ((\y -> 3 3 y) (prd 3))))
      -> (test (isZero 2) one (multiply 3 ((\y -> 3 3 y) 2)))
      -> (test (isZero 2) one (multiply 3 (3 3 2)))

