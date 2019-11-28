# Glboal
variable "region" {
  description = "AWS region that will be used to create resources in."
  default     = "eu-central-1"
}

variable common_tags {
  description = "Resources Tags"
  type = "map"
  default = {
    Project      = "ECS POC"
    Owner        = "Platform Team"
    Environment  = "prod"
    BusinessUnit = "Platform Team"
  }  
}

variable "ecs_cluster_name" {
    default = "demo-ecs-cluster"  
}

variable "ecs_service_name" {
  description = "The name of the service (up to 255 letters, numbers, hyphens, and underscores)"
  default = "demo-ecs-service"
}

variable "ecs_cluster_fargate_name" {
  description = "description"
  default = "terraform-demo-ecs-cluster-fargate"
}





variable "new_aws_account_ids" {
  description = "description"
  type = "map"
  default = {
    Account-1 = "760341739473"
  }
}



# Spot

variable "override_instance_types" {
  description = "The size of instance to launch, minimum 2 types must be specified."
  type        = "list"
  default     = ["t3.xlarge", "t3.large"]
}

variable "container_name" {
  description = "description"
  default = "green-blue-ecs-example"
}


## GitHub
variable "github_token" {
  description = "GitHub API token, as extra variable"
}