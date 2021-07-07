data "template_file" "ghost" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars = {
    SITE_DOMAIN = var.site_domain
    CONFIG_PATH = var.config_path
    SITE_EMAIL  = var.site_email
  }
}

resource "digitalocean_droplet" "ghost" {
  name               = "${var.site_domain}-${random_string.node_label.result}"
  image              = "ubuntu-20-04-x64"
  size               = var.primary_size
  region             = var.region
  backups            = "true"
  private_networking = "true"
  ssh_keys           = [digitalocean_ssh_key.default.fingerprint]
  user_data          = data.template_file.ghost.rendered
}
