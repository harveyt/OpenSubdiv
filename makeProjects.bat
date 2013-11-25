rem Run Me to rebuild VS Projects
echo CD=%CD%
set CMAKE_PATH=%CD%\Dependencies\CMake 2.8\bin
set GLEW_PATH=%CD%\Dependencies\glew-1.10.0
set OPENCL_PATH="c:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v5.5"
set MAYA_PATH="c:\Program Files\Autodesk\Maya2014"
set PATH=%PATH%;%CMAKE_PATH%
cmake -G "Visual Studio 11 Win64" -DGLEW_LOCATION:string=%GLEW_PATH% -DMAYA_LOCATION:string=%MAYA_PATH% -DOPENCL_INCLUDE_DIRS:string=%OPENCL_PATH%\include -D_OPENCL_CPP_INCLUDE_DIRS:string=%OPENCL_PATH%\include -DOPENCL_LIBRARIES:string=%OPENCL_PATH%\lib\x64\OpenCL.lib -DNO_REGRESSION=1 -DNO_PYTHON=1 -DNO_DOC=1 -DNO_OMP=1 -DNO_CUDA=1 -DNO_GCD=1
