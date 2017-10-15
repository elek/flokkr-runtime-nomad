job "prometheus" {
  datacenters = [
    "dc1"]

  type = "service"

  group "prometheus" {
    count = 1
    task "prometheus" {
      driver = "docker"
      artifact {
        source = "https://kv.anzix.net/prometheus.yml"
        destination = "local"
      }
      config {
        image = "prom/prometheus"
        network_mode = "host"
        command = "-config.file=/local/prometheus.yml"
        args = [
          "-storage.local.path=/local/data"
        ]
        force_pull = true
      }
      service {
        name = "prometheus"
        port = "web"
        tags = [
          "web"
        ]
      }
      env {
      }
      resources {
        cpu = 1000
        memory = 2001
        network {
          port "web" {
            static = 9090
          }
        }
      }
    }
  }
}
