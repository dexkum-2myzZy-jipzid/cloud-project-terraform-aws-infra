# Cloud-Native Web App AWS Infrastructure (Terraform)

This project uses Terraform to automate the deployment of cloud-native web app infrastructure on AWS, supporting automated testing, monitoring, load balancing, and DNS configuration.

## Key Features

- **VPC & Subnets**: Automatically creates VPC, public/private subnets, route tables, and Internet Gateway.
- **Security Groups**: Fine-grained security groups for web app, database, NLB, and VPC endpoints.
- **EC2 Instances**: Automated provisioning of web app and MySQL database EC2 instances, with user data initialization and IAM role attachment.
- **Load Balancing**: Integrated AWS Network Load Balancer for multi-instance traffic distribution and health checks.
- **DNS Setup**: Route 53 automatically creates API domain CNAME records for easy access.
- **CloudWatch Integration**: CloudWatch monitoring and logging for EC2 and VPC endpoints.
- **CI/CD & Automated Testing**: GitHub Actions for Terraform deployment, Python/Go automated tests, and one-click teardown.
- **Iterative Assignments**: Supports multiple assignment phases, gradually enhancing infrastructure and automation.

## Project Structure

- `*.tf`: Terraform configuration files for AWS resources.
- `grader/`: Automated grading and test scripts (Go/Python).
- `tests/`: Integration test cases (pytest).
- `.github/workflows/`: GitHub Actions CI/CD workflows.
- `assignment*.txt`: Assignment instructions and parameters for each phase.

## Development Timeline

- **Infra Bootstrapping**: Initial automation for VPC, subnets, EC2, and basic security groups.
- **Database & Security Enhancements**: Added DB instance, private subnets, and refined security group rules.
- **Automated Testing Integration**: Added null_resource and GitHub Actions for health checks and integration tests.
- **Monitoring & Logging**: Integrated CloudWatch and VPC Endpoints for better observability.
- **DNS & Load Balancing**: Route 53 and NLB for highly available API domain and traffic distribution.
- **Assignment Grading**: Automated grading scripts for streamlined classroom submissions.

## Quick Start

1. Configure `terraform.tfvars` with your AMI ID, DB credentials, etc.
2. Initialize and deploy:
   ```sh
   terraform init
   terraform apply
   ```
3. Check the output for your WebApp public IP or API domain and test access.
4. Run integration tests:
   ```sh
   cd tests
   pip install -r requirements.txt
   pytest
   ```
5. Tear down resources:
   ```sh
   terraform destroy
   ```

## Contributors

- [Liang (Mario) Chen](mailto:liang.chen829@gmail.com)

---

For detailed configuration and assignment instructions, see the assignment\*.txt files and code comments.
