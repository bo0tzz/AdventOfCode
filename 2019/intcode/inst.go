package main

type operator = func([]int) int

type Instruction struct {
	code   int
	name   string
	params int
	op     operator
	write  bool
	jump   bool
}

func MakeInstructionSet(comp computer) map[int]Instruction {
	return map[int]Instruction{
		1: {
			code:   1,
			name:   "add",
			params: 2,
			op:     add,
			write:  true,
			jump:   false,
		},
		2: {
			code:   2,
			name:   "mul",
			params: 2,
			op:     mul,
			write:  true,
			jump:   false,
		},
		3: {
			code:   3,
			name:   "input",
			params: 0,
			op:     comp.in,
			write:  true,
			jump:   false,
		},
		4: {
			code:   4,
			name:   "output",
			params: 1,
			op:     comp.out,
			write:  false,
			jump:   false,
		},
		5: {
			code:   5,
			name:   "jump-true",
			params: 2,
			op:     jt,
			write:  false,
			jump:   true,
		},
		6: {
			code:   6,
			name:   "jump-false",
			params: 2,
			op:     jf,
			write:  false,
			jump:   true,
		},
		7: {
			code:   7,
			name:   "lt",
			params: 2,
			op:     lt,
			write:  true,
			jump:   false,
		},
		8: {
			code:   8,
			name:   "eq",
			params: 2,
			op:     eq,
			write:  true,
			jump:   false,
		},
		99: {
			code:   99,
			name:   "exit",
			params: 0,
			op:     nil,
			write:  false,
			jump:   false,
		},
	}
}

func add(params []int) int {
	return params[0] + params[1]
}

func mul(params []int) int {
	return params[0] * params[1]
}

func jt(params []int) int {
	if params[0] != 0 {
		return params[1]
	} else {
		return -1
	}
}

func jf(params []int) int {
	if params[0] == 0 {
		return params[1]
	} else {
		return -1
	}
}

func lt(params []int) int {
	var isLt = params[0] < params[1]
	if isLt {
		return 1
	} else {
		return 0
	}
}

func eq(params []int) int {
	var isEq = params[0] == params[1]
	if isEq {
		return 1
	} else {
		return 0
	}
}

func (comp *computer) in(params []int) int {
	v := <-comp.input
	println(comp.id, "received", v, "from", comp.input)
	return v
}

func (comp *computer) out(params []int) int {
	println(comp.id, "sent", params[0], "to", comp.output)
	comp.output <- params[0]
	return 0 // Return value is ignored
}
