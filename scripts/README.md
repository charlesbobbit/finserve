# Scripts & Automation

Automation scripts and mock secrets management system for FinServe DevSecOps. It Demonstrates configuration abstraction and automated remediation processes.

## Mock Secrets Management

Mock secrets system using JSON configuration instead of Azure Key Vault (simplified for assessment):

```json
{
  "secrets": {
    "trivy-severity-levels": "HIGH,CRITICAL",
    "trivy-timeout": "5m",
    "checkov-frameworks": "terraform"
  },
  "configuration": {
    "security_scanning": {"enabled": true},
    "remediation": {"enabled": true, "auto_patch_vm": true}
  }
}
```

### Usage
```bash
source scripts/read-vault-config.sh
export_vault_config
# We can now use $TRIVY_SEVERITY, $CHECKOV_FRAMEWORKS, etc.
```

## Engineering Notes

- **Mock approach** - Demonstrates secrets abstraction without Azure Key Vault complexity
- **JSON config** - Human readable, version control friendly
- **Environment variables** - Standard Unix approach, works with CI/CD
- **Easy testing** - No external dependencies

## Integration

Works with GitHub Actions pipeline:
```yaml
- name: Load mock Key Vault configuration
  run: |
    source ../scripts/read-vault-config.sh
    export_vault_config
```

In production, replace with actual Azure Key Vault - application code doesn't change.
