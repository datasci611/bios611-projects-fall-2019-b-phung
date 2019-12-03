build: Dockerfile
	docker build -t mydocker . && touch $@

pull-pandas:
	docker pull amancevice/pandas:0.25.2-slim && touch $@

zip.csv:
	docker run -it --rm -v $(shell pwd):/workdir -w /workdir amancevice/pandas:0.25.2-slim \
	python scripts/wrangle.py

