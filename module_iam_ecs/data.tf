data "aws_region" "demo_region_current" {}

data "aws_caller_identity" "demo_caller_identity_current" {}

## Assume Role

data "aws_iam_policy_document" "demo_iam_policy_document_ecs_task_assume_role" {
  statement {
    sid    = "AllowECSTasksToAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "demo_iam_policy_document_ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "demo_iam_policy_document_ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}





data "aws_iam_policy_document" "demo_iam_policy_document_ecs_task_role" {
  statement {
    sid     = "AllowServiceToAccessSecretsFromSSM"
    effect  = "Allow"
    actions = ["ssm:GetParametersByPath"]
    resources = [
      "arn:aws:ssm:${data.aws_region.demo_region_current.name}:${data.aws_caller_identity.demo_caller_identity_current.account_id}:parameter/grafana/*",
    ]
  }
  statement {
    sid       = "AllowAccessToKMSForDecryptingSSMParameters"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${data.aws_region.demo_region_current.name}:${data.aws_caller_identity.demo_caller_identity_current.account_id}:alias/aws/ssm"]
  }
  statement {
    sid       = "AllowAccessToAssumeGrafanaRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["${formatlist("arn:aws:iam::%s:role/terraform-demo-iam-role-grafana-assume", values(var.aws_account_ids))}"]
  }
  statement {
    sid    = "DenyEverythingElse"
    effect = "Deny"
    not_actions = [
      "kms:Decrypt",
      "ssm:GetParametersByPath",
      "sts:AssumeRole",
    ]
    resources = ["*"]
  }
  statement {
    sid       = "AllowEC2"
    effect    = "Allow"
    actions   = [
      "ec2:*Volume*",
      "ec2:*Snapshot*",
      "ec2:*networkinterface*",
      "ec2:DeleteTags",
      "ec2:DescribeTags",
      "ec2:CreateTags"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "AllowKMS"
    effect    = "Allow"
    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
  statement {
    sid       = "AllowKMSCreate"
    effect    = "Allow"
    actions   = [
      "kms:CreateGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = [
        true
      ]
    }
  }
}



data "aws_iam_policy_document" "demo_iam_policy_document_ecs_task_execution_role" {
  statement {
    sid    = "AllowECRPull"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "AllowECRAuth"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid     = "AllowLogging"
    effect  = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
  
  statement {
    sid     = "AllowEC2"
    effect  = "Allow"
    actions = [
      "ec2:*Volume*",
      "ec2:*Snapshot*",
      "ec2:*networkinterface*",
      "ec2:DeleteTags",
      "ec2:DescribeTags",
      "ec2:CreateTags"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "AllowIAMPassRole"
    effect  = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}