package main

import (
	"flag"
	"fmt"
	"math/rand"
	"os"
	"reflect"
	"testing"
	"testing/quick"
)

func TestMain(m *testing.M) {
	flag.Parse()
	MakeEnv()
	os.Exit(m.Run())
}

func openqExample() []Node {
	openq := new(OpenQS)
	openq.Init()
	openq.Add("foo", 10)
	openq.Add("five", 5)
	openq.Add("five2", 5)
	openq.Add("foo", 3)
	openq.Add("two", 2)
	res := make([]Node, 0, 3)
	for openq.Len() > 0 {
		v := openq.Pop()
		res = append(res, v)
	}
	return res
}

func ExampleOpenqOps() {
	fmt.Print(openqExample())
	// Output: [two foo five five2]
}

func BenchmarkOpenqOps(b *testing.B) {
	for n := 0; n < b.N; n++ {
		openqExample()
	}
}

func TestEnvIsComplete(t *testing.T) {
	sector := Enioar
	bbox := envbbox[sector]
	for x := 0; x <= bbox.maxX; x++ {
		for y := 0; y <= bbox.maxY; y++ {
			_, ok := envdata[Coord{sector, x, y}]
			if !ok {
				t.Errorf("no key for (%s,%d,%d)", sector, x, y)
			}
		}
	}
}

func ExampleNbs() {
	e := Env{Ion}
	p := func(x, y int) {
		fmt.Println(e.Nbs(Coord{Enioar, x, y}))
	}
	p(0, 0)
	p(0, 12)
	p(20, 0)
	p(20, 12)
	p(1, 1)
	p(17, 6)
	p(10, 12)
	p(20, 8)
	p(7, 9)
	p(18, 7)
	// Output:
	// []
	// []
	// []
	// []
	// [{Enioar 2 1} {Enioar 1 2} {Enioar 2 2} {Enioar 0 2}]
	// [{Enioar 16 6} {Enioar 17 7} {Enioar 16 5} {Enioar 18 7} {Enioar 16 7}]
	// [{Enioar 11 12} {Enioar 10 11} {Enioar 9 11} {Enioar 11 11}]
	// [{Enioar 19 8} {Enioar 20 7} {Enioar 19 7}]
	// []
	// [{Enioar 17 7} {Enioar 19 7} {Enioar 17 6} {Enioar 19 8} {Enioar 17 8} {Enioar 19 6}]
}

func BenchmarkNbs(b *testing.B) {
	for n := 0; n < b.N; n++ {
		Env{Ion}.Nbs(Coord{Enioar, 10, 10})
	}
}

func ExampleAstar() {
	fmt.Print(astarWellKnownPath())
	// Output:
	// [{Enioar 2 2} {Enioar 3 3} {Enioar 4 4} {Enioar 5 4} {Enioar 6 4} {Enioar 7 4} {Enioar 8 4} {Enioar 9 4} {Enioar 10 4} {Enioar 11 4} {Enioar 12 4} {Enioar 13 4} {Enioar 14 5} {Enioar 15 6} {Enioar 16 7} {Enioar 17 7} {Enioar 18 7} {Enioar 19 7} {Enioar 20 7}]
}

func ExampleMoreAstar() {
	env := Env{Ion}
	fmt.Println(Astar(env, Coord{Enioar, 4, 12}, Coord{Enioar, 5, 3}))
	// Output:
	// [{Enioar 4 11} {Enioar 5 10} {Enioar 5 9} {Enioar 5 8} {Enioar 6 7} {Enioar 7 6} {Enioar 7 5} {Enioar 6 4} {Enioar 5 3}]
}

// generator for quick.Check:
func (c Coord) Generate(rand *rand.Rand, size int) reflect.Value {
	c.Sector = Enioar
	bbox := envbbox[c.Sector]
	c.X = rand.Intn(bbox.maxX + 1)
	c.Y = rand.Intn(bbox.maxY + 1)
	return reflect.ValueOf(c)
}

func TestPathsAreStraight(t *testing.T) {
	env := Env{Ion}
	f := func(p0 Coord) bool {
		if envdata[p0] == Space {
			defer func() {
				recover() // this relies on default bool = false
			}()
			checkY(p0, Astar(env, p0, findStraightX(p0, +1)))
			checkY(p0, Astar(env, p0, findStraightX(p0, -1)))
			checkX(p0, Astar(env, p0, findStraightY(p0, +1)))
			checkX(p0, Astar(env, p0, findStraightY(p0, -1)))
		}
		return true
	}
	if err := quick.Check(f, nil); err != nil {
		t.Error(err)
	}
}

func BenchmarkAstar(b *testing.B) {
	for n := 0; n < b.N; n++ {
		astarWellKnownPath()
	}
}

// private

func findStraightX(p0 Coord, dx int) Coord {
	p := p0
	for xi := p0.X + 1; ; xi += dx {
		pi := Coord{p0.Sector, xi, p0.Y}
		if envdata[pi] != Space {
			break
		}
		p = pi
	}
	return p
}

func findStraightY(p0 Coord, dy int) Coord {
	p := p0
	for yi := p0.Y + 1; ; yi += dy {
		pi := Coord{p0.Sector, p0.X, yi}
		if envdata[pi] != Space {
			break
		}
		p = pi
	}
	return p
}

func checkY(p0 Coord, path []Node) {
	for _, p := range path {
		if p.(Coord).Y != p0.Y {
			panic("Y differs")
		}
	}
}

func checkX(p0 Coord, path []Node) {
	for _, p := range path {
		if p.(Coord).X != p0.X {
			panic("X differs")
		}
	}
}
