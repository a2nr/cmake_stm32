

add_library(APP_LIB ${APP_SRC})

# message( )
add_custom_command(TARGET APP_LIB POST_BUILD
COMMAND ${CMAKE_NM} --print-size --format=bsd --size-sort --radix=d -r $<TARGET_LINKER_FILE_NAME:APP_LIB> >> ${PROJECT_SOURCE_DIR}/App/$<TARGET_LINKER_FILE_NAME:APP_LIB>.txt 
COMMAND ${CMAKE_SIZE} -B $<TARGET_LINKER_FILE_NAME:APP_LIB> >> ${PROJECT_SOURCE_DIR}/App/$<TARGET_LINKER_FILE_NAME:APP_LIB>.txt 
COMMENT "generate map file of APP_LIB" 
        )