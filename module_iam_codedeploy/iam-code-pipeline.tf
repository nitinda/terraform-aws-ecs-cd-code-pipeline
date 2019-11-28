resource "aws_iam_role" "demo_iam_role_code_pipeline" {
  name               = "terraform-demo-iam-role-code-pipeline"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_role_assumerole_code_pipeline.json}"
  description        = "IAM Role for Code Pipeline"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-iam-role-code-pipeline",
  ))}"
}

resource "aws_iam_role_policy" "demo_iam_role_policy_code_pipeline" {
  name   = "terraform-demo-iam-role-policy-code-pipeline-inline"
  role   = "${aws_iam_role.demo_iam_role_code_pipeline.name}"
  policy = "${data.aws_iam_policy_document.demo_iam_role_policy_document_code_pipline.json}"
}