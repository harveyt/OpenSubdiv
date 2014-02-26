//
//   Copyright 2013 Pixar
//
//   Licensed under the Apache License, Version 2.0 (the "Apache License")
//   with the following modification; you may not use this file except in
//   compliance with the Apache License and the following modification to it:
//   Section 6. Trademarks. is deleted and replaced with:
//
//   6. Trademarks. This License does not grant permission to use the trade
//      names, trademarks, service marks, or product names of the Licensor
//      and its affiliates, except as required to comply with Section 4(c) of
//      the License and to reproduce the content of the NOTICE file.
//
//   You may obtain a copy of the Apache License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the Apache License with the above modification is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//   KIND, either express or implied. See the Apache License for the specific
//   language governing permissions and limitations under the Apache License.
//

#ifndef OSD_EXAMPLE_CL_INIT_H
#define OSD_EXAMPLE_CL_INIT_H

#if defined(_WIN32)
    #include <windows.h>
    #include <CL/opencl.h>
#elif defined(__APPLE__)
    #include <OpenGL/OpenGL.h>
    #include <OpenCL/opencl.h>
#else
    #include <GL/glx.h>
    #include <CL/opencl.h>
#endif

#include <cstdio>

#ifdef OPENSUBDIV_CLINIT_USE_MAYA_API
#include <stdarg.h>
#include <maya/MGlobal.h>
static void error(const char *fmt, ...)
{
	char buf[512];
	va_list ap;
	va_start(ap, fmt);
	vsnprintf(buf, sizeof(buf), fmt, ap);
	va_end(ap);
	MGlobal::displayError(MString(buf));
}
#else
static void error(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	vprintf(fmt, ap);
	va_end(ap);
}
#endif

static bool initCL(cl_context *clContext, cl_command_queue *clQueue)
{
    cl_int ciErrNum;

    cl_platform_id cpPlatform = 0;
    cl_uint num_platforms;
    ciErrNum = clGetPlatformIDs(0, NULL, &num_platforms);
    if (ciErrNum != CL_SUCCESS) {
        error("Error %d in clGetPlatformIDs call.\n", ciErrNum);
        return false;
    }
    if (num_platforms == 0) {
        error("No OpenCL platform found.\n");
        return false;
    }
    cl_platform_id *clPlatformIDs;
    clPlatformIDs = new cl_platform_id[num_platforms];
    ciErrNum = clGetPlatformIDs(num_platforms, clPlatformIDs, NULL);
    char chBuffer[1024];
    for (cl_uint i = 0; i < num_platforms; ++i) {
        ciErrNum = clGetPlatformInfo(clPlatformIDs[i], CL_PLATFORM_NAME, 1024, chBuffer,NULL);
        if (ciErrNum == CL_SUCCESS) {
            cpPlatform = clPlatformIDs[i];
        }
    }
    // -------------
    cl_device_id clDevice;
    clGetDeviceIDs(cpPlatform, CL_DEVICE_TYPE_GPU, 1, &clDevice, NULL);

#if defined(_WIN32)
    cl_context_properties props[] = {
        CL_GL_CONTEXT_KHR, (cl_context_properties)wglGetCurrentContext(),
        CL_WGL_HDC_KHR, (cl_context_properties)wglGetCurrentDC(),
        CL_CONTEXT_PLATFORM, (cl_context_properties)cpPlatform,
        0
    };
#elif defined(__APPLE__)
    CGLContextObj kCGLContext = CGLGetCurrentContext();
    CGLShareGroupObj kCGLShareGroup = CGLGetShareGroup(kCGLContext);
    cl_context_properties props[] = {
        CL_CONTEXT_PROPERTY_USE_CGL_SHAREGROUP_APPLE, (cl_context_properties)kCGLShareGroup,
        0
    };
#else
    cl_context_properties props[] = {
        CL_GL_CONTEXT_KHR, (cl_context_properties)glXGetCurrentContext(),
        CL_GLX_DISPLAY_KHR, (cl_context_properties)glXGetCurrentDisplay(),
        CL_CONTEXT_PLATFORM, (cl_context_properties)cpPlatform,
        0
    };
#endif
    delete[] clPlatformIDs;

    // XXX context creation should be moved to client code
    *clContext = clCreateContext(props, 1, &clDevice, NULL, NULL, &ciErrNum);
    if (ciErrNum != CL_SUCCESS) {
        error("Error %d in clCreateContext\n", ciErrNum);
        return false;
    }

    *clQueue = clCreateCommandQueue(*clContext, clDevice, 0, &ciErrNum);
    if (ciErrNum != CL_SUCCESS) {
        error("Error %d in clCreateCommandQueue\n", ciErrNum);
        return false;
    }
    return true;
}

static void uninitCL(cl_context clContext, cl_command_queue clQueue)
{
    clReleaseCommandQueue(clQueue);
    clReleaseContext(clContext);
}

#endif // OSD_EXAMPLE_CL_INIT_H
