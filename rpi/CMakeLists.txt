
project(rpi)

add_executable(${PROJECT_NAME}
    main/src/main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE
                      wiringPi
)