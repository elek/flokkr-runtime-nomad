job "nodemanager" {
  datacenters = [
    "dc1"]

  type = "system"


  group "nodemanager" {
    count = 1

    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }

    task "nodemanager" {
      driver = "docker"

      config {
        image = "flokkr/hadoop-yarn-nodemanager:3.0.0-beta1-RC0"
        network_mode = "host"
        force_pull = true
        volumes = [
          "local/data:/data"
        ]
        #{include "logging.nomad"}#
      }
      env {
        CONFIG_TYPE = "consul"
        CONSUL_KEY = "yarn"
        HADOOP_LOG_DIR = "/tmp"
      }
      resources {
        cpu = 500
        memory = 2001
      }
    }
  }
}
