# #######################  IAM

module "iam_ecs" {
  source  = "../module_iam_ecs"

  providers = {
    "aws"  = "aws.aws_services"
  }

  common_tags     = "${var.common_tags}"
  aws_account_ids = {
    Accounts-1 = "${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  }
}

module "iam_codedeploy" {
  source  = "../module_iam_codedeploy"

  providers = {
    "aws"  = "aws.aws_services"
  }

  # Tags
  common_tags = "${var.common_tags}"

  # ARN
  ecs_task_execution_role_arn = "${module.iam_ecs.ecs_task_execution_role_arn}"
  ecs_task_role_arn           = "${module.iam_ecs.ecs_task_role_arn}"
}


######################### ECR
module "ecr_demo" {
  source  = "../module_ecr"

  providers = {
    "aws"  = "aws.aws_services"
  }

  # Tags
  common_tags = "${var.common_tags}"

  # ECR
  repository_name = "${var.container_name}"
}



########################### S3

module "s3" {
  source = "git::https://github.com/nitinda/terraform-module-aws-s3.git?ref=terraform-11"

  providers = {
    aws = "aws.aws_services"
  }

  # Tags
  common_tags = "${var.common_tags}"

  # S3
  bucket_name = "demo-s3-${data.aws_caller_identity.demo_caller_identity_current.account_id}"
  lifecycle_rule = [{
    id      = "log_expiration_lifecycle_rule"
    prefix  = ""
    enabled = true
    # noncurrent_version_transition = [{
    #   days          = "${var.noncurrent_version_transition}"
    #   storage_class = "STANDARD_IA"
    # }]
    # noncurrent_version_transition = [{
    #   days          = 60
    #   storage_class = "GLACIER"
    # }]
    expiration = [{
      expired_object_delete_marker = true
    }]
    # noncurrent_version_expiration = [{
    #   days = 90
    # }]
    abort_incomplete_multipart_upload_days = 1 
  }]

  server_side_encryption_configuration = [{
    rule = [{
      apply_server_side_encryption_by_default = [{
        sse_algorithm = "AES256"
      }]
    }]
  }]

  bucket_public_access_block = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}


######################### Network

module "network" {
  source = "git::https://github.com/nitinda/terraform-module-aws-network.git?ref=master"

  providers = {
    aws = "aws.aws_services"
  }

  cidr_block           = "10.30.0.0/16"
  enable_dns_hostnames = true

  # Subnet
  public_subnets_cidr  = ["10.30.1.0/24", "10.30.2.0/24"]
  private_subnets_cidr = ["10.30.3.0/24", "10.30.4.0/24"]
  db_subnets_cidr      = ["10.30.5.0/24", "10.30.6.0/24"]
  availability_zones   = ["eu-central-1a", "eu-central-1b"]

  # Tags
  common_tags = "${var.common_tags}"
}



########################### ALB

module "alb" {
  source = "../module_alb"

  providers = {
    aws = "aws.aws_services"
  }

  # Tags
  common_tags = "${var.common_tags}"

  # ALB
  lb_subnets     = ["${module.network.public_subnet_ids}"]
  vpc_id         = "${module.network.vpc_id}"
  sg_cidr_blocks = ["${local.workstation_external_cidr}"]
}


########################### ECS on EC2

module "ecs_cluster_ec2" {
  source  = "../module_ecs_cluster_ec2"

  providers = {
    "aws"  = "aws.aws_services"
  }

  #Tags
  common_tags = "${var.common_tags}"


  # ECS Cluster
  ecs_cluster_name          = "${var.ecs_cluster_name}"
  vpc_id                    = "${module.network.vpc_id}"
  web_subnet_ids            = "${module.network.web_subnet_ids}"
  public_subnet_ids         = "${module.network.public_subnet_ids}"
  public_subnet_cidr_blocks = "${module.network.public_subnet_cidr_blocks}"
  ecs_instance_profile_name = "${module.iam_ecs.ecs_instance_profile_name}"
  override_instance_types   = "${var.override_instance_types}"
}


########################### ECS Service


module "ecs_service" {
  source  = "../module_ecs_service"

