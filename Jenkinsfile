pipeline {
    agent {
        kubernetes {
            inheritFrom 'kaniko'
        }
    }
    node('container-build-agent') {
        stages {
            stage('build') {
                steps {
                    sh "echo HELLO WORLD!"
                    sh "/kaniko/executor --help"
                }
            }
        }
    }
}