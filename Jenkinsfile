pipeline {

    // agent {
    //     node {
    //         label 'jenkinspool1'
    //     }
    // }

    agent {
        docker {
          image 'cppalliance/boost_superproject_build:24.04-v1'
          // label 'jenkinspool1'
          }
    }

    stages {

         stage('Preclean Workspace') {
             steps {
                 sh """#!/bin/bash
                 set -xe
                 rm -rf *
                 """
                 checkout scm
             }
         }
         stage('Set Variables') {
             steps {
                sh '''#!/bin/bash -xe
                echo "" > jenkinsjobinfo.sh
                chmod 777 jenkinsjobinfo.sh
                REPONAME=$(basename -s .git "$(git config --get remote.origin.url)")
                # REPONAME=$(basename `git rev-parse --show-toplevel`)
                DNSREPONAME=$(echo $REPONAME | tr '_' '-')
                ORGANIZATION=$(basename $(dirname "${GIT_URL}"))
                echo "REPONAME=${REPONAME}" >> jenkinsjobinfo.sh
                echo "DNSREPONAME=${DNSREPONAME}" >> jenkinsjobinfo.sh
                echo "ORGANIZATION=${ORGANIZATION}" >> jenkinsjobinfo.sh
                '''
             }
         }

        stage('Diagnostics') {
            steps {
                sh '''#!/bin/bash
                set -xe
                 . jenkinsjobinfo.sh
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


        stage('Build develop or master branch') {
            when {
                anyOf{
                    branch 'develop'
                    branch 'master'
                    }
            } 

            environment {
                // See https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#using-environment-variables
                // REPONAME = 'json'
                // DNSREPONAME = 'json'

                 REPONAME = """${sh(
                 returnStdout: true,
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo "${REPONAME}"'
             )}"""
                 DNSREPONAME = """${sh(
                 returnStdout: true,
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo "${DNSREPONAME}"'
             )}"""

             //     MYVAR1 = """${sh(
             //     returnStdout: true,
             //     script: 'myvar1=$(pwd); echo "${myvar1}"'
             // )}"""
             //     MYVAR2 = """${sh(
             //     returnStdout: true,
             //     script: 'myvar2=$(ls); echo ${myvar2}'
             // )}"""


            }           

            steps {
                sh '''#!/bin/bash
                set -xe

                # echo "myvar1 is ${MYVAR1}"
                # echo "myvar2 is ${MYVAR2}"
                . jenkinsjobinfo.sh
                export pythonvirtenvpath=/opt/venvboostdocs
                if [ -f ${pythonvirtenvpath}/bin/activate ]; then
                    source ${pythonvirtenvpath}/bin/activate
                fi

                curl -s -S --retry 10 -L -o linuxdocs.sh https://github.com/boostorg/release-tools/raw/develop/build_docs/linuxdocs.sh
                chmod 755 linuxdocs.sh
                ./linuxdocs.sh --boostrootsubdir --skip-packages
                '''
                // There are multiple plugins. This is the s3 plugin
                // s3Upload entries: [[ sourceFile: "boost-root/libs/${REPONAME}/doc/html/**",  bucket: "cppalliance-websites/${BRANCH_NAME}.${DNSREPONAME}.cpp.al", selectedRegion: 'us-east-1' ]], profileName: "cppalliance-bot-profile", userMetadata: [], dontWaitForConcurrentBuildCompletion: false, consoleLogLevel: 'INFO', pluginFailureResultConstraint: 'FAILURE', dontSetBuildResultOnFailure: false

                // aws-pipeline-plugin
                withAWS(region:'eu-east-1', credentials: 'cppalliance-bot-aws-user') {
                   s3Upload(bucket:"cppalliance-websites", path:"${BRANCH_NAME}.${DNSREPONAME}.cpp.al", includePathPattern:'boost-root/libs/${REPONAME}/doc/html/**')
                }
            }
        }
    }
}
