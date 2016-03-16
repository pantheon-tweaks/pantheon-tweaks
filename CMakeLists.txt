# This a sample CMakeLists.txt for compiling plug for Switchboard
# http://elementaryos.org/docs/developer-guide/cmake

cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)

# Set the Properties of your Plug
set (PLUGNAME "tweaks")
set (PLUGCATEGORY "personal")
set (PLUGTITLE "System Tweaks")
set (PLUGICON "preferences-desktop-tweaks")

set (VERSION "1.0")
project (elementary-tweaks)

# Comment this out to enable C compiler warnings
add_definitions (-w)

#########################################################
# Only alter stuff below if you know what you are doing #
#########################################################

include (GNUInstallDirs)
set (DATADIR "${CMAKE_INSTALL_FULL_LIBDIR}/switchboard")
set (PKGDATADIR "${DATADIR}/${PLUGCATEGORY}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}-plug")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Configure file
configure_file (${CMAKE_SOURCE_DIR}/config.vala.cmake ${CMAKE_BINARY_DIR}/src/config.vala)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-desktop-tweaks.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/32/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-anim.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/24/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-cerbere.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/24/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-shadows.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/24/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icon/preferences-tweaks-slingshot.svg DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/elementary/categories/24/)
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Add 'make dist' command for creating release tarball
set (CPACK_PACKAGE_VERSION ${VERSION})
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;/.gitignore;~$;${CPACK_SOURCE_IGNORE_FILES}")
include (CPack)
add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)


# Set policy permission for theme patching
configure_file (${CMAKE_SOURCE_DIR}/data/org.pantheon.elementary-tweaks.egtk.policy.cmake ${CMAKE_BINARY_DIR}/data/org.pantheon.elementary-tweaks.egtk.policy)
install (FILES ${CMAKE_BINARY_DIR}/data/org.pantheon.elementary-tweaks.egtk.policy DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/polkit-1/actions/)

# Registering theme-patcher so it gets executed each time a dpkg install takes 
# place
# See http://unix.stackexchange.com/questions/76294/hook-a-script-to-apt-get
configure_file (${CMAKE_SOURCE_DIR}/data/99theme-patcher.cmake ${CMAKE_BINARY_DIR}/data/99theme-patcher)
install (FILES ${CMAKE_BINARY_DIR}/data/99theme-patcher DESTINATION /etc/apt/apt.conf.d/)

# Translation stuff
add_subdirectory (po)

# Info-plug
install (FILES ${resources} DESTINATION ${PKGDATADIR})

add_subdirectory(src)
add_subdirectory(theme-patcher)
add_subdirectory(schemas)

