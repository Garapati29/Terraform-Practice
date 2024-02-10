#creating vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "terraform_main"
  }
}
#creating public subnet
resource "aws_subnet" "Public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1"
  tags = {
    Name = "terraform_public_subnet"
  }
}
#creating private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1"
  tags = {
    Name = "terraform_private_subnet"
  }
}
#creating internet gateway 
resource "aws_internet_gateway" "terraform_custom_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "terrafor_internet_gateway"
  }
}
#creating route table for public subnent
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_custom_igw.id
  }
  tags = {
    Name = "terraform_public_subnet_route_table"
  }
}
#route table association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.public_route.id
}