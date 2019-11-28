resource "aws_codedeploy_app" "demo_codedeploy_app" {
  compute_platform = "ECS"
  name             = "${var.codedeploy_app_name}"
}