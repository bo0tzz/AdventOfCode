(ns day2-2
  (:require [combinatory :as combinatory]))                 ; combinatory is a copypaste from a library - idk how 2 include

(defn parse-int [s]
  (Integer/parseInt s))

; turn a sequence of strings into a sequence of ints
(defn mapStrToInt
  [seq]
  (map parse-int seq))

; return whether two numbers divide evenly
(defn divideEvenly?
  [num denom]
  (= 0 (mod num denom)))

; return all combinations of numbers that divide evenly (should only be one)
(defn getEvenDividers
  [bunchOfNumberCombinations]
  (filter #(divideEvenly? (first %) (second %)) bunchOfNumberCombinations))

; return all 2 number combinations from the collection of numbers
(defn combineAndReverse
  [line]
  (let
    [combined (combinatory/combinations line 2)]
    (into combined (map #(reverse %) combined))))       ; combinatory/combinations treats (n m) and (m n) as identical,
                                                        ; while they are not for this case

(defn divide
  [numberTuple]
  (/ (first numberTuple) (second numberTuple)))

(def reader (clojure.java.io/reader "in.txt"))
(def lines (line-seq reader))
(def separated (map #(clojure.string/split % #"[\s|\t|\n]") lines))
(def intParsed (map mapStrToInt separated))
(def evenDividers (apply concat (map #(getEvenDividers (combineAndReverse %)) intParsed)))
(def finalSum (reduce #(+ %1 (divide %2)) 0 evenDividers))
(println finalSum)
