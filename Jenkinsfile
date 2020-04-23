node {
  def app

  stage('Clone repository') {
    checkout scm
  }

  stage('Build image') {
    app = docker.build("soapbubble/hello-splice", "./hello-world")
  }

  stage('Push image') {
    docker.withRegistry('https://registry.hub.docker.com', '263d87fe-fcb5-4cdb-8a27-4c1148c376c0') {
      app.push("${env.BUILD_NUMBER}")
      app.push("latest")
    }
  }

  stage('Plan deployment') {
      sh './aws-manifest/build.sh'
  }
}