job "slave" {
  datacenters = ["dc1"]

  type = "system"


  group "datanode" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "datanode" {
      driver = "docker"

      config {
        image = "flokkr/hadoop-hdfs-datanode:latest"
        network_mode = "host"
        force_pull = true
      }
      env {
         CONFIG_TYPE = "consul"
         CONSUL_KEY =  "hdfs"
      }
      resources {
            cpu    = 900
            memory = 1000
      }
    }
  }
}
