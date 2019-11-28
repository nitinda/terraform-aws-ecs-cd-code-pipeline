resource "aws_codedeploy_deployment_group" "demo_codedeploy_deployment_group" {
  app_name               = "${aws_codedeploy_app.demo_codedeploy_app.name}"
  deployment_group_name  = "${var.deployment_group_name}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = "${var.code_deployment_iam_role_arn}"

  auto_rollback_configuration = "${var.auto_rollback_configuration}"
  blue_green_deployment_config = "${var.blue_green_deployment_config}"
  deployment_style = "${var.deployment_style}"
  ecs_service = "${var.ecs_service}"

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${var.lb_listener_arns}"]
      }

      target_group {
        name = "${var.lb_target_group_name[0]}"
      }

      target_group {
        name = "${var.lb_target_group_name[1]}"
      }

      test_traffic_route {
        listener_arns = ["${var.test_listener_arns}"]
      }
    }
  }

  # lifecycle {
  #   ignore_changes = ["blue_green_deployment_config"]
  # }
}