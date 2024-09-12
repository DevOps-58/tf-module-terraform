resource "aws_instance" "main" {
  ami                    = data.aws_ami.main.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "${var.name}-${var.env}"
  }
}

# Creates DNS Record
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.id
  name    = "${var.name}-${var.env}.expense.internal"
  type    = "A"
  ttl     = 10
  records = [aws_instance.main.private_ip]
}

resource "null_resource" "app" {
  depends_on = [aws_route53_record.main, aws_instance.main]

  triggers = {
    always_run = true
  }
  connection { # Enables connection to the remote host
    host     = aws_instance.main.private_ip
    user     = "ec2-user"
    password = "DevOps321"
    type     = "ssh"
  }
  provisioner "remote-exec" { # This let's the execution to happen on the remote node
    inline = [
      "pip3.11 install hvac",
      "ansible-pull -U https://github.com/DevOps-58/ansible.git  -e COMPONENT=${var.name} -e ENV=${var.env} -e pwd=${var.pwd} expense-pull.yml"
    ]
  }
}

