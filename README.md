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
| Scheduling (find hosts with available resource) | Yes, fine-grained constraint rules       |
| Failover on host crash                   | N/A                                      |
| Scale up/down:                           | With mondifying the Nomad job specifications |
| Multi tenancy (multiple cluster)         | NO (Host network)                        |
| __Network__                              |                                          |
| Network between containers               | Host network                             |
| DNS                                      | Yes, handled by the OS/Cloud environment (Host network) |
| Service discovery                        | Required for flexible scheduling (Consul based) |
| Data locality                            | Yes, Full                                |
| Availability of the ports                | All of them are available (Host network) |


## Getting started

You need a cluster. use terraform or any other tool to start it.

### Prerequisits 

* Install docker to the nodes
* Install consul to every node
* Install nomad to the nodes

### Configuration

Configuration is stored in consul and downloaded by every docker image.

First you need a configuration set:

```
git clone https://github.com/flokkr/configuration.git
```

You should install the configuration upload (which uploads the configuration with additional preprcessing:

```
go get github.com/flokkr/consync
```

And now you can upload the configuration:

```
consync -dir ~/projects/flokkr/configuration -consul node-1 -discovery consul
```

Where node-1 is the hostname of a consul node

### Nomad

Now you can start the images with

```
export NOMAD_ADDR=http://node-1:4646
```

Ann finally:

```
nomad run namenode.nomad
nomad run datanode.nomad
...
```

