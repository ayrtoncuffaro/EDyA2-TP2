# Ejercicio D: Demostración de profundidad de reduceS para ArrSeq

Se desea demostrar que la implementación de `reduceS` en `ArrSeq.hs` cumple con la especificación de costos para la profundidad ($S$):
$$S(\text{reduceS } f \text{ } b \text{ } s) = O(\log |s|)$$

### Implementación analizada
En `ArrSeq.hs`, `reduceS` se define mediante una función auxiliar `red`:
```haskell
reduceS f b s = f b (red f b s)
    where
        red f b s = case showtS s of
            EMPTY    -> b
            ELT x    -> x
            NODE l r -> let (l1, r1) = red f b l ||| red f b r 
                        in f l1 r1
```

La operación `showtS` para arreglos (`Arr`) se implementa como:
```haskell
showtS s = case lengthS s of
                0 -> EMPTY
                1 -> ELT (nthS s 0)
                n -> let m = div n 2
                     in NODE (A.subArray 0 m s) (A.subArray m (n - m) s)
```

### Análisis de costos de las primitivas
De acuerdo a la especificación dada para el tipo `Arr` en el enunciado y la simplificación mencionada por la cátedra acerca de los operadores binarios:
1.  `lengthS s`: $O(1)$ trabajo y profundidad.
2.  `nthS s i`: $O(1)$ trabajo y profundidad.
3.  `subArray i n s`: $O(1)$ trabajo y profundidad (puesto que es una operación que devuelve una vista del arreglo original sin copiar elementos).
4.  `f x y`: $O(1)$ profundidad (asumido por simplificación para el ejercicio).

Por lo tanto, la operación `showtS` tiene un costo de profundidad:
$$S(\text{showtS } n) = O(1)$$
y la profundidad de la función combinadora es $S(f) = O(1)$.

### Recurrencia para la profundidad de `red`
Sea $n = |s|$. La profundidad de la función `red` se puede expresar mediante la siguiente recurrencia:
*   Para el caso base ($n \le 1$): $S_{red}(n) = O(1)$.
*   Para el caso recursivo ($n > 1$):
    $$S_{red}(n) = S(\text{showtS } n) + \max(S_{red}(\lfloor n/2 \rfloor), S_{red}(\lceil n/2 \rceil)) + S(f) + O(1)$$
    Dado que se utiliza el operador de paralelismo `|||`, las dos llamadas recursivas se ejecutan concurrentemente, por lo que tomamos el máximo de sus profundidades. $S(f)$ representa la profundidad de aplicar la función combinadora `f`.

Sustituyendo $S(\text{showtS } n) = O(1)$:
$$S_{red}(n) = S_{red}(n/2) + S(f) + O(1)$$

Al resolver esta recurrencia (que corresponde a un árbol balanceado de altura $\log n$):
$$S_{red}(n) = \sum_{i=1}^{\log_2 n} O(1) = O(\log n)$$

### Conclusión
Finalmente, `reduceS` realiza una llamada adicional a `f`:
$$S(\text{reduceS } f \text{ } b \text{ } s) = S(f) + S_{red}(|s|) = O(1) + O(\log |s|)$$
$$S(\text{reduceS } f \text{ } b \text{ } s) = O(\log |s|)$$

Esto verifica que la implementación dada en `ArrSeq.hs` cumple con la especificación de costos para la profundidad de la operación `reduceS` sobre arreglos paralelos.
