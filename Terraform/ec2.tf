#creating security group by giving inbound and outbound ules
resource "aws_security_group" "security_group" {
  name        = "private_security_group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }
  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 65535
  }
  tags = {
    Name = "terraform_custom_security_group"
  }
}
output "aws_security_group_id" {
  value = aws_security_group.security_group.id
}
#creating EC2 in Public Subnet
resource "aws_instance" "public_ec2_instance" {
  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  key_name                    = "windows-test"
  vpc_security_group_ids      = ["${aws_security_group.security_group.id}"]
  subnet_id                   = aws_subnet.Public_subnet.id
  associate_public_ip_address = true
  count                       = 1
  tags = {
    "Name" = "terraform_public_instance"
  }
}
#creating EC2 in Private Subnet
resource "aws_instance" "private_ec2_instance" {
  ami                         = "ami-0a3c3a20c09d6f377"
  instance_type               = "t2.micro"
  key_name                    = "windows-test"
  vpc_security_group_ids      = ["${aws_security_group.security_group.id}"]
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  count                       = 1
  tags = {
    "Name" = "terraform_private_instance"
  }
}