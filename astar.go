package main

type Cost int
type Node interface{}

type GraphConfig interface {
	Nbs(Node) []Node
	Dist(n1, n2 Node) Cost
	H(n1, n2 Node) Cost
}

func Astar(config GraphConfig, node0, goal Node) (path []Node) {
	closedset := map[Node]struct{}{}
	parents := map[Node]Node{}
	g := map[Node]Cost{node0: 0}
	f0 := config.H(node0, goal)
	openq := new(OpenQS)
	openq.Init()
	openq.Add(node0, f0)
	path = nil

	var consPath func(node Node)
	consPath = func(node Node) {
		parent, ok := parents[node]
		if ok {
			consPath(parent)
			path = append(path, node)
		}
	}

	for openq.Len() > 0 {
		x := *openq.Pop()
		if x == goal {
			consPath(goal)
			return path
		}

		closedset[x] = struct{}{}

		for _, y := range config.Nbs(x) {
			if _, ok := closedset[y]; ok {
				continue
			}

			est_g := g[x] + config.Dist(x, y)

			if openq.Contains(y) && est_g >= g[y] {
				continue
			}

			parents[y] = x
			g[y] = est_g
			fy := config.H(y, goal) + est_g
			openq.Add(y, fy)
		}
	}
	return
}
