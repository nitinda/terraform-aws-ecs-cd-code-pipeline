resource "aws_ecr_repository" "demo_ecr_repo" {
  name = "demo-repo/${var.repository_name}"
  tags = "${var.common_tags}"
}