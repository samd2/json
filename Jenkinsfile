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
                set -x
                # not set -e. errors may occur in diagnostics
                cat jenkinsjobinfo.sh
                . jenkinsjobinfo.sh
                ls -al
                cat /etc/os-release
                pwd
                env 
                whoami
                touch $(date "+%A-%B-%d-%T-%y") || true
                mount | grep ^/dev/ | grep -v /etc | awk '{print \$3}' || true
                echo "git branch"
                git branch
                echo "git branches"
                git branch -avv
                true
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
                 REPONAME = """${sh(
                 returnStdout: true,
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo -n "${REPONAME}"'
             )}"""
                 DNSREPONAME = """${sh(
                 returnStdout: true,
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo -n "${DNSREPONAME}"'
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
                mkdir -p boost-root/libs/${REPONAME}/doc/html
                echo "qwerty" > boost-root/libs/${REPONAME}/doc/html/index.html
                mkdir -p boost-root/doc
                echo "qwerty" > boost-root/doc/index.html
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
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo -n "${REPONAME}"'
             )}"""
                 DNSREPONAME = """${sh(
                 returnStdout: true,
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo -n "${DNSREPONAME}"'
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
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo -n "${REPONAME}"'
             )}"""
                 DNSREPONAME = """${sh(
                 returnStdout: true,
                 script: '#!/bin/bash \n' + 'source jenkinsjobinfo.sh; echo -n "${DNSREPONAME}"'
             )}"""

            }

            steps {
                withAWS(region:'us-east-1', credentials: 'cppalliance-bot-aws-user') {

                    s3Upload(bucket:"cppalliance-previews", path:"${DNSREPONAME}/${CHANGE_ID}/doc/",  workingDir: "boost-root/doc" , includePathPattern:"**")
                    // s3Upload(bucket:"cppalliance-previews", path:"${DNSREPONAME}/${CHANGE_ID}/doc/",  workingDir: "boost-root/doc" , includePathPattern:"**/*")
                    s3Upload(bucket:"cppalliance-previews", path:"${DNSREPONAME}/${CHANGE_ID}/libs/${REPONAME}/doc/", workingDir: "boost-root/libs/${REPONAME}/doc", includePathPattern:"**")
                    // s3Upload(bucket:"cppalliance-previews", path:"${DNSREPONAME}/${CHANGE_ID}/libs/${REPONAME}/doc/", workingDir: "boost-root/libs/${REPONAME}/doc", includePathPattern:"**/*")

                }
                script {
                    pullRequest.comment("An automated preview of the documentation is available at [https://${env.CHANGE_ID}.${env.DNSREPONAME}.prtest.cppalliance.org/libs/${env.REPONAME}/doc/html/index.html](https://${env.CHANGE_ID}.${env.DNSREPONAME}.prtest.cppalliance.org/libs/${env.REPONAME}/doc/html/index.html)")
                }
            }
        }
    }
}
