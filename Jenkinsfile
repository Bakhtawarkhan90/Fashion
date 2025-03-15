pipeline {
    agent any
    environment {
        SONAR_HOME = tool "Sonar"
        GITHUB_TOKEN = credentials('GithubToken')  // Use a Jenkins credential for GitHub PAT
        GITHUB_USERNAME = 'Bakhtawarkhan90'   // Replace with your GitHub username
    }
    stages {
        stage("Workspace Clean-up") {
            steps {
                script {
                    cleanWs()
                }
            }
        }
        stage("Cloning Code") {
            steps {
                git url: "https://github.com/Bakhtawarkhan90/Fashion.git", branch: "main"
            }
        }
        stage("Sonarqube Code Analysis") {
            steps {
                withSonarQubeEnv("Sonar") {
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=Fashion -Dsonar.projectKey=Fashion -X"
                }
            }
        }
        stage("Download SonarQube Report") {
            steps {
                script {
                    sh """
                    curl -u admin:admin "http://localhost:9000/api/measures/component?component=YourProjectKey&metricKeys=bugs,vulnerabilities,code_smells,coverage,duplicated_lines_density" -o sonar-report.json
                    """
                }
            }
        }
        stage("Docker Image Building") {
            steps {
                sh "docker build . -t fashion:latest"
            }
        }
        stage('Trivy Image Scanning') {
            steps {
                echo "Trivy Image Scanning"
                retry(3) {
                    sh 'trivy image fashion:latest || sleep 60'
                }
            }
        }
        stage("Push Docker-Hub") {
            steps {
                withCredentials([usernamePassword(credentialsId: "dockerHub", passwordVariable: "dockerHubPass", usernameVariable: "dockerHubUser")]) {
                    sh "echo \$dockerHubPass | docker login -u \$dockerHubUser --password-stdin"
                    sh "docker tag fashion:latest ${env.dockerHubUser}/fashion:latest"
                    sh "docker push ${env.dockerHubUser}/fashion:latest"
                }
            }
        }
        stage('OWASP DC') {
            steps {
                dependencyCheck additionalArguments: '--scan .', odcInstallation: 'OWASP'
                  dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("Deploy On K8s") {
            steps {
                sh "cd /var/lib/jenkins/workspace/fashion/k8s"
                sh " kubectl delete -f . f"
                sh " kubectl apply -f . "
            }
        }
    }
    post {
        success {
            mail to: 'royalbakhtawar@gmail.com',
                subject: "Pipeline Success: ${currentBuild.fullDisplayName}",
                body: "The Pipeline '${env.JOB_NAME}' has successfully completed.\n" +
                      "Check it here: ${env.BUILD_URL}"
        }
        failure {
            mail to: 'royalbakhtawar@gmail.com',
                subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                body: "The Pipeline '${env.JOB_NAME}' has failed.\n" +
                      "Check it here: ${env.BUILD_URL}"
        }
    }
}
