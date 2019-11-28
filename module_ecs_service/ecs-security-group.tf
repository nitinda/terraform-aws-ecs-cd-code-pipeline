resource "aws_security_group" "ecs" {
  name   = "demo-ecs-servcie-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["${var.sg_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}