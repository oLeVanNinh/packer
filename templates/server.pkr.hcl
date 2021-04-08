variable "ami_name" {
  type = string
  default = "custom-ami"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "")}

source "amazon-ebs" "rails_demo_ami" {
  profile = "packer"
  ami_name = "packer ami ${local.timestamp}"
  instance_type = "t3.medium"
  region = "us-east-1"
  source_ami = "ami-0739f8cdb239fe9ae"
  ssh_username = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.rails_demo_ami"]

  provisioner "ansible" {
    user = "ubuntu"
    playbook_file = "./ansible/playbook.yml"
  }
}
