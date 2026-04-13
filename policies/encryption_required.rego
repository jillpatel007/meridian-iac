package meridian.encryption

# AWS: every S3 bucket must have an encryption config.
deny[msg] {
  input.resource.aws_s3_bucket[name]
  not has_s3_encryption(name)
  msg := sprintf("AWS S3 bucket '%s' has no server-side encryption configured — Meridian policy requires encryption-at-rest.", [name])
}

has_s3_encryption(name) {
  enc := input.resource.aws_s3_bucket_server_side_encryption_configuration[_]
  contains(enc.bucket, name)
}

# Azure: storage account must enforce TLS 1.2 minimum (encryption-in-transit precondition).
deny[msg] {
  resource := input.resource.azurerm_storage_account[name]
  resource.min_tls_version != "TLS1_2"
  msg := sprintf("Azure Storage Account '%s' min_tls_version is not TLS1_2 — Meridian policy requires TLS 1.2+.", [name])
}
