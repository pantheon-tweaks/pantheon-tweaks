# This a sample CMakeLists.txt for compiling plug for Switchboard
# http://elementaryos.org/docs/developer-guide/cmake 

cmake_minimum_required (VERSION 2.6)
cmake_policy (VERSION 2.6)

# Set the Properties of your Plug

# Set the Name of the plug, should be an executable command, lowercase, no spaces 
set (PLUGNAME "tweaks")
# Set the Category of the Plug, one of:
# personal, hardware, network, system
set (PLUGCATEGORY "personal")
# Set the Title to use for the Plug in the Overview and in the Titlebar
set (PLUGTITLE "Tweaks")
# The symbolic name of the Icon to use for the plug
set (PLUGICON "preferences-desktop-tweaks")

project (${PLUGNAME})

#########################################################
# Only alter stuff below if you know what you are doing #
#########################################################

set (DATADIR "${CMAKE_INSTALL_PREFIX}/lib/plugs")
set (PKGDATADIR "${DATADIR}/pantheon/${PLUGNAME}")
set (GETTEXT_PACKAGE "${PLUGNAME}-plug")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Configure file
configure_file (plug.plug ${CMAKE_BINARY_DIR}/${PLUGNAME}.plug)
install (FILES ${CMAKE_BINARY_DIR}/${PLUGNAME}.plug DESTINATION ${PKGDATADIR})
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-desktop-tweaks.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/32/)
configure_file (${CMAKE_SOURCE_DIR}/config.vala.cmake ${CMAKE_BINARY_DIR}/src/config.vala)
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Files
file (GLOB resources "${CMAKE_CURRENT_SOURCE_DIR}/data/*")

# Traslation stuff
add_subdirectory (po)
# Info-plug
install (FILES ${resources} DESTINATION ${PKGDATADIR})

add_subdirectory(src)
