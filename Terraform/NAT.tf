#creating a Elastic ip address for NAT gateway
resource "aws_eip" "NAT_eip" {
  depends_on = [aws_internet_gateway.terraform_custom_igw]
  tags = {
    Name = "terraform_NAT_Gateway_EIP"
  }
}
#creating an NAT gateway
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id     = aws_subnet.Public_subnet.id
  tags = {
    Name = "terraform_NAT_Gateway"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform_custom_igw]
}
#creating route table for private subnet via NAT gateway
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT.id
  }
  tags = {
    Name = "terraform_private_subnet_route_table"
  }
}
#Private route table association with private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}