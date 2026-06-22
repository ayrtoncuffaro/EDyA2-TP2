module ArrSeq where

import Seq
import qualified Arr as A
import Par

instance Seq A.Arr where
    emptyS :: A.Arr a
    emptyS = A.empty


    singletonS :: a -> A.Arr a
    singletonS x = A.fromList [x]


    lengthS :: A.Arr a -> Int
    lengthS = A.length


    nthS :: A.Arr a -> Int -> a
    nthS = (A.!)


    tabulateS :: (Int -> a) -> Int -> A.Arr a
    tabulateS = A.tabulate


    mapS :: (a -> b) -> A.Arr a -> A.Arr b
    mapS f s = tabulateS (\i -> f (nthS s i)) (lengthS s)


    appendS :: A.Arr a -> A.Arr a -> A.Arr a
    appendS s1 s2 = let n1 = lengthS s1
                        n2 = lengthS s2
                    in tabulateS (\i -> if i < n1 
                                        then nthS s1 i 
                                        else nthS s2 (i-n1)) 
                                        (n1 + n2)


    takeS :: A.Arr a -> Int -> A.Arr a
    takeS s i = A.subArray 0 i s
    

    dropS :: A.Arr a -> Int -> A.Arr a
    dropS s i = A.subArray i (lengthS s - i) s
    

    showtS :: A.Arr a -> TreeView a (A.Arr a)
    showtS s = case lengthS s of
                    0 -> EMPTY
                    1 -> ELT (nthS s 0)
                    n -> let m = div n 2
                         in NODE (A.subArray 0 m s) (A.subArray m (n - m) s)
    

    showlS :: A.Arr a -> ListView a (A.Arr a)
    showlS s = case lengthS s of
                    0 -> NIL
                    n -> CONS (nthS s 0) (A.subArray 1 (n - 1) s)


    joinS :: A.Arr (A.Arr a) -> A.Arr a
    joinS = A.flatten


    filterS :: (a -> Bool) -> A.Arr a -> A.Arr a
    filterS f s = joinS (mapS (\x -> if f x then singletonS x else emptyS) s)


    reduceS :: (a -> a -> a) -> a -> A.Arr a -> a
    reduceS f b s = f b (red f b s)
        where
            red f b s =
                case showtS s of
                    EMPTY    -> b
                    ELT x    -> x
                    NODE l r -> let (l1, r1) = red f b l ||| red f b r 
                                in f l1 r1


    scanS :: (a -> a -> a) -> a -> A.Arr a -> (A.Arr a, a)
    scanS f b s = 
        case lengthS s of
            0 -> (emptyS, b)
            1 -> (singletonS b, f b (nthS s 0))
            _ -> 
                let n = lengthS s
                    m = div n 2
                    
                    contraccion s' = 
                        let len = A.length s' 
                            mid = div len 2
                            s'' = A.tabulate (\i -> f (s' A.! (2*i)) (s' A.! (2*i+1))) mid
                        in  if mod len 2 == 0 
                            then s'' 
                            else appendS s'' (singletonS (s' A.! (len-1)))

                    expansion s' ss' = 
                        tabulateS (\i -> if mod i 2 == 0 
                                         then ss' A.! (div i 2)
                                         else f (ss' A.! (div i 2)) (s' A.! (i-1)))
                                  (lengthS s')
                    
                    (cs, total) = scanS f b (contraccion s)
            
                in (expansion s cs, total)


    fromList :: [a] -> A.Arr a
    fromList = A.fromList