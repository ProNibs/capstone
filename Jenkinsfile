// Create a list of the repos we have to loop over
def repositories = [
    'aggregatorService',
    'supplementalService',
    'dashboard-database',
    'dashboard-api',
    'dashboard-web'
]

def containerBuild(String inputName) {
    // Need this, otherwise builds fail (probably going too quick or something dumb)
    sh "ls /kaniko/.docker/"
    sh "/kaniko/executor -c `pwd`/${inputName} --cache --skip-tls-verify \
       --destination harbor.127.0.0.1.nip.io:8443/my-repo/${inputName.toLowerCase()}:latest"
    // Need to split up; otherwise, it'll timeout from taking forever
    // sh "/kaniko/executor -c `pwd`/${inputName} --skip-tls-verify \
    //    --destination harbor.127.0.0.1.nip.io/my-repo/${inputName.toLowerCase()}:${BUILD_NUMBER}"
    
    // This works for Dockerhub if we need that
    // sh "/kaniko/executor -c `pwd`/${inputName} --skip-tls-verify \
    //     --destination jklhgfcm/my-private-repo:${inputName.toLowerCase()}.latest"
}

pipeline {
    agent {
        kubernetes {
            yamlFile 'infrastructure/jenkins/buildYamls/kaniko_pod.yaml'
        }
    }
    stages {
        stage('Create Required Namespaces with Carvel Container') {
            agent {
                kubernetes {
                    yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
                }
            }
            environment {
                KAPP_KUBECONFIG = credentials('kube-config-v2')
                KAPP_NAMESPACE = "default"
            }
            steps {
                container ('carvel') {
                    sh "kapp version"
                    sh "kapp deploy -y -a namespaces -f infrastructure/namespaces/"
                }
            }
        }
        // This stage is redundant, but w/e bro
        stage('Install Kapp-Controller') {
            agent {
                kubernetes {
                    yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
                }
            }
            environment {
                KAPP_KUBECONFIG = credentials('kube-config-v2')
                KAPP_NAMESPACE = 'default'
            }
            steps {
                container ('carvel') {
                    sh "kapp deploy -y -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml"
                    sh "kapp deploy -y -a default-cluster-rbac -f infrastructure/kapp-controller-sa/serviceAccount.yaml"
                }
            }
        }
        stage('Install Metallb') {
            agent {
                kubernetes {
                    yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
                }
            }
            environment {
                KAPP_KUBECONFIG = credentials('kube-config-v2')
                KAPP_NAMESPACE = 'default'
            }
            steps {
                container ('carvel') {
                    sh "kapp deploy -y -a metallb.kapp -f infrastructure/metallb/app/"
                }
            }
        }
        stage('Install Ingress-Nginx') {
            agent {
                kubernetes {
                    yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
                }
            }
            environment {
                KAPP_KUBECONFIG = credentials('kube-config-v2')
                KAPP_NAMESPACE = 'default'
            }
            steps {
                container ('carvel') {
                    sh "kapp deploy -y -a ingress.kapp -f infrastructure/ingress/app/"
                }
            }
        }
        stage('Install Cert-Manager') {
            agent {
                kubernetes {
                    yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
                }
            }
            environment {
                KAPP_KUBECONFIG = credentials('kube-config-v2')
                KAPP_NAMESPACE = 'default'
            }
            steps {
                container ('carvel') {
                    sh "kapp deploy -y -a cert-manager.kapp -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml"
                    sh "kapp deploy -y -a self-signed.kapp -f infrastructure/cert-manager/k8s/"
                }
            }
        }
        // stage('Install Nexus') {
        //     agent {
        //         kubernetes {
        //             yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
        //         }
        //     }
        //     environment {
        //         KAPP_KUBECONFIG = credentials('kube-config-v2')
        //         KAPP_NAMESPACE = 'default'
        //     }
        //     steps {
        //         container ('carvel') {
        //             sh "echo Placeholder"
        //         }
        //     }
        // }
        stage('Harbor Check') {
            agent none
            input {
                 message '''
                            Did you create a Harbor project named "my-repo" accessible at harbor.127.0.0.1.nip.io:8443?
                            Also, be sure to run the harborPullSecretSetup script.
                            '''
                ok "Okay, time to create containers then!"
            }
            steps {
                echo "Confirmed Harbor Repo exists."
            }
        }
        stage('Build Containers') {
            // when { 
            //     beforeAgent true
            //     branch 'master' 
            // }
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
                    agent {
                        kubernetes {
                            yamlFile 'infrastructure/jenkins/buildYamls/kaniko_pod.yaml'
                        }
                    }
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
        stage('Deploy Dashboard-Web') {
            agent {
                kubernetes {
                    yamlFile 'infrastructure/jenkins/buildYamls/carvel_tools.yaml'
                }
            }
            environment {
                KAPP_KUBECONFIG = credentials('kube-config-v2')
                KAPP_NAMESPACE = 'default'
            }
            steps {
                container ('carvel') {
                    sh "kapp deploy -y -a dashboard-web -f dashboard-web/app/"
                }
            }
        }


    }
}


