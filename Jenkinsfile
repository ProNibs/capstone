// Create a list of the repos we have to loop over
def repositories = [
    'aggregatorService',
    'supplementalService',
    'dashboard-database',
    'dashboard-api',
    'dashboard-web'
]

def containerBuild(String inputName) {
    sh "/kaniko/executor -c `pwd`/${inputName} --no-push"
}

pipeline {
    agent {
        kubernetes {
            yamlFile 'infrastructure/jenkins/buildYamls/kaniko_pod.yaml'
        }
    }
    stages {
        stage('Build Containers') {
            when { branch 'master' }
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
                    agent {
                        kubernetes {
                            yamlFile 'infrastructure/jenkins/buildYamls/kaniko_pod.yaml'
                        }
                    }
                    steps {
                        echo "Building Dashboard-API container..."
                        container('kaniko') {    
                            containerBuild('dashboard-api')
                        }
                    }
                }
                stage('Build Dashboard-Web') {
                    // Get resource hogs their own pod
                    agent {
                        kubernetes {
                            yamlFile 'infrastructure/jenkins/buildYamls/kaniko_pod.yaml'
                        }
                    }
                    steps {
                        echo "Building Dashboard-Web container..."
                        container('kaniko') {    
                            containerBuild('dashboard-web')
                        }
                    }
                }
            }
        }
        stage('Test Carvel Container') {
            agent {
                kubernetes {
                    yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
                }
            }
            environment {
                KAPP_KUBECONFIG = credentials('kube-config-v2')
            }
            steps {
                container ('carvel') {
                    sh "echo $KAPP_KUBECONFIG"
                    sh "kapp version"
                    sh "kapp deploy -y -a test -n default -f https://k8s.io/examples/pods/simple-pod.yaml"
                }
            }
        }
    }
}