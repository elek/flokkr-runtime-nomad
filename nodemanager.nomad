job "nodemanager" {
  datacenters = ["dc1"]

  type = "system"


  group "nodemanager" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "nodemanager" {
      driver = "docker"

      config {
        image = "flokkr/hadoop-yarn-nodemanager:latest"
        network_mode = "host"
        force_pull = true
      }
      env {
         CONFIG_TYPE = "consul"
         CONSUL_KEY =  "yarn"
      }
      resources {
            cpu    = 500
            memory = 1000
      }
    }
  }
}
