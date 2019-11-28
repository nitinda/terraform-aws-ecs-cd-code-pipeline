resource "aws_ecs_service" "demo_ecs_service" {
  name            = "${var.ecs_service_name}"
  task_definition = "${aws_ecs_task_definition.demo_ecs_task_definition.id}"
  cluster         = "${var.ecs_cluster_name}"

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_name   = "${var.container_name}"
    container_port   = 80
  }

  launch_type   = "EC2"
  desired_count = 1

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [
      "task_definition",
      "load_balancer",
    ]
  }
}