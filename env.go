package main

import (
	"fmt"
	"math"
)

type Drive uint8

const (
	Nuclear Drive = 1
	Fusion  Drive = 2
	EFusion Drive = 2
	Ion     Drive = 3
	Am      Drive = 4
	EAm     Drive = 4
	Hyper   Drive = 5
	Ip      Drive = 6
	EIp     Drive = 6
)

type Env struct {
	Drive
}

type Coord struct {
	Sector string
	X, Y   int
}

func (node *Coord) Data() interface{} {
	return *node
}

// goodie for pretty-printing the array of ptrs:
func (pt *Coord) String() string {
	return fmt.Sprintf("%v", *pt)
}

type bbox struct{ w, h int }

type tile uint8

const (
	Block    tile = 0
	Space    tile = 11
	Nebula   tile = 16
	Viral    tile = 18
	Energy   tile = 20
	Asteroid tile = 25
	Exotic   tile = 36
)

func mvcost(tile tile, drive Drive) Cost {
	return Cost(int(tile) - int(drive))
}

var envbbox = map[string]bbox{}
var envdata = map[Coord]tile{}

type r struct{ c1, c2 int } // internal struct for env definition

func envbb(sector string, w, h int) {
	envbbox[sector] = bbox{w, h}
}

func env(sector string, v1, v2 interface{}, tile tile) {
	switch v1.(type) {
	case int:
		x := v1.(int)
		switch v2.(type) {
		case int:
			y := v2.(int)
			envdata[Coord{sector, x, y}] = tile
		case r:
			ry := v2.(r)
			for yi := ry.c1; yi <= ry.c2; yi++ {
				env(sector, x, yi, tile)
			}
		default:
			panic(fmt.Sprintf("unknown y type: `%v` %T", v2, v2))
		}
	case r:
		rx := v1.(r)
		for xi := rx.c1; xi <= rx.c2; xi++ {
			env(sector, xi, v2, tile)
		}
	default:
		panic(fmt.Sprintf("unknown x type: `%v` %T", v1, v1))
	}
}

