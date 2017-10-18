job "telegraf" {
  datacenters = [
    "dc1"]

  type = "system"

  group "telegraf" {
    count = 1
    task "telegraf" {
      driver = "docker"
      artifact {
        source = "https://kv.anzix.net/telegraf.conf"
        destination = "local"
      }
      config {
        image = "telegraf"
        network_mode = "host"
        command = "-config"
        args = [
          "/local/telegraf.conf"
        ]
        force_pull = true
      }
      service {
        name = "telegraf"
        port = "web"
        tags = [
          "web"
        ]
      }
      env {
      }
      resources {
        cpu = 200
        memory = 200
        network {
          port "web" {
            static = 9273
          }
        }
      }
    }
  }
}
