variable "location" {
  description = "Azure region"
  type        = string
  default     = "northeurope"
}

variable "rgname" {
  description = "Name of the Resource Group"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
  default     = "dev"
}
