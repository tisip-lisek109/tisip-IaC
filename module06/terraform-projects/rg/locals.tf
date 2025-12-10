locals {
  # Environment-aware storage account name
  # Musi być: 3–24 znaki, tylko małe litery i cyfry
  storage_account_name = lower("st${var.environment}mod06tl86")
}
