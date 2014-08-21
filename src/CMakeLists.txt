find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (DEPS REQUIRED gthread-2.0 gtk+-3.0 switchboard-2.0 granite gconf-2.0 gee-0.8 glib-2.0)

#add_definitions (${DEPS_CFLAGS} -I/usr/include/polkit-1)
add_definitions (${DEPS_CFLAGS})
#link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22.0" MINIMUM)

include (ValaPrecompile)
# Add all your vala files and requires packages to the List below to include them in the build
vala_precompile (VALA_C ${CMAKE_PROJECT_NAME}
    Tweaks.vala
    Settings/FilesSettings.vala
    Settings/GalaSettings.vala
    Settings/PlankSettings.vala
    Settings/KeyboardSettings.vala
    Settings/SlingshotSettings.vala
    Settings/CerbereSettings.vala
    Settings/GnomeSettings.vala
    Settings/SynapseSettings.vala
    Settings/TerminalSettings.vala
    Settings/WingpanelslimSettings.vala
    Settings/SuperwingpanelSettings.vala
    Grids/AppearanceGrid.vala
    Grids/CerbereGrid.vala
    Grids/FontsGrid.vala
    Grids/FilesGrid.vala
    Grids/ShortcutsGrid.vala
    Grids/AnimationsGrid.vala
    Grids/ShadowsGrid.vala
    Grids/PlankGrid.vala
    Grids/MiscGrid.vala
    Grids/SlingshotGrid.vala
    Grids/SynapseGrid.vala
    Grids/TerminalGrid.vala
    Grids/WingpanelslimGrid.vala
    Grids/SuperwingpanelGrid.vala
    Objects/ShortcutObject.vala
    Widgets/LLabel.vala
    Widgets/AcceleratorInputWidget.vala
    ${CMAKE_CURRENT_BINARY_DIR}/config.vala
PACKAGES
    glib-2.0
    gtk+-3.0
    gee-0.8
    switchboard-2.0
    granite
    gconf-2.0
OPTIONS
    --thread
)

add_library (${CMAKE_PROJECT_NAME} MODULE ${VALA_C})
target_link_libraries (${CMAKE_PROJECT_NAME} ${DEPS_LIBRARIES})

# Installation
install (TARGETS ${CMAKE_PROJECT_NAME} DESTINATION ${PKGDATADIR})
