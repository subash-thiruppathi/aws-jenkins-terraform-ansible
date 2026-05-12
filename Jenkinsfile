pipeline {
    agent any

    stages {
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Provision Infrastructure') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Wait for Server Boot') {
            steps {
                echo 'Waiting 60 seconds for the Linux server to turn on...'
                sleep 60 
            }
        }

        stage('Configure with Ansible') {
            steps {
                script {
                    env.SERVER_IP = sh(script: 'terraform output -raw server_ip', returnStdout: true).trim()
                }
                echo "Deploying to IP: ${env.SERVER_IP}"
                sh "ansible-playbook -i ${env.SERVER_IP}, playbook.yml -u ec2-user --private-key ~/.ssh/my_aws_key --ssh-common-args='-o StrictHostKeyChecking=no'"
            }
        }
    }
}