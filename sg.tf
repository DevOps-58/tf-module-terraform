resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}"
  description = "Allows app traffic"

  ingress {
    description = "Allows SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows APP"
    from_port   = var.port_no
    to_port     = var.port_no
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows Prometheus"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = var.prometheus_node
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# This rule is only specific to frontend 
resource "aws_security_group_rule" "nginx_exporters" {
  count             = var.name == "frontend" ? 1 : 0
  type              = "ingress"
  from_port         = 9113
  to_port           = 9113
  protocol          = "tcp"
  cidr_blocks       = var.prometheus_node
  security_group_id = aws_security_group.main.id
}

# This rule is only specific to frontend 
resource "aws_security_group_rule" "grok_exporters" {
  count             = var.name == "frontend" ? 1 : 0
  type              = "ingress"
  from_port         = 9144
  to_port           = 9144
  protocol          = "tcp"
  cidr_blocks       = var.prometheus_node
  security_group_id = aws_security_group.main.id
}
