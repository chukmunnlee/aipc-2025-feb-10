variable DO_token {
   type = string
   sensitive = true
}

variable DO_ssh_key {
   type = string
}

variable DO_ssh_priv_key {
   type = string
   sensitive = true
}

variable DO_image {
   type = string
   default = "ubuntu-24-04-x64"
}

variable DO_size {
   type = string
   default = "s-1vcpu-2gb"
}

variable DO_region {
   type = string
   default = "sgp1"
}