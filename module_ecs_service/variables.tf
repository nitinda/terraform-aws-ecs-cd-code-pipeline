# ECS Service
variable "ecs_cluster_name" {
  description = "ARN of an ECS cluster"
}

variable "alb_target_group_arn" {
  description = "The ARN of the Load Balancer target group to associate with the service."
}

variable "ecs_service_name" {
  description = "The name of the service (up to 255 letters, numbers, hyphens, and underscores)"
}


# ECS Task
variable "ecs_task_execution_role_arn" {
  description = "description"
}

variable "ecs_task_role_arn" {
  description = "description"
}

variable "sg_cidr_blocks" {
  description = "description"
  type = "list"
}

variable "vpc_id" {
  description = "description"
}

# Tags
variable "common_tags" {
    description = ""
    type = "map"
}

variable "container_name" {
  description = "description"
}

variable "container_image" {
  description = "description"
}