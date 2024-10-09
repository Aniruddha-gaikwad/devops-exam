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
               def result = sh(script: '''
                   set +x
                   LAMBDA_RESULT=$(aws lambda invoke \
                       --function-name MyLambdaFunction \
                       --log-type Tail \
                       --query 'LogResult' \
                       --output text \
                       /dev/null)
                   
                   if [ $? -ne 0 ]; then
                       echo "Lambda invocation failed"
                       exit 1
                   fi
                   
                   echo "$LAMBDA_RESULT" | base64 --decode || echo "Failed to decode base64 output"
               ''', returnStdout: true)
               
               echo "Lambda Execution Result:"
               echo result
               
               if (result.contains("ERROR") || result.contains("Failed to decode base64 output")) {
                   error "Lambda invocation failed. Check the logs for more details."
               }
            }
        }
    }
}
