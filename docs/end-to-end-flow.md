# End-to-End User Flow

This is the path a new user should follow when evaluating DataLex with jaffle-shop.

## 0. Start the DataLex Tour

The first-run and replay tour now follow the same sequence:

- Welcome to DataLex: DataLex helps teams turn dbt projects into governed, AI-ready analytics models.
- Problem: dbt lineage shows SQL dependencies, but it often misses business concepts, relationship meaning, grain, ownership, quality expectations, and governance context.
- Solution: DataLex connects business concepts to logical rules and physical dbt assets, reviews YAML standards before gaps spread, and keeps fixes reviewable through AI proposals and Git diffs.
- Product demo: the tour walks through import, readiness review, modeling layers, relationships, validation, AI-assisted fixes, and saving approved YAML changes.

Why this matters:

- Conceptual, logical, and physical modeling are usually skipped by modern analytics teams because they feel separate from dbt work.
- AI agents, semantic models, and business users need those standards because accurate answers depend on trusted definitions, relationships, lineage, and governance.
- DataLex keeps the dbt files visible, reviews their readiness, and connects them to business and data architecture models.

## 1. Build dbt Locally

```bash
make setup
make doctor
make seed
make build
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
repo path if you run the import flow from the UI. Your host home folder
is also mounted at the same path, so dbt repos under `/Users/...` or
`/home/...` can be entered with their normal host path.

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

## 4b. EventStorming flow (DataLex 1.8.1+)

Open `commerce_eventstorming.diagram.yaml`.

This file tells the same Order story as the conceptual diagram, but in
workshop-readable shape — actors, commands, aggregates, events, and
policies. The five EventStorming entity types each render with the
canonical Brandolini sticky-note color: **actor** yellow, **command**
blue, **aggregate** pale-yellow, **event** orange, **policy** pink.

Expected behavior:

- Canvas: each card carries the workshop sticky-note color, so the
  diagram is recognizable to anyone who has run an EventStorming
  session.
- DocsView (switch to the **Docs** tab): a numbered **EventStorming
  flow** card appears between the ER diagram and the per-entity
  tables, grouped in canonical order — Actors → Commands → Aggregates
  → Events → Policies. Each entry shows its name, type chip, and
  description.
- The card is auto-hidden for plain ER models, so it only surfaces
  on diagrams that actually use the EventStorming types.

Try editing the file: add a new `type: event` card called
`OrderShipped`, save, and watch DocsView re-render the narrative with
the new event in place.

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

## 9. Browse the Capability Map (DataLex 1.8.0+)

With any conceptual diagram open, switch to the **Capabilities** top-tab
(peer of Diagram / Docs / Table / Views / Enums).

Expected behavior:

- The view renders a 2-level boxes-in-boxes hierarchy: **Domain →
  Subject area → Concept**. The jaffle-shop conceptual file groups
  concepts under `commerce`, so the whole model lives in one
  domain box.
- A summary line at the top reads `1 domain · N subject areas · N
  concepts`.
- A real-time search box filters by concept name, owner, tag, or
  subject area. Type `customer` and watch unrelated subject areas
  collapse out.
- Click any concept card to jump to its definition in DocsView.

This is the LeanIX / Avolution use case for a YAML-first crowd —
dropping the question "what's in this domain?" from a Confluence page
into a renderer over the same YAML the data team already authors.

## 10. Export the docs as Markdown (DataLex 1.8.2+)

With any model open, switch to the **Docs** top-tab and click the
**Export Markdown** button next to **Export OSI** in the header.

Expected behavior:

- A `.md` file downloads, named after the active YAML file
  (e.g. `commerce_eventstorming.md`).
- The exported markdown contains the model header (name, version,
  domain, owners), the description, a fenced ` ```mermaid `
  `erDiagram` block, the EventStorming flow narrative (when the file
  has EventStorming entities), and per-entity sections with field
  tables.
- Because the diagram travels as a fenced mermaid block, pasting the
  `.md` into GitHub, GitLab, Confluence-with-the-mermaid-macro,
  Notion, or an LLM context window renders the diagram inline —
  no screenshots needed.

Try it on `commerce_eventstorming.diagram.yaml`: open it, switch to
Docs, click Export Markdown, then paste the result into a fresh
GitHub issue or PR description and watch the EventStorming story
plus the diagram render together.
