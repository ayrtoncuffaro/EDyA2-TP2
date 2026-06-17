module ListSeq where

import Seq
import Par

instance Seq [] where
    emptyS :: [a]
    emptyS = []

    singletonS :: a -> [a]
    singletonS x = [x]

    lengthS :: [a] -> Int
    lengthS = length

    nthS :: [a] -> Int -> a 
    nthS = (!!)
    
    tabulateS :: (Int -> a) -> Int -> [a]
    tabulateS f n = aux 0
        where
            aux i | i == n    = []
                  | otherwise = let (x, xs) = f i ||| aux (i+1)
                                in x:xs

    mapS :: (a -> b) -> [a] -> [b]
    mapS f [] = []
    mapS f (x:xs) = let (x', xs') = f x ||| mapS f xs
                    in x':xs'

    filterS :: (a -> Bool) -> [a] -> [a]
    filterS p [] = []
    filterS p (x:xs) = let (v, xs') = p x ||| filterS p xs
                       in if v then x:xs' else xs'

    appendS :: [a] -> [a] -> [a]
    appendS = (++)

    takeS :: [a] -> Int -> [a]
    takeS xs n = take n xs

    dropS :: [a] -> Int -> [a]
    dropS xs n = drop n xs

    showtS :: [a] -> TreeView a [a]
    showtS [] = EMPTY
    showtS [x] = ELT x
    showtS xs = NODE l r
        where
            m = div (lengthS xs) 2
            (l, r) = takeS xs m ||| dropS xs m


    showlS :: [a] -> ListView a [a]
    showlS [] = NIL
    showlS (x:xs) = CONS x xs

    joinS :: [[a]] -> [a]
    joinS = concat

    reduceS :: (a -> a -> a) -> a -> [a] -> a
    reduceS f e xs = case showtS xs of
        EMPTY    -> e
        ELT x    -> x
        NODE l r -> let (l', r') = reduceS f e l ||| reduceS f e r
                    in f l' r'
    
    scanS :: (a -> a -> a) -> a -> [a] -> ([a], a)
    scanS f b [] = ([], b)
    scanS f b [x] = ([b], x)
    scanS f b xs =  let contraccion [] = []
                        contraccion [x] = [x]
                        contraccion (x:y:ys) = 
                            let (x', ys') = f x y ||| contraccion ys
                            in x':ys'
                        
                        expansion [] _ = []
                        expansion [x] (s:_) = [s]
                        expansion (x:y:ys) (s:scanxs) = 
                            let (s', scanxs') = f s x ||| expansion ys scanxs
                            in s : s' : scanxs'

                        (cxs, total) = scanS f b (contraccion xs)

                    in (expansion xs cxs, total)
    
    fromList :: [a] -> [a]
    fromList = id