(set-env! :dependencies '[[tesser.core "1.0.2"]
                          [net.mikera/core.matrix "0.61.0"]])

(require '[tesser.core :as t])
(require '[clojure.core.matrix :as m])

(defn -main [& args]
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
            (t/tesser [vecs]))
     matrices-equal (if (= a b) "Yes" "No")]
    (println (str "\n\nAre a and b equal? " matrices-equal "\n"))
    (m/pm a)))
