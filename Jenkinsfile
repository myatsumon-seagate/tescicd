node {
   def commit_id
   stage('Preparation') {
     checkout scm
     sh "git rev-parse --short HEAD > .git/commit-id"                        
     commit_id = readFile('.git/commit-id').trim()
   }
   stage('Testing') {
     nodejs(nodeJSInstallationName: 'NodeJS') {
       sh 'npm install --only=dev'
       sh 'npm test'
     }
   }
   stage('Build and publish') {
     
        docker.withRegistry('registry.gitlab.com', 'sumon-gitlab') {
        def customImage = docker.build("registry.gitlab.com/lyvesaas/registry/sumon-cicd:${commit_id}")
        customImage.push()
        customImage.push('latest')
      }

   }
   
}
