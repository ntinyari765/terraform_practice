# Unit tests for the webserver cluster module

variables {
  cluster_name     = "test-cluster"
  environment      = "dev"
  server_port      = 8080
  ami              = "ami-0c55b159cbfafe1f0"
  use_existing_vpc = true
  project_name     = "terraform-challenge"
  team_name        = "devops"
  alert_email      = ""
}

run "validate_asg_min_size_dev" {
  command = plan

  assert {
    condition     = aws_autoscaling_group.example.min_size == 1
    error_message = "Dev environment must have min_size of 1"
  }
}

run "validate_asg_max_size_dev" {
  command = plan

  assert {
    condition     = aws_autoscaling_group.example.max_size == 3
    error_message = "Dev environment must have max_size of 3"
  }
}

run "validate_instance_type_dev" {
  command = plan

  assert {
    condition     = aws_launch_template.example.instance_type == "t3.micro"
    error_message = "Dev environment must use t3.micro instance type"
  }
}

run "validate_monitoring_disabled_in_dev" {
  command = plan

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.high_cpu) == 0
    error_message = "CloudWatch alarm must not be created in dev environment"
  }
}

run "validate_production_instance_type" {
  command = plan

  variables {
    environment = "production"
  }

  assert {
    condition     = aws_launch_template.example.instance_type == "t3.small"
    error_message = "Production environment must use t3.small instance type"
  }
}

run "validate_monitoring_enabled_in_production" {
  command = plan

  variables {
    environment = "production"
  }

  assert {
    condition     = length(aws_cloudwatch_metric_alarm.high_cpu) == 1
    error_message = "CloudWatch alarm must be created in production environment"
  }
}

run "validate_cluster_name_in_tags" {
  command = plan

  assert {
    condition     = aws_security_group.instance.name == "test-cluster-instance"
    error_message = "Security group name must include the cluster name"
  }
}