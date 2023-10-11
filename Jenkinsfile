pipeline {   
   agent any
   tools {
        maven 'maven'
    }

environment{
    PATH="/opt/apache-maven-3.9.5/bin:$PATH"
}
stages {
      stage('build'){
        steps {
          sh 'mvn clean deploy -Dmaven.test.skip=true'
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