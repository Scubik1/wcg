pipeline {
    agent any
    //options { timestamps() }
    environment {
        DOCKERHUB_CRED= credentials('dockerhub')
        APPNAME='wcg'
        K8S_URL='https://192.168.59.100:8443/'
        k8S_CRED='kubernetis'
        
    }
    stages{
        stage('Get code') {
            steps {
                git branch: "main", url: 'https://github.com/Scubik1/wcg.git/'
            }
        }
        stage('HadoLint') {
            steps {
                sh '''
                    wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 -O hadolint
                    chmod +x hadolint
                    ./hadolint Dockerfile
                '''
            }
        }
        stage('Build') {
            steps {
                sh '''
                    docker build -t $DOCKERHUB_CRED_USR/$APPNAME .
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''
                    docker run --rm --name wcg -d -p 8888:8888 $DOCKERHUB_CRED_USR/$APPNAME
                    res=`curl http://127.0.0.1:8888/version`
                    if [ "{ \\"version\\": \\"1.DEVELOPMENT\\" }" != "$res" ]; then
                      docker stop wcg
                      exit 99
                    fi
                    docker stop wcg
                '''
            }
        }
        stage('Push image') {
            steps {
                sh '''
                    echo $DOCKERHUB_CRED_PSW | docker login -u $DOCKERHUB_CRED_USR --password-stdin
                    docker push $DOCKERHUB_CRED_USR/$APPNAME:latest
                    docker logout
                '''
            }
        }
        stage('Deploy pre-production') {
            steps {
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '',
                    clusterName: 'minikube',
                    contextName: 'minikube',
                    credentialsId: "$K8S_CRED",
                    namespace: 'pre-production',
                    serverUrl: "$K8S_URL"
                    ]]) {
                        sh '''
                           curl -LO https://dl.k8s.io/release/v1.29.1/bin/linux/amd64/kubectl
                           chmod u+x kubectl
                           ./kubectl create -f .
                           sleep 30
                        '''
                    }
            }
        }
        stage('Test pre-production') {
            steps {
                sh '''
                    res=`curl http://wcg.local/version`
                    if [ "{ \\"version\\": \\"1.DEVELOPMENT\\" }" != "$res" ]; then
                      exit 99
                    fi
                '''
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '',
                    clusterName: 'minikube',
                    contextName: 'minikube',
                    credentialsId: "$K8S_CRED",
                    namespace: 'pre-production',
                    serverUrl: "$K8S_URL"
                    ]]) {
                        sh '''
                           ./kubectl delete -f .
                        '''
                    }
            }
        }
        stage('Deploy production') {
            steps {
                input 'Deployment to pre-production was successful. Test passed. Deploy to Production?'
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '',
                    clusterName: 'minikube',
                    contextName: 'minikube',
                    credentialsId: "$K8S_CRED",
                    namespace: 'production',
                    serverUrl: "$K8S_URL"
                    ]]) {
                        sh '''
                           ./kubectl create -f .
                        '''
                    }
            }
        }
    }
}
