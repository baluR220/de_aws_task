output "ec2_public_ip" {
  description = "Public IP of ec2 instance"
  value       = aws_instance.wp_ec2.public_ip
}

output "mysql_endpoint_name" {
  description = "Endpoint name of db instance"
  value       = aws_db_instance.wp.endpoint
}

output "efs_dns_name" {
  description = "DNS name of efs"
  value       = aws_efs_file_system.wp.dns_name
}
