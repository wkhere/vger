package main

import "fmt"

func astarWellKnownPath() []Node {
	return Astar(Env{Ion}, Coord{"enioar", 1, 1}, Coord{"enioar", 20, 7})
}

func main() {
	MakeEnv()
	fmt.Printf("%v\n", astarWellKnownPath())
}
