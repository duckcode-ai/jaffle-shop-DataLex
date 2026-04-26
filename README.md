# jaffle-shop DataLex

Clean, local-first example for trying DataLex with a dbt project backed by DuckDB.

## What DataLex Solves

DataLex helps teams turn dbt projects into governed, AI-ready analytics models.
It keeps business meaning, relationships, standards, and YAML fixes close to the files your team already owns.

Modern analytics teams often move fast in dbt, but dbt lineage is not enough. The business concepts, relationship meaning, model grain, ownership, quality expectations, governance, and semantic context are often spread across SQL, YAML, tickets, and tribal knowledge. That makes AI agents and semantic layers less reliable because they cannot tell which models are trusted, what each field means, or how business concepts relate to physical tables.

DataLex adds a governed modeling layer around dbt without hiding the files:

- Clarifies the problem first: scattered business meaning, inconsistent dbt YAML, weak ownership, and late quality discovery.
- Keeps conceptual, logical, and physical models connected so business language, data structure, and dbt implementation stay aligned.
- Reviews dbt/DataLex YAML for metadata, tests, contracts, relationships, governance, and enterprise modeling readiness.
- Shows red, yellow, and green readiness directly on the same files users need to inspect and fix.
- Creates reviewable AI proposals for YAML improvements instead of silently rewriting project assets.
- Helps AI agentic analytics and semantic models answer more accurately by grounding them in trusted definitions, grain, lineage, and governance signals.

This repository shows the full onboarding flow:

1. Load small jaffle shop seed data into local DuckDB.
2. Build dbt staging and mart models.
3. Open the repo in DataLex and understand the problem/solution walkthrough.
4. Review dbt readiness results on imported YAML files.
5. Review conceptual, logical, and physical diagrams.
6. Use the physical diagram to inspect dbt YAML-backed models and relationships.
7. Review Interface readiness for shared dbt models.
8. Review the generated dbt SQL/YAML staged by DataLex before promotion.

## Repository Layout

```text
.
├── DataLex/
│   └── commerce/
│       ├── Conceptual/commerce_concepts.diagram.yaml
│       ├── Logical/commerce_logical.diagram.yaml
│       ├── Physical/duckdb/commerce_physical.diagram.yaml
│       └── Generated/dbt/
├── Skills/
│   └── *.md
├── models/
│   ├── staging/jaffle_shop/
│   ├── marts/core/
│   └── semantic/
├── seeds/
├── Dockerfile
├── docker-compose.yml
├── dbt_project.yml
├── profiles.yml
└── datalex.yaml
```

## Quick Start

Use this repo when evaluating DataLex. It is intentionally different
from the generic jaffle-shop starter because it includes DataLex
conceptual, logical, physical, generated dbt, Interface, and skills
assets.

If you already have this workspace checked out locally, the project path
is:

```text
/Users/Kranthi_1/DuckCode-DQL/jaffle-shop-DataLex
```

For a fresh clone:

```bash
git clone https://github.com/duckcode-ai/jaffle-shop-DataLex.git
cd jaffle-shop-DataLex
```

### Option A: Local Python

Use Python 3.11 or 3.12 for the dbt path. Python 3.14 can currently
install `dbt-duckdb`, but dbt fails at runtime in one of its serializer
dependencies.

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pip install -U 'datalex-cli[serve,duckdb]>=1.3.6'
datalex --version
```

Build the local DuckDB warehouse:

```bash
dbt seed --profiles-dir .
dbt build --profiles-dir .
```

This creates `jaffle_shop.duckdb` locally. The database file is intentionally ignored by git.

Run DataLex against this repo:

```bash
datalex serve --project-dir .
```

Or from outside the repo:

```bash
datalex serve --project-dir /Users/Kranthi_1/DuckCode-DQL/jaffle-shop-DataLex
```

### Option B: Docker

Docker gives a fully isolated dbt + DataLex runtime. It requires Docker
Desktop or a running Docker daemon. The image installs the released
`datalex-cli` package from PyPI, so it follows the same install path
that users should run locally.

```bash
docker compose up --build
```

Open `http://localhost:3030`.

The compose file bind-mounts this repo into `/workspace`, so DataLex
edits and dbt artifacts are written back to your working tree. In the
DataLex UI, use `/workspace` as the local folder path if you run an
import flow from inside the container.

Manual Docker commands:

```bash
docker build -t jaffle-shop-datalex:local .
docker run --rm -p 3030:3030 -v "$PWD":/workspace jaffle-shop-datalex:local
```

