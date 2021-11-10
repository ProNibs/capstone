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
            containerTemplate {
                name 'kaniko'
                image 'gcr.io/kaniko-project/executor:debug'
                workingDir '/tmp/jenkins'
                ttyEnabled true
                command '/busybox/cat'
            }
        }
    }
    stages {
        stage('build') {
            steps {
                sh "echo HELLO WORLD!"
                script {
                    echo create_container(repositories)
                    parallel(create_container(repositories))
                }
            }
        }
    }
}

def create_containers(list) {
    running_set = [:]
    for (i in list) {
        running_set << ["Build ${i}'s container" : {
            container('kaniko') { 
                sh '/kaniko/executor -c `pwd`/${i} --no-push'
            }
        }]
    }
    return running_set
}