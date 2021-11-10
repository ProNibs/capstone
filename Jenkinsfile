pipeline {
    agent {
        kubernetes {
            label 'kaniko'
        }
    }
    stages {
        stage('build') {
            steps {
                sh "echo HELLO WORLD!"
                sh "/kaniko/executor --help"
            }
        }
    }
}