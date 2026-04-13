package meridian.iam

# AWS: no IAM policy document may use Action="*" or Resource="*" together.
deny[msg] {
  resource := input.resource.aws_iam_policy[name]
  contains(resource.policy, "\"Action\": \"*\"")
  msg := sprintf("AWS IAM policy '%s' contains wildcard Action='*' — Meridian policy forbids wildcard actions.", [name])
}

deny[msg] {
  resource := input.resource.aws_iam_role_policy[name]
  contains(resource.policy, "\"Action\": \"*\"")
  msg := sprintf("AWS IAM role policy '%s' contains wildcard Action='*' — Meridian policy forbids wildcard actions.", [name])
}

# Azure: no role assignment at subscription scope with Owner role.
deny[msg] {
  resource := input.resource.azurerm_role_assignment[name]
  resource.role_definition_name == "Owner"
  contains(resource.scope, "/subscriptions/")
  not contains(resource.scope, "/resourceGroups/")
  msg := sprintf("Azure role assignment '%s' grants Owner at subscription scope — Meridian policy requires RG-scoped or narrower.", [name])
}
