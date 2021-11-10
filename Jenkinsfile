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
        stage('Pull git submodules') {
            steps {
                sh "git submodule foreach git checkout master"
                sh "git submodule foreach git pull"
            }
        }
        stage('build') {
            steps {
                sh "echo HELLO WORLD!"
                container('kaniko') {
                    create_containers(repositories)
                    sh "ls -a"
                    sh "pwd"
                    sh "ls aggregatorService"
                    sh '/kaniko/executor -v debug -c `pwd`/aggregatorService --no-push'
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