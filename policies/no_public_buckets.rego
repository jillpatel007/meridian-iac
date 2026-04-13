package meridian.buckets

# Fail if AWS S3 bucket public access block has any knob set to false.
deny[msg] {
  resource := input.resource.aws_s3_bucket_public_access_block[name]
  some knob
  knob := ["block_public_acls", "block_public_policy", "ignore_public_acls", "restrict_public_buckets"][_]
  resource[knob] == false
  msg := sprintf("AWS S3 PublicAccessBlock '%s' has %s=false — Meridian policy requires all four to be true.", [name, knob])
}

# Fail if Azure Storage Account allows public blob access.
deny[msg] {
  resource := input.resource.azurerm_storage_account[name]
  resource.allow_nested_items_to_be_public == true
  msg := sprintf("Azure Storage Account '%s' has allow_nested_items_to_be_public=true — Meridian policy forbids anonymous blob access.", [name])
}

# Fail if GCS bucket public access prevention is not 'enforced'.
deny[msg] {
  resource := input.resource.google_storage_bucket[name]
  resource.public_access_prevention != "enforced"
  msg := sprintf("GCS bucket '%s' does not have public_access_prevention='enforced' — Meridian policy requires enforced.", [name])
}
