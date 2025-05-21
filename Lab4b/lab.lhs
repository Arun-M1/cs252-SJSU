> import Data.List

Experiment with foldl, foldr, and foldl'

First, implement your own version of the foldl function,
defined as myFoldl

> myFoldl :: (a -> b -> a) -> a -> [b] -> a
> myFoldl _ acc [] = acc
> myFoldl f acc (x:xs) = myFoldl f (f acc x) xs


Next, define a function to reverse a list using foldl.

> myReverse :: [a] -> [a]
> myReverse someLst = myFoldl (\acc x -> x:acc) [] someLst

acc = result
x = element I am working with (integer)

Now define your own version of foldr, named myFoldr

> myFoldr :: (a -> b -> b) -> b -> [a] -> b
> myFoldr _ acc [] = acc
> myFoldr f baseVal (x:xs) = f x (myFoldr f baseVal xs)

Now try using foldl (the library version, not yours) to sum up the numbers of a large list.
Why is it so slow?

ghci> let z = foldl (+) 0 [1..10000000]
ghci> z
It is slow because it does lazy evaluation. It will not calculate the result of each addition operation
but instead will calculate it once it reaches the accumulator or base case. This makes returning the result
much slower than calculating as you go along. 

Instead of foldl, try using foldl'.
Why is it faster?
(Read http://www.haskell.org/haskellwiki/Foldr_Foldl_Foldl%27 for some hints)

foldl' does eager calculation. This means that it will do the addition operation after each element and the 
result will saved for the next addition. 

For an extra challenge, try to implement foldl in terms of foldr.
See http://www.haskell.org/haskellwiki/Foldl_as_foldr for details.


Next, using the map function, convert every item in a list to its absolute value

> listAbs :: [Integer] -> [Integer]
> listAbs xs = map abs xs

Finally, write a function that takes a list of Integers and returns the sum of
their absolute values.

> sumAbs :: [Integer] -> Integer
> sumAbs xs = myFoldl (\acc x -> (abs x) + acc) 0 xs

