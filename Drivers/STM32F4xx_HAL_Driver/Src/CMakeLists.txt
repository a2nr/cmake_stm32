add_definitions(-D${MCU_LINE})
add_definitions(-DUSE_HAL_LIBRARY)

file(GLOB_RECURSE HAL_SOURCE *.c)

add_library(HAL_STM32 ${HAL_SOURCE})

