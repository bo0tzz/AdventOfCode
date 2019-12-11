package main

import (
	_ "net/http/pprof"
	"strconv"
	"sync"
)

type computer struct {
	id           int
	memory       []int
	pointer      int
	relativeBase int
	input        chan int
	output       chan int
	instructions map[int]Instruction
	wg           *sync.WaitGroup
}

func newComputer(id int, memory []int, input chan int, output chan int, wg *sync.WaitGroup) *computer {
	mem := make([]int, len(memory))
	copy(mem, memory)
	comp := &computer{id: id, memory: mem, input: input, output: output, wg: wg, pointer: 0, relativeBase: 0}
	comp.instructions = MakeInstructionSet(*comp)
	return comp
}

func (comp *computer) parseInstruction() (Instruction, []int) {
	code := strconv.Itoa(comp.readMemory(comp.pointer))
	var s string
	if len(code) < 2 {
		s = code
	} else {
		s = code[len(code)-2:]
	}
	i, err := strconv.Atoi(s)
	if err != nil {
		panic(err)
	}
	instr := comp.instructions[i]
	var m string
	if len(code) < 2 {
		m = ""
	} else {
		m = code[:len(code)-2]
	}
	modes := make([]int, 0)
	for _, mode := range m {
		modes = append(modes, int(mode-'0'))
	}
	missing := instr.params - len(modes)
	if instr.write {
		missing++
	}
	for i := 0; i < missing; i++ {
		modes = append(modes, 0)
	}
	reverse(modes)
	return instr, modes
}

func (comp *computer) getParams(count int, modes []int) []int {
	params := make([]int, count)
	for i := 0; i < count; i++ {
		p := comp.readMemory(comp.pointer + i + 1)
		mode := 0
		if i < len(modes) {
			mode = modes[i]
		}

		param := 0
		if mode == 0 {
			param = comp.readMemory(p)
		} else if mode == 2 {
			param = comp.readMemory(comp.relativeBase + p)
		} else {
			param = p
		}

		params[i] = param
	}

	return params
}

func (comp *computer) resize(index int) bool {
	if index > len(comp.memory) {
		size := len(comp.memory) * 2
		if index > size {
			size += index
		}
		newMem := make([]int, size)
		copy(newMem, comp.memory)
		comp.memory = newMem
		return true
	}
	return false
}

func (comp *computer) readMemory(index int) int {
	comp.resize(index)
	return comp.memory[index]
}

func (comp *computer) writeMemory(index int, param int) {
	comp.resize(index)
	comp.memory[index] = param
}

func (comp *computer) run() {
	for {
		offset := 1
		op, modes := comp.parseInstruction()
		offset += op.params

		params := comp.getParams(op.params, modes)

		if op.code == 99 {
			if comp.wg != nil {
				comp.wg.Done()
			}
			if comp.output != nil {
				close(comp.output)
			}
			return
		}
		res := op.op(params)

		if op.write {
			mode := modes[op.params]
			var target int
			if mode == 2 {
				target = comp.relativeBase //FIXME?
			} else {
				target = comp.readMemory(comp.pointer + op.params + 1)
			}
			comp.writeMemory(target, res)
			offset++
		}

		if op.jump && res != -1 {
			comp.pointer = res
		} else {
			comp.pointer += offset
		}

	}
}
