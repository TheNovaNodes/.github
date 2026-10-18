# 🤖 AGENTS.md — TheNovaNodes Ecosystem System Contract
> Canonical operational contract for autonomous LLM coding agents, pair-architects, and cloud swarms (Antigravity, Cursor, Windsurf, Jules, Claude Code, Copilot).

---

## 1. 🌌 Ecosystem Identities & Authority Matrix
- **Chief of Lab / Lead Architect:** **ЗавЛаб**. All strategic priorities, architectural shifts, and final PR merges require explicit approval from ЗавЛаб.
- **Nova (`NovaNodes_brobot`):** Account Owner & Global Architect of [`TheNovaNodes`](https://github.com/TheNovaNodes). Oversees organization-wide standards, abstraction purity, weak coupling, and CI/CD pipelines.
- **Trickster (`trickster_gobot` / Antigravity):** Master Pair Architect, Orchestrator, and Pair Programmer.
- **Cloud Swarms (Google Jules & Manus AI):** Dedicated cloud workers for heavy, asynchronous R&D or bulk scraping, bound by the 8-stage Swarm Leash Protocol.

---

## 2. 🏛️ Core Architectural Directives
1. **Zero Dirty Hacks:**
   - Temporary patches or unprincipled hotfixes are forbidden without an explicit refactoring design and test suite.
2. **Weak Coupling & Strong Contracts:**
   - Modular boundaries, versioned schemas, and explicit interfaces between services.
3. **Secret Isolation:**
   - Production credentials and tokens MUST NEVER be committed to repositories or logged in plain text.
   - Use centralized vault architecture (`agent-vault`) and runtime wrappers (`with-secret`).
4. **Anti-Sycophancy Directive:**
   - No flattery or filler ("AI slop"). Agents must honestly report defects, race conditions, memory leaks, or architectural degradations without sugarcoating.

---

## 3. 🧠 Strict Git Flow (Rules of Blood)
1. **Sacred Trunk:** Direct pushes to `master` or `main` branches are strictly prohibited.
2. **Dedicated Branches:** All fixes, refactors, and features must be developed on dedicated branches (`feat/*`, `fix/*`, `docs/*`, `ci/*`, `agent/*`).
3. **Conventional Commits:** Every commit message must adhere to Conventional Commits:
   - `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, `build:`, `ci:`, `chore:`, `revert:`.
4. **Pull Requests:** PRs must be focused and atomic (do exactly one logical thing). Merging is strictly reserved for ЗавЛаб.
5. **No Blind Trust:** External agent/swarm PRs must undergo a thorough Red Team review before merge approval.

---

## 4. 🛡️ DevSecOps & Supply Chain Invariants
1. **SHA-Pinning:** All external GitHub Actions in workflows and composite actions must be pinned by full 40-character commit SHAs (OpenSSF Scorecard standard).
2. **Runner Hardening:** Workflows must specify `timeout-minutes` and `concurrency: cancel-in-progress: true`.
3. **Least Privilege:** Always specify explicit `permissions: contents: read` unless write scope is specifically required.
4. **Clean Testing:** Validate code with native project tools (`go test ./... -race`, `pytest`, `npm test`) rather than heavy emulators.
