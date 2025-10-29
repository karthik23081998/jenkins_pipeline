pipeline {
    agent { label 'JAVA' }

    environment {
        SONARQUBE = 'SONARQUBE'       // SonarQube server name (configured in Jenkins)
        SONAR_TOKEN = credentials('sonar_ids')  // SonarQube token credentials ID
    }

    stages {

        stage('Git Checkout') {
            steps {
                echo '📥 Checking out Spring PetClinic repository...'
                dir('spring-petclinic') {
                    git branch: 'main', url: 'https://github.com/spring-projects/spring-petclinic.git'
                }
            }
        }

        stage('Java Build & SonarCloud Scan') {
            steps {
                dir('spring-petclinic') {
                    withSonarQubeEnv("${SONARQUBE}") {
                        withCredentials([string(credentialsId: 'sonar_idds', variable: 'SONAR_TOKEN')]) {
                            sh '''
                                echo "🏗️ Running Maven build and SonarQube analysis..."
                                mvn clean verify sonar:sonar \
                                    -Dsonar.projectKey=karthik23081998_spring-petclinic \
                                    -Dsonar.organization=karthik23081998 \
                                    -Dsonar.host.url=https://sonarcloud.io \
                                    -Dsonar.login=$SONAR_TOKEN
                            '''
                        }
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('spring-petclinic') {
                    sh '''
                        echo "🐳 Building Docker image..."
                        docker build -t karthik:1.0 .
                        docker image ls | grep karthik
                    '''
                }
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
