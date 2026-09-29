pipeline {
    agent any

    triggers {
        githubPush()
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    parameters {
        booleanParam(name: 'DEPLOY', defaultValue: true, description: 'Jalankan container setelah build')
    }

    environment {
        APP_VERSION    = '1.0.0'
        IMAGE          = 'simple-app-version'
        IMAGE_REPO     = 'andaraleonhart/simple-app-version'
        CONTAINER_NAME = 'simple-app-version'
        HOST_PORT      = '8081'          // 8080 dipakai Jenkins
        DOCKER_BUILDKIT = '0'            // legacy builder, sesuai setup sebelumnya
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${IMAGE}:latest .
                '''
            }
        }

        stage('Docker Tag') {
            steps {
                sh '''
                    docker tag ${IMAGE}:latest ${IMAGE_REPO}:${APP_VERSION}
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push ${IMAGE_REPO}:${APP_VERSION}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Sukses: ${env.IMAGE}:${env.APP_VERSION}"
        }
        failure {
            echo 'Pipeline gagal, cek log stage yang merah.'
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}