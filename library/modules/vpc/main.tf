resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr  
  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.vpc_igw_tag
  }
}


resource "aws_eip" "my_eip" {
  vpc = true

  tags = {
    Name = var.vpc_eip_tag
  }
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = var.nat_tag
  }
}


resource "aws_subnet" "public_subnet" {
  count       = length(var.public_subnet_ids)
  vpc_id      = aws_vpc.my_vpc.id
  cidr_block  = element(var.public_subnet_ids, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count       = length(var.private_subnet_ids)
  vpc_id      = aws_vpc.my_vpc.id
  cidr_block  = element(var.private_subnet_ids, count.index)
  availability_zone = element(var.availability_zones, count.index % length(var.availability_zones))
  tags = {
    Name = "PrivateSubnet_${count.index}"
  }
}

resource "aws_route_table" "my_route_table_public" {
 vpc_id                  = aws_vpc.my_vpc.id
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
 }
 tags = {
  Name = var.public_route_tag
 }
}

resource "aws_route_table" "my_route_table_private" {
 vpc_id                  = aws_vpc.my_vpc.id
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.my_nat_gateway.id
 }
 tags = {
  Name = var.private_route_tag
 }
}

resource "aws_route_table_association" "public_subnet_az1_association" {
   count          = length(var.public_subnet_ids)
   subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
   route_table_id = aws_route_table.my_route_table_public.id
 }

 resource "aws_route_table_association" "private_subnet_az1_association" {
  count          = length(var.private_subnet_ids)
   subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
   route_table_id = aws_route_table.my_route_table_private.id
 }


