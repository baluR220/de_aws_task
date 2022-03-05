resource "aws_lb" "wp" {
  name               = "wp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_for_alb.id]
  subnets            = [aws_subnet.wp_west_2a.id, aws_subnet.wp_west_2b.id]

  tags = {
    Name = "wp-alb"
  }
}

resource "aws_lb_listener" "wp" {
  load_balancer_arn = aws_lb.wp.arn 
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.wp.arn
  }
}

resource "aws_lb_target_group" "wp" {
  name      = "wp-serv-tg"
  port      = 80
  protocol  = "HTTP"
  vpc_id    = aws_vpc.wp.id

  health_check {
    enabled = true
    matcher = "200-399"
    path    = "/"
  }
}

resource "aws_lb_target_group_attachment" "at_s1" {
  target_group_arn  = aws_lb_target_group.wp.arn
  target_id         = aws_instance.wp_s1.id
  port              = 80
}

resource "aws_lb_target_group_attachment" "at_s2" {
  target_group_arn  = aws_lb_target_group.wp.arn
  target_id         = aws_instance.wp_s2.id
  port              = 80
}
