rem @echo off
rem Installs binaries to right place.
if not defined TNT_ROOT (
   echo TNT_ROOT is not defined!
   echo Need to be running in a Frost shell, use Drone - Code - Cmd 64 Bit
   goto :eof
)

devenv OpenSubdiv.sln /Project INSTALL /Build "Release|x64"
rem devenv OpenSubdiv.sln /Project INSTALL /Build "Debug|x64"

set PWD=
set BUILD_MLL_PATH="%CD%\lib\Release"
rem set BUILD_MLL_PATH="%CD%\lib\Debug"
set BUILD_SCRIPT_PATH="%CD%\lib"
set PLUGIN_PATH=%TNT_ROOT%\Tools\MayaPlugins\2014-x64

set oldcd=%CD%

cd /d %PLUGIN_PATH%
p4 edit plug-ins\osdPolySmooth.mll
p4 edit scripts\osdPolySmooth.mel
copy %BUILD_MLL_PATH%\osdPolySmooth.mll %PLUGIN_PATH%\plug-ins\osdPolySmooth.mll
copy %BUILD_SCRIPT_PATH%\osdPolySmooth.mel %PLUGIN_PATH%\scripts\osdPolySmooth.mel

cd /d %oldcd%


