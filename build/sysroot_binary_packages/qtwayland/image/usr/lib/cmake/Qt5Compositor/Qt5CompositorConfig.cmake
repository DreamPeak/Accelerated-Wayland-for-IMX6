
if (CMAKE_VERSION VERSION_LESS 2.8.3)
    message(FATAL_ERROR "Qt 5 requires at least CMake version 2.8.3")
endif()

get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
# Use original install prefix when loaded through a
# cross-prefix symbolic link such as /lib -> /usr/lib.
get_filename_component(_realCurr "${_IMPORT_PREFIX}" REALPATH)
get_filename_component(_realOrig "/usr/lib/cmake/Qt5Compositor" REALPATH)
if(_realCurr STREQUAL _realOrig)
    get_filename_component(_qt5Compositor_install_prefix "/usr/lib/../" ABSOLUTE)
else()
    get_filename_component(_qt5Compositor_install_prefix "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)
endif()
unset(_realOrig)
unset(_realCurr)
unset(_IMPORT_PREFIX)

# For backwards compatibility only. Use Qt5Compositor_VERSION instead.
set(Qt5Compositor_VERSION_STRING 5.3.0)

set(Qt5Compositor_LIBRARIES Qt5::Compositor)

macro(_qt5_Compositor_check_file_exists file)
    if(NOT EXISTS "${file}" )
        message(FATAL_ERROR "The imported target \"Qt5::Compositor\" references the file
   \"${file}\"
but this file does not exist.  Possible reasons include:
* The file was deleted, renamed, or moved to another location.
* An install or uninstall procedure did not complete successfully.
* The installation package was faulty and contained
   \"${CMAKE_CURRENT_LIST_FILE}\"
but not all the files it references.
")
    endif()
endmacro()


macro(_populate_Compositor_target_properties Configuration LIB_LOCATION IMPLIB_LOCATION)
    set_property(TARGET Qt5::Compositor APPEND PROPERTY IMPORTED_CONFIGURATIONS ${Configuration})

    set(imported_location "${_qt5Compositor_install_prefix}/lib/${LIB_LOCATION}")
    _qt5_Compositor_check_file_exists(${imported_location})
    set_target_properties(Qt5::Compositor PROPERTIES
        "INTERFACE_LINK_LIBRARIES" "${_Qt5Compositor_LIB_DEPENDENCIES}"
        "IMPORTED_LOCATION_${Configuration}" ${imported_location}
        "IMPORTED_SONAME_${Configuration}" "libQt5Compositor.so.5"
        # For backward compatibility with CMake < 2.8.12
        "IMPORTED_LINK_INTERFACE_LIBRARIES_${Configuration}" "${_Qt5Compositor_LIB_DEPENDENCIES}"
    )

endmacro()

if (NOT TARGET Qt5::Compositor)

    set(_Qt5Compositor_OWN_INCLUDE_DIRS "${_qt5Compositor_install_prefix}/include/qt5/" "${_qt5Compositor_install_prefix}/include/qt5/QtCompositor")
    set(Qt5Compositor_PRIVATE_INCLUDE_DIRS
        "${_qt5Compositor_install_prefix}/include/qt5/QtCompositor/5.3.0"
        "${_qt5Compositor_install_prefix}/include/qt5/QtCompositor/5.3.0/QtCompositor"
    )

    foreach(_dir ${_Qt5Compositor_OWN_INCLUDE_DIRS})
        _qt5_Compositor_check_file_exists(${_dir})
    endforeach()

    # Only check existence of private includes if the Private component is
    # specified.
    list(FIND Qt5Compositor_FIND_COMPONENTS Private _check_private)
    if (NOT _check_private STREQUAL -1)
        foreach(_dir ${Qt5Compositor_PRIVATE_INCLUDE_DIRS})
            _qt5_Compositor_check_file_exists(${_dir})
        endforeach()
    endif()

    set(Qt5Compositor_INCLUDE_DIRS ${_Qt5Compositor_OWN_INCLUDE_DIRS})

    set(Qt5Compositor_DEFINITIONS -DQT_COMPOSITOR_LIB)
    set(Qt5Compositor_COMPILE_DEFINITIONS QT_COMPOSITOR_LIB)

    set(_Qt5Compositor_MODULE_DEPENDENCIES "Gui;Core")

    set(_Qt5Compositor_FIND_DEPENDENCIES_REQUIRED)
    if (Qt5Compositor_FIND_REQUIRED)
        set(_Qt5Compositor_FIND_DEPENDENCIES_REQUIRED REQUIRED)
    endif()
    set(_Qt5Compositor_FIND_DEPENDENCIES_QUIET)
    if (Qt5Compositor_FIND_QUIETLY)
        set(_Qt5Compositor_DEPENDENCIES_FIND_QUIET QUIET)
    endif()
    set(_Qt5Compositor_FIND_VERSION_EXACT)
    if (Qt5Compositor_FIND_VERSION_EXACT)
        set(_Qt5Compositor_FIND_VERSION_EXACT EXACT)
    endif()

    set(Qt5Compositor_EXECUTABLE_COMPILE_FLAGS "")

    foreach(_module_dep ${_Qt5Compositor_MODULE_DEPENDENCIES})
        if (NOT Qt5${_module_dep}_FOUND)
            find_package(Qt5${_module_dep}
                5.3.0 ${_Qt5Compositor_FIND_VERSION_EXACT}
                ${_Qt5Compositor_DEPENDENCIES_FIND_QUIET}
                ${_Qt5Compositor_FIND_DEPENDENCIES_REQUIRED}
                PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
            )
        endif()

        if (NOT Qt5${_module_dep}_FOUND)
            set(Qt5Compositor_FOUND False)
            return()
        endif()

        list(APPEND Qt5Compositor_INCLUDE_DIRS "${Qt5${_module_dep}_INCLUDE_DIRS}")
        list(APPEND Qt5Compositor_PRIVATE_INCLUDE_DIRS "${Qt5${_module_dep}_PRIVATE_INCLUDE_DIRS}")
        list(APPEND Qt5Compositor_DEFINITIONS ${Qt5${_module_dep}_DEFINITIONS})
        list(APPEND Qt5Compositor_COMPILE_DEFINITIONS ${Qt5${_module_dep}_COMPILE_DEFINITIONS})
        list(APPEND Qt5Compositor_EXECUTABLE_COMPILE_FLAGS ${Qt5${_module_dep}_EXECUTABLE_COMPILE_FLAGS})
    endforeach()
    list(REMOVE_DUPLICATES Qt5Compositor_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5Compositor_PRIVATE_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES Qt5Compositor_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5Compositor_COMPILE_DEFINITIONS)
    list(REMOVE_DUPLICATES Qt5Compositor_EXECUTABLE_COMPILE_FLAGS)

    set(_Qt5Compositor_LIB_DEPENDENCIES "Qt5::Gui;Qt5::Core")

    add_library(Qt5::Compositor SHARED IMPORTED)

    set_property(TARGET Qt5::Compositor PROPERTY
      INTERFACE_INCLUDE_DIRECTORIES ${_Qt5Compositor_OWN_INCLUDE_DIRS})
    set_property(TARGET Qt5::Compositor PROPERTY
      INTERFACE_COMPILE_DEFINITIONS QT_COMPOSITOR_LIB)

    _populate_Compositor_target_properties(RELEASE "libQt5Compositor.so.5.3.0" "" )







_qt5_Compositor_check_file_exists("${CMAKE_CURRENT_LIST_DIR}/Qt5CompositorConfigVersion.cmake")

endif()
