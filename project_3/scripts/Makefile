build: Dockerfile
	docker build -t mydocker . && touch $@

pull-pandas:
	docker pull amancevice/pandas:0.25.2-slim && touch $@

results/summary_genus_counts.tsv: pull-pandas data/all_hits.csv scripts/generate_report.py
	docker run -it \
		--rm -v $(shell pwd):/workdir \
		-w /workdir \
		amancevice/pandas:0.25.2-slim \
			python scripts/generate_report.py \
			data/all_hits.csv \
			results/summary
