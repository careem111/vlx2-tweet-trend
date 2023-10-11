pipeline {   
   agent any
   tools {
        maven 'maven'
    }
stages {
      stage('build'){
        steps {
          sh 'mvn clean deploy'
      }
      }

    stage('SonarQube analysis'){
    environment {
      scannerHome = tool 'vlx2-sonar-scanner'
    }
    steps {
      withSonarQubeEnv('vlx2-sonarqube-server')
      sh "${scannerHome}/bin/sonar-scanner"
    }

    }
    }
}