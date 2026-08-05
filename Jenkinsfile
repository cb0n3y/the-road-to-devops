pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                checkout scm
            }
        }

        stage('Lint YAML') {
            steps {
                sh 'yamllint -c .yamllint . || true'
            }
        }

        stage('Lint Markdown') {
            steps {
                sh '''
                    find . -name "*.md" | while read f; do
                        echo "Checking: $f"
                        grep -l "TODO\|FIXME\|PLACEHOLDER" "$f" && echo "WARNING: placeholder found in $f" || true
                    done
                '''
            }
        }

        stage('Verify Structure') {
            steps {
                sh '''
                    echo "=== Repo structure ==="
                    find . -not -path "./.git/*" -type f | sort
                    echo "=== Markdown files ==="
                    find . -name "*.md" | wc -l
                    echo "=== YAML files ==="
                    find . -name "*.yml" -o -name "*.yaml" | wc -l
                '''
            }
        }

        stage('Changelog check') {
            steps {
                sh '''
                    if [ -f CHANGELOG.md ]; then
                        echo "CHANGELOG.md exists"
                        head -5 CHANGELOG.md
                    else
                        echo "WARNING: No CHANGELOG.md found"
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo '[+] Pipeline completed successfully!'
            cleanWs()
        }
        failure {
            echo '[+] Pipeline failed!'
        }
    }
}