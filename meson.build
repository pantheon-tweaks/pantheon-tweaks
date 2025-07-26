project(
    'pantheon-tweaks',
    'vala', 'c',
    version: '2.4.0',
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

subdir('data')
subdir('po')
subdir('src')

gnome.post_install(
    glib_compile_schemas: true,
    gtk_update_icon_cache: true
)
