resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "bastion-host"
    Role = "bastion"
  }
}

resource "aws_instance" "public_vm" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public[1].id
  vpc_security_group_ids      = [aws_security_group.public_vm_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "public-vm"
    Role = "public"
  }
}

resource "aws_instance" "private_vm_a" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private[0].id
  vpc_security_group_ids = [
    aws_security_group.private_vm_sg.id,
    aws_security_group.k3s_internal.id
  ]
  associate_public_ip_address = false
  key_name                    = var.key_name

  tags = {
    Name = "private-vm-a"
    Role = "k3s-server"
  }
}

resource "aws_instance" "private_vm_b" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private[1].id
  vpc_security_group_ids = [
    aws_security_group.private_vm_sg.id,
    aws_security_group.k3s_internal.id
  ]
  associate_public_ip_address = false
  key_name                    = var.key_name

  tags = {
    Name = "private-vm-b"
    Role = "k3s-agent"
  }
}
