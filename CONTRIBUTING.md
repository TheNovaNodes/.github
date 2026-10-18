# 🤝 Contributing to TheNovaNodes

Thank you for your interest in contributing to the **TheNovaNodes** software engineering and autonomous agent ecosystem!

## 🛸 Core Principles & Quality Baseline

1. **Strict Git Flow (GitHub Flow):**
   - Direct pushes to `master` or `main` branches are strictly prohibited across all organization repositories.
   - All improvements, bugfixes, and refactorings MUST be developed in dedicated feature branches (e.g., `feat/*`, `fix/*`, `docs/*`, `chore/*`).
   - All contributions are merged exclusively via Pull Requests.
   - Merging Pull Requests is strictly reserved for **ЗавЛаб** and authorized repository ambassadors.

2. **Commit Hygiene (Conventional Commits):**
   - Commit messages must strictly follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:
     - `feat:` — Introduces a new feature or capability.
     - `fix:` — Patches a bug or defect.
     - `docs:` — Documentation and architectural specifications.
     - `refactor:` — Code restructuring without altering external behavior.
     - `ci:` — Changes to CI/CD workflows, composite actions, or automation scripts.
     - `chore:` — Routine tasks, tool maintenance, or dependency updates.

3. **Zero Dirty Hacks Policy:**
   - No temporary workarounds or unverified hotfixes without a clear architectural design, unit tests, and refactoring schedule.
   - Clean API contracts, modular boundaries, and weak coupling are enforced.

4. **DevSecOps & Supply Chain Integrity:**
   - Never commit secrets, credentials, or environment variables (`.env`).
   - External GitHub Actions must be pinned by immutable 40-character commit SHAs (OpenSSF standard).

5. **AI-Ready Guidelines:**
   - Autonomous agents and AI assistants collaborating on the codebase must adhere to [`AGENTS.md`](AGENTS.md).
