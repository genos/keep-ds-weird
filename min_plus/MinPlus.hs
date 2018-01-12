module Main where
-- With help from http://r6.ca/blog/20110808T035622Z.html

import Control.Applicative
import Data.Foldable

data MinPlus = Inf
             | MP {-# UNPACK #-} !Double
             deriving (Eq, Ord)

instance Show MinPlus where
    show (MP x) = show x
    show Inf    = "∞"

zero, one :: MinPlus
zero = Inf
one = MP 0

infixl 6 .+.
infixl 7 .*.

(.+.) :: MinPlus -> MinPlus -> MinPlus
x      .+. Inf    = x
Inf    .+. y      = y
(MP x) .+. (MP y) = MP (min x y)

(.*.) :: MinPlus -> MinPlus -> MinPlus
Inf    .*. _      = Inf
_      .*. Inf    = Inf
(MP x) .*. (MP y) = MP (x + y)

instance Num MinPlus where
    (+)         = (.+.)
    (*)         = (.*.)
    fromInteger = MP . fromInteger
    abs         = undefined
    signum      = undefined
    negate      = undefined

dotList :: [MinPlus] -> [MinPlus] -> MinPlus
xs `dotList` ys = foldl' (.+.) zero $ zipWith (.*.) xs ys

dot :: (Foldable f, Applicative f) => f MinPlus -> f MinPlus -> MinPlus
xs `dot` ys = foldl' (.+.) zero $ (.*.) <$> xs <*> ys

main :: IO ()
main = do
  print $ 3 .*. 4 .+. 5
  print $ MP 3 * 4 + 5
  let (x, y, u, v) =
        ([Inf, 8, 6, 7, 5, 3, 0, 9], reverse x, ZipList x, ZipList y)
  print x
  print $ x `dotList` y
  print $ u `dot` v
