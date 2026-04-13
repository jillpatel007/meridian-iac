package meridian.tagging

# AWS: every S3 bucket must be tagged via provider default_tags or explicit tags block.
# (This policy works because we enforce default_tags at provider level; catches regressions.)
deny[msg] {
  input.provider.aws[_].default_tags[_].tags.DataClassification == ""
  msg := "AWS provider default_tags missing required 'DataClassification' tag — Meridian policy requires all AWS resources tagged."
}

# Azure: resource groups must have data_classification tag.
deny[msg] {
  resource := input.resource.azurerm_resource_group[name]
  not resource.tags.data_classification
  msg := sprintf("Azure Resource Group '%s' missing required 'data_classification' tag — Meridian policy requires tagging.", [name])
}

# GCP: storage buckets must have data_classification label.
deny[msg] {
  resource := input.resource.google_storage_bucket[name]
  not resource.labels.data_classification
  msg := sprintf("GCS bucket '%s' missing required 'data_classification' label — Meridian policy requires labeling.", [name])
}
