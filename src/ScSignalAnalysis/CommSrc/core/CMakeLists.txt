scsa_add_static("Core" ${SCSA_CORE_PRO} "")

option(CD_ENABLE_DEBUG_OUTPUT   "Enable HYK Carrier Detection Library"            ON)

# Add compile definitions
target_compile_definitions(${PROJECT_NAME} 
    PUBLIC 
    $<$<BOOL:${CD_ENABLE_DEBUG_OUTPUT}>:CD_ENABLE_DEBUG_OUTPUT>
)