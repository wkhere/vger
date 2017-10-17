go:
	go fmt
	go build
	go test -cover

goresult:
	go build
	./vger -well

gotiming:
	go test -bench=. -benchmem github.com/wkhere/astar .

goprof:
	go test -cpuprofile=cprof.now -bench=Astar 
	go tool pprof -weblist=. cprof.now

gopy: go pytest
	zsh -c 'diff -u <(./vger -well) <(python3 map.py)'

pyall: pytypes pytest pytiming

pyresult:
	python3 map.py

pytiming:
	python3 -mtimeit 'import map; map.run()'

pytest:
	py.test

pytypes:
	mypy -i *.py
