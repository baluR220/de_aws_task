resource "aws_vpc" "wp" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "wp_vpc"
  }
}

resource "aws_subnet" "wp_west_2a" {
  vpc_id                  = aws_vpc.wp.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "wp_subnet_west_2a"
  }
}

resource "aws_subnet" "wp_west_2b" {
  vpc_id            = aws_vpc.wp.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "wp_subnet_west_2b"
  }
}

resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp.id

  tags = {
    Name = "wp_igw"
  }
}

resource "aws_route_table" "wp_rt" {
  vpc_id = aws_vpc.wp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp_igw.id
  }

  tags = {
    Name = "wp_rt"
  }
}

resource "aws_main_route_table_association" "rt_as" {
  vpc_id         = aws_vpc.wp.id
  route_table_id = aws_route_table.wp_rt.id
}

resource "aws_security_group" "sg_for_ec2" {
  name        = "sg_for_ec2"
  description = "Security group for ec2 instance"
  vpc_id      = aws_vpc.wp.id

  tags = {
    Name = "sg_for_ec2"
  }
}

resource "aws_security_group" "sg_for_db" {
  name        = "sg_for_db"
  description = "Security group for db instance"
  vpc_id      = aws_vpc.wp.id

  tags = {
    Name = "sg_for_db"
  }
}

resource "aws_security_group_rule" "in_mysql_db" {
  type              = "ingress"
  description       = "mysql from all"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_for_db.id
}

resource "aws_security_group_rule" "out_all_db" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_for_db.id
}

resource "aws_security_group_rule" "in_ssh_ec2" {
  type              = "ingress"
  description       = "ssh from all"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_for_ec2.id
}

resource "aws_security_group_rule" "in_http_ec2" {
  type              = "ingress"
  description       = "ssh from all"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_for_ec2.id
}

resource "aws_security_group_rule" "out_all_ec2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg_for_ec2.id
}
