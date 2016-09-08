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
	for x := 0; x <= bbox.w; x++ {
		for y := 0; y <= bbox.h; y++ {
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
	// [{enioar 2 1} {enioar 1 2} {enioar 2 2} {enioar 0 2}]
	// [{enioar 16 6} {enioar 17 7} {enioar 16 5} {enioar 18 7} {enioar 16 7}]
	// [{enioar 11 12} {enioar 10 11} {enioar 9 11} {enioar 11 11}]
	// [{enioar 19 8} {enioar 20 7} {enioar 19 7}]
	// []
	// [{enioar 17 7} {enioar 19 7} {enioar 17 6} {enioar 19 8} {enioar 17 8} {enioar 19 6}]
}

func BenchmarkNbs(b *testing.B) {
	for n := 0; n < b.N; n++ {
		Env{Ion}.Nbs(Coord{Enioar, 10, 10})
	}
}

func ExampleAstar() {
	fmt.Print(astarWellKnownPath())
	// Output:
	// [{enioar 2 2} {enioar 3 3} {enioar 4 4} {enioar 5 4} {enioar 6 4} {enioar 7 4} {enioar 8 4} {enioar 9 4} {enioar 10 4} {enioar 11 4} {enioar 12 4} {enioar 13 4} {enioar 14 5} {enioar 15 6} {enioar 16 7} {enioar 17 7} {enioar 18 7} {enioar 19 7} {enioar 20 7}]
}

func ExampleMoreAstar() {
	env := Env{Ion}
	fmt.Println(Astar(env, Coord{Enioar, 4, 12}, Coord{Enioar, 5, 3}))
	// Output:
	// [{enioar 4 11} {enioar 5 10} {enioar 5 9} {enioar 5 8} {enioar 6 7} {enioar 7 6} {enioar 7 5} {enioar 6 4} {enioar 5 3}]
}

// generator for quick.Check:
func (c Coord) Generate(rand *rand.Rand, size int) reflect.Value {
	c.Sector = Enioar
	bbox := envbbox[c.Sector]
	c.X = rand.Intn(bbox.w + 1)
	c.Y = rand.Intn(bbox.h + 1)
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
