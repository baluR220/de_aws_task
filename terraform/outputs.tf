output "ec2_public_ip" {
  description = "Public IP of ec2 instance"
  value       = aws_instance.wp_ec2.public_ip
}

output "alb_dns_name" {
  description = "DNS name of alb"
  value       = aws_lb.wp.dns_name
}
