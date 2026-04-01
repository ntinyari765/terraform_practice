# Webserver Cluster Manual Test Plan

## Category 1 — Provisioning Verification
- [ ] `terraform init` completes without errors
- [ ] `terraform validate` passes cleanly
- [ ] `terraform plan` shows expected number of resources
- [ ] `terraform apply` completes without errors

## Category 2 — Resource Correctness
- [ ] All resources visible in AWS Console
- [ ] Resource names match variables
- [ ] Tags present on all resources: Environment, ManagedBy, Project, Owner
- [ ] Security group rules match definition — port 8080 open, no extra rules
- [ ] Correct instance type for environment (t3.micro for dev)

## Category 3 — Functional Verification
- [ ] EC2 instances are running and healthy
- [ ] ASG shows correct min/max size
- [ ] Security group attached to instances

## Category 4 — State Consistency
- [ ] `terraform plan` returns "No changes" after fresh apply
- [ ] State file reflects actual AWS resources

## Category 5 — Regression Check
- [ ] Small change to config shows only that change in plan
- [ ] Plan is clean after applying the small change

## Category 6 — Cleanup Verification
- [ ] `terraform destroy` completes cleanly
- [ ] No orphaned resources in AWS Console
- [ ] AWS CLI confirms empty results