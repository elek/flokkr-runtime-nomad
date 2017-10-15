job "scm" {
  datacenters = [
    "dc1"]

  type = "service"

  group "scm" {
    count = 1

    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }

    task "scm" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-hdfs-namenode:ozone"
        network_mode = "host"
        force_pull = true
        command = "/opt/hadoop/bin/hdfs"
        args = [
          "scm"
        ]
        volumes = [
          "local/data:/data"
        ]
        #{include "logging.nomad"}#
      }
      service {
        name = "scm"
        port = "web"
        tags = [
          "web"]
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
            static = 9874
          }
          port "rpc" {
            static = 9000
          }
        }
      }
    }
  }
}
