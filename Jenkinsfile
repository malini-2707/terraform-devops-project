pipeline {
    agent any

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/malini-2707/terraform-devops-project.git'
            }
        }

        stage('Terraform') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'aws-creds',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
        )]) {
            dir('environments/dev') {
                sh 'export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID && terraform init -no-color'
                sh 'terraform validate -no-color'
                sh 'terraform plan -no-color'
                sh 'terraform apply -auto-approve -no-color'
            }
        }
    }
}
    }
}