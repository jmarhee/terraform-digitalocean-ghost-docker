output "Ghost_Blog_info" {
  value = "Setup your blog at: https://${var.site_domain}/ghost (${digitalocean_droplet.ghost.ipv4_address})"
}
