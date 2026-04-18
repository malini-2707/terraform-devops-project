pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                git 'https://github.com/malini-2707/terraform-devops-project.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('environments/dev') {
                    sh '''
                    rm -rf .terraform
                    terraform init -no-color
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('environments/dev') {
                    timeout(time: 2, unit: 'MINUTES') {
                        sh 'terraform validate -no-color'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('environments/dev') {
                    sh 'terraform plan -no-color'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('environments/dev') {
                    sh 'terraform apply -auto-approve -no-color'
                }
            }
        }
    }
}