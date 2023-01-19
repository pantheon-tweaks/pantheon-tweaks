project(
    'pantheon-tweaks',
    'vala', 'c',
    version: '1.0.4',
    meson_version: '>= 0.57.0'
)

switchboard_dep = dependency('switchboard-2.0')
gettext_name = meson.project_name() + '-plug'
libdir = get_option('prefix') / get_option('libdir')
pkgdatadir = switchboard_dep.get_variable(pkgconfig: 'plugsdir', pkgconfig_define: ['libdir', libdir]) / 'personal'

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

gnome.post_install(
    gtk_update_icon_cache: true
)

subdir('data')
subdir('po')

plug_files = files(
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
    'src/Widgets/Categories.vala',
)

shared_module(
    meson.project_name(),
    plug_files,
    config_file,
    dependencies: [
        dependency('gee-0.8'),
        dependency('glib-2.0'),
        dependency('granite', version: '>= 6.0.0'),
        dependency('gtk+-3.0'),
        meson.get_compiler('vala').find_library('posix'),
        switchboard_dep
    ],
    install: true,
    install_dir: pkgdatadir
)
