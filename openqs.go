package main

import (
	"container/heap"
)

type QItem struct {
	value    *Node
	priority Cost
}
type Queue []*QItem

type OpenQS struct {
	set   map[interface{}]struct{}
	queue Queue
}

// heap.Interface impl

func (q Queue) Len() int           { return len(q) }
func (q Queue) Less(i, j int) bool { return q[i].priority < q[j].priority }
func (q Queue) Swap(i, j int)      { q[i], q[j] = q[j], q[i] }

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
}

func (qs *OpenQS) Add(v Node, priority Cost) {
	heap.Push(&qs.queue, &QItem{&v, priority})
	qs.set[v] = struct{}{}
}

func (qs *OpenQS) Pop() *Node {
	for {
		v := heap.Pop(&qs.queue).(*QItem).value
		key := *v
		if _, ok := qs.set[key]; ok {
			delete(qs.set, key)
			return v
		}
	}
}

func (qs *OpenQS) Len() int { return len(qs.set) }

func (qs *OpenQS) Contains(v Node) bool {
	_, ok := qs.set[v]
	return ok
}
