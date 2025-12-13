locals {
  # Environment-aware storage account name
  storage_account_name = lower("st${var.environment}mod06tl86")
}
