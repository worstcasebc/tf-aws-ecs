resource "aws_lb" "alb" {
  name = "alb"
  subnets = [
    module.vpc.public-subnet[0].id,
    module.vpc.public-subnet[1].id,
    module.vpc.public-subnet[2].id,
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
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "60"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "15"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

output "elb-public-dns" {
  value = format("http://%s/", aws_lb.alb.dns_name)
}