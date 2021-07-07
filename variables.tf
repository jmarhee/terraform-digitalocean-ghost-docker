variable "digitalocean_token" {
  description = "Your DigitalOcean API key"
}

variable "region" {
  description = "DigitalOcean Region"
  default     = "TOR1"
}

variable "primary_size" {
  description = "K8s Primary Droplet Size"
  default     = "4GB"
}

variable "site_domain" {
  description = "Your site's FQDN (no http://)"
}

variable "config_path" {
  description = "Storage path for Ghost files"
  default     = "/opt"
}

variable "site_email" {
  description = "Your email for LetsEncrypt notifications"
}
