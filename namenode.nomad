job "namenode" {
  datacenters = [
    "dc1"]

  type = "service"

  group "namenode" {
    count = 1

    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }


    task "namenode" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-hdfs-namenode:ozone"
        network_mode = "host"
        force_pull = true
        #{include "logging.nomad"}#
      }
      service {
        name = "namenode"
        port = "rpc"
        tags = [
          "rpc"]
      }
      env {
        CONFIG_TYPE = "consul"
        CONSUL_KEY = "hdfs"
        ENSURE_NAMENODE_DIR = "/data/namenode"
        HADOOP_LOG_DIR = "/tmp"
        PROMETHEUSJMX_ENABLED = "true"
      }
      resources {
        cpu = 1000
        memory = 2001
        network {
          port "web" {
            static = 50070
          }
          port "rpc" {
            static = 9000
          }
        }
      }
    }
  }
}
