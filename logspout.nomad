job "logspout" {
  datacenters = [
    "dc1"]

  type = "system"

  group "logspout" {
    count = 1
    task "logspout" {
      driver = "docker"
      config {
        image = "gliderlabs/logspout"
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
        ]
        port_map {
          web = 80
        }

      }
      service {
        name = "logspout"
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
            static = 7090
          }
        }
      }
    }
  }
}
