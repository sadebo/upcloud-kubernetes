variable "upcloud_username" {
  description = "UpCloud API username"
  type        = string
  sensitive   = true
}

variable "upcloud_password" {
  description = "UpCloud API password"
  type        = string
  sensitive   = true
}

variable "is_trial" {
  description = "Whether this is a trial account (forces use of development plans)"
  type        = bool
  default     = true
}
