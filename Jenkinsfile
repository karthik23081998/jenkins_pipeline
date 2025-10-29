pipeline {
    agent { label 'JAVA' }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/spring-projects/spring-petclinic.git'
            }
        }

        stage('Java Build and SonarCloud Scan') {
            steps {
                withSonarQubeEnv('SONARQUBE') {
                    withCredentials([string(credentialsId: 'sonar_idds', variable: 'SONAR_TOKEN')]) {
                        sh '''
                            mvn clean verify sonar:sonar \
                            -Dsonar.projectKey=karthik23081998_spring-petclinic \
                            -Dsonar.projectName=spring-petclinic \
                            -Dsonar.organization=karthik23081998 \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t karthik:1.0 .
                    docker image ls
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Build and Docker image creation successful!'
        }
        failure {
            echo '❌ Build failed! Check the Jenkins logs for details.'
        }
    }
}