To build against a specific released DataLex version:

```bash
docker build --build-arg DATALEX_VERSION=1.3.6 -t jaffle-shop-datalex:local .
```

## DataLex Flow

Recommended walkthrough:

1. Start with the onboarding tour.
   - Welcome to DataLex: the goal is governed, AI-ready analytics models.
   - Problem: dbt lineage shows dependencies, but it often misses business concepts, relationship meaning, grain, ownership, quality expectations, and governance context.
   - Solution: DataLex connects business concepts to logical rules and physical dbt assets, reviews YAML standards before gaps spread, and keeps fixes reviewable through AI proposals and Git diffs.
   - Product demo: import, readiness review, modeling layers, relationships, validation, AI-assisted fixes, and saving approved YAML changes.
2. Open Explorer and review dbt readiness badges beside YAML files.
   - Red means important metadata, tests, governance, parse, or modeling readiness gaps need attention.
   - Yellow means the file is usable but has improvement opportunities.
   - Green means the deterministic standards are satisfied for this demo scope.
   - Click a YAML file to see why each check matters and the suggested YAML change.
3. Open `DataLex/commerce/Conceptual/commerce_concepts.diagram.yaml`.
   - Business-only concepts: Customer, Order, Order Item, Product, Supply.
   - Relationships use business verbs such as places, contains, describes, consumes.
4. Open `DataLex/commerce/Logical/commerce_logical.diagram.yaml`.
   - Logical attributes, candidate keys, business keys, associative entity, and role names.
   - The Order Line entity resolves the many-to-many Order to Product relationship.
5. Open `DataLex/commerce/Physical/duckdb/commerce_physical.diagram.yaml`.
   - Physical nodes mirror dbt YAML files under `models/` and keep dbt paths visible in descriptions/tags.
   - Relationships show dbt/database intent: customer FK, order-item FK, product FK.
6. Open `models/marts/core/dim_customers.yml` and `models/marts/core/fct_orders.yml`.
   - Both are marked as DataLex Interfaces under `meta.datalex.interface`.
   - `order_items` stays internal because it resolves order/product detail but is not a shared contract.
7. Open `DataLex/commerce/Generated/dbt/customer_order_summary.sql` and `.yml`.
   - These show how logical modeling output can be staged before being promoted into dbt.

If you are hacking on DataLex from source instead of using PyPI:

```bash
cd /Users/Kranthi_1/DataLex
python3.12 -m venv .venv
source .venv/bin/activate
pip install -e '.[serve,duckdb]'
datalex serve --project-dir /Users/Kranthi_1/DuckCode-DQL/jaffle-shop-DataLex
```

## Validate

```bash
dbt seed --profiles-dir .
dbt build --profiles-dir .
dbt test --profiles-dir .
```

With make:

```bash
make setup
make seed
make build
make test
make serve
```

Optional DataLex core validation from a cloned DataLex repo:

```bash
cd /Users/Kranthi_1/DataLex
PYTHONPATH=packages/core_engine/src .venv/bin/python - <<'PY'
from datalex_core.datalex.loader import load_project
p = load_project('/Users/Kranthi_1/DuckCode-DQL/jaffle-shop-DataLex', strict=False)
print('diagrams:', sorted(p.diagrams))
print('errors:', len(p.errors.errors))
for err in p.errors.errors:
    print(err.code, err.message)
PY
```

Run the DataLex mesh Interface standards check:

```bash
cd /Users/Kranthi_1/DataLex
.venv/bin/python ./datalex datalex mesh check /Users/Kranthi_1/DuckCode-DQL/jaffle-shop-DataLex --strict
```

## Use Case

The business asks: "How do customers place orders, what products are purchased, and what supply cost supports each order?"

DataLex models the answer in three layers:

- Conceptual: business terms and relationships.
- Logical: attributes, keys, many-to-many resolution, and generation intent.
- Physical: dbt YAML-backed DuckDB models, columns, tests, and relationship readiness.

The dbt mart layer then answers the question with:

- `dim_customers`: customer lifecycle and lifetime spend.
- `fct_orders`: order totals, taxes, and fulfillment cost.
- `order_items`: product-level order line details.

Interface policy:

- `dim_customers` is a shared Interface for customer-level analysis.
- `fct_orders` is a shared Interface for order-level analysis.
- `order_items` is internal implementation detail and is not safe to consume directly.
