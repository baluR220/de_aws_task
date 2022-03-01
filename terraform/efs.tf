resource "aws_efs_file_system" "wp" {
  creation_token = "wp-efs"

  tags = {
    Name = "wp-efs"
  }
}

resource "aws_efs_mount_target" "efs_target_a" {
  file_system_id  = aws_efs_file_system.wp.id
  subnet_id       = aws_subnet.wp_west_2a.id
  ip_address      = "192.168.1.20"
  security_groups = [aws_security_group.sg_for_efs.id]
}

resource "aws_efs_mount_target" "efs_target_b" {
  file_system_id  = aws_efs_file_system.wp.id
  subnet_id       = aws_subnet.wp_west_2b.id
  ip_address      = "192.168.2.20"
  security_groups = [aws_security_group.sg_for_efs.id]
}
