package main

type Cost int

type Node interface {
	Data() interface{}
}

type GraphConfig interface {
	Nbs(Node) []Node
	Dist(n1, n2 Node) Cost
	H(n1, n2 Node) Cost
}

func Astar(config GraphConfig, node0, goal Node) (path []Node) {
	return nil
}
