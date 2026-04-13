# meridian-iac

Meridian Finserv Infrastructure-as-Code.

## Structure
- `aws/` — AWS resources (region: ap-south-1)
- `azure/` — Azure resources (region: centralindia)
- `gcp/` — GCP resources (region: asia-south1)

## Security Pipeline
Every PR runs through:
1. **tfsec** — Terraform-specific security checks
2. **Checkov** — multi-framework policy checks
3. **Terrascan** — OPA-based policy enforcement
4. **Trivy** — misconfig + secret scanning
5. **OPA/Conftest** — Meridian-specific custom policies
6. **Cosign** — artifact signing

Severity ≥ HIGH blocks merge.

## Compliance
Maps to RBI 2024 Cloud Guidelines, DPDPA 2023 technical controls, PCI DSS, ISO 27017.
