job "corona" {
  datacenters = [
    "dc1"]

  type = "service"

  group "corona" {
    count = 1

    task "corona" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-hdfs-namenode:ozone"
        network_mode = "host"
        force_pull = true
        command = "/opt/hadoop/bin/hdfs"
        args = [
          "corona"
        ]
        #{include "logging.nomad"}#
      }
      env {
        CONFIG_TYPE = "consul"
        CONSUL_KEY = "hdfs"
        HADOOP_LOG_DIR = "/tmp"
      }
      resources {
        cpu = 1000
        memory = 2000
      }
    }
  }
}
