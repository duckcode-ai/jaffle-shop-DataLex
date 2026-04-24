.PHONY: setup seed build test clean

setup:
	python -m venv .venv
	. .venv/bin/activate && pip install -r requirements.txt

seed:
	dbt seed --profiles-dir .

build:
	dbt build --profiles-dir .

test:
	dbt test --profiles-dir .

clean:
	dbt clean --profiles-dir .
