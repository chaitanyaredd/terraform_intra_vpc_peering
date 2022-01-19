/* VPC */
resource "aws_vpc" "primary" {
  cidr_block = var.primary_vpc_cidr
}

/** Internet gateway (IGW)  */
resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id
}

/** Route rule */
resource "aws_route" "primary-internet_access" {
  route_table_id         = aws_vpc.primary.main_route_table_id
  destination_cidr_block = var.public_cidr
  gateway_id             = aws_internet_gateway.primary.id
}

/* Subnet */
resource "aws_subnet" "primary-az1" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = var.primary_subnet_cidr
  map_public_ip_on_launch = true
}

/** Security group */
resource "aws_security_group" "primary-default" {
  name_prefix = "default-"
  description = "Default security group for all instances in VPC ${aws_vpc.primary.id}"
  vpc_id      = aws_vpc.primary.id

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

