resource "aws_iam_role" "demo_iam_role_code_build" {
  name               = "terraform-demo-iam-role-code-build"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_role_assumerole_code_buid.json}"
  description        = "IAM Role for Code Build Service"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-iam-role-code-build",
  ))}"
}


resource "aws_iam_role_policy" "demo_iam_role_policy_code_build" {
  name   = "terraform-demo-iam-role-policy-code-build-inline"
  role   = "${aws_iam_role.demo_iam_role_code_build.name}"
  policy = "${data.aws_iam_policy_document.demo_iam_role_policy_document_code_build.json}"
}