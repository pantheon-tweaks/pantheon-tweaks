find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (CLI_DEPS REQUIRED gthread-2.0 gtk+-3.0 granite gconf-2.0 gee-0.8 glib-2.0 )

add_definitions (${CLI_DEPS_CFLAGS})
link_directories (${CLI_DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22.0" MINIMUM)

set (CLI_EXEC_NAME theme-patcher)

include (ValaPrecompile)
# Add all your vala files and requires packages to the List below to include them in the build
vala_precompile (CLI_VALA_C ${CLI_EXEC_NAME}
    ThemePatcher.vala
    ${CMAKE_CURRENT_SOURCE_DIR}/../src/Settings/EgtkThemeSettings.vala
    EgtkThemePatcher.vala
PACKAGES
    granite
	glib-2.0
	gio-2.0    
)

add_executable(${CLI_EXEC_NAME} ${CLI_VALA_C})
target_link_libraries (${CLI_EXEC_NAME} ${CLI_DEPS_LIBRARIES})

install (TARGETS ${CLI_EXEC_NAME} DESTINATION ${PKGDATADIR})
