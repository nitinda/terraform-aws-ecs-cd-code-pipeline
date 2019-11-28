resource "aws_security_group" "demo_security_group_alb" {
  name_prefix = "demo-security-group-alb-"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-security-group-alb",
  ))}"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["${var.sg_cidr_blocks}"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["${var.sg_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}