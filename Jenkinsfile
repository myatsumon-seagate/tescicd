node {
   def commit_id
   stage('Preparation') {
     checkout scm
     sh "git rev-parse --short HEAD > .git/commit-id"                        
     commit_id = readFile('.git/commit-id').trim()
   }
   stage('test') {
     nodejs(nodeJSInstallationName: 'NodeJS') {
       sh 'npm install --only=dev'
       sh 'npm test'
     }
   }
   stage('docker build/push') {
    //  docker.withRegistry('https://index.docker.io/v1/', 'c57062ec-6179-4cbc-b45d-dbed8507d8ec') {
    //    def app = docker.build("myatsumon/testcicd:${commit_id}", '.').push()
    //  }
     def customImage = docker.build("myatsumon/testcicd:${commit_id}")
     customImage.push()
     customImage.push('latest')

   }
}