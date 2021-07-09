provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

locals {
  ssh_key_name = "ocean_key"
}

resource "random_string" "node_label" {
  length      = 6
  special     = false
  upper       = false
  min_lower   = 3
  min_numeric = 3
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cluster_private_key_pem" {
  content         = chomp(tls_private_key.ssh_key_pair.private_key_pem)
  filename        = pathexpand(format("%s", local.ssh_key_name))
  file_permission = "0600"
}

resource "local_file" "cluster_public_key" {
  content         = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  filename        = pathexpand(format("%s.pub", local.ssh_key_name))
  file_permission = "0600"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Example"
  public_key = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
}
