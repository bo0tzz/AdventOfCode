package main

const (
	UP    = direction(iota)
	RIGHT = direction(iota)
	DOWN  = direction(iota)
	LEFT  = direction(iota)
)

type direction int

func (d direction) left() direction {
	e := d - 1
	if e < 0 {
		e = 3
	}
	return e
}

func (d direction) right() direction {
	e := d + 1
	if e > 3 {
		e = 0
	}
	return e
}

type delta struct {
	x int
	y int
}

var deltas = map[direction]delta{
	UP:    delta{0, 1},
	RIGHT: delta{1, 0},
	DOWN:  delta{0, -1},
	LEFT:  delta{-1, 0},
}

func d11p1(mem string) {
	input, output := runComputer(mem)
	hull := make(map[int]map[int]int)
	x, y := 0, 0
	dir := UP

	touched := make(map[delta]struct{}, 0)
	for {
		line, ok := hull[y]
		if !ok {
			line = make(map[int]int)
		}

		panel, ko := line[x]
		if !ko {
			panel = 0
		}

		input <- panel
		color, running := <-output
		if !running {
			break
		}

		line[x] = color
		hull[y] = line

		delt := delta{x: x, y: y}
		if _, in := touched[delt]; !in {
			touched[delt] = struct{}{}
		}

		newDir := <-output
		if newDir == 0 {
			dir = dir.left()
		} else if newDir == 1 {
			dir = dir.right()
		}

		d := deltas[dir]
		x += d.x
		y += d.y

	}

	println(len(touched))

}
