# Ejercicio B: Especificación de costos para ListSeq

Dada la implementación en `ListSeq.hs`, donde las secuencias se representan mediante listas de Haskell (`[]`), se presentan a continuación los costos de trabajo ($W$) y profundidad ($S$).

Consideramos $n$ como la longitud de la secuencia y $W(f)$ / $S(f)$ como el trabajo y profundidad de la función pasada como argumento.

### 1. filterS
La implementación utiliza recursión lineal sobre la estructura de la lista:
```haskell
filterS p (x:xs) = let (v, xs') = p x ||| filterS p xs
                   in if v then x:xs' else xs'
```
*   **Trabajo ($W$):** $O(n \cdot W(p))$. Cada elemento de la lista es procesado una vez, realizando una llamada al predicado `p` y una construcción de lista (`:`), que es $O(1)$.
*   **Profundidad ($S$):** $O(n + S(p))$. Aunque se utiliza `|||` para paralelizar la evaluación del predicado y la llamada recursiva, la naturaleza secuencial de las listas (donde el acceso al resto de la estructura depende de la cabeza) impone una profundidad lineal proporcional a la cantidad de elementos.

### 2. reduceS
La implementación utiliza una estrategia de división y conquista basada en un `TreeView`:
```haskell
reduceS f e xs = case showtS xs of ... NODE l r -> let (l', r') = reduceS f e l ||| reduceS f e r ...
```
Donde `showtS` para listas se define como:
```haskell
showtS xs = NODE l r
    where
        m = div (lengthS xs) 2
        (l, r) = takeS xs m ||| dropS xs m
```
*   **Trabajo ($W$):** $O(n \log n + n \cdot W(f))$. En cada nivel del árbol de recursión (que tiene profundidad $\log n$), se realizan operaciones de `lengthS`, `takeS` y `dropS`. En el primer nivel, estas operaciones cuestan $O(n)$; en el segundo nivel, se realizan sobre dos sublistas de tamaño $n/2$, sumando nuevamente $O(n)$, y así sucesivamente. Al haber $\log n$ niveles, el trabajo total acumulado por estas operaciones de división es $O(n \log n)$. A esto se suma el trabajo de aplicar la función $f$ en cada nodo del árbol.
*   **Profundidad ($S$):** $O(n + S(f))$. La profundidad está dominada por las operaciones `takeS` y `dropS` que son secuenciales sobre listas. Aunque las ramas del árbol se procesan en paralelo, la división de la lista en cada paso toma tiempo lineal respecto al tamaño del segmento. La recurrencia es $S(n) = S(n/2) + O(n)$, lo que resulta en $O(n)$.

### 3. scanS
Utiliza un algoritmo de contracción y expansión:
*   **Trabajo ($W$):** $O(n + n \cdot W(f))$. Tanto la fase de contracción como la de expansión recorren la lista linealmente. La recurrencia de trabajo es $W(n) = W(n/2) + O(n)$, lo que resulta en $O(n)$.
*   **Profundidad ($S$):** $O(n + S(f))$. De manera similar a los casos anteriores, el recorrido y la construcción de la lista resultante son operaciones secuenciales. La recurrencia de profundidad es $S(n) = S(n/2) + O(n)$, resultando en $O(n)$.
