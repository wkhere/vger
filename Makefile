go:
	go fmt
	go build
	go test -cover

goresult:
	go build
	./vger -well

gotiming:
	go test -bench=. -benchmem	

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
