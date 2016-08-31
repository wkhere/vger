py:
	python3 map.py

pytiming:
	python3 -mtimeit 'import map; map.run()'

pytest:
	py.test
