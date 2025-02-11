data "digitalocean_ssh_key" "aipc_ed25519" {
   name = var.public_key_name
}

resource "digitalocean_droplet" "code-server" {
   name = "nginx"
   size = var.droplet_size
   image = var.droplet_image
   region = var.droplet_region

   ssh_keys = [ data.digitalocean_ssh_key.aipc_ed25519.id ]
}

resource "local_file" "inventory" {
   filename = "inventory.yaml"
   content = templatefile("inventory.yaml.tftpl", {
      private_key_path = var.private_key_path
      droplet_ip = digitalocean_droplet.code-server.ipv4_address
      code_server_archive = var.code_server_archive
      code_server_password = var.code_server_password
      code_server_domain = var.code_server_domain
   })
   file_permission = "0444"
}

resource "cloudflare_dns_record" "code-server" {
   type = "A"
   name = split(".", var.code_server_domain)[0]
   content = digitalocean_droplet.code-server.ipv4_address
   zone_id = var.CF_zone_id
   ttl = 3600
   proxied = true
}

resource "local_file" "root_at_id" {
   filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
   content = ""
   file_permission = "0444"
}

output code_server_ip {
   value = digitalocean_droplet.code-server.ipv4_address
}