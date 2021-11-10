// Create a list of the repos we have to loop over
def repositories = [
    'aggregatorService',
    'supplementalService',
    'dashboard-database',
    'dashboard-api',
    'dashboard-web'
]

def containerBuild(String inputName) {
    return {
        steps {
            container('kaniko') { 
                sh '/kaniko/executor -c `pwd`/${inputName} --no-push'
            }
        }
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
            parallel {
                stage('Build AggregatorService') {
                    containerBuild('aggregatorService')
                }
                stage('Build SupplementalService') {
                    steps {
                        container('kaniko') {    
                            sh '/kaniko/executor -c `pwd`/supplementalService --no-push'
                        }
                    }
                }
            }
        }
    }
}