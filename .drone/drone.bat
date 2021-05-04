
@ECHO ON
setlocal enabledelayedexpansion

if "%DRONE_JOB_BUILDTYPE%" == "boost" (

echo '==================================> INSTALL'

REM git clone https://github.com/boostorg/boost-ci.git boost-ci-cloned --depth 1
REM testing
git clone -b test8 https://github.com/sdarwin/boost-ci.git boost-ci-cloned --depth 1
cp -prf boost-ci-cloned/ci .
rm -rf boost-ci-cloned
REM source ci/travis/install.sh
REM The contents of install.sh below:

for /F %%i in ("%DRONE_REPO%") do @set SELF=%%~nxi
SET BOOST_CI_TARGET_BRANCH=%DRONE_COMMIT_BRANCH%
SET BOOST_CI_SRC_FOLDER=%cd%

echo "Running common_install.bat"
call ci\common_install.bat
echo "Done with running common_install.bat"

echo "SELF with percentages:"
echo "%SELF%"
echo "SELF with exclamations"
echo "!SELF!"

echo "BOOST_ROOT with percentages:"
echo "%BOOST_ROOT%"
echo "BOOST_ROOT with exclamations"
echo "!BOOST_ROOT!"

echo '==================================> COMPILE'

call !BOOST_ROOT!\libs\!SELF!\ci\build.bat

) else if "%DRONE_JOB_BUILDTYPE%" == "standalone-windows" (

echo '==================================> INSTALL'

REM Installing cmake with choco in the Dockerfile, so not required here:
REM choco install cmake

echo '==================================> COMPILE'

set CXXFLAGS="/std:c++17"
mkdir __build_17
cd __build_17
cmake -DBOOST_JSON_STANDALONE=1 ..
cmake --build .
ctest -V -C Debug .
set CXXFLAGS="/std:c++latest"
mkdir ..\__build_2a
cd ..\__build_2a
cmake -DBOOST_JSON_STANDALONE=1 ..
cmake --build .
ctest -V -C Debug .
)
