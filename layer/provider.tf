provider "aws" {
    alias   = "aws_services"
    region  = "${var.region}"
}

provider "aws" {
    region  = "${var.region}"
}