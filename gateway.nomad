job "gateway" {
  datacenters = ["dc1"]

  type = "service"

  group "namenode" {
    count = 1

    task "namenode" {
      driver = "docker"
      constraint = {
            attribute = "${node.unique.name}"
            value = "nomad-0"
          }
      config {
        image = "flokkr/hadoop-hdfs-namenode:latest"
        network_mode = "host"
        force_pull = true
        port_map = {
           http = 9000
        }
      }

      env {
         CONFIG_TYPE = "consul"
         CONSUL_KEY = "hdfs"
         ENSURE_NAMENODE_DIR = "/data/namenode"
      }
      resources {
            cpu    = 1000
            memory = 2000
            network {
              port "http" {}
            }
      }
    }
  }
}
