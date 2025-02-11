variable "DO_token" {
   type = string
   description = "DO token"
   default = "set this"
   sensitive = true
}

variable "CF_token" {
   type = string
   default = "set this"
   sensitive = true
}
variable "CF_zone_id" {
   type = string
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

variable "code_server_archive" {
   type = string
   default = " https://github.com/coder/code-server/releases/download/v4.96.4/code-server-4.96.4-linux-amd64.tar.gz"
}
variable "code_server_password" {
   type = string 
   sensitive = true
}

variable "code_server_domain" {
   type = string
   default = "code-server.chuklee.com"
}