package main

import (
	"fmt"
	"math"

	"github.com/wkhere/astar"
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

type ShipLocation struct {
	Drive
	Coord
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

func mvcost(tile tile, drive Drive) astar.Cost {
	return astar.Cost(int(tile) - int(drive))
}

var envbbox []bbox
var envdata map[Coord]tile
var envmemo map[astar.Node][]astar.Node
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

func hAbstract(p1, p2 Coord) astar.Cost {
	if p1.Sector != p2.Sector {
		panic("H() across sectors not implemented")
	}
	dx := p2.X - p1.X
	dy := p2.Y - p1.Y
	return astar.Cost(math.Floor(math.Hypot(float64(dx), float64(dy))))
}

func (point Coord) Nbs() []astar.Node {
	if memo, ok := envmemo[point]; ok {
		return memo
	}

	tile, ok := envdata[point]
	if !ok {
		panic(fmt.Sprintf("missing env at %v", point))
	}
	if tile == Block {
		return nil
	}

	nbs := make([]astar.Node, 0, 8)

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

	envmemo[point] = nbs
	return nbs
}

func (p1 Coord) DistanceTo(n2 astar.Node) astar.Cost {
	return mvcost(envdata[p1], Ion) // FIX hardcoded drive
}

func (p1 Coord) EstimateTo(n2 astar.Node) astar.Cost {
	scale := mvcost(Space, Ion) // FIX hardcoded drive
	return scale * hAbstract(p1, n2.(Coord))
}
