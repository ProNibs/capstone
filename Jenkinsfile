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
                container('kaniko') {
                    sh "/kaniko/executor --help"
                }
            }
        }
    }
}