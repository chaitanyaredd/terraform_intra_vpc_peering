/* VPC */
resource "aws_vpc" "secondary" {
  cidr_block = var.secondary_vpc_cidr
}

/** Internet gateway (IGW)  */
resource "aws_internet_gateway" "secondary" {
  vpc_id = aws_vpc.secondary.id
}

/** Route rule */
resource "aws_route" "secondary-internet_access" {
  route_table_id         = aws_vpc.secondary.main_route_table_id
  destination_cidr_block = var.public_cidr
  gateway_id             = aws_internet_gateway.secondary.id
}

/* Subnet */
resource "aws_subnet" "secondary-az1" {
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = var.secondary_subnet_cidr
  map_public_ip_on_launch = true
}

/** Security group */
resource "aws_security_group" "secondary-default" {
  name_prefix = "default-"
  description = "Default security group for all instances in VPC ${aws_vpc.secondary.id}"
  vpc_id      = aws_vpc.secondary.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr]
  }
}

