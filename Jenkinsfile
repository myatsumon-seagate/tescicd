// node {
//    def commit_id
//    stage('Preparation') {
//      checkout scm
//      sh "git rev-parse --short HEAD > .git/commit-id"                        
//      commit_id = readFile('.git/commit-id').trim()
//    }
//    stage('Testing') {
//      nodejs(nodeJSInstallationName: 'NodeJS') {
//        sh 'npm install --only=dev'
//        sh 'npm test'
//      }
//    }
//    stage('Build and publish') {
     
//         docker.withRegistry('https://index.docker.io/v1/', 'sumon-dockerhub') {
//         def customImage = docker.build("myatsumon/testcicd:${commit_id}")
//         customImage.push()
//         customImage.push('latest')
//       }

//    }
   
// }

// node('dind') {
//     // writeFile file: 'Dockerfile', text: 'FROM scratch'
//      container('docker') {
//        //def commit_id
//        stage('Preparation') {
//           checkout scm
//           //sh "git rev-parse --short HEAD > .git/commit-id"                        
//           //commit_id = readFile('.git/commit-id').trim()
//         }
//         stage('Build and publish') {
     
//           //sh 'sleep 10 && docker version && DOCKER_BUILDKIT=1 docker build --progress plain -t registry.gitlab.com/lyvesaas/registry/sumon:testcicd .'
//           sh '''

//             sleep 10
//             docker login registry.gitlab.com --username myat86@gmail.com --password _1FuNQ7rjnXwo86hpCDk
//             DOCKER_BUILDKIT=1 docker build --progress plain -t registry.gitlab.com/lyvesaas/registry/sumon:testcicd .
//             trivy --version

//           '''
//             // docker.withRegistry('registry.gitlab.com', '3101d702-e282-4378-97cd-92313e579d61') {
//             // def customImage = docker.build("myatsumon/testcicd:latest")
//             // customImage.push()
//             // customImage.push('latest')
//           }
//     }
//     container('trivy') {
//         stage("Step 1"){
//             sh 'echo hello'
//         }
//         stage("Step 2"){
//             sh 'trivy --version'
//         }
        
//     }
// }


pipeline {
  agent {
    kubernetes {
	  inheritFrom 'dind'
    }
  }
  environment {
        COMMIT-ID = '' 
  }
  stages {
     
    stage('Build') {
      steps {
        
        checkout scm
        sh "git rev-parse --short HEAD > .git/commit-id"   
        COMMIT-ID = readFile('.git/commit-id').trim()
        container('docker') {
          
            
          
            sh '''

              sleep 10
              docker login registry.gitlab.com --username myat86@gmail.com --password _1FuNQ7rjnXwo86hpCDk
              DOCKER_BUILDKIT=1 docker build --progress plain -t registry.gitlab.com/lyvesaas/registry/sumon-testcicd:${COMMIT-ID} .
            '''
              
   
          }
        }
      }
    stage("Test"){
        steps {
            container('docker'){
                sh 'docker images'
            }
        }
    }
    stage("Scan for vulnerabilities"){
        steps {
            container('trivy'){
                sh 'trivy image registry.gitlab.com/lyvesaas/registry/sumon-testcicd:${COMMIT-ID}'
            }
        }
    }    
  }
}