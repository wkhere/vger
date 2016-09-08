package main

import "container/heap"

type qitem struct {
	value    Node
	priority Cost
	t        int // 'timestamp' so that items added earlier have it lower
}
type queue []*qitem

type OpenQS struct {
	q        queue
	s        map[Node]struct{}
	tcounter int
}

// heap.Interface impl

func (q queue) Len() int { return len(q) }

func (q queue) Less(i, j int) bool {
	pri1, pri2 := q[i].priority, q[j].priority
	if pri1 == pri2 {
		return q[i].t < q[j].t
	}
	return pri1 < pri2
}

func (q queue) Swap(i, j int) { q[i], q[j] = q[j], q[i] }

func (q *queue) Push(x interface{}) {
	*q = append(*q, x.(*qitem))
}

func (q *queue) Pop() interface{} {
	old := *q
	n := len(old)
	x := old[n-1]
	*q = old[0 : n-1]
	return x
}

// external API for OpenQS

func (qs *OpenQS) Init() {
	qs.q = make(queue, 0, 10)
	qs.s = map[Node]struct{}{}
	qs.tcounter = 0
}

func (qs *OpenQS) Add(v Node, priority Cost) {
	qs.tcounter++
	heap.Push(&qs.q, &qitem{v, priority, qs.tcounter})
	qs.s[v] = struct{}{}
}

func (qs *OpenQS) Pop() Node {
	for {
		v := heap.Pop(&qs.q).(*qitem).value
		if _, ok := qs.s[v]; ok {
			delete(qs.s, v)
			return v
		}
	}
}

func (qs *OpenQS) Len() int { return len(qs.s) }

func (qs *OpenQS) Contains(v Node) bool {
	_, ok := qs.s[v]
	return ok
}
