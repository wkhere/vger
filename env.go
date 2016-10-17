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
	Sector Sector
	X, Y   int
}

type Sector uint

func (sector Sector) String() string {
	return sectors[sector]
}

// goodie for pretty-printing the array of ptrs:
// func (pt *Coord) String() string {
// 	return fmt.Sprintf("%v", *pt)
// }

type bbox struct{ maxX, maxY int }

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

var envbbox []bbox
var envdata map[Coord]tile
var envmemo map[Node][]Node
var sectors []string

type r struct{ c1, c2 int } // internal struct for env definition

func envbb(sector Sector, w, h int) {
	envbbox[sector] = bbox{w, h}
}

func env(sector Sector, v1, v2 interface{}, tile tile) {
	switch x := v1.(type) {
	case int:
		switch y := v2.(type) {
		case int:
			envdata[Coord{sector, x, y}] = tile
		case r:
			for yi := y.c1; yi <= y.c2; yi++ {
				env(sector, x, yi, tile)
			}
		default:
			panic(fmt.Sprintf("unknown y type: `%v` %T", v2, v2))
		}
	case r:
		for xi := x.c1; xi <= x.c2; xi++ {
			env(sector, xi, v2, tile)
		}
	default:
		panic(fmt.Sprintf("unknown x type: `%v` %T", v1, v1))
	}
}

func (e Env) Nbs(node Node) []Node {
	if memo, ok := envmemo[node]; ok {
		return memo
	}

	point := node.(Coord)
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
			nbs = append(nbs, newpoint)
		}
	}

	add(-1, 0)
	add(+1, 0)
	add(0, -1)
	add(0, +1)
	add(-1, -1)
	add(+1, +1)
	add(-1, +1)
	add(+1, -1)

	envmemo[node] = nbs
	return nbs
}

func hAbstract(p1, p2 Coord) Cost {
	if p1.Sector != p2.Sector {
		panic("H() across sectors not implemented")
	}
	dx := p2.X - p1.X
	dy := p2.Y - p1.Y
	return Cost(math.Floor(math.Hypot(float64(dx), float64(dy))))
}

func (e Env) H(n1, n2 Node) Cost {
	scale := mvcost(Space, e.Drive)
	return scale * hAbstract(n1.(Coord), n2.(Coord))
}

func (e Env) Dist(n1, n2 Node) Cost {
	return mvcost(envdata[n1.(Coord)], e.Drive)
}
