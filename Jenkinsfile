def registry = 'https://vlx05.jfrog.io'
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
  stage("Jar Publish") {
    steps {
      script {
              echo '<--------------- Jar Publish Started --------------->'
                def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifact-cred"
                def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"; 
                // BUILD_ID, GIT_COMMIT are default jenkins env
                def uploadSpec = """{
                    "files": [
                      {
                        "pattern": "jarstaging/(*)",
                        "target": "libs-release-local/{1}",
                        "flat": "false",
                        "props" : "${properties}",
                        "exclusions": [ "*.sha1", "*.md5"]
                      }
                    ]
                }"""
                def buildInfo = server.upload(uploadSpec)
                buildInfo.env.collect()
                server.publishBuildInfo(buildInfo)
                echo '<--------------- Jar Publish Ended --------------->'  
      
      }
        }   
    }   
    }
  }