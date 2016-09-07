package main

import (
	"container/heap"
	"fmt"
)

type QItem struct {
	value    Node
	priority Cost
	t        int // 'timestamp' so that items added earlier have it lower
}
type Queue []*QItem

type OpenQS struct {
	set      map[interface{}]struct{}
	queue    Queue
	tcounter int
}

// pretty-print:
func (x *QItem) String() string {
	return fmt.Sprintf("%v", *x)
}

// heap.Interface impl

func (q Queue) Len() int { return len(q) }

func (q Queue) Less(i, j int) bool {
	pri1, pri2 := q[i].priority, q[j].priority
	if pri1 == pri2 {
		return q[i].t < q[j].t
	}
	return pri1 < pri2
}

func (q Queue) Swap(i, j int) { q[i], q[j] = q[j], q[i] }

func (q *Queue) Push(x interface{}) {
	*q = append(*q, x.(*QItem))
}

func (q *Queue) Pop() interface{} {
	old := *q
	n := len(old)
	x := old[n-1]
	*q = old[0 : n-1]
	return x
}

// external API for OpenQS

func (qs *OpenQS) Init() {
	qs.queue = make(Queue, 0, 10)
	qs.set = map[interface{}]struct{}{}
	qs.tcounter = 0
}

func (qs *OpenQS) Add(v Node, priority Cost) {
	qs.tcounter++
	heap.Push(&qs.queue, &QItem{v, priority, qs.tcounter})
	qs.set[v] = struct{}{}
}

func (qs *OpenQS) Pop() Node {
	for {
		v := heap.Pop(&qs.queue).(*QItem).value
		if _, ok := qs.set[v]; ok {
			delete(qs.set, v)
			return v
		}
	}
}

func (qs *OpenQS) Len() int { return len(qs.set) }

func (qs *OpenQS) Contains(v Node) bool {
	_, ok := qs.set[v]
	return ok
}
