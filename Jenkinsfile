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
     
     def customImage = docker.build("myatsumon/testcicd:${commit_id}")
     customImage.push()
     customImage.push('latest')

   }
   stage('Test and Scan Build Image') {
      steps {
              sh'''
              echo "Scan image using trivy"
              wget https://github.com/aquasecurity/trivy/releases/download/v0.19.2/trivy_0.19.2_Linux-64bit.tar.gz
              tar xzvf trivy_0.19.2_Linux-64bit.tar.gz
              ./trivy myatsumon/testcicd:${commit_id}
              '''
              cleanWs()
            }

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