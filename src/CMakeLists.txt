find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (DEPS REQUIRED pantheon granite)

add_definitions (${DEPS_CFLAGS} -I/usr/include/polkit-1)
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.16.0" MINIMUM)

include (ValaPrecompile)
# Add all your vala files and requires packages to the List below to include them in the build
vala_precompile (VALA_C
    tweaks-plug.vala
    GalaSettings.vala
    PlankSettings.vala
    SlingshotSettings.vala
    ${CMAKE_CURRENT_BINARY_DIR}/config.vala
PACKAGES
    pantheon
    granite
OPTIONS
)

add_executable (${PLUGNAME} ${VALA_C})
target_link_libraries(${PLUGNAME} m)

# Installation
install (TARGETS ${PLUGNAME} DESTINATION ${PKGDATADIR})
