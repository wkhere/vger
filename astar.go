package main

type Cost int
type Node interface{}

type Graph interface {
	Nbs(Node) []Node
	Dist(n1, n2 Node) Cost
	H(n1, n2 Node) Cost
}

func Astar(graph Graph, node0, goal Node) (path []Node) {
	closedset := map[Node]struct{}{}
	parents := map[Node]Node{}
	g := map[Node]Cost{node0: 0}
	f0 := graph.H(node0, goal)
	openq := new(OpenQS)
	openq.Init()
	openq.Add(node0, f0)
	path = nil

	for openq.Len() > 0 {
		x := openq.Pop()
		if x == goal {
			consPath(goal, parents, &path)
			return path
		}

		closedset[x] = struct{}{}

		for _, y := range graph.Nbs(x) {
			if _, ok := closedset[y]; ok {
				continue
			}

			est_g := g[x] + graph.Dist(x, y)

			var updating bool

			if openq.Contains(y) {
				if est_g < g[y] {
					updating = true
				} else {
					continue
				}
			}

			parents[y] = x
			g[y] = est_g
			fy := graph.H(y, goal) + est_g
			if updating {
				openq.Update(y, fy)
			} else {
				openq.Add(y, fy)
			}
		}
	}
	return
}

func consPath(node Node, parents map[Node]Node, path *[]Node) {
	for {
		parent, ok := parents[node]
		if ok {
			*path = append(*path, node)
			node = parent
		} else {
			break
		}
	}
	reverse(*path)
}

func reverse(path []Node) {
	for i, j := 0, len(path)-1; i < j; i, j = i+1, j-1 {
		path[i], path[j] = path[j], path[i]
	}
}
