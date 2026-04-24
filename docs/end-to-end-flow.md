# End-to-End User Flow

This is the path a new user should follow when evaluating DataLex with jaffle-shop.

## 1. Build dbt Locally

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
dbt seed --profiles-dir .
dbt build --profiles-dir .
```

Expected result:

- Raw CSV seeds are loaded into DuckDB schema `raw`.
- Staging views are built in schema `main`.
- Mart tables are built in schema `main`.
- dbt tests pass.

## 2. Open in DataLex

In DataLex, create or add a project using the repository root.

Open the Explorer and verify these are visible:

- dbt source/model YAML files under `models/`.
- DataLex conceptual diagram under `DataLex/commerce/Conceptual`.
- DataLex logical diagram under `DataLex/commerce/Logical`.
- DataLex physical diagram under `DataLex/commerce/Physical/duckdb`.

## 3. Conceptual Modeling

Open `commerce_concepts.diagram.yaml`.

Expected behavior:

- Cards use business language.
- No columns, PK, or FK wording is required.
- Drag the relationship handle from one concept to another to create a business relationship.
- Use relationship verbs such as places, contains, describes, and consumes.

## 4. Logical Modeling

Open `commerce_logical.diagram.yaml`.

Expected behavior:

- Cards show attributes and key badges.
- Candidate keys, business keys, natural keys, and surrogate keys are visible in YAML.
- Order Line resolves the Order to Product many-to-many relationship.
- Drag entity handles to create logical entity-level relationships, or use fields for key-based relationships.

## 5. Physical Modeling

Open `commerce_physical.diagram.yaml`.

Expected behavior:

- Cards are backed by dbt YAML files.
- Physical columns, data types, and dbt tests appear.
- Relationships map dbt/database FK intent.
- Generated SQL/YAML under `DataLex/commerce/Generated/dbt` can be reviewed before promotion.

## 6. Promote Generated dbt

After review, copy generated SQL/YAML into `models/marts/core`, then run:

```bash
dbt build --profiles-dir .
```

This keeps DataLex generation staged, reviewable, and git-versioned.
