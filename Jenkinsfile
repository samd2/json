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
                REPONAME=$(basename `git rev-parse --show-toplevel`)
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
            steps {
                sh '''#!/bin/bash
                set -xe

                . jenkinsjobinfo.sh
                export pythonvirtenvpath=/opt/venvboostdocs
                if [ -f ${pythonvirtenvpath}/bin/activate ]; then
                    source ${pythonvirtenvpath}/bin/activate
                fi

                curl -s -S --retry 10 -L -o linuxdocs.sh https://github.com/boostorg/release-tools/raw/develop/build_docs/linuxdocs.sh
                chmod 755 linuxdocs.sh
                ./linuxdocs.sh --boostrootsubdir --skip-packages
                '''
                // s3Upload(bucket:"cppalliance-websites", path:"${BRANCH_NAME}.${DNSREPONAME}.cpp.al", includePathPattern:'boost-root/libs/${REPONAME}/doc/html/**', profile:"cppalliance-bot-profile")
                s3Upload( entries [[ bucket:"cppalliance-websites/${BRANCH_NAME}.${DNSREPONAME}.cpp.al", sourcefile:'boost-root/libs/${REPONAME}/doc/html/**', selectedregion: "us-east-1" ]], profilename:"cppalliance-bot-profile")
            }
        }
    }
}
