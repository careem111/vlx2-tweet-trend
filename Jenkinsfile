pipeline {   
   agent any
   tools {
        maven 'maven'
    }

stages {
      stage('build'){
        steps {
          echo "-------------------------------build started---------------------------"
          sh 'mvn clean deploy -Dmaven.test.skip=true'
          echo "-------------------------------build started---------------------------"
      }
      }
    stage("Test"){
        steps{
          echo "-------------------------------build started---------------------------"
          sh 'mvn surefire-report:report'
          echo "-------------------------------build started---------------------------"
        }
    }

  stage('SonarQube analysis'){
    environment {
      scannerHome = tool 'vlx2-sonar-scanner'
    }
    steps {
    withSonarQubeEnv('vlx2-sonarqube-server'){
      sh "${scannerHome}/bin/sonar-scanner"
    }

    }
    }
  stage("Quality Gate"){
    steps{
      script{
        timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
          def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
          if (qg.status != 'OK') {
            error "Pipeline aborted due to quality gate failure: ${qg.status}"
              }
           }
      }
  }
      }
    }
  }