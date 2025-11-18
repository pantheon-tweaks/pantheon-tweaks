# Files in data/styles/* are modification of System Settings 8.0.0 (LGPL-2.1-or-later).
#
# System Settings uses their own custom css in the library widgets like
# SettingsPage. However, the stylesheet resource is not included in the library
# and included in the System Settings app itself instead, which causes broken
# styles if we use libswitchboard widgets from outside the System Settings app.
sassc = find_program('sassc')

sassc_opts = [ '-a', '-M', '-t', 'compact' ]

stylesheet_deps = custom_target(
    'Application.scss',
    input: 'Index.scss',
    output: 'Application.css',
    command: [
        sassc,
        sassc_opts,
        '@INPUT@',
        '@OUTPUT@',
    ]
)

stylesheet_resource = gnome.compile_resources(
    'styles-resource',
    'styles.gresource.xml',
    source_dir: [
        meson.current_build_dir(),
        meson.current_source_dir(),
    ],
    dependencies: stylesheet_deps
)
