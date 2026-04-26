PYTHON ?= python3.12

.PHONY: setup seed build test serve docker-build docker-up docker-down clean

setup:
	$(PYTHON) -m venv .venv
	. .venv/bin/activate && pip install --upgrade pip
	. .venv/bin/activate && pip install -r requirements.txt
	. .venv/bin/activate && pip install 'datalex-cli[serve,duckdb]>=1.3.5'

seed:
	dbt seed --profiles-dir .

build:
	dbt build --profiles-dir .

test:
	dbt test --profiles-dir .

serve:
	datalex serve --project-dir .

docker-build:
	docker build -t jaffle-shop-datalex:local .

docker-up:
	docker compose up --build

docker-down:
	docker compose down

clean:
	dbt clean --profiles-dir .
