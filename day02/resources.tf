data "digitalocean_ssh_key" "aipc_ed25519" {
   name = var.public_key_name
}

resource "digitalocean_droplet" "mydroplet" {

   name = "nginx"
   size = var.droplet_size
   image = var.droplet_image
   region = var.droplet_region

   ssh_keys = [ data.digitalocean_ssh_key.aipc_ed25519.id ]
}

resource "local_file" "inventories_yaml" {
   filename = "inventories.yaml"
   content = templatefile("inventories.yaml.tftpl", {
      private_key_path = var.private_key_path
      droplet_ip = digitalocean_droplet.mydroplet.ipv4_address
   })
   file_permission = "0444"
}

resource "local_file" "root_at_id" {
   filename = "root@${digitalocean_droplet.mydroplet.ipv4_address}"
   content = ""
   file_permission = "0444"
}

output droplet_ip {
   value = digitalocean_droplet.mydroplet.ipv4_address
}