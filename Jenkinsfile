pipeline {

    agent {
        node {
            label 'jenkinspool1'
        }
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
                sh """
                echo "Running Unit Tests"
                pwd
                env
                whoami
                """
            }
        }


        stage('Deploy To Staging and Pre-Prod Code') {
            when {
                branch 'develop'
            }
            steps {
                sh '''#!/bin/bash
                echo "Building Artifact for Staging and Pre-Prod Environments"
                env
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

