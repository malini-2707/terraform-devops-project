pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {

        // 🧹 Clean old workspace (VERY IMPORTANT)
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        // 📥 Pull latest code from GitHub
        stage('Checkout') {
            steps {
                git 'https://github.com/malini-2707/terraform-devops-project.git'
            }
        }

        // ⚙️ Terraform Initialization
        stage('Terraform Init') {
            steps {
                dir('environments/dev') {
                    sh '''
                    terraform init -no-color
                    '''
                }
            }
        }

        // ✅ Validate Terraform files
        stage('Terraform Validate') {
            steps {
                dir('environments/dev') {
                    timeout(time: 2, unit: 'MINUTES') {
                        sh 'terraform validate -no-color'
                    }
                }
            }
        }

        // 📊 Terraform Plan
        stage('Terraform Plan') {
            steps {
                dir('environments/dev') {
                    sh 'terraform plan -no-color'
                }
            }
        }

        // 🚀 Terraform Apply (creates infrastructure)
        stage('Terraform Apply') {
            steps {
                dir('environments/dev') {
                    sh 'terraform apply -auto-approve -no-color'
                }
            }
        }
    }
}