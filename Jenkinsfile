pipeline {
    agent any
    stages {
        /*
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './mvnw package'
            }
        }
        */
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    app = docker.build("serhiikalchenko/spring-petclinic-image")
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
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker pull serhiikalchenko/spring-petclinic-image:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker stop spring-petclinic\""
                            BUILD_NUMBER = ${env.BUILD_NUMBER} - 1
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker rmi serhiikalchenko/spring-petclinic-image:$BUILD_NUMBER\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$STAGE_SERVER_IP \"docker run -d --rm --name spring-petclinic -p 8080:8080 serhiikalchenko/spring-petclinic-image:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
    }
}
