# 🛸 GitHub Copilot & Cursor Instructions for TheNovaNodes/.github

## Identity & Scope
- **Repository:** `TheNovaNodes/.github`
- **Scope:** Organization-wide standards, issue/PR templates, composite actions, and reusable workflows.
- **Language / Formats:** GitHub Actions YAML, Bash, GitHub Flavored Markdown (GFM).

## Standards & Constraints
1. **Zero Dirty Hacks:** Maintain impeccable abstraction hygiene and clear parameter interfaces for reusable composite actions.
2. **SHA-Pinning:** Always pin third-party actions to 40-character commit SHAs with trailing version comment (`# vX.Y.Z`).
3. **Runner Protection:** Reusable workflows must declare `timeout-minutes: 10` and `concurrency: cancel-in-progress: true`.
4. **Minimal Permissions:** Always set `permissions: contents: read` explicitly.
5. **Conventional Commits:** Adhere to `feat:`, `fix:`, `docs:`, `ci:`, `chore:`.
