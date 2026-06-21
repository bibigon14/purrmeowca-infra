variable "zone_id" {
  description = "Cloudflare Zone ID for purrmeowca.com"
  type        = string
  default     = "796252eba98cabb88f25f9f5e65d8a72"
}

variable "account_id" {
  description = "Cloudflare Account ID (needed for Workers/R2 resources)"
  type        = string
  default     = "4df5c0c98d64558858be99df4dbbf152"
}

variable "domain" {
  description = "Root domain name"
  type        = string
  default     = "purrmeowca.com"
}
