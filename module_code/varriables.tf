# Code Build
variable "codebuild_project_name" {
  description = "The projects name."
}

variable "code_build_iam_role_arn" {
  description = "description"
}

variable "ecr_repository_url" {
  description = "description"
}

variable "ecs_task_definition_family" {
  description = "description"
}

variable "container_name" {
  description = "description"
}

variable "environment_variables" {
  type = "list"
  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build."
}

variable "logs_config" {
  description = "Configuration for the builds to store log data to CloudWatch or S3."
  type = "list"
}

variable "deployment_style" {
  description = "Configuration block of the type of deployment, either in-place or blue/green"
  type = "list"
}

variable "blue_green_deployment_config" {
  description = "Configuration block of the blue/green deployment options for a deployment group"
  type = "list"
}

variable "auto_rollback_configuration" {
  description = "Configuration block of the automatic rollback configuration associated with the deployment group"
  type = "list"
}


# Code App
variable "codedeploy_app_name" {
  description = "The application's name"
}

# Code Deployment Group
variable "deployment_group_name" {
  description = "The name of the deployment group."
}

variable "code_deployment_iam_role_arn" {
  description = "iam role for code deployment"
}

variable "lb_listener_arns" {
  description = "List of Amazon Resource Names (ARNs) of the load balancer listeners."
  type        = "list"
}

variable "test_listener_arns" {
  description = "Configuration block for the test traffic route"
  type        = "list"
}

variable "lb_target_group_name" {
  description = "Name of the green and blue target group."
  type        = "list"
}

variable "ecs_service" {
  description = "Each ecs_service configuration block"
  type = "list"
}

# variable "auto_rollback_events" {
#   description = "You can configure a deployment group to automatically rollback when a deployment fails"
#   type = "list"
# }

# Code Pipline
variable "codepipline_name" {
  description = "The name of the pipeline."
}

variable "code_pipeline_iam_role_arn" {
  description = "description"
}

variable "artifact_store" {
  description = "An artifact_store block."
  type = "list"
}

variable "github_token" {
  description = "description"
}


## Tags
variable "common_tags" {
  description = "description"
  type = "map"
}