# 🌌 TheNovaNodes — Organization Default Standards & Health Files

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![Security Policy](https://img.shields.io/badge/Security-Policy-brightgreen.svg)](SECURITY.md)
[![AI-Ready](https://img.shields.io/badge/AI--Ready-2026-violet.svg)](AGENTS.md)

This repository serves as the central baseline for the [`TheNovaNodes`](https://github.com/TheNovaNodes) organization. It contains organization-wide community health files, cascade standards, reusable GitHub Actions, and default templates inherited across all organization repositories.

---

## 🏛️ Organization-Wide Cascading Defaults

- **Security Policy:** [`SECURITY.md`](SECURITY.md) — Responsible disclosure protocol and vulnerability reporting guidelines.
- **Contribution Guidelines:** [`CONTRIBUTING.md`](CONTRIBUTING.md) — Strict GitHub Flow, Zero Dirty Hacks policy, and commit standards.
- **Code of Conduct:** [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) — Contributor Covenant v2.1 community standard.
- **Pull Request Template:** [`.github/pull_request_template.md`](.github/pull_request_template.md) — Scope guard isolation and quality gate checklist.
- **Issue Templates:** [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/)
  - `bug_report.md` — Minimal Reproducible Example (MRE) triage protocol.
  - `feature_request.md` — Architectural RFC proposal protocol.

---

## 🤖 AI-Ready Standards (Agentic 2026)

- **System Contract:** [`AGENTS.md`](AGENTS.md) — Canonical rules for autonomous LLM agents (Antigravity, Cursor, Windsurf, Jules, Claude Code).
- **RAG Context Manifest:** [`llms.txt`](llms.txt) — Clean architectural index for LLM ingestion.
- **Copilot Instructions:** [`.github/copilot-instructions.md`](.github/copilot-instructions.md) — Project-level style and security constraints.

---

## 📦 Reusable Composite Actions

- **Git Hygiene Gate:** [`actions/git-hygiene/`](actions/git-hygiene/) — Secret scan, oversized files detector, `.gitignore` validation, and Conventional Commits check.
- **Go CI Gate:** [`actions/go-ci/`](actions/go-ci/) — Standard Go vet, race-detected unit tests, and build verification.
- **Node.js CI Gate:** [`actions/node-ci/`](actions/node-ci/) — Standard dependency installation, linting, typechecks, tests, and build check.
- **Secret Scan:** [`actions/secret-scan/`](actions/secret-scan/) — Zero-shame Gitleaks scanner.
- **Reusable Workflow:** [`.github/workflows/reusable-secret-scan.yml`](.github/workflows/reusable-secret-scan.yml) — Centralized callable workflow.

---

### 🚀 Production Deployment (5-Echelon Automated Gate)
In accordance with TheNovaNodes ecosystem standards, organization standards deployment and validation is orchestrated via `./scripts/deploy.sh`:

```bash
# Execute standard 5-echelon deployment
./scripts/deploy.sh

# Dry-run validation (validate without writing release manifest)
./scripts/deploy.sh --dry-run
```

**Deployment Echelons:**
1. **🛡️ Échelon 0: Pre-Flight Guard & Rollback Capsule:** Toolchain checks, resolves `TARGET_COMMIT`, and archives existing manifests into `.deploy_rollback_capsule/`.
2. **🧱 Échelon 1: Production Isolation Probe:** Validates all YAML manifests, workflows, composite actions, and ensures git working tree cleanliness.
3. **🔄 Échelon 2: Atomic Switch & Graceful Shift:** Atomically writes `governance_manifest.json` with `TARGET_COMMIT` and composite action inventory.
4. **🪞 Échelon 3: Identity & Truth Probe:** Verifies runtime manifest `commit` matches `git rev-parse HEAD`.
5. **🔍 Échelon 4: Deep Smoke Probe & Rollback Gate:** Confirms integrity of critical templates and governance files. Automatic instant rollback (`trap rollback ERR EXIT`) on any anomaly.

---

## 🔗 Architecture & Protocols
For deep architectural manifests and agent coordination protocols, see [`TheNovaNodes/ecosystem-docs`](https://github.com/TheNovaNodes/ecosystem-docs).
