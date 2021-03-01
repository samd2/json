
echo '==================================> INSTALL'

REM git clone https://github.com/boostorg/boost-ci.git boost-ci-cloned --depth 1
git clone -b test1 https://github.com/sdarwin/boost-ci.git boost-ci-cloned --depth 1
cp -prf boost-ci-cloned/ci .
rm -rf boost-ci-cloned
REM source ci/travis/install.sh
REM The contents of install.sh below:

REM export SELF=`basename $DRONE_REPO`
REM export BOOST_CI_TARGET_BRANCH="$DRONE_COMMIT_BRANCH"
REM export BOOST_CI_SRC_FOLDER=$(pwd)
REM . ./ci/common_install.sh

for /F %%i in ("%DRONE_REPO%") do @set SELF=%%~nxi
echo SELF is %SELF%
SET BOOST_CI_TARGET_BRANCH=%DRONE_COMMIT_BRANCH%
SET BOOST_CI_SRC_FOLDER=%cd%
echo BOOST_CI_SRC_FOLDER is %BOOST_CI_SRC_FOLDER%

echo "Outside of common_install.bat. Starting."
call ci\common_install.bat
echo "Outside of common_install.bat. Ending."

echo '==================================> COMPILE'

REM $BOOST_ROOT/libs/$SELF/ci/travis/build.sh

call %BOOST_ROOT%\libs\%SELF%\ci\travis\build.bat
