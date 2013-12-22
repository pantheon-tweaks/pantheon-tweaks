find_package (PkgConfig)

# Add all your dependencies to the list below
pkg_check_modules (DEPS REQUIRED pantheon granite gconf-2.0)

add_definitions (${DEPS_CFLAGS} -I/usr/include/polkit-1)
link_libraries (${DEPS_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS})

find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.16.0" MINIMUM)

include (ValaPrecompile)
# Add all your vala files and requires packages to the List below to include them in the build
vala_precompile (VALA_C
    Tweaks.vala
    LLabel.vala
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
    Widgets/AcceleratorInputWidget.vala
    ${CMAKE_CURRENT_BINARY_DIR}/config.vala
PACKAGES
    pantheon
    granite
    gconf-2.0
OPTIONS
)

add_executable (${PLUGNAME} ${VALA_C})
target_link_libraries(${PLUGNAME} m)

# Installation
install (TARGETS ${PLUGNAME} DESTINATION ${PKGDATADIR})
