# Hadoop cluster with nomad

Ansible and terraform scripts to install hadoop cluster based on [flokkr](https://github.com/flokkr/flokkr) docker images.

## Attributes
| Topic                                    | Solution                                 |
| ---------------------------------------- | ---------------------------------------- |
| __Configuration management__             |                                          |
| Source of config files:                  | Consul server (envtoconf can't be used as nomad can't use non-regular env variables) |
| Configuration preprocessing:             | **consync** (Upload configuration to the consul server) |
| Automatic restart on config change:      | Supported by the consul plugin of the baseimage. Listens on changes on the consul side |
| __Provisioning and scheduling__          |                                          |
| Multihost support                        | Yes. Nomad agents should run everywhere  |
| Requirements on the hosts                | Consul and Nomad agents                  |
| Definition of the containers per host    | Nomad job descriptors                    |
| Scheduling (find hosts with available resource) | Yes, find grained constraint rules       |
| Failover on host crash                   | N/A                                      |
| Scale up/down:                           | With mondifying the Nomad job specifications |
| Multi tenancy (multiple cluster)         | NO (Host network)                        |
| __Network__                              |                                          |
| Network between containers               | Host network                             |
| DNS                                      | Yes, handled by the OS/Cloud environment (Host network) |
| Service discovery                        | Required for flexible scheduling (Consul based) |
| Data locality                            | Yes, Full                                |
| Availability of the ports                | All of them are available (Host network) |