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

        stage('Deploy') {
            when { expression { return params.DEPLOY } }
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d \
                      --name ${CONTAINER_NAME} \
                      --restart unless-stopped \
                      -p ${HOST_PORT}:8080 \
                      ${IMAGE}:${APP_VERSION}
                '''
            }
        }

        stage('Health Check') {
            when { expression { return params.DEPLOY } }
            steps {
                sh '''
                    sleep 5
                    curl -fsS http://localhost:${HOST_PORT}/ > /dev/null
                    echo "Aplikasi merespons di port ${HOST_PORT}"
                '''
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