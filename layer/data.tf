data "aws_caller_identity" "demo_caller_identity_current" {
  provider = "aws.aws_services"
}

data "aws_caller_identity" "demo_caller_identity_current_local" {
  provider = "aws"
}

data "http" "demo_workstation_external_ip" {
  url = "http://icanhazip.com"
}

locals {
  workstation_external_cidr = "${chomp(data.http.demo_workstation_external_ip.body)}/32"
}