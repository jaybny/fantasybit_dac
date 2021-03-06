echo Available processor count: %NUMBER_OF_PROCESSORS%
echo Starting build # %BUILD_NUMBER%
cd bitshares_toolkit
rem git reset --hard
rem git pull
rem reset and pull not needed because we assume
rem that bitshares_toolkit was just cloned fresh
git submodule init || exit /b 21
git submodule update || exit /b 22

cd %WORKSPACE%
cd bitshares_toolkit/vendor
if exist leveldb-win (
    pushd leveldb-win
    git reset --hard || exit /b 23
    git pull || exit /b 24
) else (
    git clone https://www.github.com/InvictusInnovations/leveldb-win.git || exit /b 25
)

cd %WORKSPACE%
call bitshares_toolkit/setenv_x64.bat || exit /b 26
call "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64 || exit /b 29
if exist build (
  rmdir /Q /S build || exit /b 27
)
mkdir build
cd build
cmake -G "Visual Studio 12 Win64" ../bitshares_toolkit || exit /b 28
msbuild.exe /M:%NUMBER_OF_PROCESSORS% /p:Configuration=RelWithDebinfo /p:Platform=x64 /target:rebuild /clp:ErrorsOnly BitShares.sln || exit /b 30
