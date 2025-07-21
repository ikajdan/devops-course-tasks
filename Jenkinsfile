pipeline {
    agent any

    environment {
        LOCAL_REGISTRY = "localhost:5000"
        IMAGE_NAME = "flask-app:${BUILD_NUMBER}"
        FULL_IMAGE_NAME = "${LOCAL_REGISTRY}/flask-app:${BUILD_NUMBER}"
        SONARQUBE_ENV = 'SonarQube'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig'
        APP_HOST = '192.168.49.2'
        APP_PORT = '31484'
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Compiling Python source"
                sh 'python3 -m compileall app/'
            }
        }

        stage('Unit Tests') {
            steps {
                echo "Running unit tests"
                dir('app') {
                    sh 'python3 -m unittest discover'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(SONARQUBE_ENV) {
                    sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=flask-app \
                      -Dsonar.sources=./app \
                      -Dsonar.python.version=3
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker image"
                script {
                    docker.build("${IMAGE_NAME}", "app")
                }
            }
        }

        stage('Push to Local Registry') {
            steps {
                echo "Tagging and pushing to local Docker registry"
                script {
                    sh """
                        docker tag ${IMAGE_NAME} ${FULL_IMAGE_NAME}
                        docker push ${FULL_IMAGE_NAME}
                    """
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                echo "Deploying to K8s using Helm"
                withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
                    sh """
                    helm upgrade --install flask-app ./helm \
                      --set image.repository=${LOCAL_REGISTRY}/flask-app \
                      --set image.tag=${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Verify Application') {
            steps {
                echo "Verifying deployment at http://${APP_HOST}:${APP_PORT}/"
                sh 'sleep 10'
                sh "curl --fail http://${APP_HOST}:${APP_PORT}/"
            }
        }
    }

    post {
        success {
            slackSend(channel: '#ci-cd', message: "Build #${BUILD_NUMBER} succeeded.")
        }
        failure {
            slackSend(channel: '#ci-cd', message: "Build #${BUILD_NUMBER} failed.")
        }
    }
}
