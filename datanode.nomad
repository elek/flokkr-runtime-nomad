job "datanode" {
  datacenters = [
    "dc1"]

  type = "system"


  group "datanode" {
    count = 1
    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "datanode" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-hdfs-datanode:ozone"
        network_mode = "host"
        force_pull = true
        volumes = [
          "local/data:/data"
        ]
        #{include "logging.nomad"}#
      }
      env {
        CONFIG_TYPE = "consul"
        CONSUL_KEY = "hdfs"
        HADOOP_LOG_DIR = "/tmp"
        PROMETHEUSJMX_ENABLED = "true"
      }
      resources {
        cpu = 1003
        memory = 2000
      }
    }
  }
}
