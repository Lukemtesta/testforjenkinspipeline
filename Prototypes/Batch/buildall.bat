rem Build R6 repository and run unit test
@echo off
cls

rem Reference to HippoLibsR6 svn dir root
set SvnDir=%1
rem Reference to hippor6 repo root on disk
set BranchRootDir=%2
rem define to enable clean build 
set CleanBuild=%3

set VSSolutionDir=%BranchRootDir%\VSSolutions
set BinaryDir=%BranchRootDir%Build

echo "Svn:" %SvnDir%
echo "Hippo repo: %BranchRootDir%"
echo "Hippo binaries: %BinaryDir%"

rem Set environment vars 
SET HippoR6Libs=%SvnDir%

rem Clean repository
if not "%3"=="" echo "Clean Build Triggered" && rd /s /q "%BinaryDir%\debug" && rd /s /q "%BinaryDir%\release"

rem Set the failed bit. We will force build to stop on failure. Tests will continue 
set ERRORTEST=0

nuget.exe restore %VSSolutionDir%\HippoR6.sln || echo "Error(%ERRORLEVEL%): Nuget restore HippoR6.sln" && exit /b 1
MSBuild.exe -r %VSSolutionDir%\HippoR6.sln /p:Configuration=Debug || echo "Error(%ERRORLEVEL%): Building Debug HippoR6.sln" && exit /b 1
MSBuild.exe -r %VSSolutionDir%\HippoR6.sln /p:Configuration=Release || echo "Error(%ERRORLEVEL%): Building Release HippoR6.sln" && exit /b 1

rem Run C++ unit tests
for /r %BinaryDir%\debug\bin %%a in (*.test.exe) do "%%a" || echo "Error(%ERRORLEVEL%): Debug C++ unit test" && set ERRORTEST=1
for /r %BinaryDir%\release\bin %%a in (*.test.exe) do "%%a" || echo "Error(%ERRORLEVEL%): Release C++ unit test" && set ERRORTEST=1

rem Run C# unit tests 
for /r %BinaryDir%\debug\bin %%a in (*Tests.dll) do vstest.console.exe "%%a" || echo "Error(%ERRORLEVEL%): Debug C# unit test" && set ERRORTEST=1
for /r %BinaryDir%\release\bin %%a in (*Tests.dll) do vstest.console.exe "%%a" || echo "Error(%ERRORLEVEL%): Debug C# unit test" && set ERRORTEST=1

If %ERRORTEST%==1 echo [31mTests Failed[0m && exit /b 1
If %ERRORTEST%==0 echo [32mTests Passed[0m && exit /b 0

rem Usage: 
rem
rem C:\Users\pc\Documents\gh\git\HippoR6\Prototypes\Docker\devcmd.bat
rem buildall.bat C:\Users\pc\Documents\gh\svn C:\Users\pc\Documents\gh\git\HippoR6
