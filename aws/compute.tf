provider "aws" {
   region = "us-east-2"
}
resource "aws_key_pair" "defaultkey" {
  key_name   = "deployer-key"
  public_key = "${file(pathexpand("~/.ssh/id_rsa.pub"))}"
}

resource "aws_spot_instance_request" "nomad" {
  count = 3
  ami           = "ami-d8be9ebd"
  spot_price    = "0.03"
  instance_type = "r3.large"
  wait_for_fulfillment  = true
  key_name = "deployer-key"
  connection {
    user = "ubuntu"
  }
  provisioner "remote-exec" {
    script = "../docker-install.sh"
  }

}

output "master_ip" {
 value = "${aws_spot_instance_request.nomad.0.private_ip}"
}
output "external_ip" {
 value = "${aws_spot_instance_request.nomad.0.public_ip}"
}
