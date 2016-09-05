package main

import (
	"fmt"
)

const Verbose = 1
const Quiet = 0

func openqSanity(verbosity int) {
	openq := new(OpenQS)
	openq.Init()
	openq.Add("foo", 10)
	openq.Add("five", 5)
	openq.Add("foo", 3)
	openq.Add("two", 2)
	res := make([]Node, 0, 3)
	for openq.Len() > 0 {
		vptr := openq.Pop()
		res = append(res, *vptr)
	}
	if verbosity > Quiet {
		fmt.Printf("%v\n", res)
	}
}

func main() {
	openqSanity(Verbose)
}
