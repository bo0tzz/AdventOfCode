package main

func d9p1(input string) {
	mem := readMem(input)
	channel := make(chan int, 10)
	channel <- 1
	comp := newComputer(0, mem, channel, nil, nil)
	comp.run()
}