func MakeEnv() {
	var enioar = "enioar"

	envbb(enioar, 20, 12)
	env(enioar, r{7, 9}, r{0, 1}, Energy)
	// env(enioar, 8, 0, 'wormhole(unused)')
	env(enioar, 8, 2, Energy)
	// env(enioar, 8, 2, 'choke(to(r{7,9},0-1})')
	env(enioar, 1, r{1, 5}, Energy)
	env(enioar, r{1, 3}, 1, Energy)
	env(enioar, r{16, 17}, r{1, 2}, Energy)
	env(enioar, r{0, 1}, r{2, 3}, Energy)
	env(enioar, 2, r{2, 4}, Energy)
	env(enioar, r{3, 4}, 2, Energy)
	env(enioar, r{14, 17}, 2, Energy)
	env(enioar, 3, r{3, 5}, Space)
	env(enioar, r{2, 3}, r{3, 4}, Space)
	env(enioar, r{4, 14}, 3, Energy)
	env(enioar, r{15, 16}, 3, Space)
	env(enioar, r{17, 18}, r{3, 4}, Energy)
	env(enioar, r{2, 15}, 4, Space)
	env(enioar, r{7, 15}, r{4, 6}, Space)
	env(enioar, 10, r{4, 10}, Space)
	env(enioar, r{10, 15}, r{4, 7}, Space)
	env(enioar, 16, r{4, 6}, Energy)
	env(enioar, r{16, 18}, 4, Energy)
	env(enioar, r{1, 2}, 5, Energy)
	env(enioar, r{4, 6}, r{5, 7}, Nebula)
	env(enioar, r{2, 3}, 6, Energy)
	env(enioar, 3, r{6, 8}, Energy)
	env(enioar, 7, r{7, 8}, Energy)
	env(enioar, r{7, 9}, 7, Energy)
	env(enioar, 9, r{7, 11}, Energy)
	env(enioar, r{16, 17}, 6, Energy)
	env(enioar, r{14, 15}, r{7, 8}, Nebula)
	env(enioar, 16, r{7, 8}, Space)
	env(enioar, 17, r{6, 9}, Energy)
	env(enioar, r{17, 20}, 7, Energy)
	// env(enioar, 18, 7, 'choke(to(r{19,20},6-8})')
	env(enioar, r{19, 20}, r{6, 8}, Energy)
	// env(enioar, 20, 7, 'wormhole(to(pf09, 0,7})')
	env(enioar, 2, r{8, 12}, Energy)
	env(enioar, r{2, 3}, 8, Energy)
	env(enioar, 5, r{8, 9}, Space)
	env(enioar, r{4, 5}, 8, Space)
	env(enioar, 6, r{8, 10}, Energy)
	env(enioar, r{6, 7}, 8, Energy)
	env(enioar, r{11, 13}, 8, Energy)
	env(enioar, r{1, 2}, r{9, 10}, Energy)
	env(enioar, r{3, 4}, r{9, 10}, Asteroid)
	env(enioar, 3, r{9, 11}, Asteroid)
	env(enioar, 4, 11, Space)
	env(enioar, 5, r{10, 12}, Energy)
	env(enioar, 11, r{8, 10}, Energy)
	env(enioar, r{11, 13}, 8, Energy)
	env(enioar, r{2, 5}, 12, Energy)
	env(enioar, r{9, 10}, 11, Energy)
	env(enioar, r{13, 17}, 9, Energy)
	env(enioar, r{11, 14}, 10, Energy)
	env(enioar, r{13, 14}, r{9, 11}, Energy)
	env(enioar, 13, r{8, 12}, Energy)
	env(enioar, r{11, 12}, 11, Space)
	env(enioar, r{10, 13}, 12, Energy)
	// env(enioar, 12, 12, 'wormhole(to(liaface, 9,0})')
	env(enioar, r{0, 6}, 0, Block)
	env(enioar, 0, 1, Block)
	env(enioar, r{4, 6}, r{0, 1}, Block)
	env(enioar, r{5, 6}, r{0, 2}, Block)
	env(enioar, r{5, 7}, 2, Block)
	env(enioar, 9, 2, Block)
	env(enioar, r{10, 13}, r{0, 2}, Block)
	env(enioar, r{10, 15}, r{0, 1}, Block)
	env(enioar, r{10, 20}, 0, Block)
	env(enioar, r{18, 20}, r{0, 2}, Block)
	env(enioar, 0, r{4, 12}, Block)
	env(enioar, r{0, 1}, r{6, 8}, Block)
	env(enioar, 2, 7, Block)
	env(enioar, r{0, 1}, r{11, 12}, Block)
	env(enioar, 8, 8, Block)
	env(enioar, r{7, 8}, r{9, 12}, Block)
	env(enioar, 6, 11, Block)
	env(enioar, r{6, 9}, 12, Block)
	env(enioar, 12, 9, Block)
	env(enioar, r{19, 20}, r{3, 5}, Block)
	env(enioar, r{17, 20}, 5, Block)
	env(enioar, 18, 6, Block)
	env(enioar, 18, 8, Block)
	env(enioar, r{18, 20}, r{9, 12}, Block)
	env(enioar, r{15, 20}, r{10, 12}, Block)
	env(enioar, 14, 12, Block)
	// enioar done.
}

func (e Env) Nbs(node Node) []Node {
	point := node.Data().(Coord)
	tile, ok := envdata[point]
	if !ok {
		panic(fmt.Sprintf("missing env at %v", point))
	}
	if tile == Block {
		return nil
	}

	nbs := make([]Node, 0, 8)

	add := func(dx, dy int) {
		newpoint := Coord{point.Sector, point.X + dx, point.Y + dy}
		v, ok := envdata[newpoint]
		if ok && v != Block {
			nbs = append(nbs, &newpoint)
		}
	}

	add(-1, -1)
	add(0, -1)
	add(+1, -1)
	add(+1, 0)
	add(+1, +1)
	add(0, +1)
	add(-1, +1)
	add(-1, 0)
	return nbs
}

func hAbstract(p1, p2 Coord) Cost {
	if p1.Sector != p2.Sector {
		panic("H() across sectors not implemented")
	}
	dx := p2.X - p1.X
	dy := p2.Y - p1.Y
	return Cost(math.Floor(math.Sqrt(float64(dx*dx) + float64(dy*dy))))
}

func (e Env) H(n1, n2 Node) Cost {
	scale := mvcost(Space, e.Drive)
	return scale * hAbstract(n1.Data().(Coord), n2.Data().(Coord))
}

func (e Env) Dist(n1, n2 Node) Cost {
	return mvcost(envdata[n1.Data().(Coord)], e.Drive)
}
