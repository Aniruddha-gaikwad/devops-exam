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
            // Invoke the Lambda function and store the output in a file
            sh 'aws lambda invoke --function-name my_lambda --log-type Tail lambda_output.txt --output json'

            // Read the output from the lambda_output.txt file
            def jsonOutput = readFile('lambda_output.txt')

            // Extract the LogResult using jq
            def logResult = sh(script: "echo '${jsonOutput}' | jq -r '.LogResult'", returnStdout: true).trim()

            // Check if logResult is not empty
            if (logResult) {
                // Decode the Base64-encoded logs
                def decodedLogs = sh(script: "echo ${logResult} | base64 --decode", returnStdout: true)
                echo decodedLogs
            } else {
                echo "No logs available."
            }
            }
        }
    }
}

//yep
