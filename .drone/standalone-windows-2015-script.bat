
echo '==================================> BEFORE_INSTALL'

echo '==================================> INSTALL'

REM Installing cmake with choco in the Dockerfile, so not required here:
REM choco install cmake

echo '==================================> COMPILE'

set CXXFLAGS="/std:c++11"
mkdir __build_11
cd __build_11
cmake -DBOOST_JSON_STANDALONE=1 ..
cmake --build .
ctest -V -C Debug .
set CXXFLAGS="/std:c++14"
mkdir ..\__build_14
cd ..\__build_14
cmake -DBOOST_JSON_STANDALONE=1 ..
cmake --build .
ctest -V -C Debug .
