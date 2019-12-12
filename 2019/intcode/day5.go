package main

import (
	"strconv"
	"strings"
	"sync"
)

func d5p1(input string) {
	split := strings.Split(input, ",")

	mem := make([]int, len(split))
	for index, token := range split {
		i, err := strconv.Atoi(token)
		if err != nil {
			panic(err)
		}
		mem[index] = i
	}

	var wg sync.WaitGroup
	wg.Add(1)

	in, out := make(chan int, 10), make(chan int, 10)
	in <- 5
	comp := newComputer(0, mem, in, out, &wg)
	comp.run()
	for o := range out {
		println(o)
	}

}
