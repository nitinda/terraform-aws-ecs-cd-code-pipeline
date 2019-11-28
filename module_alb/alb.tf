resource "aws_lb" "demo_alb" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.demo_security_group_alb.id}"]
  subnets            = ["${var.lb_subnets}"]

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-alb",
  ))}"
}

resource "aws_lb_target_group" "demo_target_group" {
  count = "${length(local.target_groups)}"

  name = "demo-tg-${
    element(local.target_groups, count.index)
  }"

  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  target_type          = "instance"
  deregistration_delay = 1

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "5"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "3"
  }
  depends_on = ["aws_lb.demo_alb"]
}

resource "aws_lb_listener" "demo_listener" {
  load_balancer_arn = "${aws_lb.demo_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.demo_target_group.0.arn}"
  }

  lifecycle {
    ignore_changes = [
      "default_action.0.target_group_arn",
      "action.0.target_group_arn",
    ]
  }
}

resource "aws_lb_listener_rule" "demo_listener_rule" {
  listener_arn = "${aws_lb_listener.demo_listener.arn}"

  "action" {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.demo_target_group.0.arn}"
  }

  "condition" {
    field  = "path-pattern"
    values = ["/*"]
  }
}

resource "aws_lb_listener" "demo_test_listener" {
  load_balancer_arn = "${aws_lb.demo_alb.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.demo_target_group.0.arn}"
  }

  lifecycle {
    ignore_changes = [
      "default_action.0.target_group_arn",
      "action.0.target_group_arn",
    ]
  }
}