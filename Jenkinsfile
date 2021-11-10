pipeline {
    agent {
        kubernetes {
            inheritFrom 'kaniko'
        }
    }
    node('container-build-agent') {
            stage('build') {
                steps {
                    sh "echo HELLO WORLD!"
                    sh "/kaniko/executor --help"
                }
            }
    }
}