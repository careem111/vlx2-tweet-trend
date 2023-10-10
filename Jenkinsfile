pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        metadata:
            name: build-agent
            labels:
                app: build-agent
        spec:
          serviceAccount: jenkins-admin
          containers:
          - name: build-agent
            image: careem785/jenkins-build-agent:2.0
            command: 
             - cat
            tty: true
            volumeMounts:
            - name: dockersock
              mountPath: /var/run/docker.sock
          volumes:
          - name: dockersock
            hostPath:
              path: /var/run/docker.sock  
      '''
        }
  }
environment {
          PATH = "/opt/apache-maven-3.9.2/bin:$PATH"
}
    stages {
      stage('build'){
        steps {
          container('build-agent'){
          sh 'mvn clean deploy'
        }
      }
      }

    stage('SonarQube analysis'){
    environment {
      scannerHome = tool 'vlx2-sonar-scanner'
    }
    steps {
      container('build-agent'){
      withSonarQubeEnv('vlx2-sonarqube-server')
      sh "${scannerHome}/bin/sonar-scanner"
    }
    }

    }
    }
}