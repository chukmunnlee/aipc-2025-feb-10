# Create SSH public key
# ssh-key -t ed25519 -f workshop01
resource "digitalocean_ssh_key" "workshop01_pub" {
   name = "workshop01_pub"
   public_key = file(var.public_key)
}

resource "digitalocean_droplet" "nginx" {

   name = "nginx"
   size = var.droplet_size
   image = var.droplet_image
   region = var.droplet_region

   ssh_keys = [ digitalocean_ssh_key.workshop01_pub.id ]

   connection {
     type = "ssh"
     user = "root"
     private_key = file(var.private_key)
     host = self.ipv4_address
   }

   provisioner "remote-exec" {
      inline = [  
         "apt update",
         "apt upgrade -y",
         "apt install nginx -y",
         "systemctl enable nginx",
         "systemctl start nginx"
      ]
   }

   provisioner "file" {
      source = "assets/"
      destination = "/var/www/html"
   }
}

resource "local_file" "index_html" {
   filename = "assets/index.html"
   file_permission = "0644"
   content = templatefile("assets/index.html.tftpl", {
      droplet_ip = digitalocean_droplet.nginx.ipv4_address
   })
}

resource "local_file" "nginx_dns" {
   filename = "nginx-${digitalocean_droplet.nginx.ipv4_address}.nip.io"
   content = ""
   file_permission = "0444"
}

# Output the fingerprint
output ssh_fingerprint {
   value = digitalocean_ssh_key.workshop01_pub.fingerprint
}

output nginx_ip {
   value = digitalocean_droplet.nginx.ipv4_address
}