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

variable "site_domain_root" {
  description = "Your site's root A record (put @ if no subdomain)"
}

variable "config_path" {
  description = "Storage path for Ghost files"
  default     = "/opt"
}

variable "site_email" {
  description = "Your email for LetsEncrypt notifications"
}

variable "cloudflare_zone_id" {
  description = "Cloudflare DNS Zone"
}

variable "cloudflare_domain" {
  description = "Cloudflare Domain"
  default     = "your_domain.com"
}

variable "cloudflare_api_key" {
  description = "Cloudflare API Token"
}

variable "cloudflare_email" {
  description = "CloudFlare email"
}
