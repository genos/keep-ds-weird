(require '[tesser.core :as t])            ; [tesser.core "1.0.2"]
(require '[clojure.core.matrix :as m])    ; [net.mikera/core.matrix "0.61.0"]

(let
  [k 10
   n 10000
   zero (m/zero-matrix k k)
   vecs (for [_ (range n)] (shuffle (range k)))
   a (->> vecs
          (map m/permutation-matrix)
          (reduce m/add zero))
   b (->> (t/map m/permutation-matrix)
          (t/reduce m/add zero)
          (t/tesser [vecs]))]
  (println (str "Are a and b equal? " (= a b)))
  (m/pm a))
