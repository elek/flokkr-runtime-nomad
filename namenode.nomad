job "namenode" {
  datacenters = ["dc1"]

  type = "service"

  group "namenode" {
    count = 1

    task "namenode" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-hdfs-namenode:latest"
        network_mode = "host"
        force_pull = true
      }
      service {
         name = "namenode"
         port = "rpc"
			tags = ["rpc"]
      }
       service {
         name = "namenode"
         port = "web"
			tags = ["web"]
      }
      env {
         CONFIG_TYPE = "consul"
         CONSUL_KEY = "hdfs"
         ENSURE_NAMENODE_DIR = "/data/namenode"
      }
      resources {
            cpu    = 500
            memory = 1000
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
