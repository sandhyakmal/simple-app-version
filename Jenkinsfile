pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    parameters {
        booleanParam(name: 'DEPLOY', defaultValue: true, description: 'Jalankan container setelah build')
    }

    environment {
        APP_NAME       = 'simple-app-version'
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

        stage('Set Version') {
            steps {
                script {
                    def pkgVersion = sh(
                        script: '''sed -n 's/.*"version": *"\\([^"]*\\)".*/\\1/p' package.json | head -1''',
                        returnStdout: true
                    ).trim()
                    env.APP_VERSION = "${pkgVersion}-${env.BUILD_NUMBER}"
                    echo "Versi yang akan dibuild: ${env.APP_VERSION}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build \
                      --build-arg APP_VERSION="${APP_VERSION}" \
                      --build-arg APP_NAME="${APP_NAME}" \
                      -t ${IMAGE}:${APP_VERSION} \
                      -t ${IMAGE}:latest .
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