#[[
	Macro: scsa_add_static
	Description: 
		Creates a static library target, defines an alias for it, 
	and automatically links the core framework dependency.
	
	Arguments:
		- name			: Name of the static library target.
		- alias			: Alias name used for the exported target namespace.
		- description	: Description of the library project.
		- [ARGN]:      Optional extra libraries to link against.
]]
macro(scsa_add_static name alias description)
	# Forward all extra arguments to the underlying target creation logic
	sc_projects_add_static("${name}" "${description}" "${CMAKE_CURRENT_SOURCE_DIR}" ${ARGN})
	
	# Create an alias target (e.g., Namespace::TargetName) for inner-project usage
	add_library("${alias}::${alias}" ALIAS ${PROJECT_NAME})
	
	# Automatically link the core library unless this target IS the core library itself
	if (NOT "${alias}" STREQUAL "${SCSA_CORE_PRO}")
		target_link_libraries(${PROJECT_NAME} PRIVATE "${SCSA_CORE_PRO}::${SCSA_CORE_PRO}")
	endif()
endmacro()


#[[
	Macro: scsa_add_executable
	Description: 
		Creates an executable target, fetches its dependency configurations,
	maps them to namespaced aliases, and links them automatically.
	
	Arguments:
		- name        : Name of the executable target.
		- alias       : Alias/Identifier used to fetch package dependencies.
		- description : Description of the executable project.
		- [ARGN]      : Optional extra libraries to link against explicitly.
]]
macro(scsa_add_executable name alias description)
    # Forward arguments to create the base executable target
    sc_projects_add_executable("${name}" "${description}" "${CMAKE_CURRENT_SOURCE_DIR}/src" ${ARGN})
	
	# Initialize a localized list to store dependencies for this specific target
    set(_LOCAL_PROJECT_LIBS "")
	
	scsa_get_dependencies(${alias} DEPENDENCY_LIST)
	if(DEPENDENCY_LIST)
		STRING(REPLACE "," ";" LIST_RESULT ${DEPENDENCY_LIST})
		foreach(DEPENDENCY IN LISTS LIST_RESULT)
			list(APPEND _LOCAL_PROJECT_LIBS "${DEPENDENCY}::${DEPENDENCY}")
		endforeach()
	endif()
	
	# Bind resolved metadata dependencies to the current target
	if(_LOCAL_PROJECT_LIBS)
		target_link_libraries(${PROJECT_NAME} PRIVATE ${_LOCAL_PROJECT_LIBS})
	endif()
endmacro()