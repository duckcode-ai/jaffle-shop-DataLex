# Changelog — jaffle-shop-DataLex

This repo is the canonical demo for DataLex. Versions track the
DataLex release the demo is verified against.

## [1.4.1] - 2026-04-27

### Changed
- Pin to `datalex-cli[serve,duckdb]>=1.4.1` in `requirements`-equivalent
  install snippets and the `make setup` target.
- README walks through the new six-step **Onboarding Journey** panel
  shipped in DataLex 1.4.1 — connect → see gaps → design → AI key →
  ask AI to draw. Step 6 demonstrates the deterministic Conceptualizer
  against this repo's staging models.

### Notes
- Existing `make seed && make build` flow is unchanged.
- `.datalex/policies/jaffle.policy.yaml`, snapshots, exposures, unit
  tests, and the readiness-gate workflow shipped in 1.4.0 still apply.

## [1.4.0] - 2026-04-27

Aligned with DataLex 1.4.0. The repo gained the full 1.4 surface:

- **Doc-blocks** at `models/docs/_canonical.md` round-trip safely.
- **Custom policy pack** at `.datalex/policies/jaffle.policy.yaml`
  inheriting the bundled `datalex/standards/base.yaml`.
- **Snapshots** at `snapshots/customers_snapshot.sql` +
  `snapshots/snapshots.yml`.
- **Exposures** at `models/exposures.yml`.
- **Unit tests** at `models/marts/core/_unit_tests.yml`.
- **Glossary bindings** at `DataLex/commerce/_glossary.model.yaml`.
- **GitHub Action** `.github/workflows/datalex.yml` runs the readiness
  gate with sticky PR comments + SARIF upload.
- **Make targets**: `make readiness-gate`, `make policy-check`,
  `make docs-reindex`, `make emit-catalog`.
