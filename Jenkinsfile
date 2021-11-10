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
                ttyEnabled true
                command '/busybox/cat'
            }
        }
    }
    stages {
        stage('build') {
            steps {
                sh "echo HELLO WORLD!"
                container('kaniko') {
                    create_containers(repositories)
                    sh "ls -a"
                    sh '/kaniko/executor -c `pwd`/aggregatorService -f `pwd`/aggregatorService/Dockerfile --no-push -v=debug'
                }
            }
        }
    }
}

def create_containers(list) {
    for (i in list) {
        //println "Directory is ${i}"
        sh "ls ${i}"
        sh "cd ${i}"
        sh "ls ${i}"
    }
}