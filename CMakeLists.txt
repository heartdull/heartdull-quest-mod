cmake_minimum_required(VERSION 3.10)
project(heartdull)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Library name -> produces libheartdull.so
add_library(heartdull SHARED src/main.cpp)

# Find Android log
find_library(log-lib log)

target_link_libraries(heartdull ${log-lib})
