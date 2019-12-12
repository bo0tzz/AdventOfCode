package main

import (
	prmt "github.com/gitchander/permutation"
	"strconv"
	"strings"
	"sync"
)

func d7p2(input string) {
	split := strings.Split(input, ",")

	mem := make([]int, len(split))
	for index, token := range split {
		i, err := strconv.Atoi(token)
		if err != nil {
			panic(err)
		}
		mem[index] = i
	}

	perm := []int{5, 6, 7, 8, 9}
	p := prmt.New(prmt.IntSlice(perm))

	outputSignals := make([]int, 0)
	for p.Next() {
		var wg sync.WaitGroup
		wg.Add(5)

		input := make(chan int, 10)
		input <- perm[0]
		input <- 0

		AOut := make(chan int, 10)
		AOut <- perm[1]
		A := newComputer(0, mem, input, AOut, &wg)

		BOut := make(chan int, 10)
		BOut <- perm[2]
		B := newComputer(1, mem, AOut, BOut, &wg)

		COut := make(chan int, 10)
		COut <- perm[3]
		C := newComputer(2, mem, BOut, COut, &wg)

		DOut := make(chan int, 10)
		DOut <- perm[4]
		D := newComputer(3, mem, COut, DOut, &wg)

		E := newComputer(4, mem, DOut, input, &wg)

		go A.run()
		go B.run()
		go C.run()
		go D.run()
		go E.run()

		wg.Wait()

		out := <-input
		outputSignals = append(outputSignals, out)
	}

	max := 0
	for _, out := range outputSignals {
		println(out)
		if out > max {
			max = out
		}
	}

	println(max)

}

func d7p1(input string) {
	split := strings.Split(input, ",")

	mem := make([]int, len(split))
	for index, token := range split {
		i, err := strconv.Atoi(token)
		if err != nil {
			panic(err)
		}
		mem[index] = i
	}

	perm := []int{0, 1, 2, 3, 4}
	p := prmt.New(prmt.IntSlice(perm))

	outputSignals := make([]int, 0)
	for p.Next() {
		var wg sync.WaitGroup
		wg.Add(5)

		input := make(chan int, 10)
		input <- perm[0]
		input <- 0

		AOut := make(chan int, 10)
		AOut <- perm[1]
		A := newComputer(0, mem, input, AOut, &wg)

		BOut := make(chan int, 10)
		BOut <- perm[2]
		B := newComputer(1, mem, AOut, BOut, &wg)

		COut := make(chan int, 10)
		COut <- perm[3]
		C := newComputer(2, mem, BOut, COut, &wg)

		DOut := make(chan int, 10)
		DOut <- perm[4]
		D := newComputer(3, mem, COut, DOut, &wg)

		EOut := make(chan int, 10)
		E := newComputer(4, mem, DOut, EOut, &wg)

		go A.run()
		go B.run()
		go C.run()
		go D.run()
		go E.run()

		wg.Wait()

		out := <-EOut
		outputSignals = append(outputSignals, out)
	}

	max := 0
	for _, out := range outputSignals {
		if out > max {
			max = out
		}
	}

	print(max)

}
