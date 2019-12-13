package main

import (
	"os"
	"os/exec"
)

var tiles = map[int]string{
	0: " ",
	1: "=",
	2: "#",
	3: "_",
	4: "@",
}

type drawEvent struct {
	typ string
	x   int
}

func playGame(gameInput chan int, gameState chan drawEvent) {
	var paddleX int
	var ballX int
	for stateUpdate := range gameState {
		if stateUpdate.typ == "paddle" {
			paddleX = stateUpdate.x
			continue
		} else if stateUpdate.typ == "ball" {
			ballX = stateUpdate.x
		}
		dir := 0
		if paddleX < ballX {
			dir = 1
		} else if paddleX > ballX {
			dir = -1
		}
		gameInput <- dir
	}
}

func d13p2(mem string) {
	memory := readMem(mem)
	memory[0] = 2
	input := make(chan int, 10)
	output := make(chan int, 10)
	comp := newComputer(0, memory, input, output, nil)
	go comp.run()

	drawn := make(chan drawEvent, 100)
	go playGame(input, drawn)

	screen := make(map[int]map[int]int)
	for ln := 0; ln < 50; ln++ {
		screen[ln] = make(map[int]int)
	}

	score := 0
	for {
		if x, ok := <-output; ok {
			y := <-output
			id := <-output
			if x == -1 && y == 0 {
				score = id
			} else {
				if id == 3 {
					drawn <- drawEvent{typ: "paddle", x: x}
				} else if id == 4 {
					drawn <- drawEvent{typ: "ball", x: x}
				}
				screen[y][x] = id
			}
			draw(screen, score)
		} else {
			break
		}
	}

	println("FINAL SCORE: ", score)

}

func draw(screen map[int]map[int]int, score int) {
	clearScreen()
	for i := 0; i < 27; i++ {
		if line, ok := screen[i]; ok {
			for j := 0; j < 50; j++ {
				if point, ko := line[j]; ko {
					print(tiles[point])
				}
			}
			println("")
		}
	}
	println("SCORE: ", score)
}

func clearScreen() {
	cmd := exec.Command("clear")
	cmd.Stdout = os.Stdout
	_ = cmd.Run()
}
