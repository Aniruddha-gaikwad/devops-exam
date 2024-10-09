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
            // Invoke the Lambda function
            def result = sh(script: 'aws lambda invoke --function-name MyLambdaFunction --log-type Tail lambda_output.txt --output json', returnStdout: true)
            
            // Print the result for debugging
            echo result

            // Parse JSON output to get LogResult
            def jsonResult = readJSON text: result
            def logResult = jsonResult.LogResult

            // Decode the Base64-encoded log result
            def decodedLogs = sh(script: "echo ${logResult} | base64 --decode", returnStdout: true)
            echo decodedLogs
        }
            }
        }
    }
}
