output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_dns_name" {
  description = "DNS name assocaited with EC2 instance"
  value       = "http://${aws_instance.app_server.public_dns}:8080"
}