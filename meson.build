project('elementary-tweaks', 'vala', 'c')

switchboard_dep = dependency('switchboard-2.0')
gettext_name = meson.project_name() + '-plug'
pkgdatadir = join_paths(switchboard_dep.get_pkgconfig_variable('plugsdir'), 'personal')

i18n = import('i18n')

add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language:'c'
)

subdir('po')

conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
config_header = configure_file(
    input : 'config.vala.in',
    output : 'config.vala',
    configuration : conf_data
)

plug_files = files(
    'src/Tweaks.vala',
    'src/Util.vala',
    'src/Settings/AudienceSettings.vala',
    'src/Settings/IndicatorSoundSettings.vala',
    'src/Settings/FilesSettings.vala',
    'src/Settings/GalaSettings.vala',
    'src/Settings/GtkSettings.vala',
    'src/Settings/PlankSettings.vala',
    'src/Settings/KeyboardSettings.vala',
    'src/Settings/SlingshotSettings.vala',
    'src/Settings/GnomeSettings.vala',
    'src/Settings/TerminalSettings.vala',
    'src/Settings/XSettings.vala',
    'src/Panes/AudiencePane.vala',
    'src/Panes/AnimationsPane.vala',
    'src/Panes/AppearancePane.vala',
    'src/Panes/FontsPane.vala',
    'src/Panes/MiscPane.vala',
    'src/Panes/FilesPane.vala',
    'src/Panes/TerminalPane.vala',
    'src/Panes/PlankPane.vala',
    'src/Panes/SlingshotPane.vala',
    'src/Objects/ShortcutObject.vala',
    'src/Widgets/Categories.vala',
    'src/Widgets/SettingBox.vala',
    'src/Widgets/Label.vala',
)

shared_module(
    meson.project_name(),
    config_header,
    plug_files,
    dependencies: [
        dependency('gconf-2.0'),
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('polkit-gobject-1'),
        meson.get_compiler('vala').find_library('posix'),
        switchboard_dep
    ],
    install: true,
    install_dir: pkgdatadir
)

install_data(
    join_paths('icon', 'preferences-desktop-tweaks.svg'),
    install_dir: join_paths(get_option('prefix'), 'share', 'icons', 'elementary', 'categories', '32')
)
install_data(
    join_paths('icon', 'preferences-tweaks-anim.svg'),
    install_dir: join_paths(get_option('prefix'), 'share', 'icons', 'elementary', 'categories', '32')
)
install_data(
    join_paths('icon', 'preferences-tweaks-cerbere.svg'),
    install_dir: join_paths(get_option('prefix'), 'share', 'icons', 'elementary', 'categories', '32')
)
install_data(
    join_paths('icon', 'preferences-tweaks-shadows.svg'),
    install_dir: join_paths(get_option('prefix'), 'share', 'icons', 'elementary', 'categories', '32')
)
install_data(
    join_paths('icon', 'preferences-tweaks-slingshot.svg'),
    install_dir: join_paths(get_option('prefix'), 'share', 'icons', 'elementary', 'categories', '32')
)

meson.add_install_script('meson/post_install.py')
