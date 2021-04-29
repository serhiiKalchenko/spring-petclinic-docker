pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "serhiikalchenko/spring-petclinic-image"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './mvnw package'
            }
        }
        
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    app = docker.build("$DOCKER_IMAGE_NAME")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_creds') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Deploy To Stage-Server') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'stage_server_creds', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker pull $DOCKER_IMAGE_NAME:${env.BUILD_NUMBER}\""
                        sh ''
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker stop spring-petclinic\""
                            //sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"let BUILD=${env.BUILD_NUMBER}-1; docker rmi serhiikalchenko/spring-petclinic-image:$BUILD\""
                        } catch (err) {
                            echo "caught error: $err"
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker run -d --rm --name spring-petclinic -p 8080:8080 $DOCKER_IMAGE_NAME:${env.BUILD_NUMBER}\""
                        // clean up old images: docker system prune -a -f
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker system prune -a -f\""
                    }
                }
            }
        }
    }
}
