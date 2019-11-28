
variable "common_tags" {
    description = ""
    type = "map"
}

variable "lb_subnets" {
    description = ""
    type = "list"
}

variable "sg_cidr_blocks" {
    description = ""
    type = "list"
}

variable "vpc_id" {
    description = ""
}