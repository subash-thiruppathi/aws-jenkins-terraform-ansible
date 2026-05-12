# Project Overview
This project automates the provisioning and configuration of a web server on AWS using **Terraform** for infrastructure and **Ansible** for configuration management. It includes a Jenkins pipeline for continuous delivery.

## Architecture
- **Infrastructure (Terraform):** 
  - Provider: AWS (region: `ap-south-1`).
  - Resources: EC2 instance (`t2.micro`), Security Group (ports 80 and 22), and SSH Key Pair.
  - Output: Public IP of the provisioned server.
- **Configuration (Ansible):**
  - Installs and starts Apache (`httpd`).
  - Deploys a custom `index.html`.
- **Orchestration (Jenkins):**
  - A declarative pipeline that initializes Terraform, provisions resources, and triggers the Ansible playbook.

## Key Files
- `main.tf`: Terraform configuration for AWS resources.
- `playbook.yaml`: Ansible playbook for web server setup.
- `inventory.ini`: Static Ansible inventory (likely used for local testing or reference).
- `Jenkinsfile`: Defines the CI/CD pipeline.
- `jenkins_2.492.3_all.deb`: Jenkins installation package (deb).

## Building and Running

### Prerequisites
- AWS CLI configured with appropriate credentials.
- Terraform and Ansible installed.
- SSH public key available at `~/.ssh/my_aws_key.pub`.

### Infrastructure Provisioning
```bash
terraform init
terraform apply -auto-approve
```

### Server Configuration
The Jenkins pipeline automates this, but it can be run manually:
```bash
# Get the IP from terraform output
export SERVER_IP=$(terraform output -raw server_ip)

# Run Ansible
ansible-playbook -i ${SERVER_IP}, playbook.yaml -u ec2-user --private-key ~/.ssh/my_aws_key --ssh-common-args='-o StrictHostKeyChecking=no'
```

## Development Conventions
- **Naming:** Follow standard Terraform and Ansible naming conventions.
- **Security:** Security groups are configured to allow HTTP (80) and SSH (22) from all IPs (`0.0.0.0/0`). *Caution: Restrict SSH access for production environments.*
- **State Management:** Terraform state is managed locally (no remote backend configured).
