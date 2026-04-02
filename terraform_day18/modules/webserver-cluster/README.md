# Webserver Cluster Module

A production-grade, environment-aware Terraform module that deploys an auto-scaling 
webserver cluster on AWS. Supports dev, staging and production environments with 
conditional resource creation and consistent tagging.

## Usage
```hcl
module "webserver_cluster" {
  source = "../modules/webserver-cluster"

  environment  = "production"
  cluster_name = "my-cluster"
  server_port  = 8080
  ami          = "ami-xxxxxxxxxxxxxxxxx"
  project_name = "my-project"
  team_name    = "devops"
  alert_email  = "alerts@mycompany.com"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| environment | Deployment environment: dev, staging, or production | string | — | yes |
| cluster_name | Name for all resources in the cluster | string | — | yes |
| server_port | Port the server will use for HTTP requests | number | 8080 | no |
| ami | AMI ID for EC2 instances | string | — | yes |
| use_existing_vpc | Use existing default VPC or create new one | bool | true | no |
| project_name | Project these resources belong to | string | terraform-challenge | no |
| team_name | Team that owns these resources | string | devops | no |
| alert_email | Email for CloudWatch alarm notifications | string | "" | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name | Name of the deployed cluster |
| instance_type | EC2 instance type in use |
| min_size | Minimum number of instances |
| max_size | Maximum number of instances |
| alarm_arn | ARN of CloudWatch alarm (null if monitoring disabled) |

## Environment Differences

| Setting | dev | staging | production |
|---------|-----|---------|------------|
| Instance type | t3.micro | t3.micro | t3.small |
| Min instances | 1 | 1 | 3 |
| Max instances | 3 | 3 | 10 |
| CloudWatch alarm | ❌ | ❌ | ✅ |
| SNS alerts | ❌ | ❌ | ✅ |

## Production Checklist

- ✅ Consistent tagging on all resources
- ✅ prevent_destroy on critical resources  
- ✅ create_before_destroy on launch template
- ✅ Input validation on all variables
- ✅ CloudWatch alarms wired to SNS (production only)
- ✅ Environment-aware conditional resource creation
- ✅ No hardcoded values

## Notes

- Destroying production infrastructure requires temporarily removing prevent_destroy
- Alert email must be confirmed in AWS after first apply
- AMI IDs are region-specific — always fetch the latest for your region