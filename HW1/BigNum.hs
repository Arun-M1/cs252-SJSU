{-
  Name: Arun Murugan
  Class: CS 252
  Assigment: HW1
  Date: 2/13/2025
  Description: Program implements addition, subtraction, multiplication, power of, and equal comparison of BigNums
-}

module BigNum (
  BigNum,
  bigAdd,
  bigSubtract,
  bigMultiply,
  bigEq,
  bigDec,
  bigPowerOf,
  prettyPrint,
  stringToBigNum,
) where

type Block = Int -- An Int from 0-999

type BigNum = [Block]

maxblock = 1000

bigAdd :: BigNum -> BigNum -> BigNum
bigAdd x y = bigAdd' x y 0

bigAdd' :: BigNum -> BigNum -> Block -> BigNum
-- bigAdd' _ _ _ = error "Your code here"
-- base cases
-- negative number in block
bigAdd' (x:xs) (y:ys) carry | x < 0 || y < 0 = error "block is negative"
-- empty lists, no carry
bigAdd' [] [] 0 = []
-- empty lists, carry
bigAdd' [] [] carry = [carry]
--list 1, but list 2 finished and there is carry
bigAdd' (x:xs) [] carry = 
    let sum = x + carry
    in (sum `mod` maxblock) : bigAdd' xs [] (sum `div` maxblock)
--list 1 finished, but list 2 and there is carry
bigAdd' [] (y:ys) carry = 
    let sum = y + carry
    in (sum `mod` maxblock) : bigAdd' [] ys (sum `div` maxblock)
-- remainder and sum (4, 3, 1) is less than 10
bigAdd' (x:xs) (y:ys) carry = 
    let sum = x + y + carry
    in (sum `mod` maxblock) : bigAdd' xs ys (sum `div` maxblock)

bigSubtract :: BigNum -> BigNum -> BigNum
bigSubtract x y =
  if length x < length y
    then error "Negative numbers not supported"
    else reverse $ stripLeadingZeroes $ reverse result
      where result = bigSubtract' x y 0

stripLeadingZeroes :: BigNum -> BigNum
stripLeadingZeroes (0:[]) = [0]
stripLeadingZeroes (0:xs) = stripLeadingZeroes xs
stripLeadingZeroes xs = xs

-- Negative numbers are not supported, so you may throw an error in these cases
bigSubtract' :: BigNum -> BigNum -> Block -> BigNum
-- bigSubtract' _ _ _ = error "Your code here"
-- empty lists, no carry
bigSubtract' [] [] 0 = []
-- first list empty, no carry
bigSubtract' [] (y:ys) 0 = error "negative diff"
-- first list empty, but carry
bigSubtract' [] (y:ys) carry = error "negative diff"
-- second list is empty, no carry
bigSubtract' (x:xs) [] 0 = x : bigSubtract' xs [] 0
-- second list empty, but carry
bigSubtract' (x:xs) [] carry 
  -- block is greater than equal carry, subtract and add on
  | x >= carry = (x - carry) : bigSubtract' xs [] 0
  -- less than, add 1000 subtract carry and add on
  | otherwise = ((x + maxblock) - carry) : bigSubtract' xs [] 1
-- both lists, no carry
bigSubtract' (x:xs) (y:ys) 0 
  -- num1 greater than equal num 2, subtract
  | x >= y = (x - y) : bigSubtract' xs ys 0
  -- less than, add 1000 and carry 1
  | otherwise = ((x + maxblock) - y) : bigSubtract' xs ys 1
-- both lists, carry
bigSubtract' (x:xs) (y:ys) carry
  -- num 1 less than or equal num2
  | x <= y = ((x + maxblock) - y -  carry) : bigSubtract' xs ys 1
  -- strictly greater
  | otherwise = (x - y) - carry : bigSubtract' xs ys 0

bigEq :: BigNum -> BigNum -> Bool
-- bigEq _ _ = error "Your code here"
bigEq [] [] = True
bigEq [x] [] = False
bigEq [] [y] = False
bigEq (x:xs) (y:ys) = (x == y) && bigEq xs ys

bigDec :: BigNum -> BigNum
bigDec x = bigSubtract x [1]

-- Handle multiplication following the same approach you learned in grade
-- school, except dealing with blocks of 3 digits rather than single digits.
-- If you are having trouble finding a solution, write a helper method that
-- multiplies a BigNum by an Int.
bigMultiply :: BigNum -> BigNum -> BigNum
-- bigMultiply _ _ = error "Your code here"
-- [350, 1]
-- [999, 100]
-- 136348650
-- [650, 348, 1]

-- [0]
-- 350 * 100, 1 * 100
-- 35000 + 0 (carry) = 35000
-- Multiply = 35000 mod 1000 = 0
-- Carry = 35000 / 1000 = 35

-- [0,0]
-- 100 + 35 = 135
-- Multiply = 135 mod 1000 = 135
-- Carry = 135 / 1000 = 0
-- [0, 0, 135]
-- [650, 348, 1] + [0, 0, 135] = [650, 348, 136]

--reuse y block
bigMultiply x [y] = bigMultiply' x [y] 0
--pad 0 for addition based on digit place (1, 10, 100...), adding multiplication of blocks for each y block
bigMultiply x (y:ys) = bigAdd (bigMultiply' x [y] 0) ([0] ++ (bigMultiply x ys))

bigMultiply' :: BigNum -> BigNum -> Block -> BigNum
--empty list, no carry
bigMultiply' [] _ 0 = []
--empty list, carry left
bigMultiply' [] _ carry = [carry]
--empty list for second number
bigMultiply' _ [] _ = []
--multiply by 0
bigMultiply' _ [0] _ = [0]
bigMultiply' (x:xs) [y] carry
  | product < maxblock = product : bigMultiply' xs [y] 0
  | otherwise = (product `mod` maxblock) : bigMultiply' xs [y] new_carry
  where product = x * y + carry
        new_carry = product `div` maxblock

bigPowerOf :: BigNum -> BigNum -> BigNum
-- bigPowerOf _ _ = error "Your code here"
--power of 0
bigPowerOf _ [0] = [1]
--power of 1
bigPowerOf x [1] = x
--power of 2+, recursively go to power of 0 by decreasing power, then come back and multiply each result
bigPowerOf x power = bigMultiply x (bigPowerOf x (bigDec power))

prettyPrint :: BigNum -> String
prettyPrint [] = ""
prettyPrint xs = show first ++ prettyPrint' rest
  where (first:rest) = reverse xs

prettyPrint' :: BigNum -> String
prettyPrint' [] = ""
prettyPrint' (x:xs) = prettyPrintBlock x ++ prettyPrint' xs

prettyPrintBlock :: Int -> String
prettyPrintBlock x | x < 10     = ",00" ++ show x
                   | x < 100    = ",0" ++ show x
                   | otherwise  = "," ++ show x

stringToBigNum :: String -> BigNum
stringToBigNum "0" = [0]
stringToBigNum s = stringToBigNum' $ reverse s

stringToBigNum' :: String -> BigNum
stringToBigNum' [] = []
stringToBigNum' s | length s <= 3 = read (reverse s) : []
stringToBigNum' (a:b:c:rest) = block : stringToBigNum' rest
  where block = read $ c:b:a:[]

sig = "9102llaf"
