{-
  Name: Arun Murugan
  Class: CS 252
  Assigment: HW2
  Date: March 3, 2025
  Description: This program implements an interpreter with support of integers, booleans, and while loop.
-}


module WhileInterp (
  Expression(..),
  Binop(..),
  Value(..),
  testProgram,
  run
) where

import Data.Map (Map)
import qualified Data.Map as Map
import Language.Haskell.TH (Exp)
import Distribution.TestSuite (Result(Error))
import Control.Monad.Trans.Accum (evalAccum)
import Data.Type.Equality (apply)
import Distribution.SPDX (LicenseId(App_s2p))
import qualified Control.Arrow as Map

-- We represent variables as strings.
type Variable = String

-- The store is an associative map from variables to values.
-- (The store roughly corresponds with the heap in a language like Java).
type Store = Map Variable Value

data Expression =
    Var Variable                            -- x
  | Val Value                               -- v
  | Assign Variable Expression              -- x := e
  | Sequence Expression Expression          -- e1; e2
  | Op Binop Expression Expression
  | If Expression Expression Expression     -- if e1 then e2 else e3
  | While Expression Expression             -- while (e1) e2
  | And Expression Expression               -- e1 and e2
  | Or Expression Expression                -- e1 or e2
  | Not Expression                          -- not e1
  deriving (Show)

data Binop =
    Plus     -- +  :: Int  -> Int  -> Int
  | Minus    -- -  :: Int  -> Int  -> Int
  | Times    -- *  :: Int  -> Int  -> Int
  | Divide   -- /  :: Int  -> Int  -> Int
  | Gt       -- >  :: Int -> Int -> Bool
  | Ge       -- >= :: Int -> Int -> Bool
  | Lt       -- <  :: Int -> Int -> Bool
  | Le       -- <= :: Int -> Int -> Bool
  deriving (Show)

data Value =
    IntVal Int
  | BoolVal Bool
  deriving (Show)


-- This function will be useful for defining binary operations.
-- The first case is done for you.
-- Be sure to explicitly check for a divide by 0 and throw an error.
applyOp :: Binop -> Value -> Value -> Value
applyOp Plus (IntVal i) (IntVal j) = IntVal $ i + j
applyOp Minus (IntVal i) (IntVal j) = IntVal $ i - j
applyOp Times (IntVal i) (IntVal j) = IntVal $ i * j
applyOp Divide (IntVal i) (IntVal 0) = error "Divide by 0 is invalid"
applyOp Divide (IntVal i) (IntVal j) = IntVal $ i `div` j
applyOp Gt (IntVal i) (IntVal j) =  BoolVal (i > j)
applyOp Ge (IntVal i) (IntVal j) =  BoolVal (i >= j)
applyOp Lt (IntVal i) (IntVal j) =  BoolVal (i < j)
applyOp Le (IntVal i) (IntVal j) =  BoolVal (i <= j)

-- Implement this function according to the specified semantics
-- op
evaluate :: Expression -> Store -> (Value, Store)
evaluate (Op o e1 e2) s =
  let (v1,s1) = evaluate e1 s
      (v2,s2) = evaluate e2 s1
  in (applyOp o v1 v2, s2)

-- if true
-- evaluate (If (Val (BoolVal True)) e2 _) s = evaluate e2 s
-- -- if false
-- evaluate (If (Val (BoolVal False)) e3 _) s = evaluate e3 s
-- if context
evaluate (If e1 e2 e3) s = 
  let (v1, s1) = evaluate e1 s
  in case v1 of 
    BoolVal True -> evaluate e2 s
    BoolVal False -> evaluate e3 s
    _ -> error "Not boolean"

-- seq
evaluate (Sequence (Val v) e) s = evaluate e s

-- seq context
evaluate (Sequence e1 e2) s = 
  let (v1, s1) = evaluate e1 s
      (v2, s2) = evaluate e2 s1
  in (v2, s2)

--var
--look up x, store in map, assign to value, return nothing if not found
evaluate (Var x) s = 
  case Map.lookup x s of
    Just v -> (v, s)
    _ -> error "no value found"

-- val
evaluate (Val v) s = (v, s)

-- assign context
evaluate (Assign x e1) s = 
  let (v1, s1) = evaluate e1 s
  in (v1, Map.insert x v1 s1)

-- while
evaluate (While e1 e2) s = 
  let(vbool, s1) = evaluate e1 s
  in case vbool of 
    BoolVal False -> (BoolVal False, s1)
    BoolVal True -> 
      let (_, s2) = evaluate e2 s1
      in evaluate (While e1 e2) s2
    _ -> error "not boolean"
  
--and
evaluate (And e1 e2) s = 
  let (v1, s1) = evaluate e1 s
  in case v1 of 
    BoolVal True -> 
      let (v2, s2) = evaluate e2 s1
      in case v2 of
        BoolVal True -> (BoolVal True, s2)
        BoolVal False -> (BoolVal False, s2)
        _ -> error "not boolean"
    BoolVal False -> (BoolVal False, s1)
    _ -> error "not boolean"

--or
evaluate (Or e1 e2) s = 
  let (v1, s1) = evaluate e1 s
  in case v1 of
    BoolVal True -> (BoolVal True, s1)
    BoolVal False -> 
      let (v2, s2) = evaluate e2 s1
      in case v2 of
        BoolVal True -> (BoolVal True, s2)
        BoolVal False -> (BoolVal False, s2)
        _ -> error "not boolean"
    _ -> error "not boolean"

--not
evaluate (Not e) s = 
  let (v1, s1) = evaluate e s
  in case v1 of
    BoolVal True -> (BoolVal False, s1)
    BoolVal False -> (BoolVal True, s1)

-- Evaluates a program with an initially empty state
run :: Expression -> (Value, Store)
run prog = evaluate prog Map.empty

-- The same as run, but only returns the Store
testProgram :: Expression -> Store
testProgram prog = snd $ run prog


