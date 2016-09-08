package main

import "fmt"

// pretty-print:
func (x *QItem) String() string {
	return fmt.Sprintf("%v", *x)
}
