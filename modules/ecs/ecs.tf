# ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
  
    setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


# ECS Task Definition
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_definition_family
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "2048"
  memory                  = "2048"   
  execution_role_arn      = var.task_execution_role_arn
  task_role_arn           = var.task_role_arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture       = "X86_64"
  }


  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_url
      cpu       = 1024
      memory    = 2048
      essential = true

      environment = [
        {
          name  = "EMAIL_HOST_USER",
          value = "shulammite.odde@cognetiks.com"
        },
        {
          name  = "EMAIL_HOST_PASSWORD",
          value = "kwsgnflcdikqxmpc"
        },
        {
          name  = "DEFAULT_FROM_EMAIL",
          value = "shulammite.odde@cognetiks.com"
        }
      ]
      logConfiguration = {  
        logDriver = "awslogs"
        options = {
          "awslogs-create-group": "true",
          "awslogs-group"         = "/ecs/3line-cluster"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 8000
          hostPort     = 8000
          protocol     = "tcp"
        }
      ]
    }
  ])
  lifecycle {
  create_before_destroy = true
  ignore_changes = all 
}
}

resource "aws_ecs_service" "service" {
  name                              = var.service_name
  cluster                           = aws_ecs_cluster.this.id
  task_definition                   = aws_ecs_task_definition.this.arn
  health_check_grace_period_seconds = 300
  launch_type                       = "FARGATE"
  desired_count                     = 1

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = 8000
  }

  network_configuration {
    subnets          = var.subnets  
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

    lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_appautoscaling_target" "this" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory" {
  name               = "3line_memory_autoscaling_policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "3line_cpu_autoscaling_policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
}


resource "aws_security_group" "ecs" {  # Changed name from 'alb' to 'ecs' to be more accurate
  name        = "${var.ecs_cluster_name}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]  # Allow traffic from ALB
  }
   ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]  # Allow traffic from ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

