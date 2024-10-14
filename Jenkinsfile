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

        stage('Diagnostics') {
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

                export pythonvirtenvpath=/opt/venvboostdocs
                if [ -f ${pythonvirtenvpath}/bin/activate ]; then
                    source ${pythonvirtenvpath}/bin/activate
                fi 
                
                if false ; then
                    echo "Starting check to see if docs have been updated."
                    git fetch origin
                    mergebase=$(git merge-base HEAD remotes/origin/develop)
                    counter=0
                    for i in $(git diff --name-only HEAD $mergebase)
                    do
                      echo "file is $i"
                      if [[ $i =~ ^doc/ ]]; then
                        counter=$((counter+1))
                      fi
                    done
                
                    if [ "$counter" -eq "0" ]; then
                      echo "No docs found. Exiting."
                      exit 1
                    else
                      echo "Found $counter docs. Proceeding."
                    fi
                fi
                
                # testing:
                # curl -s -S --retry 10 -L -o linuxdocs.sh https://github.com/boostorg/release-tools/raw/develop/build_docs/linuxdocs.sh
                curl -s -S --retry 10 -L -o linuxdocs.sh https://github.com/sdarwin/release-tools/raw/build_docs8/build_docs/linuxdocs.sh
                chmod 755 linuxdocs.sh
                ./linuxdocs.sh --boostrootsubdir --skip-packages
                ''' 
            }
        }

    }   

}

