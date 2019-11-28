resource "aws_codepipeline" "demo_codepipline" {
  name     = "${var.codepipline_name}"
  role_arn = "${var.code_pipeline_iam_role_arn}"

  artifact_store = "${var.artifact_store}"
  
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        OAuthToken = "${var.github_token}"
        Owner      = "nitinda"
        Repo       = "demo-ecs-green-blue-example"
        Branch     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]

      configuration {
        ProjectName = "${aws_codebuild_project.demo_code_build.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["build"]

      configuration {
        ApplicationName                = "${aws_codedeploy_app.demo_codedeploy_app.name}"
        DeploymentGroupName            = "${aws_codedeploy_deployment_group.demo_codedeploy_deployment_group.deployment_group_name}"
        TaskDefinitionTemplateArtifact = "build"
        AppSpecTemplateArtifact        = "build"
      }
    }
  }
}