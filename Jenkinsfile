pipeline {
    agent {
        kubernetes {
            label 'kaniko'
            containerTemplate {
                name 'kaniko'
                image 'gcr.io/kaniko-project/executor:debug'
                ttyEnabled true
                command 'cat'
            }
        }
    }
    stages {
        stage('build') {
            steps {
                sh "echo HELLO WORLD!"
                container('kaniko') {
                    sh "/kaniko/executor -f `pwd`/aggregatprService/Dockerfile --no-push"
                }
            }
        }
    }
}