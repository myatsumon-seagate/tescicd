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
     
        docker.withRegistry('https://index.docker.io/v1/', 'sumon-dockerhub') {
        def customImage = docker.build("myatsumon/testcicd:${commit_id}")
        customImage.push()
        customImage.push('latest')
      }

   }
   stage('Test and Scan Build Image') {
      
              cleanWs()
   

   }
   post('Clean Pipeline'){
     // Clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
   }
}
