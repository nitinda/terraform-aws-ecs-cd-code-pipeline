output "nginx_alb" {
  value = "http://${module.alb.alb_dns_name}"
}
