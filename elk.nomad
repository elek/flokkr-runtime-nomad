job "elk" {
  datacenters = [
    "dc1"]

  type = "service"

  group "elk" {

    count = 1

    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }

    task "elasticsearch" {
      driver = "docker"
      config {
        image = "elasticsearch"
        network_mode = "host"
        #force_pull = true
      }
      service {
        name = "elasticsearch"
        port = "web"
        tags = [
          "web"
        ]
      }
      env {
      }
      resources {
        cpu = 1000
        memory = 3001
        network {
          port "web" {
            static = 9200
          }
        }
      }
    }
    task "kibana" {
      driver = "docker"
      config {
        image = "kibana"
        network_mode = "host"
        force_pull = true
      }
      service {
        name = "elasticsearch"
        port = "web"
        tags = [
          "web"
        ]
      }
      env {
        ELASTICSEARCH_URL = "http://localhost:9200"
      }
      resources {
        cpu = 1000
        memory = 2001
        network {
          port "web" {
            static = 5601
          }
        }
      }
    }
  }
}
