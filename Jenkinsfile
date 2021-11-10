pipeline {
    agent {
        kubernetes {
            label 'kaniko'
            cloud 'kubernetes'
            inheritFrom 'kaniko'
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