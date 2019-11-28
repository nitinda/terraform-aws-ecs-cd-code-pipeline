output "alb_arn" {
  value = "${aws_lb.demo_alb.arn}"
}

output "alb_id" {
  value = "${aws_lb.demo_alb.id}"
}

output "alb_dns_name" {
  value = "${aws_lb.demo_alb.dns_name}"
}

output "alb_target_group_arn" {
  value = "${aws_lb_target_group.demo_target_group.*.arn}"
}

output "alb_target_group_name" {
  value = "${aws_lb_target_group.demo_target_group.*.name}"
}

output "alb_target_group_arn_green" {
  value = "${aws_lb_target_group.demo_target_group.0.arn}"
}

output "lb_listener_arn" {
  value = "${aws_lb_listener.demo_listener.arn}"
}

output "test_lb_listener_arns" {
  value = "${aws_lb_listener.demo_test_listener.arn}"
}
