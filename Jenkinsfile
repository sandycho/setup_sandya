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
	}
}