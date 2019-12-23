package main

import (
	"fmt"
)

const (
	NORTH = cardinal(1)
	SOUTH = cardinal(2)
	WEST  = cardinal(3)
	EAST  = cardinal(4)
)

type cardinal int

func (c cardinal) turnRight() cardinal {
	switch c {
	case NORTH:
		return EAST
	case SOUTH:
		return WEST
	case WEST:
		return NORTH
	case EAST:
		return SOUTH
	default:
		panic(fmt.Sprintf("Unknown direction: %s", c))
	}
}

func (c cardinal) turnLeft() cardinal {
	switch c {
	case NORTH:
		return WEST
	case SOUTH:
		return EAST
	case WEST:
		return SOUTH
	case EAST:
		return NORTH
	default:
		panic(fmt.Sprintf("Unknown direction: %s", c))
	}

}

func (c cardinal) String() string {
	switch c {
	case NORTH:
		return "NORTH"
	case EAST:
		return "EAST"
	case SOUTH:
		return "SOUTH"
	case WEST:
		return "WEST"
	default:
		panic("Unknown direction")
	}
}

var dfs = map[cardinal]delta{
	NORTH: {x: 0, y: 1},
	SOUTH: {x: 0, y: -1},
	EAST:  {x: 1, y: 0},
	WEST:  {x: -1, y: 0},
}

const (
	WALL   = 0
	MOVED  = 1
	OXYGEN = 2
)

type point struct {
	typ int
	cum int
}

// ret bool is true if a dead end was found
func explore(dir cardinal, input chan int, output chan int, x int, y int, area map[int]map[int]point, accum int) map[int]map[int]point {
	// Try to move
	printArea(area)
	try := dir.turnRight()
	d := dfs[try]
	nx := x + d.x
	ny := y + d.y
	input <- int(try)
	o := <-output
	row, ok := area[ny]
	if !ok {
		row = make(map[int]point)
	}
	pt, ok := row[nx]
	if ok {
		accum = pt.cum
	}
	row[nx] = point{
		typ: o,
		cum: accum,
	}
	area[ny] = row
	switch o {
	case WALL:
		area = explore(dir.turnLeft(), input, output, x, y, area, accum)
	case MOVED:
		area = explore(try, input, output, nx, ny, area, accum+1)
	case OXYGEN:
		fmt.Printf("Found oxygen at (%d, %d)", nx, ny)
	}
	return area

}

func printArea(area map[int]map[int]point) {
	ly, hy, lx, hx := bounds(area)
	clearScreen()
	println("AREA:")
	for y := hy; y >= ly; y-- {
		for x := lx; x <= hx; x++ {
			switch a := area[y][x]; a.typ {
			case WALL:
				print(" # ")
			case MOVED:
				print(fmt.Sprintf("%03d", a.cum))
			case OXYGEN:
				print(" ! ")
			}
		}
		println("")
	}
}

func bounds(area map[int]map[int]point) (int, int, int, int) {
	var ly int
	var hy int
	var lx int
	var hx int
	for y, line := range area {
		ly = min(ly, y)
		hy = max(hy, y)
		for x, _ := range line {
			lx = min(lx, x)
			hx = max(hx, x)
		}
	}
	return ly, hy, lx, hx
}

func d15p1(mem string) {
	input, output := runComputer(mem)
	startArea := make(map[int]map[int]point)
	ln := make(map[int]point)
	ln[0] = point{
		typ: MOVED,
		cum: 0,
	}
	startArea[0] = ln
	area := explore(NORTH, input, output, 0, 0, startArea, 1)
	printArea(area)
}
