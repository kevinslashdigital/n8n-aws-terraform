# n8n Application URL
# output "n8n_url" {
#   description = "URL to access n8n application"
#   value       = module.n8n.n8n_url
# }

# # Load Balancer Information
# output "load_balancer_dns_name" {
#   description = "DNS name of the load balancer"
#   value       = module.n8n.load_balancer_dns_name
# }

# output "load_balancer_zone_id" {
#   description = "Zone ID of the load balancer (for Route53 alias records)"
#   value       = module.n8n.load_balancer_zone_id
# }

# # Database Information
# output "database_endpoint" {
#   description = "Database endpoint"
#   value       = module.n8n.db_endpoint
#   sensitive   = true
# }

# # VPC Information
# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = module.n8n.vpc_id
# }

# output "public_subnet_ids" {
#   description = "IDs of the public subnets"
#   value       = module.n8n.public_subnet_ids
# }

# output "private_subnet_ids" {
#   description = "IDs of the private subnets"
#   value       = module.n8n.private_subnet_ids
# }

# # ECS Information
# output "ecs_cluster_name" {
#   description = "Name of the ECS cluster"
#   value       = module.n8n.ecs_cluster_id
# }

# output "ecs_service_name" {
#   description = "Name of the ECS service"
#   value       = module.n8n.ecs_service_name
# }

# # CloudWatch Logs
# output "log_group_name" {
#   description = "CloudWatch log group name"
#   value       = module.n8n.log_group_name
# }
