resource "aws_instance" "bastionhost" {
  ami           = "ami-0bd39c806c2335b95"
  instance_type = "t2.micro"
  key_name      = "mbp"
  subnet_id     = aws_subnet.public-subnet[0].id

  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    "Name" = "bastionhost"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [format("%s/32", chomp(data.http.icanhazip.body))]
  }
  tags = {
    "Name" = "bastionhost"
  }
}