packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region"{
  type    = string
  default = ""
}

variable "source_ami"{
  type    = string
  default = ""
}

variable "instance_type"{
  type    = string
  default = ""
}

variable "vpc_id"{
  type    = string
  default = ""
}

variable "subnet_id"{
  type    = string
  default = ""
}

source "amazon-ebs""my-ami"{
  region                      = var.region
  source_ami                   = var.source_ami
  instance_type               = var.instance_type
  ssh_username                = "ubuntu"
  associate_public_ip_address = true

ami_name = "autoscale-ami-Build-${formatdate("YYYYMMDD-hhmmss", timestamp())}"

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  tags = {
  Name = "autoscale-ami-Build-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  }
}


build {
  name    = "autoscale-ami-build"
  sources = [
    "source.amazon-ebs.my-ami"
  ]

  provisioner "shell"{
    inline = [
      "sleep 30",
      "sudo apt-get update -y",
      "sudo apt-get install -y software-properties-common",
      "sudo add-apt-repository --yes ppa:ansible/ansible",
      "sudo apt-get install -y ansible python3-apt nginx git stress",
      "sudo git clone https://github.com/iam-rayees/my-autoscaling_testing.git /myrepo",
      "ansible-playbook /myrepo/playbook.yaml"
    ]
  }
  }