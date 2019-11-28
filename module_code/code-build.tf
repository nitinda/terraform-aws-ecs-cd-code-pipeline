resource "aws_codebuild_project" "demo_code_build" {
  name         = "${var.codebuild_project_name}"
  description  = "Codebuild for the ECS Green/Blue Example app"
  service_role = "${var.code_build_iam_role_arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type         = "BUILD_GENERAL1_SMALL"
    image                = "aws/codebuild/docker:18.09.0"
    type                 = "LINUX_CONTAINER"
    privileged_mode      = true
    environment_variable = "${var.environment_variables}"
  }

  source {
    type = "CODEPIPELINE"
  }

  tags = "${var.common_tags}"

  logs_config = "${var.logs_config}"
}