function(sc_project_collect_files target_dir SC_PROJECT_HEADERS SC_PROJECT_SOURCES) 
    file(GLOB_RECURSE collected_header_files  
        LIST_DIRECTORIES false  
        "${target_dir}/*.h"  
    )  

    file(GLOB_RECURSE collected_source_files  
        LIST_DIRECTORIES false  
        "${target_dir}/*.cpp"  
    )  

    set(SC_PROJECT_HEADERS ${collected_header_files} PARENT_SCOPE)  
    set(SC_PROJECT_SOURCES ${collected_source_files} PARENT_SCOPE)

    if(MSVC)
        foreach(header_file ${collected_header_files})
            get_filename_component(header_dir ${header_file} DIRECTORY)
            file(RELATIVE_PATH relative_dir ${target_dir} ${header_dir})
            source_group("Header Files\\${relative_dir}" FILES ${header_file})
        endforeach()

        foreach(source_file ${collected_source_files})
            get_filename_component(source_dir ${source_file} DIRECTORY)
            file(RELATIVE_PATH relative_dir ${target_dir} ${source_dir})
            source_group("Source Files\\${relative_dir}" FILES ${source_file})
        endforeach()
    endif()
endfunction()

function(sc_project_collect_dirs)
endfunction()