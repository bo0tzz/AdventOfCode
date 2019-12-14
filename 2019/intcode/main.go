package main

import (
	"io/ioutil"
)

func read(filename string) string {
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		panic(err)
	}

	return string(content)
}

func main() {
	str := read("2019/14/in")
	d14p2(str)
}
