include(projects_common)

if(SC_PROJECT_BUILD_ONLY)
	message(STATUS "Looking for projects")

	set(SC_PROJECT_BUILD_ONLY ${SC_PROJECT_BUILD_ONLY})
	LIST(REMOVE_DUPLICATES SC_PROJECT_BUILD_ONLY)

	set(PROJECT_DIRS "")
	foreach(TARGET IN LISTS SC_PROJECT_BUILD_ONLY)
		sc_get_project_dir(${TARGET} PROJECT_DIR)
		list(APPEND PROJECT_DIRS ${PROJECT_DIR})
		list(APPEND ${PROJECT_DIR} ${TARGET})
	endforeach()
	
	list(REMOVE_DUPLICATES PROJECT_DIRS)
	foreach(TARGET IN LISTS PROJECT_DIRS)
		set(SC_PROJECTS "${${TARGET}}")
		add_subdirectory("src/${TARGET}")
		unset(SC_PROJECTS)
	endforeach()
else()
	message(WARNING "No project specified for build, skipping project build.")
	
	sc_get_all_keys(ALL_PROJECT_KEYS)
	message(STATUS "Available projects: ${ALL_PROJECT_KEYS}")
	message(STATUS "Please specify a valid project, e.g.: -DSC_PROJECT_BUILD_ONLY=\"ScServer\"")
endif()

