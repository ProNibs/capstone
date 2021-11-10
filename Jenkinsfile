// Create a list of the repos we have to loop over
def repositories = [
    'aggregatorService',
    'supplementalService',
    'dashboard-database',
    'dashboard-api',
    'dashboard-web'
]

def generateBuildStage(list) {
    return {
        stage("build-${list}") {
            steps {
                container('kaniko') { 
                    sh '/kaniko/executor -c `pwd`/${list} --no-push'
                }
            }
        }
    }
}

def parallelBuildStagesMap = repositories.collectEntries {
    ["${it}" : generateBuildStage(it)]
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
        stage('build') {
            steps {
                sh "echo HELLO WORLD!"
                script {
                    echo "$parallelBuildStagesMap"
                    parallel parallelBuildStagesMap
                }
            }
        }
    }
}