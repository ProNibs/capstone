// Create a list of the repos we have to loop over
repositories = [
    'aggregatorService',
    'supplementalService',
    'dashboard-database',
    'dashboard-api',
    'dashboard-web'
]

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
                script {
                    create_containers(repositories)
                }
                container('kaniko') {
                    sh "/kaniko/executor -f `pwd`/aggregatorService/Dockerfile --no-push"
                }
            }
        }
    }
}

def create_containers(list) {
    for (i in list) {
        println "Directory is ${i}"
    }
}