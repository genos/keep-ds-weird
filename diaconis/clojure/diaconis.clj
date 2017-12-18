(require '[tesser.core :as t])
(require '[clojure.core.matrix :as m])

(let
  [k 5
   n 500
   zero (m/zero-matrix k k)
   ps (for [_ (range n)] (shuffle (range k)))
   a (->> ps
          (map m/permutation-matrix)
          (reduce m/add zero))
   b (->> (t/map m/permutation-matrix)
          (t/reduce m/add zero)
          (t/tesser [ps]))
   matrices-equal (if (= a b) "Yes" "No")]
  (println (str "Are a and b equal? " matrices-equal "\n"))
  (m/pm a {:formatter (comp str int)} ))

(System/exit 0)
