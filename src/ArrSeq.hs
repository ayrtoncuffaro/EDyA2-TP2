module ListSeq where

import Seq
import qualified Arr as A
import Par

instance Seq Arr where
    emptyS :: Arr a
    emptyS = A.empty

    singletonS :: a -> Arr a
    singletonS x = A.fromList [x]

    lengthS :: Arr a -> Int
    lengthS = A.length

    nthS :: Arr a -> Int -> a
    nthS = (A.!)

    tabulateS :: (Int -> a) -> Int -> Arr a
    tabulateS = A.tabulate

    mapS :: (a -> b) -> Arr a -> Arr b
    mapS f s = tabulateS (\i -> f (nthS s i)) (lengthS s)

    filterS :: (a -> Bool) -> Arr a -> Arr a

    appendS :: Arr a -> Arr a -> Arr a
    appendS s1 s2 = let n1 = lengthS s1
                        n2 = lengthS s2
                    in tabulateS (\i -> if i < n 
                                        then nthS s i 
                                        else nthS t (i-n)) 
                                        (n + m)

    takeS :: Arr a -> Int -> Arr a
    takeS s i = A.subArray 0 i
    
    dropS :: Arr a -> Int -> s a
    dropS s i = A.subArray i (lengthS s - i)
    
    showtS :: Arr a -> TreeView a (Arr a)
    showtS s | s == emptyS    = EMPTY
             | lengthS s == 1 = ELT (nthS s 0)
             | otherwise      = let n = lengthS s
                                    m = div n 2
                                in NODE (A.subArray 0 m) (A.subArray m (n - m))
    
    showlS :: Arr a -> ListView a (Arr a)
    showlS s | s == emptyS = NIL
             | otherwise   = CONS (nthS s 0) (A.subArray 1 (lengthS s - 1))


    joinS :: Arr (Arr a) -> Arr a
    joinS = A.flatten

    reduceS    :: (a -> a -> a) -> a -> Arr a -> a
    
    scanS      :: (a -> a -> a) -> a -> Arr a -> (Arr a, a)
    
    fromList   :: [a] -> Arr a