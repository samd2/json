# Use, modification, and distribution are
# subject to the Boost Software License, Version 1.0. (See accompanying
# file LICENSE.txt)
#
# Copyright Rene Rivera 2020.

# For Drone CI we use the Starlark scripting language to reduce duplication.
# As the yaml syntax for Drone CI is rather limited.
#
#
globalenv={'B2_CI_VERSION': '1', 'B2_VARIANT': 'release', 'B2_FLAGS': 'warnings=extra warnings-as-errors=on'}
linuxglobalimage="cppalliance/droneubuntu1804:multiarch"
windowsglobalimage="cppalliance/dronevs2019"

def main(ctx):
  return [
  # linux_cxx("armv8 Clang 12", "clang++-12", packages="clang-12 libstdc++-9-dev", llvm_os="focal", llvm_ver="12", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu2004:multiarch", environment={'B2_TOOLSET': 'clang-12', 'B2_CXXSTD': '17,20', 'DRONE_JOB_UUID': '7719a1c783'}, node={"arch": "arm64"}, globalenv=globalenv),
  linux_cxx("withlabels Clang 12", "clang++-12", packages="clang-12 libstdc++-9-dev", llvm_os="focal", llvm_ver="12", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu2004:1", environment={'B2_TOOLSET': 'clang-12', 'B2_CXXSTD': '17,20', 'DRONE_JOB_UUID': '7719a1c783'}, node={"foo": "bar"}, globalenv=globalenv),
  linux_cxx("without Clang 12", "clang++-12", packages="clang-12 libstdc++-9-dev", llvm_os="focal", llvm_ver="12", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu2004:1", environment={'B2_TOOLSET': 'clang-12', 'B2_CXXSTD': '17,20', 'DRONE_JOB_UUID': '7719a1c783'}, globalenv=globalenv),
  # linux_cxx("arm64 Clang 12", "clang++-12", packages="clang-12 libstdc++-9-dev", llvm_os="focal", llvm_ver="12", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu2004:multiarch", environment={'B2_TOOLSET': 'clang-12', 'B2_CXXSTD': '17,20', 'DRONE_JOB_UUID': '7719a1c783'}, arch="arm64", globalenv=globalenv),
  # linux_cxx("docs", "g++", packages="docbook docbook-xml docbook-xsl xsltproc libsaxonhe-java default-jre-headless flex libfl-dev bison unzip rsync", buildtype="docs", buildscript="drone", image="cppalliance/droneubuntu1804:multiarch", environment={'COMMENT': 'docs', 'DRONE_JOB_UUID': 'b6589fc6ab'},arch="arm64", globalenv=globalenv),
  linux_cxx("codecov", "g++-8", packages="g++-8", buildtype="codecov", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'codecov.io', 'LCOV_BRANCH_COVERAGE': '0', 'B2_CXXSTD': '11', 'B2_TOOLSET': 'gcc-8', 'B2_DEFINES': 'BOOST_NO_STRESS_TEST=1', 'CODECOV_TOKEN': {'from_secret': 'codecov_token'}, 'DRONE_JOB_UUID': '356a192b79'},arch="arm64", globalenv=globalenv),
  # linux_cxx("valgrind", "clang++-6.0", packages="clang-6.0 libc6-dbg libstdc++-8-dev", llvm_os="bionic", llvm_ver="6.0", buildtype="valgrind", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'valgrind', 'B2_TOOLSET': 'clang-6.0', 'B2_CXXSTD': '11,14', 'B2_DEFINES': 'BOOST_NO_STRESS_TEST=1', 'B2_VARIANT': 'debug', 'B2_TESTFLAGS': 'testing.launcher=valgrind', 'VALGRIND_OPTS': '--error-exitcode=1', 'DRONE_JOB_UUID': 'da4b9237ba'},arch="arm64", globalenv=globalenv),
  # linux_cxx("asan", "clang++-11", packages="clang-11 libstdc++-9-dev", llvm_os="bionic", llvm_ver="11", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'asan', 'B2_VARIANT': 'debug', 'B2_TOOLSET': 'clang-11', 'B2_CXXSTD': '17', 'B2_ASAN': '1', 'B2_DEFINES': 'BOOST_NO_STRESS_TEST=1', 'DRONE_EXTRA_PRIVILEGED': 'True', 'DRONE_JOB_UUID': '77de68daec'},arch="arm64", globalenv=globalenv, privileged=True),
  # linux_cxx("ubsan", "clang++-11", packages="clang-11 libstdc++-9-dev", llvm_os="bionic", llvm_ver="11", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'ubsan', 'B2_VARIANT': 'debug', 'B2_TOOLSET': 'clang-11', 'B2_CXXSTD': '17', 'B2_UBSAN': '1', 'B2_DEFINES': 'BOOST_NO_STRESS_TEST=1', 'DRONE_JOB_UUID': '1b64538924'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 4.8 C++03 (no op)", "g++-4.8", packages="g++-4.8", image="cppalliance/droneubuntu1404:multiarch", buildtype="boost", buildscript="drone", environment={"B2_TOOLSET": "gcc-4.8", "B2_CXXSTD": "03"},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 4.8", "g++-4.8", packages="g++-4.8", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu1404:multiarch", environment={'B2_TOOLSET': 'gcc-4.8', 'B2_CXXSTD': '11', 'DRONE_JOB_UUID': '0ade7c2cf9'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 4.9", "g++-4.9", packages="g++-4.9", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu1404:multiarch", environment={'B2_TOOLSET': 'gcc-4.9', 'B2_CXXSTD': '11', 'DRONE_JOB_UUID': 'b1d5781111'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 5", "g++-5", packages="g++-5", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'gcc-5', 'B2_CXXSTD': '11', 'DRONE_JOB_UUID': '17ba079149'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 6", "g++-6", packages="g++-6", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'gcc-6', 'B2_CXXSTD': '11,14', 'DRONE_JOB_UUID': '7b52009b64'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 7", "g++-7", packages="g++-7", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'gcc-7', 'B2_CXXSTD': '14,17', 'DRONE_JOB_UUID': 'bd307a3ec3'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 8", "g++-8", packages="g++-8", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'gcc-8', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': 'fa35e19212'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 9", "g++-9", packages="g++-9", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'gcc-9', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': 'f1abd67035'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 9 standalone", "g++-9", packages="g++-9", buildtype="standalone", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'standalone', 'CXX': 'g++-9', 'DRONE_JOB_UUID': '1574bddb75'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 10", "g++-10", packages="g++-10", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu2004:multiarch", environment={'B2_TOOLSET': 'gcc-10', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': '0716d9708d'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 10 standalone", "g++-10", packages="g++-10", buildtype="standalone", buildscript="drone", image="cppalliance/droneubuntu2004:multiarch", environment={'COMMENT': 'standalone', 'CXX': 'g++-10', 'DRONE_JOB_UUID': '9e6a55b6b4'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 10 cmake-superproject", "g++-10", packages="g++-10", image=linuxglobalimage, buildtype="cmake-superproject", buildscript="drone", environment={"COMMENT": "cmake-superproject", "CXX": "g++-10"},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 11", "g++-11", packages="g++-11", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu2004:multiarch", environment={'B2_TOOLSET': 'gcc-11', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': '0716d9708d'},arch="arm64", globalenv=globalenv),
  # linux_cxx("gcc 11 standalone", "g++-10", packages="g++-11", buildtype="standalone", buildscript="drone", image="cppalliance/droneubuntu2004:multiarch", environment={'COMMENT': 'standalone', 'CXX': 'g++-11', 'DRONE_JOB_UUID': '9e6a55b6b4'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 3.8", "clang++-3.8", packages="clang-3.8", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu1404:multiarch", environment={'B2_TOOLSET': 'clang-3.8', 'B2_CXXSTD': '11', 'DRONE_JOB_UUID': 'b3f0c7f6bb'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 4.0", "clang++-4.0", packages="clang-4.0 libstdc++-6-dev", llvm_os="xenial", llvm_ver="4.0", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu1604:multiarch", environment={'B2_TOOLSET': 'clang-4.0', 'B2_CXXSTD': '11,14', 'DRONE_JOB_UUID': '91032ad7bb'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 5.0", "clang++-5.0", packages="clang-5.0 libstdc++-7-dev", llvm_os="bionic", llvm_ver="5.0", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'clang-5.0', 'B2_CXXSTD': '11,14', 'DRONE_JOB_UUID': '472b07b9fc'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 6.0", "clang++-6.0", packages="clang-6.0 libc6-dbg libstdc++-8-dev", llvm_os="bionic", llvm_ver="6.0", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'clang-6.0', 'B2_CXXSTD': '14,17', 'DRONE_JOB_UUID': '12c6fc06c9'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 7", "clang++-7", packages="clang-7 libstdc++-8-dev", llvm_os="bionic", llvm_ver="7", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'clang-7', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': 'd435a6cdd7'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 8", "clang++-8", packages="clang-8 libstdc++-8-dev", llvm_os="bionic", llvm_ver="8", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'clang-8', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': '4d134bc072'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 9", "clang++-9", packages="clang-9 libstdc++-9-dev", llvm_os="bionic", llvm_ver="9", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'clang-9', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': 'f6e1126ced'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 9 standalone", "clang++-9", packages="clang-9 libstdc++-9-dev", llvm_os="bionic", llvm_ver="9", buildtype="standalone", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'standalone', 'CXX': 'clang++-9', 'DRONE_JOB_UUID': '887309d048'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 10", "clang++-10", packages="clang-10 libstdc++-9-dev", llvm_os="bionic", llvm_ver="10", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'clang-10', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': 'bc33ea4e26'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 10 standalone", "clang++-10", packages="clang-10 libstdc++-9-dev", llvm_os="bionic", llvm_ver="10", buildtype="standalone", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'standalone', 'CXX': 'clang++-10', 'DRONE_JOB_UUID': '0a57cb53ba'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 11", "clang++-11", packages="clang-11 libstdc++-9-dev", llvm_os="bionic", llvm_ver="11", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'B2_TOOLSET': 'clang-11', 'B2_CXXSTD': '17,2a', 'DRONE_JOB_UUID': '7719a1c782'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 11 standalone", "clang++-11", packages="clang-11 libstdc++-9-dev", llvm_os="bionic", llvm_ver="11", buildtype="standalone", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'standalone', 'CXX': 'clang++-11', 'DRONE_JOB_UUID': '22d200f867'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Clang 12", "clang++-12", packages="clang-12 libstdc++-9-dev", llvm_os="focal", llvm_ver="12", buildtype="boost", buildscript="drone", image="cppalliance/droneubuntu2004:multiarch", environment={'B2_TOOLSET': 'clang-12', 'B2_CXXSTD': '17,20', 'DRONE_JOB_UUID': '7719a1c783'},arch="arm64", globalenv=globalenv),
  # linux_cxx("Coverity", "g++", packages="", buildtype="coverity", buildscript="drone", image=linuxglobalimage, environment={'COMMENT': 'Coverity Scan', 'B2_TOOLSET': 'clang', 'DRONE_JOB_UUID': '632667547e'},arch="arm64", globalenv=globalenv),
  # windows_cxx("msvc-14.0", "", image="cppalliance/dronevs2015", buildtype="boost", buildscript="drone", environment={"B2_TOOLSET": "msvc-14.0", "B2_CXXSTD": "11,14"},arch="arm64", globalenv=globalenv),
  # windows_cxx("msvc-14.1", "", image="cppalliance/dronevs2017", buildtype="boost", buildscript="drone", environment={"B2_TOOLSET": "msvc-14.1", "B2_CXXSTD": "11,14,17"},arch="arm64", globalenv=globalenv),
  # windows_cxx("msvc-14.1 standalone", "msvc-14.1", image="cppalliance/dronevs2017", buildtype="standalone-windows", buildscript="drone", environment={"COMMENT": "standalone","CXX": "msvc-14.1"},arch="arm64", globalenv=globalenv),
  # windows_cxx("msvc-14.2", "", image="cppalliance/dronevs2019", buildtype="boost", buildscript="drone", environment={"B2_TOOLSET": "msvc-14.2", "B2_CXXSTD": "17,latest"},arch="arm64", globalenv=globalenv),
  # windows_cxx("msvc-14.2 standalone", "msvc-14.2", image="cppalliance/dronevs2019", buildtype="standalone-windows", buildscript="drone", environment={"COMMENT": "standalone","CXX": "msvc-14.2"},arch="arm64", globalenv=globalenv),
  # windows_cxx("msvc-14.3", "", image="cppalliance/dronevs2022:multiarch", buildtype="boost", buildscript="drone", environment={"B2_TOOLSET": "msvc-14.3", "B2_CXXSTD": "17,20"}, globalenv=globalenv)
  ]

# from https://github.com/boostorg/boost-ci
load("@boost_ci//ci/drone/:functions.star", "linux_cxx","windows_cxx","osx_cxx","freebsd_cxx")

# Generate pipeline for Linux platform compilers.

# def linux_cxx(name, cxx, cxxflags="", packages="", sources="", llvm_os="", llvm_ver="", arch="amd64", image="cppalliance/ubuntu16.04:1", buildtype="boost", buildscript="", environment={}, globalenv={}, triggers={ "branch": [ "master", "develop", "drone*", "bugfix/*", "feature/*", "fix/*", "pr/*" ] }, privileged=False):
#   environment_global = {
#       "TRAVIS_BUILD_DIR": "/drone/src",
#       "TRAVIS_OS_NAME": "linux",
#       "CXX": cxx,
#       "CXXFLAGS": cxxflags,
#       "PACKAGES": packages,
#       "SOURCES": sources,
#       "LLVM_OS": llvm_os,
#       "LLVM_VER": llvm_ver,
#       "DRONE_JOB_BUILDTYPE": buildtype
#       }
#   environment_global.update(globalenv)
#   environment_current=environment_global
#   environment_current.update(environment)
# 
#   if buildscript:
#     buildscript_to_run = buildscript
#   else:
#     buildscript_to_run = buildtype
# 
#   return {
#     "name": "Linux %s" % name,
#     "kind": "pipeline",
#     "type": "docker",
#     "trigger": triggers,
#     "platform": {
#       "os": "linux",
#       "arch": arch
#     },
#     "steps": [
#       {
#         "name": "Everything",
#         "image": image,
#         "privileged" : privileged,
#         "environment": environment_current,
#         "commands": [
# 
#           "echo '==================================> SETUP'",
#           "uname -a",
#           # Moved to Docker
#           # "apt-get -o Acquire::Retries=3 update && DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata && apt-get -o Acquire::Retries=3 install -y sudo software-properties-common wget curl apt-transport-https git make cmake apt-file sudo unzip libssl-dev build-essential autotools-dev autoconf libc++-helpers automake g++",
#           # "for i in {1..3}; do apt-add-repository ppa:git-core/ppa && break || sleep 10; done",
#           # "apt-get -o Acquire::Retries=3 update && apt-get -o Acquire::Retries=3 -y install git",
#           "BOOST_CI_ORG=sdarwin BOOST_CI_BRANCH=test6 && wget https://github.com/$BOOST_CI_ORG/boost-ci/archive/$BOOST_CI_BRANCH.tar.gz && tar -xvf $BOOST_CI_BRANCH.tar.gz && mv boost-ci-$BOOST_CI_BRANCH .drone/boost-ci && rm $BOOST_CI_BRANCH.tar.gz",
#           "echo '==================================> PACKAGES'",
#           # "./.drone/linux-cxx-install.sh",
#           "./.drone/boost-ci/ci/drone/linux-cxx-install.sh",
# 
#           "echo '==================================> INSTALL AND COMPILE'",
#           "./.drone/%s.sh" % buildscript_to_run,
#         ]
#       }
#     ]
#   }
# 
# 
