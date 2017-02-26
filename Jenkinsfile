pipeline {
	agent { docker 'ubuntu:14.04' }
	
	stages {
		stage('Build') {
            steps {
                echo 'Building..'
				
				sh './setup_sandya.sh'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
				sh './setup_sandya.sh'
            }
        }
		
		post {
			always {
				sh 'This will always run'
			}
			success {
				sh 'This will run only if successful'
			}
			failure {
				sh 'This will run only if failed'
				mail to: 'sandy.chuchuca@gmail.com',
				 subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
				 body: "Something is wrong with ${env.BUILD_URL}"
			}
			unstable {
				sh 'This will run only if the run was marked as unstable'
			}
			changed {
				sh 'This will run only if the state of the Pipeline has changed'
				sh 'For example, the Pipeline was previously failing but is now successful'
			}
		}
	}
}