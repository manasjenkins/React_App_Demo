pipeline {
  agent any
    
  tools {nodejs "node"}
    
  stages {
        
    stage('Cloning Git') {
      steps {
        git 'https://github.com/manas82/David_task.git'
      }
    }

    stage('Code Linting') {
      steps {
        sh 'npm test'
      }
    }
     
    stage('Install dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('NPM Audit') {
      steps {
        sh 'npm audit'
      }
    }  

    stage('Test before Build') {
      steps {
        sh 'npm test a'
      }
    }

    stage('Building Build Package') {
      steps {
        sh 'npm run-script build'
      }
    }
    
    stage('Building Docker container') {
      steps {
        sh 'docker build -t manasapp"$BUILD_NUMBER"/manasmc:latest .'
     }
    }

    stage('Dcker Image Security check') {
      steps {
        sh '''
        docker run -i --net host --pid host --userns host --cap-add audit_control \
    -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
    -v /etc:/etc \
    -v /usr/bin/docker-containerd:/usr/bin/docker-containerd \
    -v /usr/bin/docker-runc:/usr/bin/docker-runc \
    -v /usr/lib/systemd:/usr/lib/systemd \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --label docker_bench_security \
    docker/docker-bench-security
    '''
     }
    }
    stage('Testing App') {
      steps {
        sh 'docker run  -d -p 8020:80 --name webapptest"$BUILD_NUMBER" manasapp"$BUILD_NUMBER"/manasmc:latest'
        sh 'wget http://localhost:8020/'
     }
     
    }
    
    stage('Cleaning Testing Env') {
      steps {
        sh 'docker container stop webapptest"$BUILD_NUMBER"'
        sh 'docker container rm webapptest"$BUILD_NUMBER"'
     }
    }
    
    stage('Email') {
    steps {
        script {
            def mailRecipients = 'manasmc@gmail.com'
            def jobName = currentBuild.fullDisplayName
            emailext body: '''${SCRIPT, template="groovy-html.template"}''',
            mimeType: 'text/html',
            subject: "[Jenkins] ${jobName}",
            to: "${mailRecipients}",
            replyTo: "${mailRecipients}",
            recipientProviders: [[$class: 'CulpritsRecipientProvider']]
        }
      }
    }

    
   
  }
}