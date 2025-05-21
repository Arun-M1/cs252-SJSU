doubleMe x = x + x

doubleUs x y = x*2 + y*2

doubleUsTwo x y = doubleMe x + doubleMe y

doubleSmallNumber :: (Ord a, Num a) => a -> a
doubleSmallNumber x = if x > 100
                        then x
                        else x*2

doubleSmallNumber' x = (if x > 100 then x else x*2) + 1

lostNumbers x = [4,8,15,16,23,42] 

boomBang xs = [if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]

productCombo :: [Int]
productCombo = [x*y | x <- [2,5,10], y <- [8, 10,11]]

lengthOne' xs = (sum [1 | _ <- xs])

tell :: (Show a) => [a] -> String
tell [] = "The list is empty"  
tell (x:[]) = "The list has one element: " ++ show x  
tell (x:y:[]) = "The list has two elements: " ++ show x ++ " and " ++ show y  
tell (x:y:_) = "This list is long. The first two elements are: " ++ show x ++ " and " ++ show y 

length' :: (Num b) => [a] -> b  
length' [] = 0  
length' (_:xs) = 1 + length' xs  

divide :: Int -> Int -> Maybe Int
divide x 0 = Nothing
divide x y = Just $ x `div` y

doubleEvenNumbers :: [Int] -> [Int]
doubleEvenNumbers [] = []
doubleEvenNumbers xs = map (*2) (filter (\x -> x `mod` 2 == 0) xs)

lengthsOfStrings :: [String] -> [Int]
lengthsOfStrings [] = []
lengthsOfStrings xs = map (length) xs

zipAndDoubleEvenSum :: [Int] -> [Int] -> [Int]
zipAndDoubleEvenSum [] [] = []
zipAndDoubleEvenSum x y = map (*2) $ filter (\sum -> sum `mod` 2 == 0) (zipWith (+) x y)

productOddNumbers :: [Int] -> Int
productOddNumbers xs = foldl (\acc x -> if odd x then acc * x else acc) 1 xs

sumOfSquares :: [Int] -> Int
sumOfSquares xs = foldl (\acc x -> if x > 0 then acc + (x * x) else acc) 0 xs

reverseList :: [a] -> [a]
reverseList xs = foldl (\acc x -> x:acc) [] xs

sumList :: [Int] -> Int
sumList xs = foldr (\x acc -> x + acc) 0 xs

concatLists :: [[a]] -> [a]
concatLists xs = foldr (\x acc -> acc ++ x) [] xs

anyTrue :: [Bool] -> Bool
anyTrue xs = foldr (\x acc -> x || acc) False xs

filterLists :: (a -> Bool) -> [a] -> [a]
filterLists f xs = map f xs