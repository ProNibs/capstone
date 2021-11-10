// Create a list of the repos we have to loop over
def repositories = [
    'aggregatorService',
    'supplementalService',
    'dashboard-database',
    'dashboard-api',
    'dashboard-web'
]

def containerBuild(list) = {
    container('kaniko') { 
        sh '/kaniko/executor -c `pwd`/${list} --no-push'
    }
}



pipeline {
    agent {
        kubernetes {
            containerTemplate {
                name 'kaniko'
                image 'gcr.io/kaniko-project/executor:debug'
                ttyEnabled true
                command '/busybox/cat'
            }
        }
    }
    stages {
        stage('Build Containers') {
            steps {
                sh "echo HELLO WORLD!"
                parallel {
                    stage('Build AggregatorService') {
                        script {
                            containerBuild('aggregatorService')
                        }
                    }
                    stage('Build SupplementalService') {
                        script {
                            containerBuild('supplementalService')
                        }
                    }
                }
        }
    }
}