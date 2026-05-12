# AWS Web Server Automation (Terraform & Ansible)

This repository contains automation scripts to provision a web server on AWS and configure it with Apache using a CI/CD-ready approach.

## 🚀 Overview

The project follows an Infrastructure-as-Code (IaC) and Configuration Management (CM) workflow:
1.  **Terraform**: Provisions an AWS EC2 instance, sets up security groups (SSH & HTTP), and handles SSH key management.
2.  **Ansible**: Configures the provisioned instance by installing Apache (`httpd`) and deploying a custom landing page.
3.  **Jenkins**: Orchestrates the entire process via a declarative pipeline.

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed and configured:
- [Terraform](https://www.terraform.io/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation/index.html)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with `aws configure`)
- An SSH key pair at `~/.ssh/my_aws_key` and `~/.ssh/my_aws_key.pub`

## 📂 Project Structure

- `main.tf`: Terraform infrastructure definitions.
- `playbook.yaml`: Ansible configuration tasks.
- `Jenkinsfile`: Pipeline automation.
- `inventory.ini`: Static inventory for reference.

## 🚦 Getting Started

### 1. Provision Infrastructure
Initialize and apply the Terraform configuration:
```bash
terraform init
terraform apply -auto-approve
```

### 2. Configure the Server
After provisioning, you can run the Ansible playbook manually (though Jenkins is preferred):
```bash
# Extract the IP
export SERVER_IP=$(terraform output -raw server_ip)

# Run the playbook
ansible-playbook -i ${SERVER_IP}, playbook.yaml -u ec2-user --private-key ~/.ssh/my_aws_key
```

## 🏗️ CI/CD with Jenkins
The included `Jenkinsfile` automates the entire lifecycle:
1.  **Initialize**: Sets up Terraform.
2.  **Provision**: Executes `terraform apply`.
3.  **Wait**: Ensures the instance is fully booted.
4.  **Configure**: Runs the Ansible playbook against the new instance.

## ⚠️ Security Note
The current security group configuration allows inbound traffic on ports 22 (SSH) and 80 (HTTP) from **any IP** (`0.0.0.0/0`). For production use, it is highly recommended to restrict port 22 to your specific IP address.
