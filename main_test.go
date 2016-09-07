package main

import (
	"flag"
	"fmt"
	"os"
	"testing"
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
	sector := "enioar"
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
		fmt.Println(e.Nbs(Coord{"enioar", x, y}))
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
		Env{Ion}.Nbs(Coord{"enioar", 10, 10})
	}
}

func ExampleAstar() {
	// The result here is different than for Py. By reordering the nbs I got
	// rid of some 'slalom'.
	fmt.Print(astarWellKnownPath())
	// Output:
	// [{enioar 2 2} {enioar 3 3} {enioar 4 4} {enioar 5 4} {enioar 6 4} {enioar 7 4} {enioar 8 4} {enioar 9 4} {enioar 10 4} {enioar 11 4} {enioar 12 4} {enioar 13 4} {enioar 14 5} {enioar 15 6} {enioar 16 7} {enioar 17 7} {enioar 18 7} {enioar 19 7} {enioar 20 7}]
}

func BenchmarkAstar(b *testing.B) {
	for n := 0; n < b.N; n++ {
		astarWellKnownPath()
	}
}
