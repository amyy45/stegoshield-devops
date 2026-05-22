pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = "amy45/stegoshield-backend"
        DOCKER_CREDENTIALS_ID = "dockerhub-credentials"
        GIT_REPO = "https://github.com/amyy45/stegoshield-devops.git"
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Checking out source code...'
                checkout scm
            }
        }

        stage('Lint & Validate') {
            steps {
                echo '🔍 Validating project structure...'
                sh '''
                    echo "Checking required files..."
                    test -f backend/Dockerfile && echo "✅ Dockerfile found"
                    test -f backend/requirements.txt && echo "✅ requirements.txt found"
                    test -f docker-compose.yml && echo "✅ docker-compose.yml found"
                    test -f scripts/health_check.sh && echo "✅ health_check.sh found"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh '''
                    docker build \
                        -f backend/Dockerfile \
                        --build-arg VITE_FIREBASE_API_KEY="${VITE_FIREBASE_API_KEY}" \
                        --build-arg VITE_FIREBASE_AUTH_DOMAIN="${VITE_FIREBASE_AUTH_DOMAIN}" \
                        --build-arg VITE_FIREBASE_PROJECT_ID="${VITE_FIREBASE_PROJECT_ID}" \
                        --build-arg VITE_FIREBASE_STORAGE_BUCKET="${VITE_FIREBASE_STORAGE_BUCKET}" \
                        --build-arg VITE_FIREBASE_MESSAGING_SENDER_ID="${VITE_FIREBASE_MESSAGING_SENDER_ID}" \
                        --build-arg VITE_FIREBASE_APP_ID="${VITE_FIREBASE_APP_ID}" \
                        --build-arg VITE_FIREBASE_MEASUREMENT_ID="${VITE_FIREBASE_MEASUREMENT_ID}" \
                        -t ${DOCKER_HUB_REPO}:${BUILD_NUMBER} \
                        -t ${DOCKER_HUB_REPO}:latest \
                        .
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo '🏥 Running health check...'
                sh '''
                    docker run -d \
                        --name stegoshield-test-${BUILD_NUMBER} \
                        --env-file backend/.env \
                        -p 5001:5000 \
                        ${DOCKER_HUB_REPO}:${BUILD_NUMBER}

                    sleep 15

                    curl -f http://localhost:5001/ping || exit 1
                    echo "✅ Health check passed"

                    docker stop stegoshield-test-${BUILD_NUMBER}
                    docker rm stegoshield-test-${BUILD_NUMBER}
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '📤 Pushing to Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                        docker push ${DOCKER_HUB_REPO}:latest
                        echo "✅ Pushed ${DOCKER_HUB_REPO}:${BUILD_NUMBER}"
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo '🧹 Cleaning up local images...'
                sh '''
                    docker rmi ${DOCKER_HUB_REPO}:${BUILD_NUMBER} || true
                    docker rmi ${DOCKER_HUB_REPO}:latest || true
                    docker system prune -f || true
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            echo "✅ Image pushed: ${DOCKER_HUB_REPO}:${BUILD_NUMBER}"
        }
        failure {
            echo '❌ Pipeline failed. Check the logs above.'
            sh '''
                docker stop stegoshield-test-${BUILD_NUMBER} || true
                docker rm stegoshield-test-${BUILD_NUMBER} || true
            '''
        }
        always {
            echo 'Pipeline finished.'
        }
    }
}