build: Dockerfile
	docker build -t mydocker . && touch $@

pull-pandas:
	docker pull amancevice/pandas:0.25.2-slim && touch $@

create-csv:
	docker run -d --rm -v "$(shell pwd)":"$(shell pwd)" -w "$(shell pwd)"
	python scripts/wrangle.py

