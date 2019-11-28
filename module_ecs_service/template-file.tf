
data "template_file" "demo_template_file" {
  template = "${file("${path.module}/task-definitions/ecs-task-definition.json")}"

  vars {
    container_name  = "${var.container_name}"
    container_image = "${var.container_image}"
  }
}