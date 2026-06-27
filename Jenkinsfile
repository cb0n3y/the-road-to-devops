pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo "Fetching repository..."
                checkout scm
            }
        }

        stage('Verify') {
            sh '''
                echo "Repository successfully cloned."
                pwd
                ls -lh
            '''
        }
    }
}