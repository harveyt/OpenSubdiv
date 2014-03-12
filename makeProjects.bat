rem Run Me to rebuild VS Projects
echo CD=%CD%
set CMAKE_PATH=%CD%\..\Dependencies\CMake 2.8\bin
set GLEW_PATH=%CD%\..\Dependencies\glew-1.10.0
rem set OPENCL_PATH="c:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5"
rem set OPENCL_INC=%OPENCL_PATH%\include
rem set OPENCL_LIB=%OPENCL_PATH%\lib\x64\OpenCL.lib
set OPENCL_PATH="C:\Program Files (x86)\AMD APP SDK\2.9"
set OPENCL_INC=%OPENCL_PATH%\include
set OPENCL_LIB=%OPENCL_PATH%\lib\x86_64\OpenCL.lib
set MAYA_PATH="c:\Program Files\Autodesk\Maya2014"
set PATH=%PATH%;%CMAKE_PATH%
cmake -G "Visual Studio 11 Win64" -DGLEW_LOCATION:string=%GLEW_PATH% -DMAYA_LOCATION:string=%MAYA_PATH% -DOPENCL_INCLUDE_DIRS:string=%OPENCL_PATH%\include -D_OPENCL_CPP_INCLUDE_DIRS:string=%OPENCL_INC% -DOPENCL_LIBRARIES:string=%OPENCL_LIB% -DNO_REGRESSION=1 -DNO_PYTHON=1 -DNO_DOC=1 -DNO_OMP=1 -DNO_CUDA=1 -DNO_GCD=1