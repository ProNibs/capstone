// Create a list of the repos we have to loop over
def repositories = [
    'aggregatorService',
    'supplementalService',
    'dashboard-database',
    'dashboard-api',
    'dashboard-web'
]

// def containerBuild(list) = {
//     sh '/kaniko/executor -c `pwd`/${list} --no-push'
// }



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
                            sh '/kaniko/executor -c `pwd`/${aggregatorService} --no-push'
                        }
                    }
                }
                stage('Build SupplementalService') {
                    steps {
                        container('kaniko') {    
                            script {
                                sh '/kaniko/executor -c `pwd`/${supplementalService} --no-push'
                            }
                        }
                    }
                }
            }
        }
    }
}