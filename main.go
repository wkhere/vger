package main

import (
	"flag"
	"fmt"
)

func astarWellKnownPath() []Node {
	return Astar(Env{Ion}, Coord{"enioar", 1, 1}, Coord{"enioar", 20, 7})
}

func main() {
	well := flag.Bool("well", false, "run with well known data")
	flag.Parse()

	MakeEnv()
	if *well {
		fmt.Printf("%v\n", astarWellKnownPath())
	}
}
