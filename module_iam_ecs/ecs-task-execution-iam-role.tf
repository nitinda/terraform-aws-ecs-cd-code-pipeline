resource "aws_iam_role" "demo_iam_role_ecs_task_execution_role" {
  name               = "terraform-demo-iam-role-ecs-task-execution-role"
  path               = "/service-role/"
  assume_role_policy = "${data.aws_iam_policy_document.demo_iam_policy_document_ecs_task_assume_role.json}"
  description        = "IAM Role for ECS Task Execution"

  tags = "${merge(var.common_tags, map(
    "Name", "terraform-demo-iam-role-ecs-task-execution-role",
  ))}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_role_policy_attachment" "demo_iam_role_policy_attachment_ecs_task_execution_role_AmazonECSTaskExecutionRolePolicy" {
  role       = "${aws_iam_role.demo_iam_role_ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "demo_iam_role_inline_policy_ecs_task_execution_role" {
  name = "terraform-demo-role-inline-policy-ecs-task-execution-role"
  role   = "${aws_iam_role.demo_iam_role_ecs_task_execution_role.name}"
  policy = "${data.aws_iam_policy_document.demo_iam_policy_document_ecs_task_execution_role.json}"
}