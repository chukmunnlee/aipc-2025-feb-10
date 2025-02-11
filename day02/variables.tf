variable "DO_token" {
   type = string
   description = "DO token"
   default = "set this"
   sensitive = true
}

variable droplet_size {
   type = string
   default = "s-1vcpu-2gb"
}

variable "droplet_image" {
   type = string
   default = "ubuntu-24-04-x64"
}

variable "droplet_region" {
   type = string
   default = "sgp1"
}

variable "private_key_path" {
   type = string
   default = "/opt/tmp/aipc_ed25519"
}

variable "public_key_name" {
   type = string
   default = "aipc_ed25519"
}