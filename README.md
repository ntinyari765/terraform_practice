# Terraform 30 Days Challenge

Welcome to my **Terraform 30 Days Challenge** repository! This is a project where I dedicate 30 days to learning and practicing Terraform, the infrastructure as code tool by HashiCorp.

## Overview

Over the course of 30 days, I'll be working through various Terraform concepts, configurations and real-world scenarios. Each day focuses on a specific topic or task, building upon the previous ones to create a comprehensive understanding of Terraform.

## Repository Structure

The repository is organized by days, with each folder containing the Terraform configurations and resources for that specific day:

- `terraform_day3/` - Day 3 configurations
- `terraform_day4/` - Day 4 configurations
- `terraform_day4b/` - Day 4b configurations (additional practice)
- `terraform_day5/` - Day 5 configurations
- And so on...

Each day folder typically includes:
- `main.tf` - Main Terraform configuration file
- `variables.tf` - Variable definitions
- `outputs.tf` - Output definitions (where applicable)

## Prerequisites

To follow along or run these configurations, you'll need:

- [Terraform](https://www.terraform.io/downloads.html) installed (version 1.x recommended)
- An AWS account (for AWS-related resources)
- AWS CLI configured with appropriate credentials
- Basic knowledge of cloud infrastructure concepts

## Getting Started

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd terraform
   ```

2. Navigate to a specific day's folder:
   ```bash
   cd terraform_day5
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan the changes:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

**Note:** Be cautious when applying configurations, especially those that create real cloud resources, as they may incur costs.

## Learning Objectives

Through this challenge, I aim to:
- Master Terraform syntax and configuration
- Understand state management
- Learn about providers and resources
- Explore modules and workspaces
- Practice best practices for infrastructure as code

## Progress

- [x] Day 3
- [x] Day 4
- [x] Day 4b
- [x] Day 5
- [ ] Day 6 - Upcoming

This is a personal learning repository, but feel free to open issues or pull requests if you have suggestions or improvements!

## License

This project is for educational purposes. Feel free to use the code as reference for your own learning.