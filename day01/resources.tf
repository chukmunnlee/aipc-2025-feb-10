data "digitalocean_ssh_key" "aipc_ed25519" {
   name = var.public_key_name
}

#resource "digitalocean_droplet" "droplet-day01" {
#   name = "droplet-day01"
#   image = var.droplet_image
#   size = var.droplet_size
#   region = var.droplet_region
#   ssh_keys = [ data.digitalocean_ssh_key.aipc_ed25519.id ]
#}

#resource "digitalocean_droplet" "droplet-day01" {
#   for_each = var.droplets
#   name = each.key
#   image = each.value.image
#   size = each.value.size
#   region = each.value.region
#   ssh_keys = [ data.digitalocean_ssh_key.aipc_ed25519.id ]
#}

resource "digitalocean_droplet" "droplet-day01" {
   count = var.instance_count
   name = "droplet-day01-${count.index}"
   image = var.droplet_image
   size = var.droplet_size
   region = var.droplet_region
   ssh_keys = [ data.digitalocean_ssh_key.aipc_ed25519.id ]

   connection {
      type = "ssh"
      user = "root"
      private_key = file(var.private_key)
      host = self.ipv4_address
   }

   provisioner "remote-exec" {
      inline = [  
         "apt update",
         "apt upgrade -y"
      ]
   }
}

resource "local_file" "name" {
   filename = "droplets_ips.txt"
   content = templatefile("droplets_ips.txt.tftpl", {
      message = "Generated on Feb 10 2025",
      droplets_ip = [ for d in digitalocean_droplet.droplet-day01: d.ipv4_address ]
      # droplets_ip = digitalocean_droplet.droplet-day01[*].ipv4_address
   })
}

output "aipc_ed25519_fingerprint" {
   description = "This is the fingerprint of my public key"
   value = data.digitalocean_ssh_key.aipc_ed25519.fingerprint
}

output "aipc_ed25519_pubkey" {
   value = data.digitalocean_ssh_key.aipc_ed25519.public_key
}

#output "droplet-day01-ipv4" {
#   description = "Droplet public IP address"
#   value = join(", ", [ for d in digitalocean_droplet.droplet-day01: d.ipv4_address ])
#}

output "droplet-day01-ipv4" {
   description = "Droplet public IP address"
   value = join(", ", digitalocean_droplet.droplet-day01[*].ipv4_address)
}

#output "droplet-day01-ipv4" {
#   description = "Droplet public IP address"
#   value = digitalocean_droplet.droplet-day01.ipv4_address
#}