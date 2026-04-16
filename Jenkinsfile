pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-creds')
        AWS_SECRET_ACCESS_KEY = "${env.AWS_ACCESS_KEY_ID_PSW}"
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('environments/dev') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('environments/dev') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('environments/dev') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('environments/dev') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}