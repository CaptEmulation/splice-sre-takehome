
locals {
  common_tags = "${map(
    "Type", "spliceSreTakehome",
  )}"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "spliceSreTakehome" {
  cidr_block = "10.0.0.0/16"
  tags = local.common_tags
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "spliceSreTakehome" {
  vpc_id = aws_vpc.spliceSreTakehome.id
  tags = local.common_tags
}

# Public subnet
resource "aws_subnet" "spliceSreTakehome_1" {
  vpc_id = aws_vpc.spliceSreTakehome.id
  cidr_block = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = local.common_tags
}

resource "aws_subnet" "spliceSreTakehome_2" {
  vpc_id = aws_vpc.spliceSreTakehome.id
  cidr_block = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = local.common_tags
}

# Routing table for public subnet
resource "aws_route_table" "spliceSreTakehome_1" {
  vpc_id = aws_vpc.spliceSreTakehome.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spliceSreTakehome.id
  }
  tags = local.common_tags
}

resource "aws_route_table" "spliceSreTakehome_2" {
  vpc_id = aws_vpc.spliceSreTakehome.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spliceSreTakehome.id
  }
  tags = local.common_tags
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "spliceSreTakehome_1" {
  subnet_id = aws_subnet.spliceSreTakehome_1.id
  route_table_id = aws_route_table.spliceSreTakehome_1.id
}

resource "aws_route_table_association" "spliceSreTakehome_2" {
  subnet_id = aws_subnet.spliceSreTakehome_2.id
  route_table_id = aws_route_table.spliceSreTakehome_2.id
}

# ECS Instance Security group
resource "aws_security_group" "spliceSreTakehome" {
    name = "spliceSreTakehome_public_sg"
    description = "Test public access security group"
    vpc_id = aws_vpc.spliceSreTakehome.id

   ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
    }

    ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"]
    }


    egress {
        # allow all traffic to private SN
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"]
    }

    tags = local.common_tags
}