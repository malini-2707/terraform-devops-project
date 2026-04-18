pipeline {
    agent any

    stages {

        // 🧹 Clean workspace
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        // 📥 Checkout code
        stage('Checkout') {
            steps {
                git 'https://github.com/malini-2707/terraform-devops-project.git'
            }
        }

        // 🔐 Terraform execution (all steps together)
        stage('Terraform') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {

                    dir('environments/dev') {

                        sh 'terraform init -no-color'
                        sh 'terraform validate -no-color'
                        sh 'terraform plan -no-color'
                        sh 'terraform apply -auto-approve -no-color'

                    }
                }
            }
        }
    }
}