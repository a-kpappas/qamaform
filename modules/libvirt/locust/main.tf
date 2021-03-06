module "locust" {
  source             = "../host"
  base_configuration = var.base_configuration
  name               = var.name
  ssh_key_path       = var.ssh_key_path
  roles              = ["locust"]
  grains = {
    mirror             = var.base_configuration["mirror"]
    server             = var.server_configuration["hostname"]
    locust_file        = base64encode(file(var.locust_file))
    server_username    = var.server_configuration["username"]
    server_password    = var.server_configuration["password"]
    locust_master_host = null
    locust_slave_count = var.slave_quantity
  }

  // Provider-specific variables
  image   = "opensuse151"
  memory  = var.memory
  running = var.running
  mac     = var.mac
}

module "locust-slave" {
  source             = "../host"
  base_configuration = var.base_configuration
  name               = "${var.name}-slave"
  quantity           = var.slave_quantity
  ssh_key_path       = var.ssh_key_path
  roles              = ["locust"]
  grains = {
    mirror             = var.base_configuration["mirror"]
    server             = var.server_configuration["hostname"]
    locust_file        = base64encode(file(var.locust_file))
    server_username    = var.server_configuration["username"]
    server_password    = var.server_configuration["password"]
    locust_master_host = module.locust.configuration["hostname"]
  }


  // Provider-specific variables
  image   = "opensuse151"
  memory  = var.memory
  running = var.running
}

output "configuration" {
  value = {
    id       = length(module.locust.configuration["ids"]) > 0 ? module.locust.configuration["ids"][0] : null
    hostname = length(module.locust.configuration["hostnames"]) > 0 ? module.locust.configuration["hostnames"][0] : null
  }
}
