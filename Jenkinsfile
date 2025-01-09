pipeline {
    agent any

    stages {
        stage('Code CheckOut') {
            steps {
                git branch: 'main', url: 'https://github.com/mohangopi08/NodeDeployement.git'
            }
        }
        stage('Code Build') {
            steps {
                echo 'Build Artificat'
                sh 'npm install'
            }
        }
        stage('Code Test') {
            steps {
                echo 'Run Test Cases'
                sh 'npm test -- --passWithNoTests'
                
            }
        }
         stage('Build Image') {
            steps {
                echo 'Building Docker Image'
                sh 'sudo docker image prune -a -f'
                sh 'sudo docker build -t swargamgopi/nodeapp:${BUILD_NUMBER} . '
                
            }
        }
        stage('Docker Login') {
            steps{
            withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
               sh 'sudo docker login -u swargamgopi -p ${dockerhub}'
                 echo 'login into DockerHub'
            }
             
        }
    }
       stage('Push To DockerHub') {
            steps {
                sh 'sudo docker push swargamgopi/nodeapp:${BUILD_NUMBER}'
                echo 'Pushed to Docker Hub'
                
                
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH')]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ubuntu@13.203.161.234 \
                            'sudo docker pull swargamgopi/nodeapp:${BUILD_NUMBER} && sudo docker run -d -p 5000:5000 swargamgopi/nodeapp:${BUILD_NUMBER}'
                        """
                    }
                    echo 'Deployment to EC2 successful'
                }
            }
    
       
    }
}
}
