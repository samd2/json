pipeline {

    // agent {
    //     node {
    //         label 'jenkinspool1'
    //     }
    // }

    agent {
        docker { image 'ubuntu:24.04' }
    }

    options {
        buildDiscarder logRotator( 
            daysToKeepStr: '16', 
            numToKeepStr: '10'
        )
    }

    stages {
        
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
                sh """
                echo "Cleaned Up Workspace For Project"
                """
            }
        }

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
                mount | grep ^/dev/ | grep -v /etc | awk '{print ${3}}' || true
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

