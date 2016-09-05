package main

import "testing"

func TestEnvIsComplete(t *testing.T) {
	MakeEnv()
	sector := "enioar"
	bbox := envbbox[sector]
	for x := 0; x <= bbox.w; x++ {
		for y := 0; y <= bbox.h; y++ {
			_, ok := envdata[EnvCoord{sector, x, y}]
			if !ok {
				t.Errorf("no key for (%s,%d,%d)", sector, x, y)
			}
		}
	}
}

func ExampleSanity() {
	openqSanity(Verbose)
	// Output: [two foo five]
}

func BenchmarkSanity(b *testing.B) {
	for n := 0; n < b.N; n++ {
		openqSanity(Quiet)
	}
}
