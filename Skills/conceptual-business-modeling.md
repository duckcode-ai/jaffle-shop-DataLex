---
name: "Conceptual Business Modeling"
description: "Business concept modeling before logical or physical implementation."
use_when:
  - "conceptual model"
  - "business concept"
  - "business scenario"
  - "domain model"
  - "bounded context"
tags:
  - "conceptual"
  - "business"
  - "glossary"
layers:
  - "conceptual"
agent_modes:
  - "conceptual_architect"
  - "relationship_modeler"
priority: 4
---

# Conceptual Business Modeling

- Create concepts, not tables. Do not add columns, database datatypes, indexes, DDL, dbt tests, or warehouse constraints.
- Each important concept should have name, description, owner, subject_area, domain, tags, and glossary terms when known.
- Relationships should be entity-level with business verbs, for example: "One account can have many opportunities."
- Cross-domain relationships need a description explaining business meaning and ownership.
- Use follow-up questions when owner, domain, glossary meaning, or relationship verb is unclear.
