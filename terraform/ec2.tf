data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "local_file" "local_pub_key" {
  filename = var.local_pub_key_path
}

data "local_file" "ec2_pub_key" {
  filename = "${path.module}/ec2_key.pub"

  depends_on = [aws_instance.wp_ec2]
}

resource "aws_key_pair" "local_key" {
  key_name   = "local_key"
  public_key = data.local_file.local_pub_key.content
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = data.local_file.ec2_pub_key.content
}

resource "aws_instance" "wp_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.local_key.id
  subnet_id                   = aws_subnet.wp_west_2a.id
  vpc_security_group_ids      = [aws_security_group.sg_for_ec2.id]
  depends_on                  = [aws_internet_gateway.wp_igw]
  associate_public_ip_address = true
  private_ip                  = "192.168.1.10"

  tags = {
    Name = "wp_ec2"
  }

  provisioner "local-exec" {
    command = "${path.module}/local_script.sh ${aws_instance.wp_ec2.public_ip} ${path.module} ${aws_db_instance.wp.endpoint}"
  }
}

resource "aws_instance" "wp_s1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_key.id
  subnet_id              = aws_subnet.wp_west_2a.id
  vpc_security_group_ids = [aws_security_group.sg_for_serv.id]
  private_ip             = "192.168.1.100"
  associate_public_ip_address = true

  tags = {
    Name = "wp_s1"
  }
}

resource "aws_instance" "wp_s2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ec2_key.id
  subnet_id              = aws_subnet.wp_west_2b.id
  vpc_security_group_ids = [aws_security_group.sg_for_serv.id]
  private_ip             = "192.168.2.100"
  associate_public_ip_address = true

  tags = {
    Name = "wp_s2"
  }
}
