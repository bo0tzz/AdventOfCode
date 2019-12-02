(ns day2-1)

(defn parse-int [s]
  (Integer/parseInt s))

(defn mapStrToInt
  [seq]
  (map parse-int seq))

(defn rangeDiff
  [first, last]
  (- last first))

(defn sortedSetToRangeDiff
  [srtdSet]
  (rangeDiff (first srtdSet) (last srtdSet)))

(def reader (clojure.java.io/reader "in.txt"))
(def lines (line-seq reader))
(def separated (map #(clojure.string/split % #"[\s|\t|\n]") lines))
(def intParsed (map mapStrToInt separated))
(def sortedInts (map #(into (sorted-set) %) intParsed))

(def diffs (map sortedSetToRangeDiff sortedInts))
(def checksum (reduce + diffs))
(println (str "checksum: " checksum))
