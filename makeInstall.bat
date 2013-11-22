@echo off
rem Installs binaries to right place.
if not defined TNT_ROOT (
   echo TNT_ROOT is not defined!
   echo Need to be running in a Frost shell, use Drone - Code - Cmd 64 Bit
   goto :eof
)

devenv OpenSubdiv.sln /Project INSTALL /ProjectConfig "Release|x64" /Build "Release|x64"

set BUILD_PATH="c:\Program Files\OpenSubDiv\plugin"
set PLUGIN_PATH=%TNT_ROOT%\Tools\MayaPlugins\2014-x64

cd /d %PLUGIN_PATH%
p4 edit plug-ins\osdPolySmooth.mll
p4 edit scripts\osdPolySmooth.mel
copy %BUILD_PATH%\osdPolySmooth.mll %PLUGIN_PATH%\plug-ins\osdPolySmooth.mll
copy %BUILD_PATH%\osdPolySmooth.mel %PLUGIN_PATH%\scripts\osdPolySmooth.mel

