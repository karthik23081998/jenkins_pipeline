pipeline {
    agent { label 'JAVA' }

    tool {
        Maven 'MAVEN'
    }

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

        stage('Upload to JFrog Artifactory') {
            steps {
                script {
                    def server = Artifactory.server('JFROG')  // Must match Jenkins config ID
                    def buildInfo = Artifactory.newBuildInfo()
                    buildInfo.env.capture = true

                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "libs-release-local/"
                            }
                        ]
                    }"""

                    server.upload(spec: uploadSpec, buildInfo: buildInfo)
                    server.publishBuildInfo(buildInfo)
                }
            }
        }

        stage('Docker Build') {
            agent { label 'node1' }
            steps {
                sh '''
                    docker build -t karthik:1.0 .
                    docker image ls
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo '✅ Build, SonarCloud scan, JFrog upload, and Docker build completed successfully!'
        }
        failure {
            echo '❌ Build or deployment failed! Check the Jenkins logs for details.'
        }
    }
}
