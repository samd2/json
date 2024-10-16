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

        stage('Build docs') {
            when {
                anyOf{
                    branch 'develop'
                    branch 'master'
                    expression { env.CHANGE_ID != null }
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
                # Only during testing, skip
                # ./linuxdocs.sh --boostrootsubdir --skip-packages
                mkdir -p doc/html
                echo "qwerty" > doc/html/index.html
                '''
                }
            }

        stage('Main branches: Upload to S3') {
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

            }

            steps {
                withAWS(region:'eu-east-1', credentials: 'cppalliance-bot-aws-user') {
                    s3Upload(bucket:"cppalliance-websites", path:"${BRANCH_NAME}.${DNSREPONAME}.cpp.al", includePathPattern:'boost-root/libs/${REPONAME}/doc/html/**')
                }
            }
        }


        stage('Pull requests: Upload to S3') {
            when { 
                anyOf{
                    expression { env.CHANGE_ID != null }
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

            }

            steps {
                withAWS(region:'us-east-1', credentials: 'cppalliance-bot-aws-user') {
                    s3Upload(bucket:"cppalliance-previews", path:"${REPONAME}/${CHANGE_ID}/doc", includePathPattern:'boost-root/doc/**')
                    s3Upload(bucket:"cppalliance-previews", path:"${REPONAME}/${CHANGE_ID}/libs/${REPONAME}/doc", includePathPattern:'boost-root/libs/${REPONAME}/doc/**')
                }
                script {
                    def commenter = pullRequest.comment('Test comment 1')
                    echo ${commenter}
                    pullRequest.comment('Test comment 2')
                    for (comment in pullRequest.comments) {
                        echo "Author: ${comment.user}, Comment: ${comment.body}"
                    }
                }
            }
        }
    }
}
