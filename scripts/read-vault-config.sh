#!/bin/bash
set -euo pipefail

# Resolve absolute path to the JSON next to this script, regardless of CWD
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_CONFIG_FILE="$SCRIPT_DIR/security-config.json"

read_vault_secret() {
    local name="$1"
    [ -f "$VAULT_CONFIG_FILE" ] || { echo "mock vault not found" >&2; return 1; }
    jq -r ".secrets.\"$name\"" "$VAULT_CONFIG_FILE" 2>/dev/null || echo ""
}

read_vault_config() {
    local path="$1"
    [ -f "$VAULT_CONFIG_FILE" ] || { echo "mock vault not found" >&2; return 1; }
    jq -r "$path" "$VAULT_CONFIG_FILE" 2>/dev/null || echo "false"
}

export_vault_config() {
    TRIVY_SEVERITY_VAL=$(read_vault_secret "trivy-severity-levels")
    TRIVY_TIMEOUT_VAL=$(read_vault_secret "trivy-timeout")
    CHECKOV_FRAMEWORKS_VAL=$(read_vault_secret "checkov-frameworks")
    SCAN_OUTPUT_FORMAT_VAL=$(read_vault_secret "scan-output-format")
    VM_PATCH_TIMEOUT_VAL=$(read_vault_secret "vm-patch-timeout")
    KUBECTL_TIMEOUT_VAL=$(read_vault_secret "kubectl-rollout-timeout")
    SECURITY_SCANNING_ENABLED_VAL=$(read_vault_config ".configuration.security_scanning.enabled")
    REMEDIATION_ENABLED_VAL=$(read_vault_config ".configuration.remediation.enabled")
    AUTO_PATCH_VM_VAL=$(read_vault_config ".configuration.remediation.auto_patch_vm")

    export TRIVY_SEVERITY="${TRIVY_SEVERITY_VAL:-HIGH,CRITICAL}"
    export TRIVY_TIMEOUT="${TRIVY_TIMEOUT_VAL:-5m}"
    export CHECKOV_FRAMEWORKS="${CHECKOV_FRAMEWORKS_VAL:-terraform}"
    export SCAN_OUTPUT_FORMAT="${SCAN_OUTPUT_FORMAT_VAL:-sarif}"
    export VM_PATCH_TIMEOUT="${VM_PATCH_TIMEOUT_VAL:-300}"
    export KUBECTL_TIMEOUT="${KUBECTL_TIMEOUT_VAL:-300s}"
    export SECURITY_SCANNING_ENABLED="${SECURITY_SCANNING_ENABLED_VAL:-true}"
    export REMEDIATION_ENABLED="${REMEDIATION_ENABLED_VAL:-true}"
    export AUTO_PATCH_VM="${AUTO_PATCH_VM_VAL:-true}"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ "${1:-}" = "--export" ]; then
        export_vault_config
    else
        echo "usage: $0 --export" >&2
    fi
fi