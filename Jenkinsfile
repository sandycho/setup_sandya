pipeline {
	agent any
	
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