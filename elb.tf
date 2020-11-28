resource "aws_lb" "alb" {
  name = "alb"
  subnets = [
    aws_subnet.public-subnet[0].id,
    aws_subnet.public-subnet[1].id,
    aws_subnet.public-subnet[2].id,
  ]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]

  tags = {
    Environment = "dev"
    Application = "flask"
  }
}

resource "aws_lb_listener" "http_eighty" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev.arn
  }
}

resource "aws_lb_target_group" "dev" {
  name        = "tg-alb-flask"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "2"
  }
}