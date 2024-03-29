terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "tcp://192.168.1.136:2375"
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

variable "internal_port" {
  type    = number
  default = 80
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"
  ports {
    internal = var.internal_port
    external = 8000
  }
}

module "mysql" {
  source = "./mysql_module"

  mysql_root_password = "xxxxxxx"
  mysql_database_name = "test_db"
}

output "mysql_container_id" {
  value = module.mysql.mysql_container_id
}
