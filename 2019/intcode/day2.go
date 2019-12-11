package main

import (
	"strconv"
	"strings"
	"sync"
)

func d2p1(input string) {
	split := strings.Split(input, ",")

	mem := make([]int, len(split))
	for index, token := range split {
		i, err := strconv.Atoi(token)
		if err != nil {
			panic(err)
		}
		mem[index] = i
	}

	mem[1] = 12
	mem[2] = 2

	var wg sync.WaitGroup
	wg.Add(1)
	comp := newComputer(0, mem, nil, make(chan int), &wg)
	comp.run()
	println(comp.memory[0])

}
