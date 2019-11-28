locals {
  instance_types  = ["${data.null_data_source.null_resource_override_instance_types.*.outputs}"]
}