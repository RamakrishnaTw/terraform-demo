resource "aws_instance" "R-ec2Instance" {
  ami           = var.ami
  instance_type = var.instance_type


  subnet_id = element(var.ec2_subnet_id, 0)


  vpc_security_group_ids = [var.ec2_sg]

  # the public SSH key
  key_name = aws_key_pair.Rkeypair.key_name

  tags = {
    Name = "R-ec2Instance"
  }
}

resource "aws_key_pair" "Rkeypair" {
  key_name   = var.keypair_name
  public_key = "${file("${path.cwd}/../${var.pb_key}")}"
}
