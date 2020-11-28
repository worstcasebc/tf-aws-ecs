resource "aws_security_group" "elb" {
  name        = "sg-elb"
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
  name        = "sg-ecs-tasks"
  description = "allow inbound access from the ELB only"

  ingress {
    protocol  = "tcp"
    from_port = 5000
    to_port   = 5000
    #cidr_blocks     = ["0.0.0.0/0"]
    security_group_id = [aws_security_group.elb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}