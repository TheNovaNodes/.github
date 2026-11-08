#!/usr/bin/env bash
# ==============================================================================
# 🚀 .github: Canonical 5-Echelon Production Deployment Script
# Standard: ecosystem-docs (Deploy-as-Code / Anti-Ghost-Deploy / Atomic Switch)
# Specification: Issue #1 (scripts/deploy.sh + commit_sha propagation)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CAPSULE_DIR="${ROOT_DIR}/.deploy_rollback_capsule"
MANIFEST_FILE="${ROOT_DIR}/governance_manifest.json"

DEPLOY_SUCCESS=0
DRY_RUN=0
SKIP_CLEAN_CHECK=0

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()  { echo -e "${CYAN}ℹ️  ${1}${NC}"; }
log_ok()    { echo -e "${GREEN}✅ ${1}${NC}"; }
log_warn()  { echo -e "${YELLOW}⚠️  ${1}${NC}"; }
log_error() { echo -e "${RED}❌ ${1}${NC}" >&2; }
log_title() { echo -e "\n${PURPLE}=== ${1} ===${NC}"; }

show_help() {
  cat << EOF
TheNovaNodes .github Organization Governance Deployment Tool

USAGE:
  $(basename "$0") [OPTIONS]

OPTIONS:
  --dry-run             Execute pre-flight, validation without writing release manifest
  --skip-clean-check    Allow execution with uncommitted/dirty working tree (development only)
  -h, --help            Show this help message

ECHELONS:
  🛡️  0: Pre-Flight Guard (Toolchain & Rollback Capsule)
  🧱  1: Production Isolation Probe (YAML & Action Validation Suite & Clean Working Tree)
  🔄  2: Atomic Switch & Graceful Shift (Manifest Generation & Schema Alignment)
  🪞  3: Identity & Truth Probe (runtime_commit_sha == git rev-parse HEAD)
  🔍  4: Deep Smoke Probe & Rollback Gate (Governance & Templates Integrity Smoke Gate)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --skip-clean-check)
      SKIP_CLEAN_CHECK=1
      shift
      ;;
    *)
      log_error "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

ROLLBACK_EXECUTED=0

rollback() {
  local exit_code=$?
  if (( DEPLOY_SUCCESS == 1 )) || (( ROLLBACK_EXECUTED == 1 )); then
    return 0
  fi
  ROLLBACK_EXECUTED=1

  log_title "🚨 EMERGENCY ROLLBACK TRIGGERED"
  log_error "Deployment failed with exit code ${exit_code}! Initiating automated rollback..."

  if [[ -d "${CAPSULE_DIR}" && -f "${CAPSULE_DIR}/governance_manifest.json" ]]; then
    log_info "Restoring previous manifest from Rollback Capsule..."
    cp -f "${CAPSULE_DIR}/governance_manifest.json" "${MANIFEST_FILE}"
    log_ok "Previous manifest restored."
  else
    log_warn "No Rollback Capsule manifest available to restore."
  fi

  log_error "Deployment ABORTED. Environment reverted to safe state (Version N-1)."
  exit 1
}

trap rollback ERR EXIT

# ==============================================================================
# 🛡️ Эшелон 0: Pre-Flight Guard & Rollback Capsule
# ==============================================================================
log_title "🛡️ Эшелон 0: Pre-Flight Guard & Rollback Capsule"

for cmd in git python3; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    log_error "Required tool not found: ${cmd}"
    exit 1
  fi
done

TARGET_COMMIT="$(git -C "${ROOT_DIR}" rev-parse HEAD)"
log_ok "Target Git Commit determined: ${TARGET_COMMIT}"

# Prepare Rollback Capsule
log_info "Creating Rollback Capsule in ${CAPSULE_DIR}..."
rm -rf "${CAPSULE_DIR}"
mkdir -p "${CAPSULE_DIR}"
chmod 0700 "${CAPSULE_DIR}"

if [[ -f "${MANIFEST_FILE}" ]]; then
  cp -f "${MANIFEST_FILE}" "${CAPSULE_DIR}/governance_manifest.json"
  log_ok "Existing manifest backed up to capsule."
fi

cat << EOF > "${CAPSULE_DIR}/capsule_meta.env"
BACKUP_TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
TARGET_COMMIT="${TARGET_COMMIT}"
EOF
log_ok "Rollback Capsule sealed."

