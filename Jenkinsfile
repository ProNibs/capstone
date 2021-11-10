pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                sh "echo HELLO WORLD!"
                sh "/kaniko/executor --help"
            }
        }
    }
}