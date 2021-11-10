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
        sh "/kaniko/executor -c `pwd`/${inputName} --no-push"
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
                    steps {
                        container('kaniko') {
                            containerBuild('aggregatorService')
                        }
                    }
                }
                stage('Build SupplementalService') {
                    steps {
                        container('kaniko') {    
                            containerBuild('supplementalService')
                        }
                    }
                }
                stage('Build Dashboard-Database') {
                    steps {
                        container('kaniko') {    
                            containerBuild('dashboard-database')
                        }
                    }
                }
                stage('Build Dashboard-API') {
                    steps {
                        container('kaniko') {    
                            containerBuild('dashboard-api')
                        }
                    }
                }
                stage('Build Dashboard-Web') {
                    steps {
                        container('kaniko') {    
                            containerBuild('dashboard-web')
                        }
                    }
                }
            }
        }
    }
}