rem Run Me to rebuild VS Projects
echo CD=%CD%
set CMAKE_PATH=%CD%\Dependencies\CMake 2.8\bin
set GLEW_PATH=%CD%\Dependencies\glew-1.10.0
set MAYA_PATH="c:\Program Files\Autodesk\Maya2014"
set PATH=%PATH%;%CMAKE_PATH%
cmake -G "Visual Studio 11" -DGLEW_LOCATION:string=%GLEW_PATH% -DMAYA_LOCATION:string=%MAYA_PATH% -DNO_REGRESSION=1 -DNO_PYTHON=1 -DNO_DOC=1 -DNO_OMP=1 -DNO_CUDA=1 -DNO_GCD=1
