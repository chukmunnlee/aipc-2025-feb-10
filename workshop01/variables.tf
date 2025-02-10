variable "DO_token" {
   type = string
   description = "DO token"
   default = "set this"
   sensitive = true
}

variable droplet_size {
   type = string
   default = "s-1vcpu-1gb"
}

variable "droplet_image" {
   type = string
   default = "ubuntu-24-04-x64"
}

variable "droplet_region" {
   type = string
   default = "sgp1"
}

variable "public_key" {
   type = string
}
variable "private_key" {
   type = string
   sensitive = true
}