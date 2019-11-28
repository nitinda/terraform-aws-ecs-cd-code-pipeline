resource "aws_iam_role" "demo_iam_role_code_deploy" {
  name               = "terraform-demo-iam-role-code-deploy"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_role_assumerole_code_deploy.json}"
  path               = "/service-role/"
  description        = "IAM Role for Code Deploy"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-iam-role-codedeploy",
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "demo_iam_role_policy_attachment_codedeploy_AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.demo_iam_role_code_deploy.name}"
}


resource "aws_iam_policy" "demo_iam_policy_codedeploy" {
  name        = "terraform-demo-iam-policy-codedeploy"
  policy      = "${data.aws_iam_policy_document.demo_iam_role_policy_document_code_deploy.json}"
  description = "IAM Policy for Code Deploy"
  path        = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "demo_iam_role_policy_attachment_codedeploy" {
  role       = "${aws_iam_role.demo_iam_role_code_deploy.name}"
  policy_arn = "${aws_iam_policy.demo_iam_policy_codedeploy.arn}"
}