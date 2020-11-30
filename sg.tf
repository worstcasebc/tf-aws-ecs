resource "aws_security_group" "elb" {
  vpc_id      = module.vpc.vpc_id
  name        = "elb-sg"
  description = "controls access to the ELB"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  vpc_id      = module.vpc.vpc_id
  name        = "ecs-tasks-sg"
  description = "allow inbound access from the ELB only"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "inbound-eighty" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb.id
  security_group_id        = aws_security_group.ecs_tasks.id
}

resource "aws_security_group_rule" "inbound-fivethousand" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.elb.id
  security_group_id        = aws_security_group.ecs_tasks.id
}

resource "aws_security_group_rule" "inbound-twentytwo" {
  count                    = var.bastion_host ? 1 : 0
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpc.bastion_id
  security_group_id        = aws_security_group.ecs_tasks.id
}