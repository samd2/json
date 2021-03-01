
echo '==================================> INSTALL'

git clone https://github.com/boostorg/boost-ci.git boost-ci-cloned --depth 1
cp -prf boost-ci-cloned/ci .
rm -rf boost-ci-cloned
# source ci/travis/install.sh
# The contents of install.sh below:

#export SELF=`basename $DRONE_REPO`
#export BOOST_CI_TARGET_BRANCH="$DRONE_COMMIT_BRANCH"
#export BOOST_CI_SRC_FOLDER=$(pwd)
#. ./ci/common_install.sh

for /F %%i in ("%DRONE_REPO%") do @set SELF=%%~nxi
echo SELF is %SELF%
SET BOOST_CI_TARGET_BRANCH=%DRONE_COMMIT_BRANCH%
echo BOOST_CI_TARGET_BRANCH is %BOOST_CI_TARGET_BRANCH%
pwd > tmpFile
SET /p BOOST_CI_SRC_FOLDER= < tmpFile
DEL tmpFile
echo BOOST_CI_SRC_FOLDER is %BOOST_CI_SRC_FOLDER%

ci\common_install.bat

echo '==================================> COMPILE'

#$BOOST_ROOT/libs/$SELF/ci/travis/build.sh

%BOOST_ROOT%\libs\%SELF%\ci\travis\build.bat