  providers = {
    "aws"  = "aws.aws_services"
  }

  #Tags
  common_tags = "${var.common_tags}"

  # ECS
  ecs_cluster_name = "${var.ecs_cluster_name}"
  ecs_service_name = "${var.ecs_service_name}"
  alb_target_group_arn = "${module.alb.alb_target_group_arn_green}"
  ecs_task_role_arn = "${module.iam_ecs.ecs_task_role_arn}"
  ecs_task_execution_role_arn = "${module.iam_ecs.ecs_task_execution_role_arn}"
  sg_cidr_blocks = ["${local.workstation_external_cidr}","${module.network.public_subnet_cidr_blocks}", "${module.network.web_subnet_cidr_blocks}"]
  vpc_id = "${module.network.vpc_id}"
  container_name = "${var.container_name}"
  container_image = "${module.ecr_demo.ecr_repository_url}:latest"
}


########################### Code

module "code" {
  source  = "../module_code"

  providers = {
    "aws"  = "aws.aws_services"
  }

  #Tags
  common_tags = "${var.common_tags}"

  # ECS Code Build
  codebuild_project_name = "demo-ecs-blue-green-codebuild-project"
  code_build_iam_role_arn = "${module.iam_codedeploy.code_build_iam_role_arn}"
  container_name = "${var.container_name}"
  ecr_repository_url = "${module.ecr_demo.ecr_repository_url}"
  ecs_task_definition_family = "${module.ecs_service.ecs_task_definition_family}"
  # We cant user references in the following block
  environment_variables = [
    {
      name = "CONTAINER_NAME"
      value = "${var.container_name}"
    },
    {
      name = "REPOSITORY_URI"
      value = "074912011001.dkr.ecr.eu-central-1.amazonaws.com/demo-repo/green-blue-ecs-example"
    },
    {
      name = "TASK_DEFINITION"
      value = "arn:aws:ecs:eu-central-1:074912011001:task-definition/demo-ecs-task-definition"
    },
    {
      name = "TASK_DEFINITION_FAMILY"
      value = "demo-ecs-task-definition"
    },
    {
      name = "SUBNET_1"
      value = "subnet-08488ded1b587c99b"                        
    },
    {
      name = "SUBNET_2"
      value = "subnet-0d63a2acc84660852"
    },
  ]
  logs_config = [{
      cloudwatch_logs = [{
        status = "ENABLED"
      }]
      s3_logs = [{
        status = "DISABLED"
      }]
  }]

  # ECS Code Application
  codedeploy_app_name = "demo-example-deploy"

  # ECS Code Deployment
  deployment_group_name = "demo-example-deploy"
  code_deployment_iam_role_arn = "${module.iam_codedeploy.code_deploy_iam_role_arn}"
  lb_listener_arns = ["${module.alb.lb_listener_arn}"]
  lb_target_group_name = "${module.alb.alb_target_group_name}"
  test_listener_arns = ["${module.alb.test_lb_listener_arns}"]

  auto_rollback_configuration = [{
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }]

  blue_green_deployment_config = [{
    deployment_ready_option = [{
      action_on_timeout = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }]
    terminate_blue_instances_on_deployment_success = [{
      action = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }]
  }]

  deployment_style = [{
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }]

  ecs_service = [{
    cluster_name = "${var.ecs_cluster_name}"
    service_name = "${var.ecs_service_name}"
  }]

  # ECS Code Pipeline
  codepipline_name = "demo-code-pipeline"
  code_pipeline_iam_role_arn = "${module.iam_codedeploy.code_pipeline_iam_role_arn}"
  artifact_store = [
    {
      location = "demo-s3-074912011001"
      type     = "S3"
    }
  ]
  github_token = "${var.github_token}"   ### Git Hub Token
}