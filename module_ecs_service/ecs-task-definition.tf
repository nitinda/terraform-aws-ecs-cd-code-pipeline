resource "aws_ecs_task_definition" "demo_ecs_task_definition" {
  family                   = "demo-ecs-task-definition"
  container_definitions    = "${data.template_file.demo_template_file.rendered}"
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = "${var.ecs_task_execution_role_arn}"
  task_role_arn            = "${var.ecs_task_role_arn}"
  network_mode             = "bridge"

  tags = "${merge(var.common_tags, map(
    "Name", "demo-ecs-task-definition",
    "Description", "ECS Task Definition for demo",
    "ManagedBy", "Terraform"
  ))}"
}