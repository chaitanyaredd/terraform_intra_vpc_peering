//"ImageLocation": "309956199498/RHEL-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2"
//RHEL-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2

data "aws_ami" "rhel8" {
  most_recent = true
  owners      = var.owner_ids

  filter {
    name   = "name"
    values = ["RHEL-8.4.0_HVM-*", ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "VM-in-primary-vpc" {
  ami                    = data.aws_ami.rhel8.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.primary-az1.id
  vpc_security_group_ids = [aws_security_group.primary-default.id]
  key_name               = "learnaws"
  tags = {
    Name = "primary_server"
  }
}
resource "aws_instance" "VM-in-secondary-vpc" {
  ami                    = data.aws_ami.rhel8.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.secondary-az1.id
  vpc_security_group_ids = [aws_security_group.secondary-default.id]
  key_name               = "learnaws"
  tags = {
    Name = "secondary_server"
  }
}
