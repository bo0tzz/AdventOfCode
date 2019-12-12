package main

import (
	"strconv"
	"strings"
)

func reverse(slice []int) {
	for i := len(slice)/2 - 1; i >= 0; i-- {
		opp := len(slice) - 1 - i
		slice[i], slice[opp] = slice[opp], slice[i]
	}
}

func readMem(input string) []int {
	split := strings.Split(input, ",")

	mem := make([]int, len(split))
	for index, token := range split {
		i, err := strconv.Atoi(token)
		if err != nil {
			panic(err)
		}
		mem[index] = i
	}

	return mem
}
