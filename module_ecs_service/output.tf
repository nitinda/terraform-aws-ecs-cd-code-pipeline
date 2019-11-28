# ECS Service
output "ecs_service_name" {
  value = "${aws_ecs_service.demo_ecs_service.name}"
}

# ECS Task
output "ecs_task_definition_arn" {
  value = "${aws_ecs_task_definition.demo_ecs_task_definition.arn}"
}

output "ecs_task_definition_family" {
  value = "${aws_ecs_task_definition.demo_ecs_task_definition.family}"
}