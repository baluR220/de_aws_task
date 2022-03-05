output "ec2_public_ip" {
  description = "Public IP of ec2 instance"
  value       = aws_instance.wp_ec2.public_ip
}

output "efs_dns_name" {
  description = "DNS name of efs"
  value       = aws_efs_file_system.wp.dns_name
}

output "alb_dns_name" {
  description = "DNS name of alb"
  value       = aws_lb.wp.dns_name
}
