cmake_minimum_required(VERSION 3.21)
project(scpcb)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake/)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BUILD_RPATH})

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)

set(ASSIMP_BUILD_TESTS OFF CACHE BOOL "")
set(ASSIMP_BUILD_ASSIMP_TOOLS OFF CACHE BOOL "")

option(PGE_D3D "DirectX(11) (Windows Only)" ON)
option(PGE_VKR "Vulkan (Windows & Linux)" ON)
option(PGE_OGL "OpenGL(3)" ON)

if(WIN32 AND PGE_D3D)
    add_compile_definitions(PGE_D3D)
endif()
if(PGE_VKR)
    find_package(Vulkan REQUIRED FATAL_ERROR)
    add_compile_definitions(PGE_VKR)
endif()
if(PGE_OGL)
    add_compile_definitions(PGE_OGL)
endif()

# add_compile_definitions(PGE_DEBUG)

if(UNIX AND NOT APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-strict-aliasing") # angelscript
    add_compile_definitions(LINUX)
endif()

add_compile_definitions(ANGELSCRIPT_EXPORT)

add_subdirectory(Engine)
add_subdirectory(Libraries/assimp)
add_subdirectory(Libraries/freetype)
add_subdirectory(Libraries/angelscript/sdk/angelscript/projects/cmake)
# add_subdirectory(Libraries/tinyxml2) # this seems to break cmake for some reason
add_subdirectory(Src)
