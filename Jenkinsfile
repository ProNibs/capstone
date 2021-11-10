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
                        echo "Building AggregatorService container..."
                        container('kaniko') {
                            containerBuild('aggregatorService')
                        }
                    }
                }
                stage('Build SupplementalService') {
                    steps {
                        echo "Building SupplementalService container..."
                        container('kaniko') {    
                            containerBuild('supplementalService')
                        }
                    }
                }
                stage('Build Dashboard-Database') {
                    steps {
                        echo "Building Dashboard-Database container..."
                        container('kaniko') {    
                            containerBuild('dashboard-database')
                        }
                    }
                }
                stage('Build Dashboard-API') {
                    steps {
                        echo "Building Dashboard-API container..."
                        container('kaniko') {    
                            containerBuild('dashboard-api')
                        }
                    }
                }
                stage('Build Dashboard-Web') {
                    steps {
                        echo "Building Dashboard-Web container..."
                        container('kaniko') {    
                            containerBuild('dashboard-web')
                        }
                    }
                }
            }
        }
    }
}