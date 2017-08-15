#!/usr/bin/env bash
set -x
terraform apply
ansible-playbook -s -u ubuntu --inventory-file=`which terraform-inventory` consul.yaml
ansible-playbook -s -u ubuntu --inventory-file=`which terraform-inventory` nomad.yaml
export GATEWAY_HOST=nomad-0
consync -dir ../configuration -consul $(terraform output external_ip)
gcloud compute scp *.nomad nomad-0:
gcloud compute ssh nomad-0 --command="nomad run gateway.nomad"
gcloud compute ssh nomad-0 --command="nomad run datanode.nomad"



