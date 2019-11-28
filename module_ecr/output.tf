output "ecr_repository_url" {
  value = "${aws_ecr_repository.demo_ecr_repo.repository_url}"
}

output "ecr_name" {
  value = "${aws_ecr_repository.demo_ecr_repo.name}"
}