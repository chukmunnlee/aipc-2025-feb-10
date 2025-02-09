data "digitalocean_ssh_key" apic_key {
   name = var.DO_ssh_key
}

resource "digitalocean_droplet" mydroplet {
   name = "mydroplet"
   size = var.DO_size
   region =  var.DO_region
   image =  var.DO_image
   ssh_keys = [ data.digitalocean_ssh_key.apic_key.id ]

   connection {
      type = "ssh"
      user = "root"
      private_key = file(var.DO_ssh_priv_key)
      host = self.ipv4_address
   }

   provisioner "remote-exec" {
      inline = [ 
         "apt update",
         "apt upgrade -y",
         "reboot"
      ]
   }
}

resource "local_file" "root_at_droplet_ip" {
   filename = "root@${digitalocean_droplet.mydroplet.ipv4_address}"
   content = ""
   file_permission = "0444"
}

resource "local_file" "ansible_inventory" {
   filename = "inventory.yaml"
   content = templatefile("inventory.yaml.tftpl", {
      droplet_ip = digitalocean_droplet.mydroplet.ipv4_address
      ssh_private_key_file = var.DO_ssh_priv_key
   })
   file_permission = "0444"
}

output ssh_key {
   description = "SSH public key fingerprint"
   value = data.digitalocean_ssh_key.apic_key.fingerprint
}

output mydroplet_ip {
   description = "mydroplet's public IP"
   value = digitalocean_droplet.mydroplet.ipv4_address
}