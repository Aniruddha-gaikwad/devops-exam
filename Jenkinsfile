pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {
        stage('TF Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('TF Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }      

        stage('TF Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }

        stage('TF Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Invoke Lambda') {
            steps {
                script {
                    sh 'aws lambda invoke --function-name my_lambda --log-type Tail lambda_output.txt'
                    sh 'cat lambda_output.txt | base64 --decode'
                }
            }
        }
    }
}

