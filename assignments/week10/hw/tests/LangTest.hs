module LangTest where

import Test.Tasty (testGroup, TestTree)
import Test.Tasty.HUnit (assertEqual, assertBool, testCase)
import Test.Tasty.QuickCheck hiding (Fun)


import ParserMonad

import EnvUnsafe
import Lang
import LangParserTest () -- for the arbitrary instance

-- equality that doesn't handle function well
instance Eq Val where
  (I l) == (I r) = l == r
  (B l) == (B r) = l == r
  (Ls l) == (Ls r) = l == r
  (Fun l) == (Fun r) = True -- no good way to test function equality. it's true so it still follows the laws
  _ == _ = False


assertVal :: String -> Ast -> Val -> TestTree
assertVal s ast out =  testCase (s ++  ": " ++ (show ast)) $ assertEqual [] (Ok out) $ run ast

assertErr :: String -> Ast -> TestTree
assertErr s ast =  testCase (s ++  ": should be an error " ++ (show ast)) $ assertBool [] $ case run ast of
                                                                                                 Error _ -> True
                                                                                                 _       -> False

unitTests =
  testGroup
    "LangTest"
    [instructorTests
     -- TODO: your tests here!!!
	 ]

instructorTests = testGroup
      "instructorTests"
      [
         assertVal "" (Plus (ValInt 2) (ValInt 3)) (I 5),
         assertVal "" (And (ValBool True) (ValBool False)) (B False),
         assertErr "" (And (ValBool True) (ValInt 3)),
         assertVal "" (((Lam "x" (Lam "y" ( (Var "x") `Plus` (Var "y")))) `App` (ValInt 7)) `App` (ValInt 4)) (I 11),
         assertVal "" (let x = Var "x" in  (Lam "x" ( x `Plus` x)) `App` (ValInt 7) ) (I 14),
         assertVal "singleton list" (Cons (ValInt 2) Nil) (Ls [I 2])
      ]

-- TODO: your tests here!!!
-- TODO: Many, many more example test cases (every simple thing, many normal things, some extreme things)
-- TODO: division by 0 gives an error, errors propagate correctly
-- TODO: standard lib tests: lenth and head
-- TODO: test functions returned behave correctly
-- TODO: some really long example
-- TODO: clean up the custom asserts (handle empty s better)