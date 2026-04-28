PYTHON ?= $(shell command -v python3.12 2>/dev/null || command -v python3.11 2>/dev/null || command -v python3 2>/dev/null)
VENV := .venv
BIN := $(VENV)/bin

.PHONY: setup doctor seed build test serve readiness-gate docs-reindex policy-check emit-catalog docker-build docker-up docker-down clean

setup:
	@test -n "$(PYTHON)" || (echo "Python 3.12 or 3.11 is required. Install one, then rerun make setup."; exit 1)
	@$(PYTHON) -c 'import sys; v=sys.version_info; print(f"Using Python {sys.version.split()[0]}"); sys.exit(0 if (3, 11) <= v < (3, 13) else f"Python 3.11 or 3.12 is required for dbt here; got {sys.version.split()[0]}")'
	chflags -R nouchg,nohidden $(VENV) 2>/dev/null || true
	rm -rf $(VENV)
	$(PYTHON) -m venv $(VENV)
	$(BIN)/python -m pip install --upgrade pip
	$(BIN)/python -m pip install -r requirements.txt
	$(BIN)/python -m pip install --no-cache-dir 'datalex-cli[serve,duckdb]>=1.4.0'

doctor:
	@$(BIN)/python --version
	@$(BIN)/dbt --version
	@$(BIN)/datalex --version

seed:
	rm -rf target
	$(BIN)/dbt seed --profiles-dir .

build:
	$(BIN)/dbt build --profiles-dir .

test:
	$(BIN)/dbt test --profiles-dir .

serve:
	$(BIN)/datalex serve --project-dir .

# DataLex 1.4 — red/yellow/green readiness gate (also runs in CI).
readiness-gate:
	$(BIN)/datalex readiness-gate --project . --min-score 70 \
	  --sarif datalex-readiness.sarif --pr-comment datalex-readiness.md

# Rebuild the {% docs %} index used by AI retrieval + the inspector.
docs-reindex:
	$(BIN)/datalex dbt docs reindex --project-dir .

# Run the custom policy pack against an example model.
policy-check:
	$(BIN)/datalex policy-check models/marts/core/fct_orders.yml \
	  --policy .datalex/policies/jaffle.policy.yaml --inherit

# Export the glossary + bindings to every supported catalog target.
emit-catalog:
	mkdir -p out/catalog
	$(BIN)/datalex emit catalog --target atlan \
	  --model DataLex/commerce/_glossary.model.yaml --out out/catalog
	$(BIN)/datalex emit catalog --target datahub \
	  --model DataLex/commerce/_glossary.model.yaml --out out/catalog
	$(BIN)/datalex emit catalog --target openmetadata \
	  --model DataLex/commerce/_glossary.model.yaml --out out/catalog

docker-build:
	docker build -t jaffle-shop-datalex:local .

docker-up:
	docker compose up --build

docker-down:
	docker compose down

clean:
	$(BIN)/dbt clean --profiles-dir .
