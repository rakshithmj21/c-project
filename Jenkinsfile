
            
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rakshi21/k8s-cicd-demo"
        DOCKER_TAG = "latest"
        KUBECONFIG_CREDENTIAL = "kubeconfig-file" // optional: if Jenkins needs admin.conf
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ./app"
                }
            }
        }

        stage('Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DH_USER', passwordVariable: 'DH_PWD')]) {
                    sh 'echo $DH_PWD | docker login -u $DH_USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        /* Option A: If Jenkins has kubectl configured (kubeconfig in Jenkins home)
        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl set image deployment/k8s-cicd-demo web=${DOCKER_IMAGE}:${DOCKER_TAG} --record || true"
                sh "kubectl apply -f k8s/service.yaml || true"
                sh "kubectl rollout status deployment/k8s-cicd-demo --timeout=120s"
            }
        }
        */

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials(credentialsId: 'kubeconfig-file', variable: 'KUBECONFIG') {
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                    sh "kubectl set image deployment/k8s-cicd-demo web=${DOCKER_IMAGE}:${DOCKER_TAG} || true"
                    sh "kubectl rollout status deployment/k8s-cicd-demo --timeout=120s"
                }
            }
        }

        stage('Verify') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-file', variable: 'KUBECONFIG')]) {
                    sh "kubectl get pods -o wide"
                    sh "kubectl get svc k8s-cicd-demo-svc -o wide"
                }
            }
        }
    }

    post {
        always {
            sh "docker logout || true"
        }
   }
}
