# Build system contain two parts, one related with host and one with raspberry.
# If any part is enabled using -DHOST=ON or -DRPI=ON other one is skipped.
cmake_minimum_required(VERSION 3.16)
project(smarPi)

set(PROJECT_ROOT ${CMAKE_CURRENT_LIST_DIR})
set(BUILD_DIR "${PROJECT_ROOT}/build")
message(STATUS "Build directory: ${BUILD_DIR}")

if (NOT HOST AND NOT RPI)
    set(HOST ON)
    set(RPI ON)
endif ()

if (HOST)
    message(STATUS "BUILD HOST")
    set(HOST_BUILD_DIR "${BUILD_DIR}/host")
    set(HOST_DIR "${PROJECT_ROOT}/host")
    if (NOT EXISTS ${HOST_BUILD_DIR})
    execute_process(
        COMMAND mkdir -p ${HOST_BUILD_DIR} WORKING_DIRECTORY ${PROJECT_ROOT}
    )
    endif()
    set(HOST_BUILD_ARGS)
    execute_process(
        COMMAND cmake ${HOST_BUILD_ARGS} ${HOST_DIR}
        WORKING_DIRECTORY ${HOST_BUILD_DIR}
        RESULT_VARIABLE HOST_CMAKE_RES
    )
    if (MAKE AND HOST_CMAKE_RES EQUAL 0)
        execute_process(COMMAND make -j4 -l4 WORKING_DIRECTORY ${HOST_BUILD_DIR})
    endif()
endif ()

if (RPI)
    message(STATUS "BUILD RPI")
    set(RPI_BUILD_DIR "${BUILD_DIR}/rpi")
    set(RPI_DIR "${PROJECT_ROOT}/rpi")
    set(RPI_COMPILATOR_DIR "/opt/cross-pi-gcc/bin/")
    set(ENVIROMENT_COMPONENTS_DIR "${PROJECT_ROOT}/env")
    if (NOT EXISTS ${RPI_BUILD_DIR})
    execute_process(
        COMMAND mkdir -p ${RPI_BUILD_DIR} WORKING_DIRECTORY ${PROJECT_ROOT}
    )
    endif()
    set(RPI_BUILD_ARGS -DCMAKE_TOOLCHAIN_FILE=${PROJECT_ROOT}/env/Toolchain-rpi.cmake)
    set(ENV{RASPBIAN_ROOTFS} ${ENVIROMENT_COMPONENTS_DIR}/rootfs)
    set(ENV{PATH} $ENV{PATH}:${RPI_COMPILATOR_DIR})
    execute_process(
        COMMAND cmake ${RPI_BUILD_ARGS} ${RPI_DIR}
        WORKING_DIRECTORY ${RPI_BUILD_DIR}
        RESULT_VARIABLE RPI_CMAKE_RES
    )
    if (MAKE AND RPI_CMAKE_RES EQUAL 0)
        execute_process(COMMAND make -j4 -l4 WORKING_DIRECTORY ${RPI_BUILD_DIR})
    endif()
endif ()

unset(HOST CACHE)
unset(RPI CACHE)