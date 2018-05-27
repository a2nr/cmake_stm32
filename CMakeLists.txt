set(MCU_FAMILY  STM32F4xx)
set(MCU_LINE    STM32F446xx)
cmake_minimum_required(VERSION 3.6)

project(cmake_Blajar C ASM)

set(USER_INCLUDE Inc)
set(CMSIS_DEVICE_INCLUDE Drivers/CMSIS/Device/ST/STM32F4xx/Include)
set(CMSIS_INCLUDE Drivers/CMSIS/Include)
set(HAL_INCLUDE Drivers/STM32F4xx_HAL_Driver/Inc)
set(APP_INCLUDE App/Inc)
set(MODUL_INCLUDE App/Modul)

include_directories(${USER_INCLUDE}
                    ${CMSIS_DEVICE_INCLUDE} 
                    ${CMSIS_INCLUDE} 
                    ${HAL_INCLUDE} 
                    ${APP_INCLUDE}
                    ${MODUL_INCLUDE} )

add_subdirectory(App/Src)
add_subdirectory(App/Modul)
add_subdirectory(Drivers/${MCU_FAMILY}_HAL_Driver/Src)
add_subdirectory(startup)
add_subdirectory(Src)
