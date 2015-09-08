cmake_minimum_required(VERSION 2.8.3)
project(box_qp)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include_directories(src)

## Declare a cpp library
file(GLOB_RECURSE alglib_SOURCES src/*.cpp src/*.c)
add_library(${PROJECT_NAME} ${alglib_SOURCES})


add_executable(minqp_d_bc1 example/minqp_d_bc1.cpp)
target_link_libraries(minqp_d_bc1 ${PROJECT_NAME})

add_executable(read_from_file example/read_from_file.cpp)
target_link_libraries(read_from_file ${PROJECT_NAME})

