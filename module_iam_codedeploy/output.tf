output "code_deploy_iam_role_arn" {
  value = "${aws_iam_role.demo_iam_role_code_deploy.arn}"
}

output "code_build_iam_role_arn" {
  value = "${aws_iam_role.demo_iam_role_code_build.arn}"
}

output "code_pipeline_iam_role_arn" {
  value = "${aws_iam_role.demo_iam_role_code_pipeline.arn}"
}