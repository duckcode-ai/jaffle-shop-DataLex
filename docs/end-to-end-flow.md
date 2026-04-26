# End-to-End User Flow

This is the path a new user should follow when evaluating DataLex with jaffle-shop.

## 0. Understand the DataLex Problem

Start with the product framing before opening files:

- dbt projects can have strong SQL but weak shared meaning: unclear grain, missing descriptions, thin ownership, and inconsistent tests.
- Conceptual, logical, and physical modeling are usually skipped by modern analytics teams because they feel separate from dbt work.
- AI agents, semantic models, and business users need those standards because accurate answers depend on trusted definitions, relationships, lineage, and governance.
- DataLex keeps the dbt files visible, reviews their readiness, and connects them to business and data architecture models.

Expected onboarding message:

- Problem: scattered business meaning and inconsistent dbt metadata reduce trust.
- Solution: guided import, readiness review, modeling layers, validation, AI proposals, and Git-reviewed changes.
- Benefit: earlier gap detection, cleaner dbt YAML, stronger semantic contracts, and more reliable AI-assisted analytics.

## 1. Build dbt Locally

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pip install -U 'datalex-cli[serve,duckdb]>=1.3.5'
datalex --version
dbt seed --profiles-dir .
dbt build --profiles-dir .
```

Expected result:

- Raw CSV seeds are loaded into DuckDB schema `raw`.
- Staging views are built in schema `main`.
- Mart tables are built in schema `main`.
- dbt tests pass.

## 2. Open in DataLex

Start DataLex against the repository root:

```bash
datalex serve --project-dir /Users/Kranthi_1/DuckCode-DQL/jaffle-shop-DataLex
```

In DataLex, verify the active project path is the repository root.

## Docker Alternative

From the repository root:

```bash
docker compose up --build
```

Open `http://localhost:3030`. The repository is mounted at
`/workspace` inside the container, so use `/workspace` as the local dbt
repo path if you run the import flow from the UI.

Open the Explorer and verify these are visible:

- dbt source/model YAML files under `models/`.
- DataLex conceptual diagram under `DataLex/commerce/Conceptual`.
- DataLex logical diagram under `DataLex/commerce/Logical`.
- DataLex physical diagram under `DataLex/commerce/Physical/duckdb`.

## 3. Readiness Review

Use Explorer and Validation to review dbt/DataLex YAML readiness before changing models.

Expected behavior:

- YAML files show red, yellow, or green readiness status in Explorer.
- Import Results summarizes readiness counts after a dbt import.
- Validation groups findings by file and check category.
- Clicking a reviewed YAML file opens that same file and shows why each issue matters.
- Suggested YAML changes remain reviewable through the AI proposal/apply flow.

For this demo, focus on:

- Metadata: model, source, and column descriptions.
- dbt quality: tests, primary keys, relationships, accepted values, contracts, and freshness.
- Modeling: grain, fact/dimension role, staging/intermediate/mart conventions, and generated model opportunities.
- Governance: owner, domain, Interface readiness, sensitivity, semantic metadata, and exposures.

## 4. Conceptual Modeling

Open `commerce_concepts.diagram.yaml`.

Expected behavior:

- Cards use business language.
- No columns, PK, or FK wording is required.
- Drag the relationship handle from one concept to another to create a business relationship.
- Use relationship verbs such as places, contains, describes, and consumes.

## 5. Logical Modeling

Open `commerce_logical.diagram.yaml`.

Expected behavior:

- Cards show attributes and key badges.
- Candidate keys, business keys, natural keys, and surrogate keys are visible in YAML.
- Order Line resolves the Order to Product many-to-many relationship.
- Drag entity handles to create logical entity-level relationships, or use fields for key-based relationships.

## 6. Physical Modeling

Open `commerce_physical.diagram.yaml`.

Expected behavior:

- Cards are backed by dbt YAML files.
- Physical columns, data types, and dbt tests appear.
- Relationships map dbt/database FK intent.
- Generated SQL/YAML under `DataLex/commerce/Generated/dbt` can be reviewed before promotion.

## 7. Interface Readiness

Open `models/marts/core/dim_customers.yml` and `models/marts/core/fct_orders.yml`.

Expected behavior:

- DataLex shows Interface badges for the shared models.
- The Validation panel reports owner, domain, version, unique key, freshness, column descriptions, and contract readiness.
- `order_items` remains internal because it is an implementation bridge, not a governed shared contract.

Run the CI-style check from a cloned DataLex repo:

```bash
cd /Users/Kranthi_1/DataLex
.venv/bin/python ./datalex datalex mesh check /Users/Kranthi_1/DuckCode-DQL/jaffle-shop-DataLex --strict
```

Expected result:

- `dim_customers` passes as a shared customer Interface.
- `fct_orders` passes as a shared order Interface.
- `order_items` is skipped by mesh standards because it is marked internal.

## 8. Promote Generated dbt

After review, copy generated SQL/YAML into `models/marts/core`, then run:

```bash
dbt build --profiles-dir .
```

This keeps DataLex generation staged, reviewable, and git-versioned.
