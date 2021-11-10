pipeline {
    agent {
        kubernetes {
            inheritFrom 'kaniko'
        }
    }
    node('POD_LABEL') {
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