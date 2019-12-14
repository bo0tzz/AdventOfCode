package main

import (
	"math"
	"regexp"
	"strconv"
	"strings"
)

var quantityRegex, _ = regexp.Compile(`(\d+)\s(\w+)`)

type chemical struct {
	name string
}

func (c chemical) String() string {
	return c.name
}

type quantity struct {
	chem   chemical
	amount int
}

func (q quantity) String() string {
	return strconv.Itoa(q.amount) + " " + q.chem.String()
}

func (q quantity) times(mult int) quantity {
	return quantity{
		chem:   q.chem,
		amount: q.amount * mult,
	}
}

type reaction struct {
	inputs []quantity
	output quantity
}

func (r reaction) String() string {
	s := ""
	for _, input := range r.inputs {
		s += input.String()
		s += ", "
	}
	s = strings.Trim(s, ", ")
	s += " => "
	s += r.output.String()
	return s
}

func parseQuantity(match []string) quantity {
	chem := chemical{name: match[2]}
	amount, _ := strconv.Atoi(match[1])
	return quantity{
		chem:   chem,
		amount: amount,
	}
}

func parseQuantities(q string) []quantity {
	matches := quantityRegex.FindAllStringSubmatch(q, -1)
	quantities := make([]quantity, 0)
	for _, match := range matches {
		quantities = append(quantities, parseQuantity(match))
	}
	return quantities
}

func parseReaction(in string) reaction {
	split := strings.Split(in, "=>")
	i, o := split[0], split[1]
	ins := parseQuantities(i)
	outs := parseQuantities(o)[0]
	return reaction{
		inputs: ins,
		output: outs,
	}
}

func oreCostToProduce(quan quantity, reactions map[chemical]reaction, spare map[chemical]int) (int, map[chemical]int) {

	if quan.chem.name == "ORE" {
		return quan.amount, spare
	}

	needed := quan.amount
	if s, ok := spare[quan.chem]; ok {
		for needed > 0 && s > 0 {
			needed -= 1
			s--
		}
		spare[quan.chem] = s
	}

	if needed < 1 {
		return 0, spare
	}

	react := reactions[quan.chem]
	mult := 1
	for react.output.amount*mult < needed {
		mult += 1
	}

	cost := 0
	for _, input := range react.inputs {
		dcost := 0
		dcost, spare = oreCostToProduce(input.times(mult), reactions, spare)
		cost += dcost
	}

	spare[quan.chem] += react.output.amount*mult - needed

	return cost, spare

}

func d14p1(input string) {
	lines := strings.Split(input, "\n")
	reactions := make(map[chemical]reaction)
	for _, r := range lines {
		rct := parseReaction(r)
		reactions[rct.output.chem] = rct
	}
	goal := quantity{
		chem:   chemical{name: "FUEL"},
		amount: 1,
	}
	spare := make(map[chemical]int)
	cost, _ := oreCostToProduce(goal, reactions, spare)
	println(cost)
}

func d14p2(input string) {
	lines := strings.Split(input, "\n")
	reactions := make(map[chemical]reaction)
	for _, r := range lines {
		rct := parseReaction(r)
		reactions[rct.output.chem] = rct
	}

	amount := 1
	goal := quantity{
		chem:   chemical{name: "FUEL"},
		amount: amount,
	}
	spare := make(map[chemical]int)
	cost, _ := oreCostToProduce(goal, reactions, spare)

	cache := map[int]int{amount: cost}
	for {
		amount *= 2
		goal := quantity{
			chem:   chemical{name: "FUEL"},
			amount: amount,
		}
		spare := make(map[chemical]int)
		c, _ := oreCostToProduce(goal, reactions, spare)
		cache[amount] = c
		println(amount, c)
		if c > 1000000000000 {
			break
		}
	}

	low := 0
	high := 0
	for k, _ := range cache {
		high = int(math.Max(float64(high), float64(k)))
	}
	target := 1000000000000
	for {
		if low == high {
			println("DONE: ", low)
		}
		mid := low + (high-low)/2
		cost, ok := cache[mid]
		if !ok {
			cost, _ = oreCostToProduce(quantity{chem: chemical{name: "FUEL"}, amount: mid}, reactions, make(map[chemical]int))
			cache[mid] = cost
		}
		println(mid, cost)
		if cost < target {
			low = mid
		} else {
			high = mid
		}
	}
}
