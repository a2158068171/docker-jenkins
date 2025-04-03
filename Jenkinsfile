

pipeline {
    agent any
    
    stages {

        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[
                        url: 'http://gitlab/root/docker-jenkins.git',
                        credentialsId: 'gitlab-creds'
                    ]]
                ])
            }
        }
        

        stage('Build') {
            steps {
                sh 'chmod +x build_and_push.sh'
                sh './build_and_push.sh'
            }
        }
        

       stage('Build and Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_TOKEN')]) {
                    sh '''
                        chmod +x build_and_push.sh
                        export DOCKER_PASS="$DOCKER_TOKEN"
                        ./build_and_push.sh
                    '''
                }
            }
        }
    }
}