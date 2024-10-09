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
                   aws lambda invoke \
                       --function-name my_lambda \
                       --log-type Tail \
                       --query 'LogResult' \
                       --output text \
                       lambda_output.txt | base64 --decode
                   
                   LAMBDA_STATUS=$?
                   if [ $LAMBDA_STATUS -ne 0 ]; then
                       echo "Lambda invocation failed with status: $LAMBDA_STATUS"
                       exit 1
                   fi
                   
                   cat lambda_output.txt
               ''', returnStatus: true)     // test
               
               if (result != 0) {
                   error "Lambda invocation failed. Check the logs for more details."
               }
           }
       }
   }

