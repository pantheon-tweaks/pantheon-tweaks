systheme_rootdir = get_option('systheme_rootdir')
if (systheme_rootdir == '')
    systheme_rootdir = get_option('prefix') / get_option('datadir')
endif

config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set_quoted('GETTEXT_PACKAGE', gettext_name)
config_data.set_quoted('SYSTHEME_ROOTDIR', systheme_rootdir)
config_file = configure_file(
    input: 'Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

source_files = files(
    'MainWindow.vala',
    'Tweaks.vala',
    'Model/StringIdObject.vala',
    'Panes/AppearancePane.vala',
    'Panes/FilesPane.vala',
    'Panes/FontsPane.vala',
    'Panes/KeyboardPane.vala',
    'Panes/MiscPane.vala',
    'Panes/TerminalPane.vala',
    'Settings/AccountsService.vala',
    'Settings/GtkSettings.vala',
    'Settings/ThemeSettings.vala',
    'Settings/XSettings.vala',
    'Util/SettingsUtil.vala',
    'Util/StringIdListUtil.vala',
    'Util/StringListUtil.vala',
    'Widgets/BasePane.vala',
    'Widgets/Categories.vala',
    'Widgets/Dialog.vala',
    'Widgets/DropDownId.vala',
    'Widgets/DropDownRow.vala',
    'Widgets/OpenButton.vala',
)

executable(
    meson.project_name(),
    source_files,
    config_file,
    stylesheet_resource,
    dependencies: [
        # Version limitation for GLib.ApplicationFlags.DEFAULT_FLAGS
        dependency('glib-2.0', version: '>= 2.74'),
        # Version limitation for Granite.CssClass
        dependency('granite-7', version: '>= 7.7.0'),
        # Version limitation for Gtk.FontDialogButton
        dependency('gtk4', version: '>= 4.10'),
        dependency('pango'),
        # Version limitation for GTK4 ported version
        dependency('switchboard-3', version: '>= 8.0.0'),
    ],
    install: true
)
