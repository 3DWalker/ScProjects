#[[
  Function: cdsa_link_library_external
  Description:
    Links a specific library to a target by providing explicit paths.
    Automatically falls back to the Release library if the Debug version (with 'd' suffix) is not found.
  Arguments:
    target_name   : The target name to link the library to (e.g., ${PROJECT_NAME}).
    inc_dir       : Full path to the directory containing header files.
    lib_dir       : Full path to the directory containing library binaries.
    lib_base_name : The base name of the library (without prefix/suffix like .lib or .a).
]]
function(cdsa_link_library_external target_name inc_dir lib_dir lib_base_name)
    target_include_directories(${target_name} PRIVATE "${inc_dir}")

    find_library(LIB_REL_${lib_base_name} 
        NAMES ${lib_base_name} 
        PATHS "${lib_dir}" 
        NO_DEFAULT_PATH
    )

    find_library(LIB_DBG_${lib_base_name} 
        NAMES "${lib_base_name}d" 
        PATHS "${lib_dir}" 
        NO_DEFAULT_PATH
    )

    if(NOT LIB_DBG_${lib_base_name})
        set(LIB_DBG_${lib_base_name} ${LIB_REL_${lib_base_name}})
    endif()

    target_link_libraries(${target_name} PRIVATE 
        $<$<CONFIG:Debug>:${LIB_DBG_${lib_base_name}}>
        $<$<CONFIG:Release>:${LIB_REL_${lib_base_name}}>
    )   
endfunction()

#[[
  Function: cdsa_link_library_base
  Description:
    Simplified wrapper for linking libraries following the convention:
    - Include: ${lib_root}/include
    - Library: ${lib_root}/lib/${CD_ARCH}/[optional_sub_dir]
  Arguments:
    target_name   : Target to link (e.g., ${PROJECT_NAME})
    lib_root      : Base directory of the library package
    lib_base_name : Name of the library file (without extension/prefix)
    lib_sub_dir   : Optional suffix to append to the library path (pass "" if none)
]]
function(cdsa_link_library_base target_name lib_root lib_sub_dir lib_base_name)
    set(SC_LIB_ROOT "${lib_root}/${lib_base_name}")
    set(SC_FINAL_LIB_DIR "${SC_LIB_ROOT}/lib/${CD_ARCH}")

    if(NOT "${lib_sub_dir}" STREQUAL "")
        set(SC_FINAL_LIB_DIR "${FINAL_LIB_DIR}/${lib_sub_dir}")
    endif()

    cdsa_link_library_external(
        ${target_name} 
        "${SC_LIB_ROOT}/include" 
        "${SC_FINAL_LIB_DIR}" 
        "${lib_base_name}"
    )
endfunction()

#[[
  Function: cdsa_link_library
  Description:
    A wrapper for cdsa_add_library_base that follows a standard directory structure:
    - Headers: ${lib_root}/include
    - Libs:    ${lib_root}/lib/${CD_ARCH}
  Arguments:
    target_name   : The target name to link the library to.
    lib_root      : The root folder of the library package.
    lib_base_name : The base name of the library.
]]
function(cdsa_link_library target_name lib_root lib_base_name)
    cdsa_link_library_base(${target_name} ${lib_root} "" ${lib_base_name})
endfunction()