package main

import "testing"

func ExampleSanity() {
	openqSanity(Verbose)
	// Output: [two foo five]
}

func BenchmarkSanity(b *testing.B) {
	for n := 0; n < b.N; n++ {
		openqSanity(Quiet)
	}
}
