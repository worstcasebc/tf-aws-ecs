resource "aws_ecs_cluster" "dev" {
  name = "tf-ecs-cluster"
}

resource "aws_ecs_task_definition" "service" {
  family                   = "flask-dev"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 100
  memory                   = 256
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode(
    [
      {
        "name" : "flask",
        "image" : "docker.io/worstcaseffm/flaskserver:v1",
        "cpu" : 10,
        "memory" : 256,
        "essential" : true,
        "portMappings" : [
          {
            "containerPort" : 5000
          }
        ]
      }
    ]
  )
  
  tags = {
    Environment = "dev"
    Application = "flask"
  }
}

resource "aws_ecs_service" "dev" {
  name            = "dev"
  cluster         = aws_ecs_cluster.dev.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets = [
      aws_subnet.private-subnet[0].id,
      aws_subnet.private-subnet[1].id,
      aws_subnet.private-subnet[2].id,
    ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dev.arn
    container_name   = "flask"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.http_eighty, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = {
    Environment = "dev"
    Application = "flask"
  }
}

resource "aws_cloudwatch_log_group" "flask" {
  name = "awslogs-flask-dev"

  tags = {
    Environment = "dev"
    Application = "flask"
  }
}