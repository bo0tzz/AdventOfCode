package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"unicode"
)

type Circular struct {
	Array []int
}

func (c Circular) index(n int) int {
	return c.Array[n]
}

func (c Circular) slice(index, length int) Circular {
	if index + length > len(c.Array) {
		out := make([]int, length)
		for i := 0; length > 0; i++ {
			if index >= len(c.Array) {
				index = 0
			}
			out[i] = c.Array[index]
			index++
			length--
		}
		return Circular{out}
	} else {
		out := make([]int, length)
		copy(out, c.Array[index : index + length])
		return Circular{out}
	}
}

func (c *Circular) reverse() {
	for i, j := 0, len(c.Array)-1; i < j; i, j = i+1, j-1 {
		c.Array[i], c.Array[j] = c.Array[j], c.Array[i]
	}
}

func (c *Circular) insert(index int, d Circular) {
	if len(d.Array) > len(c.Array) - index {
		length := len(d.Array)
		for i := 0; length > 0; i++ {
			if index >= len(c.Array) {
				index = 0
			}
			c.Array[index] = d.Array[i]
			index++
			length--
		}
	} else {
		length := len(d.Array)
		for i := 0; length > 0; i++ {
			fmt.Println(index)
			c.Array[index] = d.Array[i]
			index++
			length--
		}
	}
}

func (c *Circular) append(d Circular) {
	c.Array = append(c.Array, d.Array...)
}

func makeRange(from, to int) Circular {
	out := make([]int, to-from+1)
	for i := range out {
		out[i] = from + i
	}
	return Circular{out}
}

func KnotHash(numRange, lengths Circular, index, skip int) (Circular, int, int) {
	for _, length := range lengths.Array {
		s := numRange.slice(index, length)
		s.reverse()
		numRange.insert(index, s)
		index = (index + length + skip) % len(numRange.Array)
		skip++
	}
	return numRange, index, skip
}

func cumulativeXOR(nums Circular) int {

	out := nums.Array[0]
	for i := 1; i < len(nums.Array); i++ {
		out = out ^ nums.Array[i]
	}
	return out
}

func DenseHash(c Circular) string {
	out := ""
	for i := 0; i < len(c.Array); i += 16 {
		s := c.slice(i, 16)
		x := cumulativeXOR(s)
		hex := fmt.Sprintf("%02x", x)
		out += hex
	}
	return out
}

func stripControlchars(str string) string {
	return strings.Map(func(r rune) rune {
		if unicode.IsControl(r) {
			return -1
		}
		return r
	}, str)
}

func main() {

	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter input: ")
	text, _ := reader.ReadString('\n')
	fmt.Print(text)
	text = stripControlchars(text)
	fmt.Print(text)
	readStrings := strings.Split(text, ",")
	fmt.Println(readStrings)
	runes := []rune(text)
	ints := Circular{make([]int, len(runes))}
	for i := 0; i < len(runes); i++ {
		ints.Array[i] = int(runes[i])
	}
	if text == "" {
		ints = Circular{[]int{17, 31, 73, 47, 23}}
	} else {
		ints.append(Circular{[]int{17, 31, 73, 47, 23}})
	}
	fmt.Println(ints)

	out := makeRange(0, 255)
	index, skip := 0, 0
	for i := 0; i < 64; i++ {
		out, index, skip = KnotHash(out, ints, index, skip)
	}

	dense := DenseHash(out)
	fmt.Printf("Dense hash is %v\n", dense)

}
