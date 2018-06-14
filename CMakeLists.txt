################################################################################################################
set(TOOLCHAIN_PATH              ${CMAKE_SOURCE_DIR}/STM32Toolchain.cmake)
set(MCU_FAMILY  STM32F4xx)
set(MCU_LINE    STM32F446xx)

set(LIB_HARDWARE        USE_FULL_LL_DRIVER)
# set(LIB_HARDWARE        USE_HAL_LIBRARY)

# set(FLASH_START       0x8000000)
# set(LINK_SRC      STM32F446RETx_FLASH.ld)
# set(MY_FLAGS  "-D${MCU_LINE} -D${LIB_HARDWARE} -O0 ") 

#for dev only
set(FLASH_START         0x20000000)
set(LINK_SRC      STM32F446RETx_RAM.ld)
set(MY_FLAGS  "-D${MCU_LINE} -D${LIB_HARDWARE} -DVECT_TAB_SRAM -O0 ") 
################################################################################################################

include(${TOOLCHAIN_PATH})
# set(CMAKE_TRY_COMPILE_TARGET_TYPE EXECUTABLE)
set(CMAKE_EXE_LINKER_FLAGS      "${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_SOURCE_DIR}/${LINK_SRC}")
# set(MY_COMMON_FLAGS "-g3 -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -lc --specs=nosys.specs -mthumb -mthumb-interwork  -g -fno-common ")
set(MY_COMMON_FLAGS "")
set(CMAKE_C_FLAGS  "${MY_COMMON_FLAGS}  ${CMAKE_C_FLAGS} ${MY_FLAGS}") 
set(CMAKE_CXX_FLAGS  "${MY_COMMON_FLAGS} ${CMAKE_CXX_FLAGS} ${MY_FLAGS}")

cmake_minimum_required(VERSION 3.6)
get_filename_component(ProjectId ${CMAKE_CURRENT_SOURCE_DIR} NAME)
string(REPLACE " " "_" ProjectId ${ProjectId})
project(${ProjectId} CXX C ASM)

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


set(ALL_SOURCE  
                # ${APP_SRC} 
                ${CMD_SRC} 
                ${MDL_SRC} 
                ${HAL_SRC}                  
                ${MAIN_SRC} 
                ${LINK_SRC} 
                ${STR_SRC})
include_directories(
                ${USER_INC} 
                ${CMSIS_DEVICE_INC} 
                ${CMSIS_INC}     
                ${HAL_INC} 
                ${APP_INC} 
                ${MODUL_INC} 
                ${ML_INC}  
                ${CM_INC})                

add_subdirectory(App)

add_executable(${PROJECT_NAME}.elf  ${ALL_SOURCE} )
target_link_libraries(${PROJECT_NAME}.elf APP_LIB)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.map")
set(HEX_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.bin)
set(ELF_FILE ${PROJECT_SOURCE_DIR}/build/${PROJECT_NAME}.elf)

add_custom_command(TARGET ${PROJECT_NAME}.elf PRE_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_SOURCE_DIR}/build
        COMMENT "Creating build directory")

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE} 
Building ${BIN_FILE}")
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_SIZE} -B ${PROJECT_NAME}.elf)

add_custom_target(flash
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMAND st-flash write ${BIN_FILE} ${FLASH_START}
        COMMENT "Flashing the target processor..."
        DEPENDS ${PROJECT_NAME}.elf)
add_custom_command(TARGET flash POST_BUILD COMMENT "Flashing finished!")

add_custom_target(debug
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMAND st-util -p 3333 -n -v
        COMMENT "Happy Debug !!"
        DEPENDS ${PROJECT_NAME}.elf)

