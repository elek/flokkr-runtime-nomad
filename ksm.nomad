job "ksm" {
  datacenters = [
    "dc1"
  ]

  type = "service"

  group "ksm" {
    count = 1

    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }

    task "ksm" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-hdfs-namenode:ozone"
        network_mode = "host"
        force_pull = true
        command = "/opt/hadoop/bin/hdfs"
        volumes = [
          "local/data:/data"
        ]
        args = [
          "ksm"
        ]
        #{include "logging.nomad"}#
      }
      service {
        name = "ksm"
        port = "web"
        tags = [
          "web"
        ]
      }
      env {
        CONFIG_TYPE = "consul"
        CONSUL_KEY = "hdfs"
        HADOOP_LOG_DIR = "/tmp"
        PROMETHEUSJMX_ENABLED = "true"
      }
      resources {
        cpu = 1000
        memory = 2001
        network {
          port "web" {
            static = 9876
          }
          port "rpc" {
            static = 9000
          }
        }
      }
    }
  }
}
