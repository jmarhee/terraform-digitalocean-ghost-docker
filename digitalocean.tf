data "template_file" "ghost" {
  template = "${file("${path.module}/templates/userdata.tpl")}"

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
  //  user_data          = data.template_file.ghost.rendered
}

resource "cloudflare_record" "ghost" {
  depends_on = [digitalocean_droplet.ghost]
  zone_id    = var.cloudflare_zone_id
  name       = var.site_domain_root
  value      = digitalocean_droplet.ghost.ipv4_address
  type       = "A"
  ttl        = 1
  proxied    = false
}

resource "null_resource" "node_setup" {
  depends_on = [digitalocean_droplet.ghost, cloudflare_record.ghost]
  connection {
    host        = digitalocean_droplet.ghost.public_ipv4
    type        = "ssh"
    user        = "root"
    private_key = pathexpand(format("%s", local.ssh_key_name))
  }

  provisioner "file" {
    source      = template_file.ghost.rendered
    destination = "/root/ghost.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod /root/ghost.sh",
      "./root/ghost.sh"
    ]
  }
}
