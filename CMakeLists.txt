set(MCU_FAMILY  STM32F4xx)
set(MCU_LINE    STM32F446xx)
set(FLASH_START 0x8000000)


cmake_minimum_required(VERSION 3.6)
get_filename_component(ProjectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" ProjectId ${ProjectId})

project(${ProjectId} CXX C ASM)


set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -D${MCU_LINE} -DUSE_HAL_LIBRARY")
set(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -D${MCU_LINE} -DUSE_HAL_LIBRARY")

set(USER_INC            Inc)
set(CMSIS_DEVICE_INC    Drivers/CMSIS/Device/ST/${MCU_FAMILY}/Include)
set(CMSIS_INC           Drivers/CMSIS/Include)
set(HAL_INC             Drivers/${MCU_FAMILY}_HAL_Driver/Inc)
set(APP_INC             App/Inc)
set(MODUL_INC           App/Modul )
set(ML_INC              ${MODUL_INC}/ML_Driver/Inc)
set(CM_INC              ${MODUL_INC}/CommandHandler)

file(GLOB_RECURSE APP_SRC       App/Src/*.cpp  
                                App/Src/*.c)
file(GLOB_RECURSE MDL_SRC       App/Modul/*.c 
                                App/Modul/*.cpp)
file(GLOB_RECURSE HAL_SRC       Drivers/*.c)
file(GLOB_RECURSE STR_SRC       startup/*.s)
file(GLOB_RECURSE MAIN_SRC      Src/*.c)
file(GLOB LINK_SRC              *.ld)

set(ALL_SOURCE  ${APP_SRC} ${CMD_SRC} ${MDL_SRC} ${HAL_SRC} 
                ${STR_SRC} ${MAIN_SRC} ${LINK_SRC})
include_directories(${USER_INC} ${CMSIS_DEVICE_INC} ${CMSIS_INC} 
                    ${HAL_INC} ${APP_INC} ${MODUL_INC} ${ML_INC}  ${CM_INC})                

add_executable(${PROJECT_NAME}.elf  ${ALL_SOURCE})

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.map")
set(HEX_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.bin)
set(ELF_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.elf)

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

add_custom_target(debug
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        # COMMAND openocd -f openocd_flash.cfg
        COMMAND st-flash write ${BIN_FILE} ${FLASH_START}
        COMMAND st-util -p 3333
        COMMENT "Happy Debug !!"
        DEPENDS ${PROJECT_NAME}.elf)

