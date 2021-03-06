-- |
-- Module      : Benchmarks.List
-- Copyright   : (c) 2018 Harendra Kumar
--
-- License     : MIT
-- Maintainer  : harendra.kumar@gmail.com

module Benchmarks.List where

import Benchmarks.Common (value, maxValue)
import Prelude (Int, (+), id, ($), (.), even, (>), (<=), subtract, undefined,
                maxBound)

import qualified Data.List          as S

-------------------------------------------------------------------------------
-- Stream generation and elimination
-------------------------------------------------------------------------------

{-# INLINE source #-}
source :: Int -> [Int]
source v = [v..v+value]

-------------------------------------------------------------------------------
-- Elimination
-------------------------------------------------------------------------------

{-# INLINE toNull #-}
{-# INLINE toList #-}
{-# INLINE foldl #-}
{-# INLINE last #-}
toNull, toList :: [Int] -> [Int]
foldl :: [Int] -> Int
last  :: [Int] -> Int

toNull = id
toList = id
foldl  = S.foldl' (+) 0
last   = S.last

-------------------------------------------------------------------------------
-- Transformation
-------------------------------------------------------------------------------

{-# INLINE transform #-}
transform :: [a] -> [a]
transform = id

{-# INLINE composeN #-}
composeN :: Int -> ([Int] -> [Int]) -> [Int] -> [Int]
composeN n f =
    case n of
        1 -> transform . f
        2 -> transform . f . f
        3 -> transform . f . f . f
        4 -> transform . f . f . f . f
        _ -> undefined

{-# INLINE scan #-}
{-# INLINE map #-}
{-# INLINE mapM #-}
{-# INLINE filterEven #-}
{-# INLINE filterAllOut #-}
{-# INLINE filterAllIn #-}
{-# INLINE takeOne #-}
{-# INLINE takeAll #-}
{-# INLINE takeWhileTrue #-}
{-# INLINE dropOne #-}
{-# INLINE dropAll #-}
{-# INLINE dropWhileTrue #-}
{-# INLINE dropWhileFalse #-}
scan, map, mapM,
    filterEven, filterAllOut, filterAllIn,
    takeOne, takeAll, takeWhileTrue,
    dropOne, dropAll, dropWhileTrue, dropWhileFalse
    :: Int -> [Int] -> [Int]

scan           n = composeN n $ S.scanl' (+) 0
map            n = composeN n $ S.map (+1)
mapM             = map
filterEven     n = composeN n $ S.filter even
filterAllOut   n = composeN n $ S.filter (> maxValue)
filterAllIn    n = composeN n $ S.filter (<= maxValue)
takeOne        n = composeN n $ S.take 1
takeAll        n = composeN n $ S.take maxValue
takeWhileTrue  n = composeN n $ S.takeWhile (<= maxValue)
dropOne        n = composeN n $ S.drop 1
dropAll        n = composeN n $ S.drop maxValue
dropWhileFalse n = composeN n $ S.dropWhile (<= 1)
dropWhileTrue  n = composeN n $ S.dropWhile (<= maxValue)

-------------------------------------------------------------------------------
-- Mixed Composition
-------------------------------------------------------------------------------

{-# INLINE scanMap #-}
{-# INLINE dropMap #-}
{-# INLINE dropScan #-}
{-# INLINE takeDrop #-}
{-# INLINE takeScan #-}
{-# INLINE takeMap #-}
{-# INLINE filterDrop #-}
{-# INLINE filterTake #-}
{-# INLINE filterScan #-}
{-# INLINE filterMap #-}
scanMap, dropMap, dropScan, takeDrop, takeScan, takeMap, filterDrop,
    filterTake, filterScan, filterMap
    :: Int -> [Int] -> [Int]

scanMap    n = composeN n $ S.map (subtract 1) . S.scanl' (+) 0
dropMap    n = composeN n $ S.map (subtract 1) . S.drop 1
dropScan   n = composeN n $ S.scanl' (+) 0 . S.drop 1
takeDrop   n = composeN n $ S.drop 1 . S.take maxValue
takeScan   n = composeN n $ S.scanl' (+) 0 . S.take maxValue
takeMap    n = composeN n $ S.map (subtract 1) . S.take maxValue
filterDrop n = composeN n $ S.drop 1 . S.filter (<= maxValue)
filterTake n = composeN n $ S.take maxValue . S.filter (<= maxValue)
filterScan n = composeN n $ S.scanl' (+) 0 . S.filter (<= maxBound)
filterMap  n = composeN n $ S.map (subtract 1) . S.filter (<= maxValue)

-------------------------------------------------------------------------------
-- Zipping and concat
-------------------------------------------------------------------------------

{-# INLINE zip #-}
zip :: [Int] -> [(Int, Int)]
zip src       = transform $ (S.zipWith (,) src src)

{-# INLINE concat #-}
concat :: [Int] -> [Int]
concat src    = transform $ (S.concatMap (S.replicate 3) src)