# ==============================================================================
# 🧱 Эшелон 1: Production Isolation Probe
# ==============================================================================
log_title "🧱 Эшелон 1: Production Isolation Probe"

log_info "Validating YAML manifests, GitHub Actions, and workflows..."
cd "${ROOT_DIR}"
python3 -c "
import glob, yaml, sys

files = set(glob.glob('**/*.yml', recursive=True) + glob.glob('**/*.yaml', recursive=True) + glob.glob('.github/**/*.yml', recursive=True) + glob.glob('.github/**/*.yaml', recursive=True))
# Filter out rollback capsule files if any
files = [f for f in files if '.deploy_rollback_capsule' not in f]

failed = False
for f in sorted(files):
    try:
        with open(f, 'r', encoding='utf-8') as fp:
            yaml.safe_load(fp)
        print(f'  ✅ {f} is valid YAML')
    except Exception as e:
        print(f'  ❌ {f} parsing error: {e}')
        failed = True
if failed:
    sys.exit(1)
"
log_ok "All YAML manifests verified: 100% PASS."

if (( SKIP_CLEAN_CHECK == 0 )); then
  DIFF_OUTPUT="$(git status --porcelain -uno)"
  if [[ -n "${DIFF_OUTPUT}" ]]; then
    log_error "Working tree has uncommitted tracked changes:"
    echo "${DIFF_OUTPUT}"
    exit 1
  fi
  log_ok "Working tree cleanliness verified: No dirty tracked files."
else
  log_warn "Clean tree check skipped via --skip-clean-check."
fi

# ==============================================================================
# 🔄 Эшелон 2: Atomic Switch & Graceful Shift
# ==============================================================================
log_title "🔄 Эшелон 2: Atomic Switch & Graceful Shift"

CANDIDATE_MANIFEST="${CAPSULE_DIR}/manifest.candidate"

cat << EOF > "${CANDIDATE_MANIFEST}"
{
  "repository": "TheNovaNodes/.github",
  "status": "active",
  "commit": "${TARGET_COMMIT}",
  "deployedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "compositeActions": ["git-hygiene", "go-ci", "node-ci", "secret-scan"]
}
EOF

if (( DRY_RUN == 0 )); then
  log_info "Atomically writing governance manifest to ${MANIFEST_FILE}..."
  install -m 644 "${CANDIDATE_MANIFEST}" "${MANIFEST_FILE}"
  log_ok "Governance manifest atomically updated."
else
  log_warn "Dry run mode active: manifest update skipped."
fi

# ==============================================================================
# 🪞 Эшелон 3: Identity & Truth Probe
# ==============================================================================
log_title "🪞 Эшелон 3: Identity & Truth Probe"

PROBE_FILE="${MANIFEST_FILE}"
if (( DRY_RUN == 1 )); then
  PROBE_FILE="${CANDIDATE_MANIFEST}"
fi

STORED_COMMIT="$(grep -o '"commit": "[^"]*"' "${PROBE_FILE}" | cut -d'"' -f4)"
log_info "Manifest commit output: ${STORED_COMMIT}"

if [[ "${STORED_COMMIT}" != "${TARGET_COMMIT}" ]]; then
  log_error "Truth violation: Stored commit '${STORED_COMMIT}' does not match target commit '${TARGET_COMMIT}'!"
  exit 1
fi
log_ok "Runtime identity confirmed: commit SHA match verified."

# ==============================================================================
# 🔍 Эшелон 4: Deep Smoke Probe & Rollback Gate
# ==============================================================================
log_title "🔍 Эшелон 4: Deep Smoke Probe & Rollback Gate"

log_info "Verifying essential governance files and templates..."
for item in README.md AGENTS.md CONTRIBUTING.md CODE_OF_CONDUCT.md SECURITY.md pull_request_template.md .github/ISSUE_TEMPLATE/bug_report.md .github/ISSUE_TEMPLATE/feature_request.md; do
  if [[ ! -s "${ROOT_DIR}/${item}" ]]; then
    log_error "Critical governance file missing or empty: ${item}"
    exit 1
  fi
done
log_ok "All critical governance files and templates verified."

DEPLOY_SUCCESS=1
log_title "🎉 DEPLOYMENT SUCCESSFUL"
log_ok "All 5 echelons passed. Candidate ${TARGET_COMMIT:0:8} is active."
exit 0
