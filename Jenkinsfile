pipeline {

    // agent {
    //     node {
    //         label 'jenkinspool1'
    //     }
    // }

    agent {
        docker {
          image 'cppalliance/boost_superproject_build:24.04-v1'
          label 'jenkinspool1'
          }
    }

    stages {
        
    //    stage('Cleanup Workspace') {
    //        steps {
    //            cleanWs()
    //            sh """
    //            echo "Cleaned Up Workspace For Project"
    //            """
    //            checkout scm
    //        }
    //    }

    //  stage('Code Checkout') {
    //      steps {
    //          checkout([
    //              $class: 'GitSCM', 
    //              branches: [[name: '*/main']], 
    //              userRemoteConfigs: [[url: 'https://github.com/spring-projects/spring-petclinic.git']]
    //          ])
    //      }
    //  }

        stage('Unit Testing') {
            steps {
                sh '''#!/bin/bash
                set -xe
                ls -al || true
                cat /etc/os-release || true
                echo "Running Unit Tests" || true
                pwd || true
                env || true
                whoami || true
                touch $(date "+%A-%B-%d-%T-%y") || true
                mount | grep ^/dev/ | grep -v /etc | awk '{print \$3}' || true
                echo "git branch"
                git branch
                echo "git branches"
                git branch -avv
                ''' 
            }
        }


        stage('Deploy To Staging and Pre-Prod Code') {
            when {
                branch 'develop'
            }
            steps {
                sh '''#!/bin/bash
                set -xe
                echo "Building Artifact for Staging and Pre-Prod Environments"
                env
                mount | grep ^/dev/ | grep -v /etc | awk '{print ${3}}' || true
                '''
                sh """
                echo "Deploying to Staging Environment"
                """
                sh """
                echo "Deploying to Pre-Prod Environment"
                """
            }
        }

    }   

}

