project(
    'pantheon-tweaks',
    'vala', 'c',
    version: '2.1.0',
    meson_version: '>= 0.57.0'
)

gettext_name = meson.project_name()
# Use this when reverse-DNS format is required
application_id = 'io.github.pantheon_tweaks.' + meson.project_name()

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language:'c'
)

config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set_quoted('GETTEXT_PACKAGE', gettext_name)
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

subdir('data')
subdir('po')

source_files = files(
    'src/MainWindow.vala',
    'src/Tweaks.vala',
    'src/Settings/AccountsService.vala',
    'src/Settings/GtkSettings.vala',
    'src/Settings/ThemeSettings.vala',
    'src/Settings/XSettings.vala',
    'src/Panes/AppearancePane.vala',
    'src/Panes/FontsPane.vala',
    'src/Panes/MiscPane.vala',
    'src/Panes/FilesPane.vala',
    'src/Panes/TerminalPane.vala',
    'src/Widgets/BasePane.vala',
    'src/Widgets/Categories.vala',
    'src/Widgets/OpenButton.vala',
)

executable(
    meson.project_name(),
    source_files,
    config_file,
    stylesheet_resource,
    dependencies: [
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite-7', version: '>= 7.1.0'),
        dependency('gtk4', version: '>= 4.10'),
        dependency('pango'),
        dependency('switchboard-3', version: '>= 8.0.0'),
        meson.get_compiler('vala').find_library('posix')
    ],
    install: true
)

gnome.post_install(
    glib_compile_schemas: true,
    gtk_update_icon_cache: true
)
