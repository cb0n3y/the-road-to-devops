pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                echo "Fetching repository..."
                checkout scm
                sh 'mkdir -p build'
            }
        }

        stage('Verify') {
            steps {
                sh '''
                    echo "Repository successfully cloned."
                    pwd
                    ls -lh
                '''
            }
        }
    }

    post {
        success {
            cleanWs()
        }
    }
}