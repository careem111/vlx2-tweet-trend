def registry = 'https://vlx.jfrog.io'
def imageName = 'vlx.jfrog.io/vlx2-docker-local/ttrend'
def version   = "${env.BUILD_ID}"


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
  // stage("Quality Gate"){
  //   steps{
  //     script{
  //       timeout(time: 0.1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
  //         def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
  //         if (qg.status != 'OK') {
  //           error "Pipeline aborted due to quality gate failure: ${qg.status}"
  //             }
  //          }
  //     }
  // }
  //     }
  stage("Jar Publish") {
    steps {
      script {
              echo '<--------------- Jar Publish Started --------------->'
                def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifact-cred"
                def properties = "buildid=${env.BUILD_ID},commitid=${env.GIT_COMMIT}"; 
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
  
    stage(" Docker Build ") {
      steps {
        
        script {
          def mavenPom = readMavenPom file: 'pom.xml'
           echo '<--------------- Docker Build Started --------------->'
           app = docker.build(imageName+":"+mavenPom.version, "--build-arg VERSION=${mavenPom.version} .")
           echo '<--------------- Docker Build Ends --------------->'
        }
      }
    }

    stage (" Docker Publish "){
      steps {
          script {
              echo '<--------------- Docker Publish Started --------------->'  
              docker.withRegistry(registry, 'artifact-cred'){
                  app.push()
              }    
              echo '<--------------- Docker Publish Ended --------------->'  
            }
        }
      }

    stage('Helm Chart'){
      steps{
        script{
          def mavenPom = readMavenPom file: 'pom.xml'
          dir('helm') {
            withCredentials([usernamePassword(credentialsId: 'jfrog-cred', usernameVariable: 'username', passwordVariable: 'password')]) {
            sh 'helm package ttrend --version ' + mavenPom.version
            sh "helm push-artifactory tweet-cd-${mavenPom.version}.tgz https://vlx.jfrog.io/artifactory/vlx2-helm-local/ --username $username  --password $password"
                }
            }
            }
        }
      }

    stage ('Invoke_tweet-trend-deploy-eks') {
            steps {
                build job: 'tweet-trend-deploy-eks'
            }
        }

    
    }
}