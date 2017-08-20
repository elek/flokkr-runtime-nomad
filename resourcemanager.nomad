job "resourcemanager" {
  datacenters = ["dc1"]

  type = "service"

  group "resourcemanager" {
    count = 1

    task "resourcemanager" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-yarn-resourcemanager:latest"
        network_mode = "host"
        force_pull = true
      }
      service {
         name = "resourcemanager"
         port = "rpc"
      }

      env {
         CONFIG_TYPE = "consul"
         CONSUL_KEY = "yarn"
         ENSURE_NAMENODE_DIR = "/data/namenode"
      }
      resources {
            cpu    = 500
            memory = 1000
            network {
              port "rpc" {}
            }
      }
    }
  }
}
