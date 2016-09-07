go:
	go fmt
	go build
	go test -cover

goresult:
	go build
	./vger

gotiming:
	go test -bench=. -benchmem	

pyall: pytypes pytest pytiming

pyresult:
	python3 map.py

pytiming:
	python3 -mtimeit 'import map; map.run()'

pytest:
	py.test

pytypes:
	mypy -i *.py
