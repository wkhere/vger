package main

import (
	"fmt"
)

const Verbose = 1
const Quiet = 0

type SNode struct{ string }

func (node SNode) Data() interface{} { return node.string }

func openqSanity(verbosity int) {
	openq := new(OpenQS)
	openq.Init()
	openq.Add(SNode{"foo"}, 10)
	openq.Add(SNode{"five"}, 5)
	openq.Add(SNode{"foo"}, 3)
	openq.Add(SNode{"two"}, 2)
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
	MakeEnv()
}
