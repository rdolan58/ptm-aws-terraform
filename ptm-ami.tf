provider "aws" {
  access_key = "AKIAQW3UMACDKX7JQRWK"
  secret_key = "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"
  region     = "us-east-2"
}


resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
description = "Allow SSH"
vpc_id = "vpc-c711d3ac"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }

ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 80
    to_port = 80
    protocol = "tcp"
  }

ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }

ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }


// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "PTMQuality" {
  ami           = "ami-02ccb28830b645a41"
  instance_type = "t2.micro"
  key_name = "ptm-kp1"
  security_groups = ["${aws_security_group.ingress-all-test.name}"]

 connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/OneDrive/PTM/AWSKEYS/ptm-kp1.pem")
    host     = self.public_ip

 }
provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo yum install -y python3",
      "sudo yum install -y gcc-c++ make",
      "curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -",
      "sudo yum install -y nodejs",
      "RUN yes | sudo npm install -g  @angular/cli",
      "sudo amazon-linux-extras install -y nginx1",
      #"sudo amazon-linux-extras install -y java-openjdk11",
      "sudo systemctl start nginx",
      "sudo yum install -y git",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo",
      "sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key",
      "sudo yum install -y jenkins",
      "sudo yum install -y java-1.8.0-openjdk",
      "sudo service jenkins start",
      "sudo chkconfig jenkins on",
      "sleep 10"
    ]
  
  }
}