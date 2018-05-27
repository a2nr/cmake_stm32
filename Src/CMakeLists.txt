add_definitions(-D${MCU_LINE})
add_definitions(-DUSE_HAL_LIBRARY)
set(FLASH_START 0x8000000)

file(GLOB_RECURSE MAIN_SOURCE *.c)

add_executable(${PROJECT_NAME}.elf ${MAIN_SOURCE})

target_link_libraries( ${PROJECT_NAME}.elf STARTUP HAL_STM32 APP_LIB)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.map")
set(HEX_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME}.elf PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_SOURCE_DIR}/build
        COMMENT "Creating build directory")

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE} 
Building ${BIN_FILE}")
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_SIZE} -B ${PROJECT_NAME}.elf)

add_custom_target(flash
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        # COMMAND openocd -f openocd_flash.cfg
        COMMAND st-flash write ${BIN_FILE} ${FLASH_START}
        COMMENT "Flashing the target processor..."
        DEPENDS ${PROJECT_NAME}.elf)
add_custom_command(TARGET flash POST_BUILD COMMENT "Flashing finished!")