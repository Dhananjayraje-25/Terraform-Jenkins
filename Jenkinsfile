pipeline {

    parameters {
        booleanParam(
            name: 'autoApprove',
            defaultValue: false,
            description: 'Automatically run apply after generating plan?'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    stages {

        stage('Checkout') {
            steps {
                script {
                    dir('terraform') {
                        git branch: 'main',
                            url: 'https://github.com/Dhananjayraje-25/Terraform-Jenkins.git'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                bat '''
                    cd terraform
                    terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                bat '''
                    cd terraform
                    terraform plan -out=tfplan
                '''
            }
        }

        stage('Show Plan') {
            steps {
                bat '''
                    cd terraform
                    terraform show -no-color tfplan > tfplan.txt
                '''
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile('terraform/tfplan.txt')

                    input(
                        message: 'Do you want to apply the Terraform plan?',
                        parameters: [
                            text(
                                name: 'Plan',
                                description: 'Please review the Terraform plan',
                                defaultValue: plan
                            )
                        ]
                    )
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                bat '''
                    cd terraform
                    terraform apply -input=false tfplan
                '''
            }
        }
    }

    post {
        success {
            echo 'Terraform pipeline completed successfully.'
        }

        failure {
            echo 'Terraform pipeline failed. Please check the console output.'
        }
    }
}
