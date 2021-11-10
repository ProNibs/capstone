pipeline {
    agent {
        kubernetes {
            podTemplate {
                inheritFrom 'kaniko'
            }
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