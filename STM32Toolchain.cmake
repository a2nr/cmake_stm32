
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)

set(COMPILER    arm-none-eabi)

set(CMAKE_C_COMPILER            ${COMPILER}-gcc)
set(CMAKE_CXX_COMPILER          ${COMPILER}-g++)
set(CMAKE_OBJCOPY               ${COMPILER}-objcopy)
set(CMAKE_NM                    ${COMPILER}-nm)
set(CMAKE_OBJDUMP               ${COMPILER}-objdump)
set(CMAKE_RANLIB                ${COMPILER}-ranlib)
set(CMAKE_LINKER                ${COMPILER}-ld)
set(CMAKE_ASM_COMPILER          ${COMPILER}-as)
set(CMAKE_SIZE                  ${COMPILER}-size)

set(COMMON_FLAGS "-g3 -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -lc --specs=nosys.specs -mthumb -mthumb-interwork -ffunction-sections -fdata-sections -g -fno-common -fmessage-length=0")

set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -std=c++11")
set(CMAKE_C_FLAGS "${COMMON_FLAGS} -std=gnu99")
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-gc-sections -T")